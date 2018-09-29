ifeq (,$(shell which sha1sum))
SHA1 := shasum
else
SHA1 := sha1sum
endif

RGBASM := rgbasm
RGBFIX := rgbfix
RGBGFX := rgbgfx
RGBLINK := rgblink
RGBASMFLAGS :=

roms := pikalaxbot.gbc

all_obj := \
hram.o \
main.o


### Build targets

.SUFFIXES:
.PHONY: all rom clean compare tools
.SECONDEXPANSION:
.PRECIOUS:
.SECONDARY:

all: rom
rom: pikalaxbot.gbc

clean:
	rm -f $(roms) $(all_obj) $(roms:.gbc=.map) $(roms:.gbc=.sym)
	$(MAKE) clean -C tools/

compare: $(roms)
	@$(SHA1) -c roms.sha1

tools:
	$(MAKE) -C tools/


$(all_obj):

# The dep rules have to be explicit or else missing files won't be reported.
# As a side effect, they're evaluated immediately instead of when the rule is invoked.
# It doesn't look like $(shell) can be deferred so there might not be a better way.
define DEP
$1: $2 $$(shell tools/scan_includes $2)
	$$(RGBASM) $$(RGBASMFLAGS) -o $$@ $$<
endef

# Build tools when building the rom.
# This has to happen before the rules are processed, since that's when scan_includes is run.
ifeq (,$(filter clean tools,$(MAKECMDGOALS)))

$(info $(shell $(MAKE) -C tools))

$(foreach obj, $(all_obj), $(eval $(call DEP,$(obj),$(obj:.o=.asm))))

endif


pikalaxbot.gbc: $(all_obj)
	$(RGBLINK) -w -n pikalaxbot.sym -m pikalaxbot.map -o $@ -p 0xFF $(all_obj)
	$(RGBFIX) -v -m 0x19 -p 0xFF -t IMAGEROM $@
	tools/sort_symfile.sh pikalaxbot.sym

### Catch-all graphics rules

%.bin: ;

%.2bpp: %.png
	$(RGBGFX) $(rgbgfx) -o $@ $<
	$(if $(tools/gfx),\
		tools/gfx $(tools/gfx) -o $@ $@)

%.1bpp: %.png
	$(RGBGFX) $(rgbgfx) -d1 -o $@ $<
	$(if $(tools/gfx),\
		tools/gfx $(tools/gfx) -d1 -o $@ $@)
