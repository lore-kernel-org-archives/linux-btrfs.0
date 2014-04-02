Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:11878 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758018AbaDBI2u (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Apr 2014 04:28:50 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s328SYnE014911
	for <linux-btrfs@vger.kernel.org>; Wed, 2 Apr 2014 16:28:34 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 02/27] btrfs-progs: Convert man page for btrfs-subvolume
Date: Wed, 2 Apr 2014 16:29:13 +0800
Message-ID: <1396427378-10487-3-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1396427378-10487-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1396427378-10487-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Convert man page for btrfs-subvolume.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 Documentation/Makefile            |   2 +-
 Documentation/btrfs-subvolume.txt | 172 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 173 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/btrfs-subvolume.txt

diff --git a/Documentation/Makefile b/Documentation/Makefile
index bf38617..15c1679 100644
--- a/Documentation/Makefile
+++ b/Documentation/Makefile
@@ -16,7 +16,7 @@ MAN8_TXT += btrfs.txt
 #MAN8_TXT += mkfs.btrfs.txt
 
 # Sub commands for btrfs
-#MAN8_TXT += btrfs-subvolume.txt
+MAN8_TXT += btrfs-subvolume.txt
 #MAN8_TXT += btrfs-filesystem.txt
 #MAN8_TXT += btrfs-balance.txt
 #MAN8_TXT += btrfs-device.txt
diff --git a/Documentation/btrfs-subvolume.txt b/Documentation/btrfs-subvolume.txt
new file mode 100644
index 0000000..7f32dbd
--- /dev/null
+++ b/Documentation/btrfs-subvolume.txt
@@ -0,0 +1,172 @@
+btrfs-subvolume(8)
+==================
+
+NAME
+----
+btrfs-subvolume - control btrfs subvolume(s)
+
+SYNOPSIS
+--------
+'btrfs subvolume' <subcommand> [<args>]
+
+DESCRIPTION
+-----------
+'btrfs subvolume' is used to control the filesystem to create/delete/list/show
+subvolumes and snapshots.
+
+SUBVOLUME AND SNAPSHOT
+----------------------
+A subvolume in btrfs is not like an LVM logical volume, which is quite
+independent from each other, a btrfs subvolume has its hierarchy and relations
+between other subvolumes.
+
+A subvolume in btrfs can be accessed in two ways.
+
+1. From the parent subvolume +
+When accessing from the parent subvolume, the subvolume can be used just
+like a directory. It can have child subvolumes and its own files/directories.
+
+2. Separate mounted filesystem +
+When `mount`(8) using 'subvol' or 'subvolid' mount option, one can access
+files/directories/subvolumes inside it, but nothing in parent subvolumes.
+
+Also every btrfs filesystem has a default subvolume as its initially top-level
+subvolume, whose subvolume id is 5(FS_TREE).
+
+A btrfs snapshot is much like a subvolume, but shares its data(and metadata)
+with other subvolume/snapshot. Due to the capabilities of COW, modifications
+inside a snapshot will only show in a snapshot but not in its source subvolume.
+
+Although in btrfs, subvolumes/snapshots are treated as directories, only
+subvolume/snapshot can be the source of a snapshot, snapshot can not be made
+from normal directories.
+
+SUBCOMMAND
+-----------
+'create' [-i <qgroupid>] [<dest>]<name>::
+Create a subvolume <name> in <dest>.
++
+If <dest> is not given, subvolume <name> will be created in the currently
+directory.
++
+`Options`
++
+-i <qgroupid>::::
+Add the newly created subvolume to a qgroup. This option can be given multiple
+times.
+
+'delete' [options] <subvolume> [<subvolume>...]::
+Delete the subvolume(s) from the filesystem.
++
+If <subvolume> is not a subvolume, btrfs returns an error but continues if
+there are more arguments to process.
++
+The corresponding directory is removed instantly but the data blocks are
+removed later.  The deletion does not involve full commit by default due to
+performance reasons (as a consequence, the subvolume may appear again after a
+crash).  Use one of the '--commit' options to wait until the operation is safely
+stored on the media.
++
+`Options`
++
+-c|--commit-after::::
+wait for transaction commit at the end of the operation
++
+-C|--commit-each::::
+wait for transaction commit after delet each subvolume
+
+'list' [options] [-G [\+|-] values] [-C [+|-]value] [--sort=rootid,gen,ogen,path] <path>::
+List the subvolumes present in the filesystem <path>.
++
+For every subvolume the following information is shown by default. +
+ID <ID> top level <ID> path <path> +
+where path is the relative path of the subvolume to the top level subvolume.
+The subvolume's ID may be used by the subvolume set-default command,
+or at mount time via the subvolid= option.
+If `-p` is given, then parent <ID> is added to the output between ID
+and top level. The parent's ID may be used at mount time via the
+`subvolrootid=` option.
++
+`Options`
++
+-p::::
+print parent ID.
+-a::::
+print all the subvolumes in the filesystem and distinguish between
+absolute and relative path with respect to the given <path>.
+-c::::
+print the ogeneration of the subvolume, aliases: ogen or origin generation.
+-g::::
+print the generation of the subvolume.
+-o::::
+print only subvolumes bellow specified <path>.
+-u::::
+print the UUID of the subvolume.
+-q::::
+print the parent uuid of subvolumes (and snapshots).
+-t::::
+print the result as a table.
+-s::::
+only snapshot subvolumes in the filesystem will be listed.
+-r::::
+only readonly subvolumes in the filesystem will be listed.
+-G [+|-]value::::
+list subvolumes in the filesystem that its generation is
+>=, \<= or = value. \'\+' means >= value, \'-' means \<= value, If there is
+neither \'+' nor \'-', it means = value.
+-C [+|-]value::::
+list subvolumes in the filesystem that its ogeneration is
+>=, \<= or = value. The usage is the same to '-g' option.
+--sort=rootid,gen,ogen,path::::
+list subvolumes in order by specified items.
+you can add \'\+' or \'-' in front of each items, \'+' means ascending,
+\'-' means descending. The default is ascending.
++
+for --sort you can combine some items together by \',', just like
+-sort=+ogen,-gen,path,rootid.
+
+'snapshot' [-r] <source> <dest>|[<dest>/]<name>::
+Create a writable/readonly snapshot of the subvolume <source> with the
+name <name> in the <dest> directory.
++
+If only <dest> is given, the subvolume will be named the basename of <source>.
+If <source> is not a subvolume, btrfs returns an error.
+If '-r' is given, the snapshot will be readonly.
+
+'get-default' <path>::
+Get the default subvolume of the filesystem <path>.
++
+The output format is similar to 'subvolume list' command.
+
+'set-default' <id> <path>::
+Set the subvolume of the filesystem <path> which is mounted as
+default.
++
+The subvolume is identified by <id>, which is returned by the 'subvolume list'
+command.
+
+'find-new' <subvolume> <last_gen>::
+List the recently modified files in a subvolume, after <last_gen> ID.
+
+'show' <path>::
+Show information of a given subvolume in the <path>.
+
+EXIT STATUS
+-----------
+'btrfs subvolume' returns a zero exist status if it succeeds. Non zero is
+returned in case of failure.
+
+AVAILABILITY
+------------
+'btrfs' is part of btrfs-progs. Btrfs filesystem is currently under heavy
+development,
+and not suitable for any uses other than benchmarking and review.
+Please refer to the btrfs wiki http://btrfs.wiki.kernel.org for
+further details.
+
+SEE ALSO
+--------
+`mkfs.btrfs`(8),
+`btrfs-subvolume`(8),
+`btrfs-quota`(8),
+`btrfs-qgroup`(8),
-- 
1.9.1

