Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:9523 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751055AbaHITkX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 9 Aug 2014 15:40:23 -0400
From: Josef Bacik <jbacik@fb.com>
To: Filipe Manana <fdmanana@suse.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: fix csum tree corruption, duplicate and outdated
 checksums
Date: Sat, 9 Aug 2014 19:40:17 +0000
Message-ID: <mmfcdo0u9ha9kxqgm6e9xd6n.1407613215870@email.android.com>
References: <1407615747-12949-1-git-send-email-fdmanana@suse.com>
In-Reply-To: <1407615747-12949-1-git-send-email-fdmanana@suse.com>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm getting on a plane right now to kiss you, be prepared.  Thanks,

Josef

Filipe Manana <fdmanana@suse.com> wrote:


Under rare circumstances we can end up leaving 2 versions of a checksum
for the same file extent range.

The reason for this is that after calling btrfs_next_leaf we process
slot 0 of the leaf it returns, instead of processing the slot set in
path->slots[0]. Most of the time (by far) path->slots[0] is 0, but after
btrfs_next_leaf() releases the path and before it searches for the next
leaf, another task might cause a split of the next leaf, which migrates
some of its keys to the leaf we were processing before calling
btrfs_next_leaf(). In this case btrfs_next_leaf() returns again the
same leaf but with path->slots[0] having a slot number corresponding
to the first new key it got, that is, a slot number that didn't exist
before calling btrfs_next_leaf(), as the leaf now has more keys than
it had before. So we must really process the returned leaf starting at
path->slots[0] always, as it isn't always 0, and the key at slot 0 can
have an offset much lower than our search offset/bytenr.

For example, consider the following scenario, where we have:

sums->bytenr: 40157184, sums->len: 16384, sums end: 40173568
four 4kb file data blocks with offsets 40157184, 40161280, 40165376, 40169472

  Leaf N:

    slot = 0                           slot = btrfs_header_nritems() - 1
  |-------------------------------------------------------------------|
  | [(CSUM CSUM 39239680), size 8] ... [(CSUM CSUM 40116224), size 4] |
  |-------------------------------------------------------------------|

  Leaf N + 1:

      slot = 0                          slot = btrfs_header_nritems() - 1
  |--------------------------------------------------------------------|
  | [(CSUM CSUM 40161280), size 32] ... [((CSUM CSUM 40615936), size 8 |
  |--------------------------------------------------------------------|

Because we are at the last slot of leaf N, we call btrfs_next_leaf() to
find the next highest key, which releases the current path and then searches
for that next key. However after releasing the path and before finding that
next key, the item at slot 0 of leaf N + 1 gets moved to leaf N, due to a call
to ctree.c:push_leaf_left() (via ctree.c:split_leaf()), and therefore
btrfs_next_leaf() will returns us a path again with leaf N but with the slot
pointing to its new last key (CSUM CSUM 40161280). This new version of leaf N
is then:

    slot = 0                        slot = btrfs_header_nritems() - 2  slot = btrfs_header_nritems() - 1
  |----------------------------------------------------------------------------------------------------|
  | [(CSUM CSUM 39239680), size 8] ... [(CSUM CSUM 40116224), size 4]  [(CSUM CSUM 40161280), size 32] |
  |----------------------------------------------------------------------------------------------------|

And incorrecly using slot 0, makes us set next_offset to 39239680 and we jump
into the "insert:" label, which will set tmp to:

    tmp = min((sums->len - total_bytes) >> blocksize_bits,
        (next_offset - file_key.offset) >> blocksize_bits) =
    min((16384 - 0) >> 12, (39239680 - 40157184) >> 12) =
    min(4, (u64)-917504 = 18446744073708634112 >> 12) = 4

and

   ins_size = csum_size * tmp = 4 * 4 = 16 bytes.

In other words, we insert a new csum item in the tree with key
(CSUM_OBJECTID CSUM_KEY 40157184 = sums->bytenr) that contains the checksums
for all the data (4 blocks of 4096 bytes each = sums->len). Which is wrong,
because the item with key (CSUM CSUM 40161280) (the one that was moved from
leaf N + 1 to the end of leaf N) contains the old checksums of the last 12288
bytes of our data and won't get those old checksums removed.

So this leaves us 2 different checksums for 3 4kb blocks of data in the tree,
and breaks the logical rule:

   Key_N+1.offset >= Key_N.offset + length_of_data_its_checksums_cover

An obvious bad effect of this is that a subsequent csum tree lookup to get
the checksum of any of the blocks with logical offset of 40161280, 40165376
or 40169472 (the last 3 4kb blocks of file data), will get the old checksums.

Cc: stable@vger.kernel.org
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/file-item.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index a1f97de..7897dcd 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -746,7 +746,7 @@ again:
                                found_next = 1;
                        if (ret != 0)
                                goto insert;
-                       slot = 0;
+                       slot = path->slots[0];
                }
                btrfs_item_key_to_cpu(path->nodes[0], &found_key, slot);
                if (found_key.objectid != BTRFS_EXTENT_CSUM_OBJECTID ||
--
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  https://urldefense.proofpoint.com/v1/url?u=http://vger.kernel.org/majordomo-info.html&k=ZVNjlDMF0FElm4dQtryO4A%3D%3D%0A&r=cKCbChRKsMpTX8ybrSkonQ%3D%3D%0A&m=%2F%2BJGihlBY9P4TZ77yUay5e6r3fawI30oSQXNPGxdVvc%3D%0A&s=32396751f1503bfc1bd4b63ca15fcf656cf42bacc3b09aaadbcc8e394bc65733
