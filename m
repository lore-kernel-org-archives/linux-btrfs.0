Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from linux-libre.fsfla.org ([208.118.235.54]:39746 "EHLO
	linux-libre.fsfla.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900AbaH3QXF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 30 Aug 2014 12:23:05 -0400
Received: from freie.home (home.lxoliva.fsfla.org [172.31.160.22])
	by linux-libre.fsfla.org (8.14.4/8.14.4/Debian-2ubuntu2.1) with ESMTP id s7UGAxl7020077
	for <linux-btrfs@vger.kernel.org>; Sat, 30 Aug 2014 16:10:59 GMT
From: Alexandre Oliva <oliva@gnu.org>
To: linux-btrfs@vger.kernel.org
Subject: fixes for btrfs check --repair
Date: Sat, 30 Aug 2014 13:00:40 -0300
Message-ID: <ora96m3r2v.fsf@free.home>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--=-=-=

I got a faulty memory module a while ago, and it ran for a while,
corrupting a number of filesystems on that server.  Most of the
corruption is long gone, as the filesystems (ceph osds) were
reconstructed, but I tried really hard to avoid having to rebuild one
4TB filesystem from scratch, since it was still fully operational.  I
failed, but in the process, I ran into and fixed two btrfs check
--repair bugs.  I gave up when removing an old snapshot caused the
delayed refs processing to abort because it couldn't find a ref to
delete, whereas btrfs check --repair completed successfully without
fixing anything.  Mounting the apparently-clean filesystem would still
run into the same delayed refs error, but trying to map the logical
extent back to a file produced an error.  Since it was far too big to
preserve, even in metadata only, I didn't, and proceeded to mkfs.btrfs
right away.

Here are the patches.


--=-=-=
Content-Type: text/x-diff
Content-Disposition: inline; filename=repair-recow-del.patch

repair: remove recowed entry from the to-recow list

From: Alexandre Oliva <oliva@gnu.org>

If we attempt to repair a filesystem with metadata blocks that need
recowing, we'll get into an infinite loop repeatedly recowing the
first entry in the list, without ever removing it from the list.
Oops.  Fixed.

Signed-off-by: Alexandre Oliva <oliva@gnu.org>
---
 cmds-check.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/cmds-check.c b/cmds-check.c
index 268e588..66c982f 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -6760,6 +6760,7 @@ int cmd_check(int argc, char **argv)
 
 		eb = list_first_entry(&root->fs_info->recow_ebs,
 				      struct extent_buffer, recow);
+		list_del_init(&eb->recow);
 		ret = recow_extent_buffer(root, eb);
 		if (ret)
 			break;

--=-=-=
Content-Type: text/x-diff
Content-Disposition: inline; filename=check-no-tree-refs-as-data-refs.patch

check: do not dereference tree_refs as data_refs

From: Alexandre Oliva <oliva@gnu.org>

In a filesystem corrupted by a faulty memory module, btrfsck would get
very confused attempting to access backrefs that weren't data backrefs
as if they were.  Besides invoking undefined behavior for accessing
potentially-uninitialized data past the end of objects, or with
dynamic types unrelated with the static types held in the
corresponding memory, it used offsets and lengths from such fields
that did not correspond to anything in the filesystem proper.

Moving the test for full backrefs and checking that they're data
backrefs earlier avoided the crash I was running into, but that was
not enough to make the filesystem complete a successful repair.

Signed-off-by: Alexandre Oliva <oliva@gnu.org>
---
 cmds-check.c |   19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 66c982f..319dd2b 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -4781,15 +4781,17 @@ static int verify_backrefs(struct btrfs_trans_handle *trans,
 		return 0;
 
 	list_for_each_entry(back, &rec->backrefs, list) {
+		if (back->full_backref || !back->is_data)
+			continue;
+
 		dback = (struct data_backref *)back;
+
 		/*
 		 * We only pay attention to backrefs that we found a real
 		 * backref for.
 		 */
 		if (dback->found_ref == 0)
 			continue;
-		if (back->full_backref)
-			continue;
 
 		/*
 		 * For now we only catch when the bytes don't match, not the
@@ -4905,6 +4907,9 @@ static int verify_backrefs(struct btrfs_trans_handle *trans,
 	 * references and fix up the ones that don't match.
 	 */
 	list_for_each_entry(back, &rec->backrefs, list) {
+		if (back->full_backref || !back->is_data)
+			continue;
+
 		dback = (struct data_backref *)back;
 
 		/*
@@ -4913,8 +4918,6 @@ static int verify_backrefs(struct btrfs_trans_handle *trans,
 		 */
 		if (dback->found_ref == 0)
 			continue;
-		if (back->full_backref)
-			continue;
 
 		if (dback->bytes == best->bytes &&
 		    dback->disk_bytenr == best->bytenr)
@@ -5134,14 +5137,16 @@ static int find_possible_backrefs(struct btrfs_trans_handle *trans,
 	int ret;
 
 	list_for_each_entry(back, &rec->backrefs, list) {
+		/* Don't care about full backrefs (poor unloved backrefs) */
+		if (back->full_backref || !back->is_data)
+			continue;
+
 		dback = (struct data_backref *)back;
 
 		/* We found this one, we don't need to do a lookup */
 		if (dback->found_ref)
 			continue;
-		/* Don't care about full backrefs (poor unloved backrefs) */
-		if (back->full_backref)
-			continue;
+
 		key.objectid = dback->root;
 		key.type = BTRFS_ROOT_ITEM_KEY;
 		key.offset = (u64)-1;

--=-=-=



-- 
Alexandre Oliva, freedom fighter    http://FSFLA.org/~lxoliva/
You must be the change you wish to see in the world. -- Gandhi
Be Free! -- http://FSFLA.org/   FSF Latin America board member
Free Software Evangelist|Red Hat Brasil GNU Toolchain Engineer

--=-=-=--
