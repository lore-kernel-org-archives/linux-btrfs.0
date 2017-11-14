Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:49352 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751872AbdKNHzn (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Tue, 14 Nov 2017 02:55:43 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, chris@colorremedies.com
Subject: [PATCH 1/2] btrfs-progs: lowmem check: Fix false alerts of referencer count mismatch for snapshot
Date: Tue, 14 Nov 2017 15:55:20 +0800
Message-Id: <20171114075521.24736-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Btrfs lowmem check reports such false alerts:
------
ERROR: extent[366498091008, 134217728] referencer count mismatch (root: 827, owner: 73782, offset: 134217728) wanted: 4, have: 26
ERROR: extent[366498091008, 134217728] referencer count mismatch (root: 818, owner: 73782, offset: 134217728) wanted: 4, have: 26
ERROR: extent[366498091008, 134217728] referencer count mismatch (root: 870, owner: 73782, offset: 134217728) wanted: 4, have: 26
------

While in extent tree, the extent has:
------
        item 81 key (366498091008 EXTENT_ITEM 134217728) itemoff 9008 itemsize 169
                refs 39 gen 224 flags DATA
                extent data backref root 827 objectid 73782 offset 134217728 count 4
                extent data backref root 818 objectid 73782 offset 134217728 count 4
                extent data backref root 259 objectid 73482 offset 134217728 count 1
                extent data backref root 644 objectid 73782 offset 134217728 count 26
                extent data backref root 870 objectid 73782 offset 134217728 count 4
------

And in root 827, there is one leaf with 4 references to that extent
which is owned by 827:
------
leaf 714964992 items 68 free space 10019 generation 641 owner 827
leaf 714964992 flags 0x1(WRITTEN) backref revision 1
......
        item 64 key (73782 EXTENT_DATA 134217728) itemoff 11878 itemsize 53
                generation 224 type 1 (regular)
                extent data disk byte 366498091008 nr 134217728
                extent data offset 0 nr 6410240 ram 134217728
                extent compression 0 (none)
        item 65 key (73782 EXTENT_DATA 140627968) itemoff 11825 itemsize 53
                generation 224 type 1 (regular)
                extent data disk byte 366498091008 nr 134217728
                extent data offset 6410240 nr 5120000 ram 134217728
                extent compression 0 (none)
        item 66 key (73782 EXTENT_DATA 145747968) itemoff 11772 itemsize 53
                generation 224 type 1 (regular)
                extent data disk byte 366498091008 nr 134217728
                extent data offset 11530240 nr 7675904 ram 134217728
                extent compression 0 (none)
        item 67 key (73782 EXTENT_DATA 153423872) itemoff 11719 itemsize 53
                generation 224 type 1 (regular)
                extent data disk byte 366498091008 nr 134217728
                extent data offset 19206144 nr 6397952 ram 134217728
                extent compression 0 (none)
------

And starts from next leaf, there are 22 references to the data extent:
------
leaf 894861312 items 208 free space 59 generation 261 owner 644
leaf 894861312 flags 0x1(WRITTEN) backref revision 1
        item 0 key (73782 EXTENT_DATA 159821824) itemoff 16230 itemsize 53
                generation 224 type 1 (regular)
                extent data disk byte 366498091008 nr 134217728
                extent data offset 25604096 nr 8192 ram 134217728
                extent compression 0 (none)
        item 1 key (73782 EXTENT_DATA 159830016) itemoff 16177 itemsize 53
                generation 224 type 1 (regular)
                extent data disk byte 366498091008 nr 134217728
                extent data offset 25612288 nr 7675904 ram 134217728
                extent compression 0 (none)
......
------

However the next leaf is owned by other subvolume, normally owned by (part of)
the snapshot source.

Fix it by also checking the leaf's owner before increasing the reference
counter.

Reported-by: Chris Murphy <chris@colorremedies.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 cmds-check.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/cmds-check.c b/cmds-check.c
index 4805e11b752b..d782567c77ee 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -10909,11 +10909,17 @@ static int check_extent_data_backref(struct btrfs_fs_info *fs_info,
 		 * Except normal disk bytenr and disk num bytes, we still
 		 * need to do extra check on dbackref offset as
 		 * dbackref offset = file_offset - file_extent_offset
+		 *
+		 * Also, we must check the leaf owner.
+		 * In case of shared tree blocks (snapshots) we can inherit
+		 * leaves from source snapshot.
+		 * In that case, reference from source snapshot should not
+		 * count.
 		 */
 		if (btrfs_file_extent_disk_bytenr(leaf, fi) == bytenr &&
 		    btrfs_file_extent_disk_num_bytes(leaf, fi) == len &&
 		    (u64)(key.offset - btrfs_file_extent_offset(leaf, fi)) ==
-		    offset)
+		    offset && btrfs_header_owner(leaf) == root_id)
 			found_count++;
 
 next:
-- 
2.15.0

