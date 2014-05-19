Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35104 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932420AbaESQUX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 May 2014 12:20:23 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 0D3FBAC77
	for <linux-btrfs@vger.kernel.org>; Mon, 19 May 2014 16:20:22 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 4/5] btrfs-progs: doc: make all commands and subcommands bold
Date: Mon, 19 May 2014 18:20:21 +0200
Message-Id: <a4197dfe24a1964f43734af126188c100885d88e.1400515868.git.dsterba@suse.cz>
In-Reply-To: <cover.1400515867.git.dsterba@suse.cz>
References: <cover.1400515867.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Italic format is used for parameters and values, bold makes the text visually
separated.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 Documentation/btrfs-balance.txt          | 22 +++++++--------
 Documentation/btrfs-check.txt            | 14 +++++-----
 Documentation/btrfs-convert.txt          |  6 ++---
 Documentation/btrfs-debug-tree.txt       |  6 ++---
 Documentation/btrfs-device.txt           | 20 +++++++-------
 Documentation/btrfs-filesystem.txt       | 22 +++++++--------
 Documentation/btrfs-find-root.txt        |  6 ++---
 Documentation/btrfs-image.txt            |  6 ++---
 Documentation/btrfs-inspect-internal.txt | 16 +++++------
 Documentation/btrfs-map-logical.txt      |  6 ++---
 Documentation/btrfs-property.txt         | 20 +++++++-------
 Documentation/btrfs-qgroup.txt           | 24 ++++++++---------
 Documentation/btrfs-quota.txt            | 14 +++++-----
 Documentation/btrfs-receive.txt          | 10 +++----
 Documentation/btrfs-replace.txt          | 14 +++++-----
 Documentation/btrfs-rescue.txt           | 14 +++++-----
 Documentation/btrfs-restore.txt          | 10 +++----
 Documentation/btrfs-scrub.txt            | 20 +++++++-------
 Documentation/btrfs-send.txt             |  8 +++---
 Documentation/btrfs-show-super.txt       |  6 ++---
 Documentation/btrfs-subvolume.txt        | 28 +++++++++----------
 Documentation/btrfs-zero-log.txt         | 12 ++++-----
 Documentation/btrfs.txt                  | 46 ++++++++++++++++----------------
 Documentation/btrfstune.txt              |  6 ++---
 Documentation/fsck.btrfs.txt             |  6 ++---
 Documentation/mkfs.btrfs.txt             |  8 +++---
 26 files changed, 185 insertions(+), 185 deletions(-)

diff --git a/Documentation/btrfs-balance.txt b/Documentation/btrfs-balance.txt
index 7edc44b150dd..d34833d6f380 100644
--- a/Documentation/btrfs-balance.txt
+++ b/Documentation/btrfs-balance.txt
@@ -7,11 +7,11 @@ btrfs-balance - balance btrfs filesystem
 
 SYNOPSIS
 --------
-'btrfs [filesystem] balance' <subcommand>|<args>
+*btrfs [filesystem] balance* <subcommand>|<args>
 
 DESCRIPTION
 -----------
-'btrfs balance' is used to balance chunks in a btrfs filesystem across
+*btrfs balance* is used to balance chunks in a btrfs filesystem across
 multiple or even single device.
 
 See `btrfs-device`(8) for more details about the effect on device management.
@@ -21,10 +21,10 @@ SUBCOMMAND
 <path>::
 Balance chunks across the devices *online*.
 +
-'btrfs balance <path>' is deprecated,
-please use 'btrfs balance start' command instead.
+*btrfs balance <path>* is deprecated,
+please use *btrfs balance start* command instead.
 
-'start' [options] <path>::
+*start* [options] <path>::
 Balance chunks across the devices *online*.
 +
 Balance and/or convert (change allocation profile of) chunks that
@@ -47,28 +47,28 @@ be verbose
 -f::::
 force reducing of metadata integrity
 
-'pause' <path>::
+*pause* <path>::
 Pause running balance.
 
-'cancel' <path>::
+*cancel* <path>::
 Cancel running or paused balance.
 
-'resume' <path>::
+*resume* <path>::
 Resume interrupted balance.
 
-'status' [-v] <path>::
+*status* [-v] <path>::
 Show status of running or paused balance.
 +
 If '-v' option is given, output will be verbose.
 
 EXIT STATUS
 -----------
-'btrfs balance' returns a zero exist status if it succeeds. Non zero is
+*btrfs balance* returns a zero exist status if it succeeds. Non zero is
 returned in case of failure.
 
 AVAILABILITY
 ------------
-'btrfs' is part of btrfs-progs. Btrfs filesystem is currently under heavy
+*btrfs* is part of btrfs-progs. Btrfs filesystem is currently under heavy
 development,
 and not suitable for any uses other than benchmarking and review.
 Please refer to the btrfs wiki http://btrfs.wiki.kernel.org for
diff --git a/Documentation/btrfs-check.txt b/Documentation/btrfs-check.txt
index ce491734a981..073667265c13 100644
--- a/Documentation/btrfs-check.txt
+++ b/Documentation/btrfs-check.txt
@@ -7,18 +7,18 @@ btrfs-check - check or repair a btrfs filesystem offline
 
 SYNOPSIS
 --------
-'btrfs check' [options] <device>
+*btrfs check* [options] <device>
 
 DESCRIPTION
 -----------
-'btrfs check' is used to check or repair a btrfs filesystem offline.
+*btrfs check* is used to check or repair a btrfs filesystem offline.
 
-NOTE: Since btrfs is under heavy development especially the 'btrfs check'
+NOTE: Since btrfs is under heavy development especially the *btrfs check*
 command, it is *highly* recommended to read the following btrfs wiki before
-executing 'btrfs check' with '--repair' option: +
+executing *btrfs check* with '--repair' option: +
 https://btrfs.wiki.kernel.org/index.php/Btrfsck
 
-'btrfsck' is an alias of 'btrfs check' command and is now deprecated.
+*btrfsck* is an alias of *btrfs check* command and is now deprecated.
 
 OPTIONS
 -------
@@ -33,12 +33,12 @@ create a new extent tree.
 
 EXIT STATUS
 -----------
-'btrfs check' returns a zero exist status if it succeeds. Non zero is
+*btrfs check* returns a zero exist status if it succeeds. Non zero is
 returned in case of failure.
 
 AVAILABILITY
 ------------
-'btrfs' is part of btrfs-progs. Btrfs filesystem is currently under heavy
+*btrfs* is part of btrfs-progs. Btrfs filesystem is currently under heavy
 development,
 and not suitable for any uses other than benchmarking and review.
 Please refer to the btrfs wiki http://btrfs.wiki.kernel.org for
diff --git a/Documentation/btrfs-convert.txt b/Documentation/btrfs-convert.txt
index 780ca9ef052a..ed61d143d59f 100644
--- a/Documentation/btrfs-convert.txt
+++ b/Documentation/btrfs-convert.txt
@@ -7,11 +7,11 @@ btrfs-convert - convert from ext2/3/4 filesystem to btrfs or rollback
 
 SYNOPSIS
 --------
-'btrfs-convert' [options] <device>
+*btrfs-convert* [options] <device>
 
 DESCRIPTION
 -----------
-'btrfs-convert' is used to convert existed ext2/3/4 to btrfs filesystem,
+*btrfs-convert* is used to convert existed ext2/3/4 to btrfs filesystem,
 and the original filesystem image is accessible as from separate subvolume
 named 'ext2_subvol' as file image.
 
@@ -28,7 +28,7 @@ Roll back to ext2fs.
 
 EXIT STATUS
 -----------
-'btrfs-convert' will return 0 if no error happened.
+*btrfs-convert* will return 0 if no error happened.
 If any problems happened, 1 will be returned.
 
 AUTHOR
diff --git a/Documentation/btrfs-debug-tree.txt b/Documentation/btrfs-debug-tree.txt
index 80a85d44cdbb..bfc8aa401abb 100644
--- a/Documentation/btrfs-debug-tree.txt
+++ b/Documentation/btrfs-debug-tree.txt
@@ -7,11 +7,11 @@ btrfs-debug-tree - dump btrfs filesystem metadata into stdout
 
 SYNOPSIS
 --------
-'btrfs-debug-tree' [options] <device>
+*btrfs-debug-tree* [options] <device>
 
 DESCRIPTION
 -----------
-'btrfs-debug-tree' is used to dump the whole tree of the given device.
+*btrfs-debug-tree* is used to dump the whole tree of the given device.
 
 This is maybe useful for analyzing filesystem state or inconsistence and has
 a positive educational effect on understanding the internal structure.
@@ -30,7 +30,7 @@ Print info of the specified block only.
 
 EXIT STATUS
 -----------
-'btrfs-debug-tree' will return 0 if no error happened.
+*btrfs-debug-tree* will return 0 if no error happened.
 If any problems happened, 1 will be returned.
 
 AUTHOR
diff --git a/Documentation/btrfs-device.txt b/Documentation/btrfs-device.txt
index 9cd8ad081a5a..4f847763bb66 100644
--- a/Documentation/btrfs-device.txt
+++ b/Documentation/btrfs-device.txt
@@ -7,12 +7,12 @@ btrfs-device - control btrfs devices
 
 SYNOPSIS
 --------
-'btrfs device' <subcommand> <args>
+*btrfs device* <subcommand> <args>
 
 DESCRIPTION
 -----------
-'btrfs device' is used to control the btrfs devices, since btrfs can be used
-across several devices, 'btrfs device' is used for multiple device management.
+*btrfs device* is used to control the btrfs devices, since btrfs can be used
+across several devices, *btrfs device* is used for multiple device management.
 
 DEVICE MANAGEMENT
 -----------------
@@ -62,7 +62,7 @@ See `btrfs-replace`(8) and this man page for more details.
 
 SUBCOMMAND
 ----------
-'add' [-Kf] <dev> [<dev>...] <path>::
+*add* [-Kf] <dev> [<dev>...] <path>::
 Add device(s) to the filesystem identified by <path>.
 +
 If applicable, a whole device discard (TRIM) operation is performed.
@@ -74,10 +74,10 @@ do not perform discard by default
 -f|--force::::
 force overwrite of existing filesystem on the given disk(s)
 
-'delete' <dev> [<dev>...] <path>::
+*delete* <dev> [<dev>...] <path>::
 Remove device(s) from a filesystem identified by <path>.
 
-'scan' [(--all-devices|-d)|<device> [<device>...]]::
+*scan* [(--all-devices|-d)|<device> [<device>...]]::
 Scan devices for a btrfs filesystem.
 +
 If one or more devices are passed, these are scanned for a btrfs filesystem. 
@@ -86,10 +86,10 @@ filesystem as listed by blkid.
 Finally, if '--all-devices' or '-d' is passed, all the devices under /dev are 
 scanned.
 
-'ready' <device>::
+*ready* <device>::
 Check device to see if it has all of it's devices in cache for mounting.
 
-'stats' [-z] <path>|<device>::
+*stats* [-z] <path>|<device>::
 Read and print the device IO stats for all devices of the filesystem
 identified by <path> or for a single <device>.
 +
@@ -100,12 +100,12 @@ Reset stats to zero after reading them.
 
 EXIT STATUS
 -----------
-'btrfs device' returns a zero exist status if it succeeds. Non zero is
+*btrfs device* returns a zero exist status if it succeeds. Non zero is
 returned in case of failure.
 
 AVAILABILITY
 ------------
-'btrfs' is part of btrfs-progs. Btrfs filesystem is currently under heavy
+*btrfs* is part of btrfs-progs. Btrfs filesystem is currently under heavy
 development,
 and not suitable for any uses other than benchmarking and review.
 Please refer to the btrfs wiki http://btrfs.wiki.kernel.org for
diff --git a/Documentation/btrfs-filesystem.txt b/Documentation/btrfs-filesystem.txt
index 63e3ef676cd3..e3e270ff0957 100644
--- a/Documentation/btrfs-filesystem.txt
+++ b/Documentation/btrfs-filesystem.txt
@@ -7,20 +7,20 @@ btrfs-filesystem - control btrfs filesystem
 
 SYNOPSIS
 --------
-'btrfs filesystem' <subcommand> <args>
+*btrfs filesystem* <subcommand> <args>
 
 DESCRIPTION
 -----------
-'btrfs filesystem' is used to do the filesystem level control jobs, including
+*btrfs filesystem* is used to do the filesystem level control jobs, including
 all the regular filesystem operations like setting/getting label,
 resizing, defragment.
 
 SUBCOMMAND
 ----------
-'df' <path> [<path>...]::
+*df* <path> [<path>...]::
 Show space usage information for a mount point.
 
-'show' [--mounted|--all-devices|<path>|<uuid>|<device>|<label>]::
+*show* [--mounted|--all-devices|<path>|<uuid>|<device>|<label>]::
 Show the btrfs filesystem with some additional info.
 +
 If no option nor <path>|<uuid>|<device>|<label> is passed, btrfs shows
@@ -30,10 +30,10 @@ filesystem(s);
 If '--all-devices' is passed, all the devices under /dev are scanned;
 otherwise the devices list is extracted from the /proc/partitions file.
 
-'sync' <path>::
+*sync* <path>::
 Force a sync for the filesystem identified by <path>.
 
-'defragment' [options] <file>|<dir> [<file>|<dir>...]::
+*defragment* [options] <file>|<dir> [<file>|<dir>...]::
 Defragment file data and/or directory metadata *online*.
 +
 If '-r' is passed, files in dir will be defragmented recursively.
@@ -70,10 +70,10 @@ don't use it if you use snapshots, have de-duplicated your data or made
 copies with `cp --reflink`.
 
 // Some wording are extracted by the resize2fs man page
-'resize' [<devid>:][+/-]<size>[gkm]|[<devid>:]max <path>::
+*resize* [<devid>:][+/-]<size>[gkm]|[<devid>:]max <path>::
 Resize a filesystem identified by <path> for the underlying device
 devid *online*. +
-The devid can be found with 'btrfs filesystem show' and
+The devid can be found with *btrfs filesystem show* and
 defaults to 1 if not specified.
 The <size> parameter specifies the new size of the filesystem.
 If the prefix + or - is present the size is increased or decreased
@@ -94,7 +94,7 @@ partition after reducing the size of the filesystem.  This can done using
 it with the new desired size.  When recreating the partition make sure to use
 the same starting disk cylinder as before.
 
-'label' [<dev>|<mountpoint>] [<newlabel>]::
+*label* [<dev>|<mountpoint>] [<newlabel>]::
 Show or update the label of a filesystem.
 +
 [<device>|<mountpoint>] is used to identify the filesystem. 
@@ -103,12 +103,12 @@ NOTE: the maximum allowable length shall be less than 256 chars
 
 EXIT STATUS
 -----------
-'btrfs filesystem' returns a zero exist status if it succeeds. Non zero is
+*btrfs filesystem* returns a zero exist status if it succeeds. Non zero is
 returned in case of failure.
 
 AVAILABILITY
 ------------
-'btrfs' is part of btrfs-progs. Btrfs filesystem is currently under heavy
+*btrfs* is part of btrfs-progs. Btrfs filesystem is currently under heavy
 development,
 and not suitable for any uses other than benchmarking and review.
 Please refer to the btrfs wiki http://btrfs.wiki.kernel.org for
diff --git a/Documentation/btrfs-find-root.txt b/Documentation/btrfs-find-root.txt
index 18b1e845b143..a360f8f6e9f2 100644
--- a/Documentation/btrfs-find-root.txt
+++ b/Documentation/btrfs-find-root.txt
@@ -7,11 +7,11 @@ btrfs-find-root - filter to find btrfs root
 
 SYNOPSIS
 --------
-'btrfs-find-root' [options] <dev>
+*btrfs-find-root* [options] <dev>
 
 DESCRIPTION
 -----------
-'btrfs-find-root' is used to find the satisfied root, you can filter by
+*btrfs-find-root* is used to find the satisfied root, you can filter by
 root tree's objectid, generation, level.
 
 OPTIONS
@@ -25,7 +25,7 @@ Filter root tree by B-+ tree's level, level 0 in default.
 
 EXIT STATUS
 -----------
-'btrfs-find-root' will return 0 if no error happened.
+*btrfs-find-root* will return 0 if no error happened.
 If any problems happened, 1 will be returned.
 
 AUTHOR
diff --git a/Documentation/btrfs-image.txt b/Documentation/btrfs-image.txt
index c41e36d6c59a..7ee820c22721 100644
--- a/Documentation/btrfs-image.txt
+++ b/Documentation/btrfs-image.txt
@@ -7,11 +7,11 @@ btrfs-image - create/restore an image of the filesystem
 
 SYNOPSIS
 --------
-'btrfs-image' [options] <source> <target>
+*btrfs-image* [options] <source> <target>
 
 DESCRIPTION
 -----------
-'btrfs-image' is used to create an image of a btrfs filesystem.
+*btrfs-image* is used to create an image of a btrfs filesystem.
 All data will be zeroed, but metadata and the like is preserved.
 
 Mainly used for debug purpose.
@@ -50,7 +50,7 @@ captured.
 
 EXIT STATUS
 -----------
-'btrfs-image' will return 0 if no error happened.
+*btrfs-image* will return 0 if no error happened.
 If any problems happened, 1 will be returned.
 
 AUTHOR
diff --git a/Documentation/btrfs-inspect-internal.txt b/Documentation/btrfs-inspect-internal.txt
index c5f751dc4f71..fe76217365b0 100644
--- a/Documentation/btrfs-inspect-internal.txt
+++ b/Documentation/btrfs-inspect-internal.txt
@@ -7,15 +7,15 @@ btrfs-inspect-internal - resolve different btrfs items for debug purpose
 
 SYNOPSIS
 --------
-'btrfs inspect-internal' <subcommand> <args>
+*btrfs inspect-internal* <subcommand> <args>
 
 DESCRIPTION
 -----------
-'btrfs inspect-internal' is used to resolve different items for debug purpose.
+*btrfs inspect-internal* is used to resolve different items for debug purpose.
 
 SUBCOMMAND
 ----------
-'inode-resolve' [-v] <inode> <path>::
+*inode-resolve* [-v] <inode> <path>::
 Resolves an <inode> in subvolume <path> to all filesystem paths.
 +
 `Options`
@@ -23,7 +23,7 @@ Resolves an <inode> in subvolume <path> to all filesystem paths.
 -v::::
 verbose mode. print count of returned paths and ioctl() return value
 
-'logical-resolve' [-Pv] [-s <bufsize>] <logical> <path>::
+*logical-resolve* [-Pv] [-s <bufsize>] <logical> <path>::
 Resolves a <logical> address in the filesystem mounted at <path> to all inodes.
 +
 By default, each inode is then resolved to a file system path (similar to the
@@ -41,10 +41,10 @@ set inode container's size.
 This is used to increase inode container's size in case it is
 not enough to read all the resolved results. The max value one can set is 64k.
 
-'subvolid-resolve' <subvolid> <path>::
+*subvolid-resolve* <subvolid> <path>::
 Get file system paths for the given subvolume ID.
 
-'rootid' <path>::
+*rootid* <path>::
 For a given file or directory, return the containing tree root id. For a
 subvolume return it's own tree id.
 +
@@ -52,12 +52,12 @@ The result is undefined for the so-called empty subvolumes (identified by inode
 
 EXIT STATUS
 -----------
-'btrfs inspect-internal' returns a zero exist status if it succeeds. Non zero is
+*btrfs inspect-internal* returns a zero exist status if it succeeds. Non zero is
 returned in case of failure.
 
 AVAILABILITY
 ------------
-'btrfs' is part of btrfs-progs. Btrfs filesystem is currently under heavy
+*btrfs* is part of btrfs-progs. Btrfs filesystem is currently under heavy
 development,
 and not suitable for any uses other than benchmarking and review.
 Please refer to the btrfs wiki http://btrfs.wiki.kernel.org for
diff --git a/Documentation/btrfs-map-logical.txt b/Documentation/btrfs-map-logical.txt
index 2a93fb052514..a8710bfa24b0 100644
--- a/Documentation/btrfs-map-logical.txt
+++ b/Documentation/btrfs-map-logical.txt
@@ -7,11 +7,11 @@ btrfs-map-logical - map btrfs logical extent to physical extent
 
 SYNOPSIS
 --------
-'btrfs-map-logical' <options> <device>
+*btrfs-map-logical* <options> <device>
 
 DESCRIPTION
 -----------
-'btrfs-map-logical' can be used to find out what the physical offsets are
+*btrfs-map-logical* can be used to find out what the physical offsets are
 on the mirrors, the result is dumped into stdout in default.
 
 Mainly used for debug purpose.
@@ -29,7 +29,7 @@ Number of bytes to read.
 
 EXIT STATUS
 -----------
-'btrfs-map-logical' will return 0 if no error happened.
+*btrfs-map-logical* will return 0 if no error happened.
 If any problems happened, 1 will be returned.
 
 AUTHOR
diff --git a/Documentation/btrfs-property.txt b/Documentation/btrfs-property.txt
index 82466f9e6dff..4b0f49e04b20 100644
--- a/Documentation/btrfs-property.txt
+++ b/Documentation/btrfs-property.txt
@@ -7,20 +7,20 @@ btrfs-property - get/set/list properties for given btrfs object.
 
 SYNOPSIS
 --------
-'btrfs property' <subcommand> <args>
+*btrfs property* <subcommand> <args>
 
 DESCRIPTION
 -----------
-'btrfs property' is used to get/set/list property, like lable or compression
+*btrfs property* is used to get/set/list property, like lable or compression
 state, for given btrfs object.
 
-'btrfs property' provides an unified and user-friendly method to tune different
+*btrfs property* provides an unified and user-friendly method to tune different
 btrfs properties instead of using the traditional method like `chattr`(1) or
 `lsattr`(1).
 
 SUBCOMMAND
 ----------
-'get' [-t <type>] <object> [<name>]::
+*get* [-t <type>] <object> [<name>]::
 Gets a property from a btrfs object.
 +
 If no name is specified, all properties for the given object are
@@ -37,26 +37,26 @@ Possible types are 's[ubvol]', 'f[ilesystem]', 'i[node]' and 'd[evice]'.
 The <object> can be path of btrfs device, btrfs mount point, or any
 directories/files inside btrfs.
 
-'set' [-t <type>] <object> <name> <value>::
+*set* [-t <type>] <object> <name> <value>::
 Sets a property on a btrfs object.
 +
-See description of 'get' subcommand for a description of objects and object
+See description of *get* subcommand for a description of objects and object
 types.
 
-'list' [-t <type>] <object>::
+*list* [-t <type>] <object>::
 Lists available properties with their descriptions for the given object.
 +
-Please see the help of 'btrfs property get' for a description of
+Please see the help of *btrfs property get* for a description of
 objects and object types.
 
 EXIT STATUS
 -----------
-'btrfs property' returns a zero exist status if it succeeds. Non zero is
+*btrfs property* returns a zero exist status if it succeeds. Non zero is
 returned in case of failure.
 
 AVAILABILITY
 ------------
-'btrfs' is part of btrfs-progs. Btrfs filesystem is currently under heavy
+*btrfs* is part of btrfs-progs. Btrfs filesystem is currently under heavy
 development,
 and not suitable for any uses other than benchmarking and review.
 Please refer to the btrfs wiki http://btrfs.wiki.kernel.org for
diff --git a/Documentation/btrfs-qgroup.txt b/Documentation/btrfs-qgroup.txt
index 531febb3a086..12321926b25b 100644
--- a/Documentation/btrfs-qgroup.txt
+++ b/Documentation/btrfs-qgroup.txt
@@ -7,13 +7,13 @@ btrfs-qgroup - control the quota group of a btrfs filesystem
 
 SYNOPSIS
 --------
-'btrfs qgroup' <subcommand> <args>
+*btrfs qgroup* <subcommand> <args>
 
 DESCRIPTION
 -----------
-'btrfs qgroup' is used to control quota group(qgroup) of a btrfs filesystem.
+*btrfs qgroup* is used to control quota group(qgroup) of a btrfs filesystem.
 
-NOTE: To use qgroup, it needs to enable quota first using 'btrfs quota'
+NOTE: To use qgroup, it needs to enable quota first using *btrfs quota*
 command.
 
 WARNING: Qgroup is not stable yet and will impact performance in current mainline
@@ -29,34 +29,34 @@ Also for snapshot, it consumes no quota initially since all its data
 shares with its parent, so only modification in snapshot consumes quota.
 
 Every subvolume/snapshot will have its own qgroup with id '0/<subvolume id>'
-upon creating, but can be later destroyed by 'btrfs qgroup destroy' command.
+upon creating, but can be later destroyed by *btrfs qgroup destroy* command.
 
 NOTE: If the qgroup of a subvolume is destroyed, quota about the subvolume
 will not be functional until qgroup '0/<subvolume id>' is created again.
 
 SUBCOMMAND
 ----------
-'assign' <src> <dst> <path>::
+*assign* <src> <dst> <path>::
 Assign qgroup <src> as the child qgroup of <dst> in the btrfs filesystem
 identified by <path>.
 
-'remove' <src> <dst> <path>::
+*remove* <src> <dst> <path>::
 Remove the relationship between child qgroup <src> and parent qgroup <dst> in
 the btrfs filesystem identified by <path>.
 
-'create' <qgroupid> <path>::
+*create* <qgroupid> <path>::
 Create a subvolume quota group.
 +
 For the '0/<subvolume id>' qgroup, a qgroup can be created even before the
 subvolume created.
 
-'destroy' <qgroupid> <path>::
+*destroy* <qgroupid> <path>::
 Destroy a qgroup.
 +
 If a qgroup is no isolated,which means it is a parent or child qgroup, it
 can't be destroyed.
 
-'show' [options] <path>::
+*show* [options] <path>::
 Show all qgroups in the btrfs filesystem identified by <path>.
 +
 `Options`
@@ -83,7 +83,7 @@ If no prefix is given, use ascending order by default.
 +
 If multiple <attr>s is given, use comma to separate.
 
-'limit' [options] <size>|none [<qgroupid>] <path>::
+*limit* [options] <size>|none [<qgroupid>] <path>::
 Limit the size of a qgroup to <size> or no limit in the btrfs filesystem
 identified by <path>.
 +
@@ -92,12 +92,12 @@ is used if possible.
 
 EXIT STATUS
 -----------
-'btrfs qgroup' returns a zero exist status if it succeeds. Non zero is
+*btrfs qgroup* returns a zero exist status if it succeeds. Non zero is
 returned in case of failure.
 
 AVAILABILITY
 ------------
-'btrfs' is part of btrfs-progs. Btrfs filesystem is currently under heavy
+*btrfs* is part of btrfs-progs. Btrfs filesystem is currently under heavy
 development,
 and not suitable for any uses other than benchmarking and review.
 Please refer to the btrfs wiki http://btrfs.wiki.kernel.org for
diff --git a/Documentation/btrfs-quota.txt b/Documentation/btrfs-quota.txt
index 82f2f499c730..f7b0fd13b0db 100644
--- a/Documentation/btrfs-quota.txt
+++ b/Documentation/btrfs-quota.txt
@@ -7,11 +7,11 @@ btrfs-quota - control the quota of a btrfs filesystem
 
 SYNOPSIS
 --------
-'btrfs quota' <subcommand> <args>
+*btrfs quota* <subcommand> <args>
 
 DESCRIPTION
 -----------
-'btrfs quota' is used to enable/disable or rescan subvolume quota of a btrfs
+*btrfs quota* is used to enable/disable or rescan subvolume quota of a btrfs
 filesystem.
 
 For setting quota or other quota operations on a btrfs filesystem, please see
@@ -22,14 +22,14 @@ performance in mainline kernel yet(v3.14 so far).
 
 SUBCOMMAND
 ----------
-'enable' <path>::
+*enable* <path>::
 Enable subvolume quota support for a filesystem.
 
 
-'disable' <path>::
+*disable* <path>::
 Disable subvolume quota support for a filesystem.
 
-'rescan' [-s] <path>::
+*rescan* [-s] <path>::
 Trash all qgroup numbers and scan the metadata again with the current config.
 +
 `Options`
@@ -41,12 +41,12 @@ wait for rescan operation to finish(can be already in progress).
 
 EXIT STATUS
 -----------
-'btrfs quota' returns a zero exist status if it succeeds. Non zero is
+*btrfs quota* returns a zero exist status if it succeeds. Non zero is
 returned in case of failure.
 
 AVAILABILITY
 ------------
-'btrfs' is part of btrfs-progs. Btrfs filesystem is currently under heavy
+*btrfs* is part of btrfs-progs. Btrfs filesystem is currently under heavy
 development,
 and not suitable for any uses other than benchmarking and review.
 Please refer to the btrfs wiki http://btrfs.wiki.kernel.org for
diff --git a/Documentation/btrfs-receive.txt b/Documentation/btrfs-receive.txt
index a67bc6645051..fba39269f929 100644
--- a/Documentation/btrfs-receive.txt
+++ b/Documentation/btrfs-receive.txt
@@ -7,15 +7,15 @@ btrfs-receive - receive subvolumes from stdin/file.
 
 SYNOPSIS
 --------
-'btrfs receive' [-ve] [-f <infile>] <mount>
+*btrfs receive* [-ve] [-f <infile>] <mount>
 
 DESCRIPTION
 -----------
 Receives one or more subvolumes that were previously
-sent with 'btrfs send'. The received subvolumes are stored
+sent with *btrfs send*. The received subvolumes are stored
 into <mount>.
 
-'btrfs receive' will fail with the following case:
+*btrfs receive* will fail with the following case:
 
 1. a receiving subvolume already exists.
 
@@ -41,12 +41,12 @@ or on EOF.
 
 EXIT STATUS
 -----------
-'btrfs receive' returns a zero exist status if it succeeds. Non zero is
+*btrfs receive* returns a zero exist status if it succeeds. Non zero is
 returned in case of failure.
 
 AVAILABILITY
 ------------
-'btrfs' is part of btrfs-progs. Btrfs filesystem is currently under heavy
+*btrfs* is part of btrfs-progs. Btrfs filesystem is currently under heavy
 development,
 and not suitable for any uses other than benchmarking and review.
 Please refer to the btrfs wiki http://btrfs.wiki.kernel.org for
diff --git a/Documentation/btrfs-replace.txt b/Documentation/btrfs-replace.txt
index 0d3b3185506e..46ff08d960ab 100644
--- a/Documentation/btrfs-replace.txt
+++ b/Documentation/btrfs-replace.txt
@@ -7,11 +7,11 @@ btrfs-replace - replace devices managed by btrfs with other device.
 
 SYNOPSIS
 --------
-'btrfs replace' <subcommand> <args>
+*btrfs replace* <subcommand> <args>
 
 DESCRIPTION
 -----------
-'btrfs replace' is used to replace btrfs managed devices with other device.
+*btrfs replace* is used to replace btrfs managed devices with other device.
 
 Note: this is not currently supported for RAID5/6 profiles and must use the
 device add/delete workaround.
@@ -21,7 +21,7 @@ management.
 
 SUBCOMMAND
 ----------
-'start' [-Bfr] <srcdev>|<devid> <targetdev> <path>::
+*start* [-Bfr] <srcdev>|<devid> <targetdev> <path>::
 Replace device of a btrfs filesystem.
 +
 On a live filesystem, duplicate the data to the target device which
@@ -52,7 +52,7 @@ never allowed to be used as the <targetdev>.
 -B::::
 no background replace.
 
-'status' [-1] <mount_point>::
+*status* [-1] <mount_point>::
 Print status and progress information of a running device replace operation.
 +
 `Options`
@@ -61,17 +61,17 @@ Print status and progress information of a running device replace operation.
 print once instead of print continuously until the replace
 operation finishes (or is canceled)
 
-'cancel' <mount_point>::
+*cancel* <mount_point>::
 Cancel a running device replace operation.
 
 EXIT STATUS
 -----------
-'btrfs replace' returns a zero exist status if it succeeds. Non zero is
+*btrfs replace* returns a zero exist status if it succeeds. Non zero is
 returned in case of failure.
 
 AVAILABILITY
 ------------
-'btrfs' is part of btrfs-progs. Btrfs filesystem is currently under heavy
+*btrfs* is part of btrfs-progs. Btrfs filesystem is currently under heavy
 development,
 and not suitable for any uses other than benchmarking and review.
 Please refer to the btrfs wiki http://btrfs.wiki.kernel.org for
diff --git a/Documentation/btrfs-rescue.txt b/Documentation/btrfs-rescue.txt
index f66ca856c8ec..0b75befade47 100644
--- a/Documentation/btrfs-rescue.txt
+++ b/Documentation/btrfs-rescue.txt
@@ -7,15 +7,15 @@ btrfs-rescue - Recover a damaged btrfs filesystem
 
 SYNOPSIS
 --------
-'btrfs rescue' <subcommand> <args>
+*btrfs rescue* <subcommand> <args>
 
 DESCRIPTION
 -----------
-'btrfs rescue' is used to try to recover a damaged btrfs filesystem.
+*btrfs rescue* is used to try to recover a damaged btrfs filesystem.
 
 SUBCOMMAND
 ----------
-'chunk-recover' [options] <device>::
+*chunk-recover* [options] <device>::
 Recover the chunk tree by scanning the devices
 +
 `Options`
@@ -27,10 +27,10 @@ verbose mode.
 -h::::
 help.
 
-NOTE: Since 'chunk-recover' will scan the whole device, it will be *VERY* slow
+NOTE: Since *chunk-recover* will scan the whole device, it will be *VERY* slow
 especially executed on a large device.
 
-'super-recover' [options] <device>::
+*super-recover* [options] <device>::
 Recover bad superblocks from good copies.
 +
 `Options`
@@ -42,12 +42,12 @@ verbose mode.
 
 EXIT STATUS
 -----------
-'btrfs rescue' returns a zero exist status if it succeeds. Non zero is
+*btrfs rescue* returns a zero exist status if it succeeds. Non zero is
 returned in case of failure.
 
 AVAILABILITY
 ------------
-'btrfs' is part of btrfs-progs. Btrfs filesystem is currently under heavy
+*btrfs* is part of btrfs-progs. Btrfs filesystem is currently under heavy
 development,
 and not suitable for any uses other than benchmarking and review.
 Please refer to the btrfs wiki http://btrfs.wiki.kernel.org for
diff --git a/Documentation/btrfs-restore.txt b/Documentation/btrfs-restore.txt
index c1d1607ae393..1882f0d0362d 100644
--- a/Documentation/btrfs-restore.txt
+++ b/Documentation/btrfs-restore.txt
@@ -7,15 +7,15 @@ btrfs-restore - try to restore files from a damaged btrfs filesystem(unmounted)
 
 SYNOPSIS
 --------
-'btrfs restore' [options] <device> <path> | -l <device>
+*btrfs restore* [options] <device> <path> | -l <device>
 
 DESCRIPTION
 -----------
-'btrfs restore' is used to try to salvage files from a damaged filesystem and
+*btrfs restore* is used to try to salvage files from a damaged filesystem and
 restore them into <path> or just list the tree roots.
 
 Since current `btrfs-check`(8) or `btrfs-rescue`(8) only has very limited usage,
-'btrfs restore' is normally a better choice.
+*btrfs restore* is normally a better choice.
 
 NOTE: It is recommended to read the following btrfs wiki page if your data is
 not salvaged with default option: +
@@ -58,12 +58,12 @@ list tree roots.
 
 EXIT STATUS
 -----------
-'btrfs restore' returns a zero exist status if it succeeds. Non zero is
+*btrfs restore* returns a zero exist status if it succeeds. Non zero is
 returned in case of failure.
 
 AVAILABILITY
 ------------
-'btrfs' is part of btrfs-progs. Btrfs filesystem is currently under heavy
+*btrfs* is part of btrfs-progs. Btrfs filesystem is currently under heavy
 development,
 and not suitable for any uses other than benchmarking and review.
 Please refer to the btrfs wiki http://btrfs.wiki.kernel.org for
diff --git a/Documentation/btrfs-scrub.txt b/Documentation/btrfs-scrub.txt
index c87658739620..2928e1d1afb8 100644
--- a/Documentation/btrfs-scrub.txt
+++ b/Documentation/btrfs-scrub.txt
@@ -7,21 +7,21 @@ btrfs-scrub - scrub btrfs filesystem
 
 SYNOPSIS
 --------
-'btrfs scrub' <subcommand> <args>
+*btrfs scrub* <subcommand> <args>
 
 DESCRIPTION
 -----------
-'btrfs scrub' is used to scrub a btrfs filesystem, which will reading all data
+*btrfs scrub* is used to scrub a btrfs filesystem, which will reading all data
 from all disks and verifying checksums.
 
 SUBCOMMAND
 ----------
-'start' [-BdqrRf] [-c <ioprio_class> -n <ioprio_classdata>] <path>|<device>::
+*start* [-BdqrRf] [-c <ioprio_class> -n <ioprio_classdata>] <path>|<device>::
 Start a scrub on all devices of the filesystem identified by <path> or on
 a single <device>.
 +
 Without options, scrub is started as a background process.
-Progress can be obtained with the 'scrub status' command. Scrubbing
+Progress can be obtained with the *scrub status* command. Scrubbing
 involves reading all data from all disks and verifying checksums. Errors are
 corrected along the way if possible.
 +
@@ -50,7 +50,7 @@ Set IO priority classdata (see `ionice`(1) manpage).
 force to check whether scrub has started or resumed in userspace.
 this is useful when scrub stat record file is damaged.
 
-'cancel' <path>|<device>::
+*cancel* <path>|<device>::
 If a scrub is running on the filesystem identified by <path>, cancel it.
 +
 Progress is saved in the scrub progress file and scrubbing can be resumed later
@@ -58,7 +58,7 @@ using the scrub resume command.
 If a <device> is given, the corresponding filesystem is found and
 scrub cancel behaves as if it was called on that filesystem.
 
-'resume' [-BdqrR] [-c <ioprio_class> -n <ioprio_classdata>] <path>|<device>::
+*resume* [-BdqrR] [-c <ioprio_class> -n <ioprio_classdata>] <path>|<device>::
 Resume a canceled or interrupted scrub cycle on the filesystem identified by
 <path> or on a given <device>.
 +
@@ -66,9 +66,9 @@ Does not start a new scrub if the last scrub finished successfully.
 +
 `Options`
 +
-see 'scrub start'.
+see *scrub start*.
 
-'status' [-d] <path>|<device>::
+*status* [-d] <path>|<device>::
 Show status of a running scrub for the filesystem identified by <path> or
 for the specified <device>.
 +
@@ -82,12 +82,12 @@ Print separate statistics for each device of the filesystem.
 
 EXIT STATUS
 -----------
-'btrfs scrub' returns a zero exist status if it succeeds. Non zero is
+*btrfs scrub* returns a zero exist status if it succeeds. Non zero is
 returned in case of failure.
 
 AVAILABILITY
 ------------
-'btrfs' is part of btrfs-progs. Btrfs filesystem is currently under heavy
+*btrfs* is part of btrfs-progs. Btrfs filesystem is currently under heavy
 development,
 and not suitable for any uses other than benchmarking and review.
 Please refer to the btrfs wiki http://btrfs.wiki.kernel.org for
diff --git a/Documentation/btrfs-send.txt b/Documentation/btrfs-send.txt
index 18a98fa3861e..2fbb4cb6094d 100644
--- a/Documentation/btrfs-send.txt
+++ b/Documentation/btrfs-send.txt
@@ -7,7 +7,7 @@ btrfs-send - send data of subvolume(s) to stdout/file.
 
 SYNOPSIS
 --------
-'btrfs send' [-ve] [-p <parent>] [-c <clone-src>] [-f <outfile>] <subvol> [<subvol>...]
+*btrfs send* [-ve] [-p <parent>] [-c <clone-src>] [-f <outfile>] <subvol> [<subvol>...]
 
 DESCRIPTION
 -----------
@@ -23,7 +23,7 @@ You must not specify clone sources unless you guarantee that these snapshots
 are exactly in the same state on both sides, the sender and the receiver.
 
 It is allowed to omit the '-p <parent>' option when '-c <clone-src>' options
-are given, in which case 'btrfs send' will determine a suitable parent among the
+are given, in which case *btrfs send* will determine a suitable parent among the
 clone sources itself.
 
 `Options`
@@ -43,12 +43,12 @@ An alternative would be to use pipes.
 
 EXIT STATUS
 -----------
-'btrfs send' returns a zero exist status if it succeeds. Non zero is
+*btrfs send* returns a zero exist status if it succeeds. Non zero is
 returned in case of failure.
 
 AVAILABILITY
 ------------
-'btrfs' is part of btrfs-progs. Btrfs filesystem is currently under heavy
+*btrfs* is part of btrfs-progs. Btrfs filesystem is currently under heavy
 development,
 and not suitable for any uses other than benchmarking and review.
 Please refer to the btrfs wiki http://btrfs.wiki.kernel.org for
diff --git a/Documentation/btrfs-show-super.txt b/Documentation/btrfs-show-super.txt
index e8e17abc042f..e06157f5d1b6 100644
--- a/Documentation/btrfs-show-super.txt
+++ b/Documentation/btrfs-show-super.txt
@@ -7,11 +7,11 @@ btrfs-show-super - show btrfs superblock information stored in devices
 
 SYNOPSIS
 --------
-'btrfs-show-super' [options] <dev> [<dev>...]
+*btrfs-show-super* [options] <dev> [<dev>...]
 
 DESCRIPTION
 -----------
-'btrfs-show-super' is used to print the information of superblock,
+*btrfs-show-super* is used to print the information of superblock,
 you can specify which mirror to print out.
 
 By default, every device's first superblock will be printed out.
@@ -33,7 +33,7 @@ If several '-i <super_mirror>' are given, only the last one is valid.
 
 EXIT STATUS
 -----------
-'btrfs-show-super' will return 0 if no error happened.
+*btrfs-show-super* will return 0 if no error happened.
 If any problems happened, 1 will be returned.
 
 AUTHOR
diff --git a/Documentation/btrfs-subvolume.txt b/Documentation/btrfs-subvolume.txt
index 6cc72803b34a..3fd29282e32f 100644
--- a/Documentation/btrfs-subvolume.txt
+++ b/Documentation/btrfs-subvolume.txt
@@ -7,11 +7,11 @@ btrfs-subvolume - control btrfs subvolume(s)
 
 SYNOPSIS
 --------
-'btrfs subvolume' <subcommand> [<args>]
+*btrfs subvolume* <subcommand> [<args>]
 
 DESCRIPTION
 -----------
-'btrfs subvolume' is used to control the filesystem to create/delete/list/show
+*btrfs subvolume* is used to control the filesystem to create/delete/list/show
 subvolumes and snapshots.
 
 SUBVOLUME AND SNAPSHOT
@@ -43,7 +43,7 @@ from normal directories.
 
 SUBCOMMAND
 -----------
-'create' [-i <qgroupid>] [<dest>]<name>::
+*create* [-i <qgroupid>] [<dest>]<name>::
 Create a subvolume <name> in <dest>.
 +
 If <dest> is not given, subvolume <name> will be created in the currently
@@ -55,7 +55,7 @@ directory.
 Add the newly created subvolume to a qgroup. This option can be given multiple
 times.
 
-'delete' [options] <subvolume> [<subvolume>...]::
+*delete* [options] <subvolume> [<subvolume>...]::
 Delete the subvolume(s) from the filesystem.
 +
 If <subvolume> is not a subvolume, btrfs returns an error but continues if
@@ -75,7 +75,7 @@ wait for transaction commit at the end of the operation
 -C|--commit-each::::
 wait for transaction commit after delet each subvolume
 
-'list' [options] [-G [\+|-]<value>] [-C [+|-]<value>] [--sort=rootid,gen,ogen,path] <path>::
+*list* [options] [-G [\+|-]<value>] [-C [+|-]<value>] [--sort=rootid,gen,ogen,path] <path>::
 List the subvolumes present in the filesystem <path>.
 +
 For every subvolume the following information is shown by default. +
@@ -125,7 +125,7 @@ you can add \'\+' or \'-' in front of each items, \'+' means ascending,
 for --sort you can combine some items together by \',', just like
 -sort=+ogen,-gen,path,rootid.
 
-'snapshot' [-r] <source> <dest>|[<dest>/]<name>::
+*snapshot* [-r] <source> <dest>|[<dest>/]<name>::
 Create a writable/readonly snapshot of the subvolume <source> with the
 name <name> in the <dest> directory.
 +
@@ -133,32 +133,32 @@ If only <dest> is given, the subvolume will be named the basename of <source>.
 If <source> is not a subvolume, btrfs returns an error.
 If '-r' is given, the snapshot will be readonly.
 
-'get-default' <path>::
+*get-default* <path>::
 Get the default subvolume of the filesystem <path>.
 +
-The output format is similar to 'subvolume list' command.
+The output format is similar to *subvolume list* command.
 
-'set-default' <id> <path>::
+*set-default* <id> <path>::
 Set the subvolume of the filesystem <path> which is mounted as
 default.
 +
-The subvolume is identified by <id>, which is returned by the 'subvolume list'
+The subvolume is identified by <id>, which is returned by the *subvolume list*
 command.
 
-'find-new' <subvolume> <last_gen>::
+*find-new* <subvolume> <last_gen>::
 List the recently modified files in a subvolume, after <last_gen> ID.
 
-'show' <path>::
+*show* <path>::
 Show information of a given subvolume in the <path>.
 
 EXIT STATUS
 -----------
-'btrfs subvolume' returns a zero exist status if it succeeds. Non zero is
+*btrfs subvolume* returns a zero exist status if it succeeds. Non zero is
 returned in case of failure.
 
 AVAILABILITY
 ------------
-'btrfs' is part of btrfs-progs. Btrfs filesystem is currently under heavy
+*btrfs* is part of btrfs-progs. Btrfs filesystem is currently under heavy
 development,
 and not suitable for any uses other than benchmarking and review.
 Please refer to the btrfs wiki http://btrfs.wiki.kernel.org for
diff --git a/Documentation/btrfs-zero-log.txt b/Documentation/btrfs-zero-log.txt
index a8e4dd347cd0..0a8d3e33ae4d 100644
--- a/Documentation/btrfs-zero-log.txt
+++ b/Documentation/btrfs-zero-log.txt
@@ -7,17 +7,17 @@ btrfs-zero-log - clear out log tree
 
 SYNOPSIS
 --------
-'btrfs-zero-log' <dev>
+*btrfs-zero-log* <dev>
 
 DESCRIPTION
 -----------
-'btrfs-zero-log' will remove the log tree if log tree is corrupt, which will
+*btrfs-zero-log* will remove the log tree if log tree is corrupt, which will
 allow you to mount the filesystem again.
 
 The common case where this happens has been fixed a long time ago,
 so it is unlikely that you will see this particular problem.
 
-One can determine whether 'btrfs-zero-log' is needed according to the kernel
+One can determine whether *btrfs-zero-log* is needed according to the kernel
 backtrace:
 ----
 ? replay_one_dir_item+0xb5/0xb5 [btrfs]
@@ -29,15 +29,15 @@ backtrace:
 ? open_ctree+0xff6/0x132c [btrfs]
 ----
 
-If the errors are like above, then 'btrfs-zero-log' should be used to clear
+If the errors are like above, then *btrfs-zero-log* should be used to clear
 the log and the filesystem may be mounted normally again.
 
 NOTE: If you use btrfs as the root filesystem, you may want to include
-'btrfs-zero-log' into initramdisk if the log problems hits you often.
+*btrfs-zero-log* into initramdisk if the log problems hits you often.
 
 EXIT STATUS
 -----------
-'btrfs-zero-log' will return 0 if no error happened.
+*btrfs-zero-log* will return 0 if no error happened.
 Other exit code means some problems happened.
 
 AUTHOR
diff --git a/Documentation/btrfs.txt b/Documentation/btrfs.txt
index c9bed7026a61..d0b3f35aaeb0 100644
--- a/Documentation/btrfs.txt
+++ b/Documentation/btrfs.txt
@@ -7,92 +7,92 @@ btrfs - control a btrfs filesystem
 
 SYNOPSIS
 --------
-'btrfs' <command> [<args>]
+*btrfs* <command> [<args>]
 
 DESCRIPTION
 -----------
-'btrfs' is used to control the filesystem and the files and directories stored.
+*btrfs* is used to control the filesystem and the files and directories stored.
 It is the tool to create or destroy a snapshot or a subvolume for the
 filesystem, to defrag a file or a directory, flush the data to the disk,
 to resize the filesystem, to scan the device.
 
 It is possible to abbreviate the commands unless the commands are ambiguous.
-For example: it is possible to run 'btrfs sub snaps' instead of
-'btrfs subvolume snapshot'.
-But 'btrfs file s' is not allowed, because 'file s' may be interpreted
-both as 'filesystem show' and as 'filesystem sync'.
+For example: it is possible to run *btrfs sub snaps* instead of
+*btrfs subvolume snapshot*.
+But *btrfs file s* is not allowed, because *file s* may be interpreted
+both as *filesystem show* and as *filesystem sync*.
 
 If a command is terminated by '--help', the detailed help is showed.
 If the passed command matches more commands,
 detailed help of all the matched commands is showed. For example
-'btrfs dev --help' shows the help of all 'device*' commands.
+*btrfs dev --help* shows the help of all *device** commands.
 
 COMMANDS
 --------
-'subvolume'::
+*subvolume*::
 	Create/delete/list/manage btrfs subvolume. +
 	See `btrfs-subvolume`(8) for details.
 
-'filesystem'::
+*filesystem*::
 	Manage a btrfs filesystem, including label setting/sync and so on. +
 	See `btrfs-filesystem`(8) for details.
 
-'[filesystem] balance'::
+*[filesystem] balance*::
 	Balance btrfs filesystem chunks across single or several devices. +
 	See `btrfs-balance`(8) for details.
 
-'device'::
+*device*::
 	Manage devices managed by btrfs, including add/delete/scan and so
 	on. +
 	See `btrfs-device`(8) for details.
 
-'scrub'::
+*scrub*::
 	Scrub a btrfs filesystem. +
 	See `btrfs-scrub`(8) for details.
 
-'check'::
+*check*::
 	Do off-line check on a btrfs filesystem. +
 	See `btrfs-check`(8) for details.
 
-'rescue'::
+*rescue*::
 	Try to rescue damaged btrfs filesystem. +
 	See `btrfs-rescue`(8) for details.
 
-'restore'::
+*restore*::
 	Manage a btrfs filesystem, including label setting/sync and so on. +
 	See `btrfs-restore`(8) for details.
 
-'inspect-internal'::
+*inspect-internal*::
 	Debug tools for developers/hackers. +
 	See `btrfs-inspect-internal`(8) for details.
 
-'send'::
+*send*::
 	Send subvolume data to stdout/file for backup and etc. +
 	See `btrfs-send`(8) for details.
 
-'receive'::
+*receive*::
 	Receive subvolume data from stdin/file for restore and etc. +
 	See `btrfs-receive`(8) for details.
-'quota'::
+*quota*::
 	Manage quota on btrfs filesystem like enabling/rescan and etc. +
 	See `btrfs-quota`(8) and `btrfs-qgroup`(8) for details.
 
-'qgroup'::
+*qgroup*::
 	Manage quota group(qgroup) for btrfs filesystem. +
 	See `btrfs-qgroup`(8) for details.
 
-'replace'::
+*replace*::
 	Replace btrfs devices. +
 	See `btrfs-replace`(8) for details.
 
 EXIT STATUS
 -----------
-'btrfs' returns a zero exist status if it succeeds. Non zero is returned in
+*btrfs* returns a zero exist status if it succeeds. Non zero is returned in
 case of failure.
 
 AVAILABILITY
 ------------
-'btrfs' is part of btrfs-progs. Btrfs filesystem is currently under heavy
+*btrfs* is part of btrfs-progs. Btrfs filesystem is currently under heavy
 development,
 and not suitable for any uses other than benchmarking and review.
 Please refer to the btrfs wiki http://btrfs.wiki.kernel.org for
diff --git a/Documentation/btrfstune.txt b/Documentation/btrfstune.txt
index bf4bfcecdc21..1309fb6ab99e 100644
--- a/Documentation/btrfstune.txt
+++ b/Documentation/btrfstune.txt
@@ -7,11 +7,11 @@ btrfstune - tune various btrfs filesystem parameters
 
 SYNOPSIS
 --------
-'btrfstune' [options] <dev> [<dev>...]
+*btrfstune* [options] <dev> [<dev>...]
 
 DESCRIPTION
 -----------
-'btrfstune' is used to tune various btrfs filesystem parameters,you can
+*btrfstune* is used to tune various btrfs filesystem parameters,you can
 enable/disable some extended features for btrfs.
 
 OPTIONS
@@ -27,7 +27,7 @@ Enable skinny metadata extent refs.
 
 EXIT STATUS
 -----------
-'btrfstune' will return 0 if no error happened.
+*btrfstune* will return 0 if no error happened.
 If any problems happened, 1 will be returned.
 
 AUTHOR
diff --git a/Documentation/fsck.btrfs.txt b/Documentation/fsck.btrfs.txt
index cc4544a58b1b..0bad075b68fa 100644
--- a/Documentation/fsck.btrfs.txt
+++ b/Documentation/fsck.btrfs.txt
@@ -7,11 +7,11 @@ fsck.btrfs - do nothing, successfully
 
 SYNOPSIS
 --------
-'fsck.btrfs' [-aApy] [<device>...]
+*fsck.btrfs* [-aApy] [<device>...]
 
 DESCRIPTION
 -----------
-'fsck.btrfs' is a type of utility that should exist for any filesystem and is
+*fsck.btrfs* is a type of utility that should exist for any filesystem and is
 called during system setup when the corresponding `/etc/fstab` entries
 contain non-zero value for `fs_passno` , see `fstab`(5) for more.
 
@@ -26,7 +26,7 @@ with care!).
 
 OPTIONS
 -------
-The options are all the same and detect if 'fsck.btrfs' is executed in
+The options are all the same and detect if *fsck.btrfs* is executed in
 non-interactive mode and exits with success,
 otherwise prints a message about btrfs check.
 
diff --git a/Documentation/mkfs.btrfs.txt b/Documentation/mkfs.btrfs.txt
index 95098328bb68..634e486105a2 100644
--- a/Documentation/mkfs.btrfs.txt
+++ b/Documentation/mkfs.btrfs.txt
@@ -7,7 +7,7 @@ mkfs.btrfs - create a btrfs filesystem
 
 SYNOPSIS
 --------
-'mkfs.btrfs'
+*mkfs.btrfs*
 $$[-A|--alloc-start <alloc-start>]$$
 $$[-b|--byte-count <byte-count>]$$
 $$[-d|--data <data-profile>]$$
@@ -27,7 +27,7 @@ $$<device> [<device>...]$$
 
 DESCRIPTION
 -----------
-'mkfs.btrfs'
+*mkfs.btrfs*
 is used to create a btrfs filesystem (usually in a disk partition, or an array
 of disk partitions).
 
@@ -110,7 +110,7 @@ To see all features run::::
 mkfs.btrfs -O list-all
 
 -V|--version::
-Print the 'mkfs.btrfs' version and exit.
+Print the *mkfs.btrfs* version and exit.
 
 -h::
 Print help.
@@ -122,7 +122,7 @@ to the arguments like 'k' for KBytes, 'm' for MBytes...
 
 AVAILABILITY
 ------------
-'btrfs' is part of btrfs-progs. Btrfs filesystem is currently under heavy
+*btrfs* is part of btrfs-progs. Btrfs filesystem is currently under heavy
 development,
 and not suitable for any uses other than benchmarking and review.
 Please refer to the btrfs wiki http://btrfs.wiki.kernel.org for
-- 
1.9.0

