From: David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 1/4] md: Factor out RAID6 algorithms into lib/
Date: Mon, 13 Jul 2009 15:11:42 +0100
Message-ID: <1247494302.19180.268.camel@macbook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: neilb@suse.de, linux-raid@vger.kernel.org
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

We'll want to use these in btrfs too.

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
---
 drivers/md/Kconfig                           |    5 +-
 drivers/md/Makefile                          |   76 -------------------------
 lib/Kconfig                                  |    3 +
 lib/Makefile                                 |    1 +
 lib/raid6/Makefile                           |   78 ++++++++++++++++++++++++++
 {drivers/md => lib/raid6}/mktables.c         |    0
 {drivers/md => lib/raid6}/raid6algos.c       |    0
 {drivers/md => lib/raid6}/raid6altivec.uc    |    0
 {drivers/md => lib/raid6}/raid6int.uc        |    0
 {drivers/md => lib/raid6}/raid6mmx.c         |    0
 {drivers/md => lib/raid6}/raid6recov.c       |    0
 {drivers/md => lib/raid6}/raid6sse1.c        |    0
 {drivers/md => lib/raid6}/raid6sse2.c        |    0
 {drivers/md => lib/raid6}/raid6test/Makefile |    0
 {drivers/md => lib/raid6}/raid6test/test.c   |    0
 {drivers/md => lib/raid6}/raid6x86.h         |    0
 {drivers/md => lib/raid6}/unroll.pl          |    0
 17 files changed, 83 insertions(+), 80 deletions(-)
 create mode 100644 lib/raid6/Makefile
 rename {drivers/md => lib/raid6}/mktables.c (100%)
 rename {drivers/md => lib/raid6}/raid6algos.c (100%)
 rename {drivers/md => lib/raid6}/raid6altivec.uc (100%)
 rename {drivers/md => lib/raid6}/raid6int.uc (100%)
 rename {drivers/md => lib/raid6}/raid6mmx.c (100%)
 rename {drivers/md => lib/raid6}/raid6recov.c (100%)
 rename {drivers/md => lib/raid6}/raid6sse1.c (100%)
 rename {drivers/md => lib/raid6}/raid6sse2.c (100%)
 rename {drivers/md => lib/raid6}/raid6test/Makefile (100%)
 rename {drivers/md => lib/raid6}/raid6test/test.c (100%)
 rename {drivers/md => lib/raid6}/raid6x86.h (100%)
 rename {drivers/md => lib/raid6}/unroll.pl (100%)

diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index 36e0675..42bf294 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -121,7 +121,7 @@ config MD_RAID10
 config MD_RAID456
 	tristate "RAID-4/RAID-5/RAID-6 mode"
 	depends on BLK_DEV_MD
-	select MD_RAID6_PQ
+	select RAID6_PQ
 	select ASYNC_MEMCPY
 	select ASYNC_XOR
 	---help---
@@ -152,9 +152,6 @@ config MD_RAID456
 
 	  If unsure, say Y.
 
-config MD_RAID6_PQ
-	tristate
-
 config MD_MULTIPATH
 	tristate "Multipath I/O support"
 	depends on BLK_DEV_MD
diff --git a/drivers/md/Makefile b/drivers/md/Makefile
index 45cc595..2c0b697 100644
--- a/drivers/md/Makefile
+++ b/drivers/md/Makefile
@@ -10,13 +10,6 @@ dm-snapshot-y	+= dm-snap.o dm-exception-store.o dm-snap-transient.o \
 dm-mirror-y	+= dm-raid1.o
 md-mod-y	+= md.o bitmap.o
 raid456-y	+= raid5.o
-raid6_pq-y	+= raid6algos.o raid6recov.o raid6tables.o \
-		   raid6int1.o raid6int2.o raid6int4.o \
-		   raid6int8.o raid6int16.o raid6int32.o \
-		   raid6altivec1.o raid6altivec2.o raid6altivec4.o \
-		   raid6altivec8.o \
-		   raid6mmx.o raid6sse1.o raid6sse2.o
-hostprogs-y	+= mktables
 
 # Note: link order is important.  All raid personalities
 # and must come before md.o, as they each initialise 
@@ -27,7 +20,6 @@ obj-$(CONFIG_MD_LINEAR)		+= linear.o
 obj-$(CONFIG_MD_RAID0)		+= raid0.o
 obj-$(CONFIG_MD_RAID1)		+= raid1.o
 obj-$(CONFIG_MD_RAID10)		+= raid10.o
-obj-$(CONFIG_MD_RAID6_PQ)	+= raid6_pq.o
 obj-$(CONFIG_MD_RAID456)	+= raid456.o
 obj-$(CONFIG_MD_MULTIPATH)	+= multipath.o
 obj-$(CONFIG_MD_FAULTY)		+= faulty.o
@@ -40,75 +32,7 @@ obj-$(CONFIG_DM_SNAPSHOT)	+= dm-snapshot.o
 obj-$(CONFIG_DM_MIRROR)		+= dm-mirror.o dm-log.o dm-region-hash.o
 obj-$(CONFIG_DM_ZERO)		+= dm-zero.o
 
-quiet_cmd_unroll = UNROLL  $@
-      cmd_unroll = $(PERL) $(srctree)/$(src)/unroll.pl $(UNROLL) \
-                   < $< > $@ || ( rm -f $@ && exit 1 )
-
-ifeq ($(CONFIG_ALTIVEC),y)
-altivec_flags := -maltivec -mabi=altivec
-endif
-
 ifeq ($(CONFIG_DM_UEVENT),y)
 dm-mod-objs			+= dm-uevent.o
 endif
 
-targets += raid6int1.c
-$(obj)/raid6int1.c:   UNROLL := 1
-$(obj)/raid6int1.c:   $(src)/raid6int.uc $(src)/unroll.pl FORCE
-	$(call if_changed,unroll)
-
-targets += raid6int2.c
-$(obj)/raid6int2.c:   UNROLL := 2
-$(obj)/raid6int2.c:   $(src)/raid6int.uc $(src)/unroll.pl FORCE
-	$(call if_changed,unroll)
-
-targets += raid6int4.c
-$(obj)/raid6int4.c:   UNROLL := 4
-$(obj)/raid6int4.c:   $(src)/raid6int.uc $(src)/unroll.pl FORCE
-	$(call if_changed,unroll)
-
-targets += raid6int8.c
-$(obj)/raid6int8.c:   UNROLL := 8
-$(obj)/raid6int8.c:   $(src)/raid6int.uc $(src)/unroll.pl FORCE
-	$(call if_changed,unroll)
-
-targets += raid6int16.c
-$(obj)/raid6int16.c:  UNROLL := 16
-$(obj)/raid6int16.c:  $(src)/raid6int.uc $(src)/unroll.pl FORCE
-	$(call if_changed,unroll)
-
-targets += raid6int32.c
-$(obj)/raid6int32.c:  UNROLL := 32
-$(obj)/raid6int32.c:  $(src)/raid6int.uc $(src)/unroll.pl FORCE
-	$(call if_changed,unroll)
-
-CFLAGS_raid6altivec1.o += $(altivec_flags)
-targets += raid6altivec1.c
-$(obj)/raid6altivec1.c:   UNROLL := 1
-$(obj)/raid6altivec1.c:   $(src)/raid6altivec.uc $(src)/unroll.pl FORCE
-	$(call if_changed,unroll)
-
-CFLAGS_raid6altivec2.o += $(altivec_flags)
-targets += raid6altivec2.c
-$(obj)/raid6altivec2.c:   UNROLL := 2
-$(obj)/raid6altivec2.c:   $(src)/raid6altivec.uc $(src)/unroll.pl FORCE
-	$(call if_changed,unroll)
-
-CFLAGS_raid6altivec4.o += $(altivec_flags)
-targets += raid6altivec4.c
-$(obj)/raid6altivec4.c:   UNROLL := 4
-$(obj)/raid6altivec4.c:   $(src)/raid6altivec.uc $(src)/unroll.pl FORCE
-	$(call if_changed,unroll)
-
-CFLAGS_raid6altivec8.o += $(altivec_flags)
-targets += raid6altivec8.c
-$(obj)/raid6altivec8.c:   UNROLL := 8
-$(obj)/raid6altivec8.c:   $(src)/raid6altivec.uc $(src)/unroll.pl FORCE
-	$(call if_changed,unroll)
-
-quiet_cmd_mktable = TABLE   $@
-      cmd_mktable = $(obj)/mktables > $@ || ( rm -f $@ && exit 1 )
-
-targets += raid6tables.c
-$(obj)/raid6tables.c: $(obj)/mktables FORCE
-	$(call if_changed,mktable)
diff --git a/lib/Kconfig b/lib/Kconfig
index 8ade0a7..18e0b5f 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -7,6 +7,9 @@ config BINARY_PRINTF
 
 menu "Library routines"
 
+config RAID6_PQ
+	tristate
+
 config BITREVERSE
 	tristate
 
diff --git a/lib/Makefile b/lib/Makefile
index 33a40e4..7f394cd 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -64,6 +64,7 @@ obj-$(CONFIG_ZLIB_DEFLATE) += zlib_deflate/
 obj-$(CONFIG_REED_SOLOMON) += reed_solomon/
 obj-$(CONFIG_LZO_COMPRESS) += lzo/
 obj-$(CONFIG_LZO_DECOMPRESS) += lzo/
+obj-$(CONFIG_RAID6_PQ) += raid6/
 
 lib-$(CONFIG_DECOMPRESS_GZIP) += decompress_inflate.o
 lib-$(CONFIG_DECOMPRESS_BZIP2) += decompress_bunzip2.o
diff --git a/lib/raid6/Makefile b/lib/raid6/Makefile
new file mode 100644
index 0000000..b2fe4ba
--- /dev/null
+++ b/lib/raid6/Makefile
@@ -0,0 +1,78 @@
+obj-$(CONFIG_RAID6_PQ)	+= raid6_pq.o
+
+raid6_pq-y	+= raid6algos.o raid6recov.o raid6tables.o \
+		   raid6int1.o raid6int2.o raid6int4.o \
+		   raid6int8.o raid6int16.o raid6int32.o \
+		   raid6altivec1.o raid6altivec2.o raid6altivec4.o \
+		   raid6altivec8.o \
+		   raid6mmx.o raid6sse1.o raid6sse2.o
+hostprogs-y	+= mktables
+
+quiet_cmd_unroll = UNROLL  $@
+      cmd_unroll = $(PERL) $(srctree)/$(src)/unroll.pl $(UNROLL) \
+                   < $< > $@ || ( rm -f $@ && exit 1 )
+
+ifeq ($(CONFIG_ALTIVEC),y)
+altivec_flags := -maltivec -mabi=altivec
+endif
+
+targets += raid6int1.c
+$(obj)/raid6int1.c:   UNROLL := 1
+$(obj)/raid6int1.c:   $(src)/raid6int.uc $(src)/unroll.pl FORCE
+	$(call if_changed,unroll)
+
+targets += raid6int2.c
+$(obj)/raid6int2.c:   UNROLL := 2
+$(obj)/raid6int2.c:   $(src)/raid6int.uc $(src)/unroll.pl FORCE
+	$(call if_changed,unroll)
+
+targets += raid6int4.c
+$(obj)/raid6int4.c:   UNROLL := 4
+$(obj)/raid6int4.c:   $(src)/raid6int.uc $(src)/unroll.pl FORCE
+	$(call if_changed,unroll)
+
+targets += raid6int8.c
+$(obj)/raid6int8.c:   UNROLL := 8
+$(obj)/raid6int8.c:   $(src)/raid6int.uc $(src)/unroll.pl FORCE
+	$(call if_changed,unroll)
+
+targets += raid6int16.c
+$(obj)/raid6int16.c:  UNROLL := 16
+$(obj)/raid6int16.c:  $(src)/raid6int.uc $(src)/unroll.pl FORCE
+	$(call if_changed,unroll)
+
+targets += raid6int32.c
+$(obj)/raid6int32.c:  UNROLL := 32
+$(obj)/raid6int32.c:  $(src)/raid6int.uc $(src)/unroll.pl FORCE
+	$(call if_changed,unroll)
+
+CFLAGS_raid6altivec1.o += $(altivec_flags)
+targets += raid6altivec1.c
+$(obj)/raid6altivec1.c:   UNROLL := 1
+$(obj)/raid6altivec1.c:   $(src)/raid6altivec.uc $(src)/unroll.pl FORCE
+	$(call if_changed,unroll)
+
+CFLAGS_raid6altivec2.o += $(altivec_flags)
+targets += raid6altivec2.c
+$(obj)/raid6altivec2.c:   UNROLL := 2
+$(obj)/raid6altivec2.c:   $(src)/raid6altivec.uc $(src)/unroll.pl FORCE
+	$(call if_changed,unroll)
+
+CFLAGS_raid6altivec4.o += $(altivec_flags)
+targets += raid6altivec4.c
+$(obj)/raid6altivec4.c:   UNROLL := 4
+$(obj)/raid6altivec4.c:   $(src)/raid6altivec.uc $(src)/unroll.pl FORCE
+	$(call if_changed,unroll)
+
+CFLAGS_raid6altivec8.o += $(altivec_flags)
+targets += raid6altivec8.c
+$(obj)/raid6altivec8.c:   UNROLL := 8
+$(obj)/raid6altivec8.c:   $(src)/raid6altivec.uc $(src)/unroll.pl FORCE
+	$(call if_changed,unroll)
+
+quiet_cmd_mktable = TABLE   $@
+      cmd_mktable = $(obj)/mktables > $@ || ( rm -f $@ && exit 1 )
+
+targets += raid6tables.c
+$(obj)/raid6tables.c: $(obj)/mktables FORCE
+	$(call if_changed,mktable)
diff --git a/drivers/md/mktables.c b/lib/raid6/mktables.c
similarity index 100%
rename from drivers/md/mktables.c
rename to lib/raid6/mktables.c
diff --git a/drivers/md/raid6algos.c b/lib/raid6/raid6algos.c
similarity index 100%
rename from drivers/md/raid6algos.c
rename to lib/raid6/raid6algos.c
diff --git a/drivers/md/raid6altivec.uc b/lib/raid6/raid6altivec.uc
similarity index 100%
rename from drivers/md/raid6altivec.uc
rename to lib/raid6/raid6altivec.uc
diff --git a/drivers/md/raid6int.uc b/lib/raid6/raid6int.uc
similarity index 100%
rename from drivers/md/raid6int.uc
rename to lib/raid6/raid6int.uc
diff --git a/drivers/md/raid6mmx.c b/lib/raid6/raid6mmx.c
similarity index 100%
rename from drivers/md/raid6mmx.c
rename to lib/raid6/raid6mmx.c
diff --git a/drivers/md/raid6recov.c b/lib/raid6/raid6recov.c
similarity index 100%
rename from drivers/md/raid6recov.c
rename to lib/raid6/raid6recov.c
diff --git a/drivers/md/raid6sse1.c b/lib/raid6/raid6sse1.c
similarity index 100%
rename from drivers/md/raid6sse1.c
rename to lib/raid6/raid6sse1.c
diff --git a/drivers/md/raid6sse2.c b/lib/raid6/raid6sse2.c
similarity index 100%
rename from drivers/md/raid6sse2.c
rename to lib/raid6/raid6sse2.c
diff --git a/drivers/md/raid6test/Makefile b/lib/raid6/raid6test/Makefile
similarity index 100%
rename from drivers/md/raid6test/Makefile
rename to lib/raid6/raid6test/Makefile
diff --git a/drivers/md/raid6test/test.c b/lib/raid6/raid6test/test.c
similarity index 100%
rename from drivers/md/raid6test/test.c
rename to lib/raid6/raid6test/test.c
diff --git a/drivers/md/raid6x86.h b/lib/raid6/raid6x86.h
similarity index 100%
rename from drivers/md/raid6x86.h
rename to lib/raid6/raid6x86.h
diff --git a/drivers/md/unroll.pl b/lib/raid6/unroll.pl
similarity index 100%
rename from drivers/md/unroll.pl
rename to lib/raid6/unroll.pl
-- 
1.6.2.5

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

