From: Josef Bacik <josef@redhat.com>
Subject: [RFC] make btrfs-image work
Date: Tue, 19 Jan 2010 11:04:17 -0500
Message-ID: <20100119160417.GA16384@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

btrfs-image would be very helpful for debugging some users problems that we
can't reproduce ourselves, but every image that i try and re-create with
btrfs-image makes btrfs panic.  This is because we zero out the superblocks
chunk array and re-create our uuid.  This means that we end up not being able to
read the chunk tree on mount, and then even if we could the uuid's of the
metadata we read back wouldn't match the uuid of the device.  The way I've fixed
this is to just spit the metadata back onto the disk exactly the way we got it.
The caveat to this I think is that if we try to image a multi-device setup that
it won't work right unless we have a multi-device setup to restore the image
onto.  I'm not sure if thats the goal or not.  This patch makes the single disk
case work fine for me.  Let me know what you think.  Thanks,

Josef

diff --git a/btrfs-image.c b/btrfs-image.c
index f2bbcc8..2d45ac3 100644
--- a/btrfs-image.c
+++ b/btrfs-image.c
@@ -564,41 +564,6 @@ static int create_metadump(const char *input, FILE *out, int num_threads,
 	return 0;
 }
 
-static void update_super(u8 *buffer)
-{
-	struct btrfs_super_block *super = (struct btrfs_super_block *)buffer;
-	struct btrfs_chunk *chunk;
-	struct btrfs_disk_key *key;
-	u32 sectorsize = btrfs_super_sectorsize(super);
-	u64 flags = btrfs_super_flags(super);
-
-	flags |= BTRFS_SUPER_FLAG_METADUMP;
-	btrfs_set_super_flags(super, flags);
-
-	key = (struct btrfs_disk_key *)(super->sys_chunk_array);
-	chunk = (struct btrfs_chunk *)(super->sys_chunk_array +
-				       sizeof(struct btrfs_disk_key));
-
-	btrfs_set_disk_key_objectid(key, BTRFS_FIRST_CHUNK_TREE_OBJECTID);
-	btrfs_set_disk_key_type(key, BTRFS_CHUNK_ITEM_KEY);
-	btrfs_set_disk_key_offset(key, 0);
-
-	btrfs_set_stack_chunk_length(chunk, (u64)-1);
-	btrfs_set_stack_chunk_owner(chunk, BTRFS_EXTENT_TREE_OBJECTID);
-	btrfs_set_stack_chunk_stripe_len(chunk, 64 * 1024);
-	btrfs_set_stack_chunk_type(chunk, BTRFS_BLOCK_GROUP_SYSTEM);
-	btrfs_set_stack_chunk_io_align(chunk, sectorsize);
-	btrfs_set_stack_chunk_io_width(chunk, sectorsize);
-	btrfs_set_stack_chunk_sector_size(chunk, sectorsize);
-	btrfs_set_stack_chunk_num_stripes(chunk, 1);
-	btrfs_set_stack_chunk_sub_stripes(chunk, 0);
-	chunk->stripe.devid = super->dev_item.devid;
-	chunk->stripe.offset = cpu_to_le64(0);
-	memcpy(chunk->stripe.dev_uuid, super->dev_item.uuid, BTRFS_UUID_SIZE);
-	btrfs_set_super_sys_array_size(super, sizeof(*key) + sizeof(*chunk));
-	csum_block(buffer, 4096);
-}
-
 static void *restore_worker(void *data)
 {
 	struct mdrestore_struct *mdres = (struct mdrestore_struct *)data;
@@ -637,9 +602,6 @@ static void *restore_worker(void *data)
 			size = async->bufsize;
 		}
 
-		if (async->start == BTRFS_SUPER_INFO_OFFSET)
-			update_super(outbuf);
-
 		ret = pwrite64(outfd, outbuf, size, async->start);
 		BUG_ON(ret != size);
 
