From: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Subject: Re: [patch 1/2] grub-0.97: btrfs support for a singe device configuration
Date: Wed, 28 Oct 2009 22:30:25 +0100
Message-ID: <200910282230.25307.johannes.hirte@fem.tu-ilmenau.de>
References: <4ABBED68.6090801@redhat.com> <200910272335.04825.johannes.hirte@fem.tu-ilmenau.de> <4AE77BD3.2010400@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Cc: The development of BTRFS <linux-btrfs@vger.kernel.org>
To: Edward Shishkin <edward.shishkin@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4AE77BD3.2010400@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Am Mittwoch 28 Oktober 2009 00:01:39 schrieb Edward Shishkin:
> Johannes Hirte wrote:
> > Am Freitag 25 September 2009 00:06:32 schrieb Edward Shishkin:
> >   
> >>     
> > I was trying the patch and got a little confused. How did you get this work
> > without linking against libgcc?
> 
> Hmm.. Actually my Fedora stuff does link it:
> [...]
> 
> +btrfs_stage1_5_exec_LDADD = @LIBGCC@
> 
> [...]
> I guess you have missed it when porting to Gentoo..

Ok, I've got it. I had to add -lgcc also for some more targets in Makefile.am:

if NETBOOT_SUPPORT
-pre_stage2_exec_LDADD = ../netboot/libdrivers.a
+pre_stage2_exec_LDADD = ../netboot/libdrivers.a -lgcc
+else
+pre_stage2_exec_LDADD = -lgcc
 endif

 if DISKLESS_SUPPORT
@@ -197,6 +201,16 @@
        -DNO_BLOCK_FILES=1
 reiserfs_stage1_5_exec_LDFLAGS = $(STAGE1_5_LINK)

+# For btrfs_stage1_5 target.
+btrfs_stage1_5_exec_SOURCES = start.S asm.S common.c char_io.c \
+       disk_io.c stage1_5.c fsys_btrfs.c bios.c
+btrfs_stage1_5_exec_CFLAGS = $(STAGE1_5_COMPILE) -DFSYS_BTRFS=1 \
+       -DNO_BLOCK_FILES=1
+btrfs_stage1_5_exec_CCASFLAGS = $(STAGE1_5_COMPILE) -DFSYS_BTRFS=1 \
+       -DNO_BLOCK_FILES=1
+btrfs_stage1_5_exec_LDFLAGS = $(STAGE1_5_LINK)
+btrfs_stage1_5_exec_LDADD = -lgcc
+
 # For vstafs_stage1_5 target.
 vstafs_stage1_5_exec_SOURCES = start.S asm.S common.c char_io.c \
        disk_io.c stage1_5.c fsys_vstafs.c bios.c
@@ -240,7 +254,7 @@
 diskless_exec_CCASFLAGS = $(STAGE2_COMPILE) $(FSYS_CFLAGS) \
        -DSUPPORT_DISKLESS=1
 diskless_exec_LDFLAGS = $(PRE_STAGE2_LINK)
-diskless_exec_LDADD = ../netboot/libdrivers.a
+diskless_exec_LDADD = ../netboot/libdrivers.a -lgcc

 diskless_size.h: diskless
        -rm -f $@

This compiles and works, but only with stage2. When using stage1_5, grub hangs
on boot with

GRUB loading stage1.5 

and blinking cursor. Is the multidevice patch also necessary for single 
devices? I've omitted this patch, since my root-fs (with /boot) lies on a 
single partition.
