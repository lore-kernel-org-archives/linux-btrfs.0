Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35096 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932338AbaESQTw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 May 2014 12:19:52 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id BCEA9AC77
	for <linux-btrfs@vger.kernel.org>; Mon, 19 May 2014 16:19:50 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 1/5] btrfs-progs: doc: fix argument notation and typos
Date: Mon, 19 May 2014 18:19:50 +0200
Message-Id: <7ba6e8a22d20d73576fd6838219036dc52eb7fa3.1400515868.git.dsterba@suse.cz>
In-Reply-To: <cover.1400515867.git.dsterba@suse.cz>
References: <cover.1400515867.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

All user-supplied values should be enclosed in <...> to distinguish
them from verbatim strings.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 Documentation/btrfs-balance.txt          |  6 +++---
 Documentation/btrfs-check.txt            |  2 +-
 Documentation/btrfs-filesystem.txt       | 10 +++++-----
 Documentation/btrfs-image.txt            |  4 ++--
 Documentation/btrfs-inspect-internal.txt |  2 +-
 Documentation/btrfs-qgroup.txt           | 10 +++++-----
 Documentation/btrfs-scrub.txt            |  8 ++++----
 Documentation/btrfs-subvolume.txt        |  6 +++---
 Documentation/fsck.btrfs.txt             |  2 +-
 Documentation/mkfs.btrfs.txt             |  2 +-
 10 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/Documentation/btrfs-balance.txt b/Documentation/btrfs-balance.txt
index 1b1861cfd31f..7edc44b150dd 100644
--- a/Documentation/btrfs-balance.txt
+++ b/Documentation/btrfs-balance.txt
@@ -36,11 +36,11 @@ given balance all chunks in a filesystem.
 +
 `Options`
 +
--d[filters]::::
+-d[<filters>]::::
 act on data chunks
--m[filters]::::
+-m[<filters>]::::
 act on metadata chunks
--s[filters]::::
+-s[<filters>]::::
 act on system chunks (only under -f)
 -v::::
 be verbose
diff --git a/Documentation/btrfs-check.txt b/Documentation/btrfs-check.txt
index 485a49cbc3ec..ce491734a981 100644
--- a/Documentation/btrfs-check.txt
+++ b/Documentation/btrfs-check.txt
@@ -22,7 +22,7 @@ https://btrfs.wiki.kernel.org/index.php/Btrfsck
 
 OPTIONS
 -------
--s|--support <superblock>::
+-s|--super <superblock>::
 use <superblock>th superblock copy.
 --repair::
 try to repair the filesystem.
diff --git a/Documentation/btrfs-filesystem.txt b/Documentation/btrfs-filesystem.txt
index de9b3f3c39c4..4ac8711f62c0 100644
--- a/Documentation/btrfs-filesystem.txt
+++ b/Documentation/btrfs-filesystem.txt
@@ -17,7 +17,7 @@ resizing, defragment.
 
 SUBCOMMAND
 ----------
-'df' [-b] path [<path>...]::
+'df' [-b] <path> [<path>...]::
 Show space usage information for a mount point.
 +
 If '-b' is given, then byte is used as unit. Default unit will be
@@ -59,10 +59,10 @@ lower than 100% because the metadata is duplicated for security reasons.
 If all the data and metadata are duplicated (or have a profile like RAID1)
 the Data to disk ratio could be 50%.
 
-'show' [--mounted|--all-devices|<path>|<uuid>|<device>|<lable>]::
+'show' [--mounted|--all-devices|<path>|<uuid>|<device>|<label>]::
 Show the btrfs filesystem with some additional info.
 +
-If no option nor <path>|<uuid>|<device>|<lable> is passed, btrfs shows
+If no option nor <path>|<uuid>|<device>|<label> is passed, btrfs shows
 information of all the btrfs filesystem both mounted and unmounted.
 If '--mounted' is passed, it would probe btrfs kernel to list mounted btrfs
 filesystem(s);
@@ -109,7 +109,7 @@ don't use it if you use snapshots, have de-duplicated your data or made
 copies with `cp --reflink`.
 
 // Some wording are extracted by the resize2fs man page
-'resize' [devid:][+/-]<size>[gkm]|[devid:]max <path>::
+'resize' [<devid>:][+/-]<size>[gkm]|[<devid>:]max <path>::
 Resize a filesystem identified by <path> for the underlying device
 devid *online*. +
 The devid can be found with 'btrfs filesystem show' and
@@ -133,7 +133,7 @@ partition after reducing the size of the filesystem.  This can done using
 it with the new desired size.  When recreating the partition make sure to use
 the same starting disk cylinder as before.
 
-'label' [<dev>|<mount_point>] [newlabel]::
+'label' [<dev>|<mountpoint>] [<newlabel>]::
 Show or update the label of a filesystem.
 +
 [<device>|<mountpoint>] is used to identify the filesystem. 
diff --git a/Documentation/btrfs-image.txt b/Documentation/btrfs-image.txt
index bd74a86cff44..c41e36d6c59a 100644
--- a/Documentation/btrfs-image.txt
+++ b/Documentation/btrfs-image.txt
@@ -24,10 +24,10 @@ using 1 stripe pointing to primary device, so that file system can be
 restored by running tree log reply if possible. To restore without
 changing number of stripes in chunk tree check -o option.
 
--c value::
+-c <value>::
 Compression level (0 ~ 9).
 
--t value::
+-t <value>::
 Number of threads (1 ~ 32) to be used to process the image dump or restore.
 
 -o::
diff --git a/Documentation/btrfs-inspect-internal.txt b/Documentation/btrfs-inspect-internal.txt
index 4555c70670df..c5f751dc4f71 100644
--- a/Documentation/btrfs-inspect-internal.txt
+++ b/Documentation/btrfs-inspect-internal.txt
@@ -23,7 +23,7 @@ Resolves an <inode> in subvolume <path> to all filesystem paths.
 -v::::
 verbose mode. print count of returned paths and ioctl() return value
 
-'logical-resolve' [-Pv] [-s bufsize] <logical> <path>::
+'logical-resolve' [-Pv] [-s <bufsize>] <logical> <path>::
 Resolves a <logical> address in the filesystem mounted at <path> to all inodes.
 +
 By default, each inode is then resolved to a file system path (similar to the
diff --git a/Documentation/btrfs-qgroup.txt b/Documentation/btrfs-qgroup.txt
index d0544232f353..531febb3a086 100644
--- a/Documentation/btrfs-qgroup.txt
+++ b/Documentation/btrfs-qgroup.txt
@@ -73,15 +73,15 @@ print max exclusive size of qgroup.
 list all qgroups which impact the given path(include ancestral qgroups)
 -f::::
 list all qgroups which impact the given path(exclude ancestral qgroups)
---sort=[\+/-]ATTR[,[+/-]ATTR]...::::
-list qgroups in order of ATTR.
+--sort=[\+/-]<attr>[,[+/-]<attr>]...::::
+list qgroups in order of <attr>.
 +
-ATTR can be one or more of qgroupid,rfer,excl,max_rfer,max_excl.
+<attr> can be one or more of qgroupid,rfer,excl,max_rfer,max_excl.
 +
-Prefix \'+' means ascending order and \'-' means descending order of ATTR.
+Prefix \'+' means ascending order and \'-' means descending order of <attr>.
 If no prefix is given, use ascending order by default.
 +
-If multiple ATTRs is given, use comma to separate.
+If multiple <attr>s is given, use comma to separate.
 
 'limit' [options] <size>|none [<qgroupid>] <path>::
 Limit the size of a qgroup to <size> or no limit in the btrfs filesystem
diff --git a/Documentation/btrfs-scrub.txt b/Documentation/btrfs-scrub.txt
index 3973f3174c72..c87658739620 100644
--- a/Documentation/btrfs-scrub.txt
+++ b/Documentation/btrfs-scrub.txt
@@ -16,7 +16,7 @@ from all disks and verifying checksums.
 
 SUBCOMMAND
 ----------
-'start' [-BdqrRf] [-c ioprio_class -n ioprio_classdata] <path>|<device>::
+'start' [-BdqrRf] [-c <ioprio_class> -n <ioprio_classdata>] <path>|<device>::
 Start a scrub on all devices of the filesystem identified by <path> or on
 a single <device>.
 +
@@ -40,11 +40,11 @@ Quiet. Omit error messages and statistics.
 Read only mode. Do not attempt to correct anything.
 -R::::
 Raw print mode. Print full data instead of summary.
--c ioprio_class::::
+-c <ioprio_class>::::
 Set IO priority class (see
  ionice (1)
 manpage).
--n ioprio_classdata::::
+-n <ioprio_classdata>::::
 Set IO priority classdata (see `ionice`(1) manpage).
 -f::::
 force to check whether scrub has started or resumed in userspace.
@@ -58,7 +58,7 @@ using the scrub resume command.
 If a <device> is given, the corresponding filesystem is found and
 scrub cancel behaves as if it was called on that filesystem.
 
-'resume' [-BdqrR] [-c ioprio_class -n ioprio_classdata] <path>|<device>::
+'resume' [-BdqrR] [-c <ioprio_class> -n <ioprio_classdata>] <path>|<device>::
 Resume a canceled or interrupted scrub cycle on the filesystem identified by
 <path> or on a given <device>.
 +
diff --git a/Documentation/btrfs-subvolume.txt b/Documentation/btrfs-subvolume.txt
index 7f32dbdfe538..6cc72803b34a 100644
--- a/Documentation/btrfs-subvolume.txt
+++ b/Documentation/btrfs-subvolume.txt
@@ -75,7 +75,7 @@ wait for transaction commit at the end of the operation
 -C|--commit-each::::
 wait for transaction commit after delet each subvolume
 
-'list' [options] [-G [\+|-] values] [-C [+|-]value] [--sort=rootid,gen,ogen,path] <path>::
+'list' [options] [-G [\+|-]<value>] [-C [+|-]<value>] [--sort=rootid,gen,ogen,path] <path>::
 List the subvolumes present in the filesystem <path>.
 +
 For every subvolume the following information is shown by default. +
@@ -110,11 +110,11 @@ print the result as a table.
 only snapshot subvolumes in the filesystem will be listed.
 -r::::
 only readonly subvolumes in the filesystem will be listed.
--G [+|-]value::::
+-G [+|-]<value>::::
 list subvolumes in the filesystem that its generation is
 >=, \<= or = value. \'\+' means >= value, \'-' means \<= value, If there is
 neither \'+' nor \'-', it means = value.
--C [+|-]value::::
+-C [+|-]<value>::::
 list subvolumes in the filesystem that its ogeneration is
 >=, \<= or = value. The usage is the same to '-g' option.
 --sort=rootid,gen,ogen,path::::
diff --git a/Documentation/fsck.btrfs.txt b/Documentation/fsck.btrfs.txt
index 52e8e4d0375f..cc4544a58b1b 100644
--- a/Documentation/fsck.btrfs.txt
+++ b/Documentation/fsck.btrfs.txt
@@ -7,7 +7,7 @@ fsck.btrfs - do nothing, successfully
 
 SYNOPSIS
 --------
-'fsck.btrfs' [-aApy] [device...]
+'fsck.btrfs' [-aApy] [<device>...]
 
 DESCRIPTION
 -----------
diff --git a/Documentation/mkfs.btrfs.txt b/Documentation/mkfs.btrfs.txt
index 7ce009611d93..95098328bb68 100644
--- a/Documentation/mkfs.btrfs.txt
+++ b/Documentation/mkfs.btrfs.txt
@@ -20,7 +20,7 @@ $$[-M|--mixed]$$
 $$[-s|--sectorsize <sectorsize>]$$
 $$[-r|--rootdir <rootdir>]$$
 $$[-K|--nodiscard]$$
-$$[-O|--features <feature1>[<,feature2...>]]$$
+$$[-O|--features <feature1>[,<feature2>...]]$$
 $$[-h]$$
 $$[-V|--version]$$
 $$<device> [<device>...]$$
-- 
1.9.0

