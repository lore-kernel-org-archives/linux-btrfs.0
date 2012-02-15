From: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: Problems Implementing Snappy Patches
Date: Wed, 15 Feb 2012 16:46:00 -0600
Message-ID: <CAKcLGm_AgoHWa1TGwxz6PfSkKvxmDXi_3ykHR10WgTFVW9Gt4g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I've been trying to test the snappy compression patches, but I'm
getting corruptions when trying to use snappy as built on my system.

I'm checking out the Linux 3.2.6 kernel, merging that with the latest
'for-linus' branch on Chris Mason's kernel.org repo, and then
integrating the snappy and lz4 patches from David Sterba's git
repository (dev/compression-squad branch).

I've tried a simple merge of the dev/compression-squad branch (which
merged without complaint by git), and I also tried a second build of
the kernel integrating the dev/compression-squad branch patches with
format-patch (git format-patch -k -m -U5 --stdout <range> | git am -3
-k).

I've also tried sourcing my snappy patches from Chris Mason's snappy
branch on kernel.org with the same result.

I get the same results either way.

My system is a Core 2 Duo x86_64 Sabayon based system (Gentoo is our
parent distro).  My target btrfs/snappy partition is a 16 GB partition
I use for testing on a 500GB Western Digital Hard Drive.

When I copy directory containing a kernel sources git repository to a
freshly formated partition mounted with snappy, I get a corrupted
copy.  If I mount with lzo or lz4 compression, I don't see any
corruptions from the copy.

I'm not showing any errors in dmesg.

My procedure to replicate is as follows:

mkfs.btrfs -m single /dev/sdb6
mount -o compress-force=snappy,autodefrag /dev/sdb6 /mnt/benchmark/
cp -a /var/tmp/portage/subdir1 /mnt/benchmark/
diff -Naur /var/tmp/portage/subdir1 /mnt/benchmark/subdir1 | less

I've spot checked the corrupted files with filefrag, and the one's
I've checked are *NOT* in-lined.

The following is a brief, representative excerpt of the diff (the full
diff is very long):

diff -Naur /var/tmp/portage/subdir1/linux-btrfs-backport/drivers/net/bnx2x/bnx2x_reg.h
/mnt/benchmark/subdir1/linux-btrfs-backport/drivers/net/bnx2x/bnx2x_reg.h
--- /var/tmp/portage/subdir1/linux-btrfs-backport/drivers/net/bnx2x/bnx2x_reg.h
2011-01-12 16:31:39.000000000 -0600
+++ /mnt/benchmark/subdir1/linux-btrfs-backport/drivers/net/bnx2x/bnx2x_reg.h
  2011-01-12 16:31:39.000000000 -0600
@@ -4051,76 +4051,73 @@
 #define UCM_REG_TM_INIT_CRD                                     0xe021c
 /* [RW 28] The CM header for Timers expiration command. */
 #define UCM_REG_TM_UCM_HDR                                      0xe009c
-/* [RW 1] Timers - CM Interface enable. If 0 - the valid input is
+/* [RW  Timimers - CM Interface enable. If 0 - the valid input is
    disregarded; acknowledge output is deasserted; all other signals are
    treated as usual; if 1 - normal activity. */
-#define UCM_REG_TM_UCM_IFEN                                     0xe001c
-/* [RW 3] The weight of the Timers input in the WRR mechanism. 0 stands for
-   weight 8 (the most prioritised); 1 stands for weight 1(least
-   prioritised); 2 stands for weight 2; tc. */
+#define UCM_REG_TM_UCM_IFEN                                     0xe00
+/* * [RW 3] The weight of the mers input i in the WRR mechanism. 0 stands for
+   ightht 8 (the most prioritised); 1 stands foreighght 1(least
+   ioritised); ; 2 stands for weight 2; tc. */
 #define UCM_REG_TM_WEIGHT                                       0xe00d4
-/* [RW 1] Input tsem Interface enable. If 0 - the valid input is
+/* [RW  TiInput tsem Interface enable. If 0 - the valid input is
    disregarded; acknowledge output is deasserted; all other signals are
    treated as usual; if 1 - normal activity. */
-#define UCM_REG_TSEM_IFEN                                       0xe0024
-/* [RC 1] Set when the message length mismatch (relative to last indication)
-   at the tsem interface is detected. */
+#define UCM_REG_TSEM_IFEN                                       0xe00
+/* * [RC 1] Set when the message length mismatch (relative to last indication)
+    thehe tsem terfrface is detected. */
 #define UCM_REG_TSEM_LENGTH_MIS                                 0xe015c


Here's a list of the top commits in my git repository:

54ca0b5 btrfs: lz4: tune speed/compression ratio
7ead5fb btrfs: lz4: add wrapper functions and enable it
3a611a7 btrfs: lz4: add wrapper for context size estimation
ae2de6b btrfs: add LZ4 compression method
56e0aa6 btrfs: prepare incompat flags for more compression methods
540f832 Btrfs: fix decompressing of snappy-compressed inline extents
8f8b19f8 Btrfs: fix incompat flags setting
369cc38 SNAPPY: Add dual GPL/BSD license to snappy module
b479967 Add snappy interface to crypto API
e68c69a BTRFS: Add snappy support v2
428ac51 Add the snappy-c compressor to lib v2
4d0defa Merge branch 'for-linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs into
linux-3.2.6-btrfs-lz4-v6.3
c2db2e2 Linux 3.2.6
