Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym03.jp.fujitsu.com ([211.128.242.42]:18223 "EHLO
        mgwym03.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S968195AbeFRIiN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Jun 2018 04:38:13 -0400
Received: from g01jpfmpwkw03.exch.g01.fujitsu.local (g01jpfmpwkw03.exch.g01.fujitsu.local [10.0.193.57])
        by yt-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id B103BAC0185
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Jun 2018 17:38:08 +0900 (JST)
Received: from g01jpexchkw33.g01.fujitsu.local (unknown [10.0.193.4])
        by g01jpfmpwkw03.exch.g01.fujitsu.local (Postfix) with ESMTP id D4F2ABD65F4
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Jun 2018 17:38:07 +0900 (JST)
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 01/20] btrfs-progs: doc: Update man btrfs subvolume
Date: Mon, 18 Jun 2018 17:40:49 +0900
Message-ID: <812810057f55e9942516b3d4984a2647b90b2209.1529310485.git.misono.tomohiro@jp.fujitsu.com>
In-Reply-To: <cover.1529310485.git.misono.tomohiro@jp.fujitsu.com>
References: <cover.1529310485.git.misono.tomohiro@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Some information is obsolete and updated as follows:
 - Add missing explanations of some options
 - Remove outdated explanation of "subvolrootid" mount option
 - Reorder/group options of "sub list" to corresponds help message
 - Add explanation about different meaning of parent in "parent ID/UUID"
 - Fix indent/misspelling
 - Add missing comma

Signed-off-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
---
 Documentation/btrfs-subvolume.asciidoc | 77 ++++++++++++++++++++++++----------
 1 file changed, 55 insertions(+), 22 deletions(-)

diff --git a/Documentation/btrfs-subvolume.asciidoc b/Documentation/btrfs-subvolume.asciidoc
index a8c4af4b..f3eb4e26 100644
--- a/Documentation/btrfs-subvolume.asciidoc
+++ b/Documentation/btrfs-subvolume.asciidoc
@@ -77,13 +77,16 @@ safely stored on the device.
 `Options`
 +
 -c|--commit-after::::
-wait for transaction commit at the end of the operation
+wait for transaction commit at the end of the operation.
 +
 -C|--commit-each::::
-wait for transaction commit after deleting each subvolume
+wait for transaction commit after deleting each subvolume.
++
+-v|--verbose::::
+verbose output of operations.
 
 *find-new* <subvolume> <last_gen>::
-List the recently modified files in a subvolume, after <last_gen> ID.
+List the recently modified files in a subvolume, after <last_gen> generation.
 
 *get-default* <path>::
 Get the default subvolume of the filesystem <path>.
@@ -93,40 +96,54 @@ The output format is similar to *subvolume list* command.
 *list* [options] [-G [\+|-]<value>] [-C [+|-]<value>] [--sort=rootid,gen,ogen,path] <path>::
 List the subvolumes present in the filesystem <path>.
 +
-For every subvolume the following information is shown by default. +
-ID <ID> top level <ID> path <path> +
-where path is the relative path of the subvolume to the top level subvolume.
+For every subvolume the following information is shown by default:
++
+ID <ID> gen <generation> top level <ID> path <path>
++
+where ID is subvolume's id, gen is an internal counter which is updated
+every transaction, top level is the same as parent subvolume's id, and
+path is the relative path of the subvolume to the top level subvolume.
 The subvolume's ID may be used by the subvolume set-default command,
 or at mount time via the subvolid= option.
-If `-p` is given, then parent <ID> is added to the output between ID
-and top level. The parent's ID may be used at mount time via the
-`subvolrootid=` option.
 +
 `Options`
 +
--p::::
-print parent ID.
+Path filtering;;
+-o::::
+print only subvolumes below specified <path>.
 -a::::
 print all the subvolumes in the filesystem and distinguish between
 absolute and relative path with respect to the given <path>.
+
+Field selection;;
+-p::::
+print the parent ID
+('parent' here means the subvolume which contains this subvolume).
 -c::::
 print the ogeneration of the subvolume, aliases: ogen or origin generation.
 -g::::
-print the generation of the subvolume.
--o::::
-print only subvolumes below specified <path>.
+print the generation of the subvolume (default).
 -u::::
 print the UUID of the subvolume.
 -q::::
-print the parent uuid of subvolumes (and snapshots).
+print the parent UUID of the subvolume
+('parent' here means subvolume of which this subvolume is a snapshot).
 -R::::
-print the UUID of the sent subvolume, where the subvolume is the result of a receive operation
--t::::
-print the result as a table.
+print the UUID of the sent subvolume, where the subvolume is the result of a receive operation.
+
+Type filtering;;
 -s::::
 only snapshot subvolumes in the filesystem will be listed.
 -r::::
 only readonly subvolumes in the filesystem will be listed.
+-d::::
+list deleted subvolumes that are not yet cleaned.
+
+Other;;
+-t::::
+print the result as a table.
+
+Sorting;;
 -G [+|-]<value>::::
 list subvolumes in the filesystem that its generation is
 >=, \<= or = value. \'\+' means >= value, \'-' means \<= value, If there is
@@ -144,9 +161,9 @@ for --sort you can combine some items together by \',', just like
 
 *set-default* [<subvolume>|<id> <path>]::
 Set the default subvolume for the (mounted) filesystem.
-
++
 Set the default subvolume for the (mounted) filesystem at <path>. This will hide
-the top-level subvolume (ie. the one mounted with 'subvol=/' or 'subvolid=5').
+the top-level subvolume (i.e. the one mounted with 'subvol=/' or 'subvolid=5').
 Takes action on next mount.
 +
 There are two ways how to specify the subvolume, by <id> or by the <subvolume>
@@ -154,10 +171,22 @@ path.
 The id can be obtained from *btrfs subvolume list*, *btrfs subvolume show* or
 *btrfs inspect-internal rootid*.
 
-*show* <path>::
+*show* [options] <path>|<mnt>::
 Show information of a given subvolume in the <path>.
++
+`Options`
++
+-r|--rootid::::
+rootid of the subvolume.
+-u|--uuid:::
+UUID of the subvolume.
+
++
+If no option is specified, subvolume information of <path> is shown,
+otherwise the subvolume information of rootid or UUID in the filesystem
+is shown.
 
-*snapshot* [-r] <source> <dest>|[<dest>/]<name>::
+*snapshot* [-r|-i <qgroupid>] <source> <dest>|[<dest>/]<name>::
 Create a snapshot of the subvolume <source> with the
 name <name> in the <dest> directory.
 +
@@ -168,6 +197,10 @@ If <source> is not a subvolume, btrfs returns an error.
 +
 -r::::
 Make the new snapshot read only.
++
+-i <qgroupid>::::
+Add the newly created subvolume to a qgroup. This option can be given multiple
+times.
 
 *sync* <path> [subvolid...]::
 Wait until given subvolume(s) are completely removed from the filesystem after
-- 
2.14.4


