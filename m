Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44309 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751120Ab3BYLyS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Feb 2013 06:54:18 -0500
Date: Mon, 25 Feb 2013 12:54:16 +0100
From: David Sterba <dsterba@suse.cz>
To: Tomasz Kusmierz <wally_tm@wally-tm.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Changing node & leaf size on live partition.
Message-ID: <20130225115416.GT27541@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <5128DCF0.4040209@wally-tm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5128DCF0.4040209@wally-tm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Feb 23, 2013 at 03:14:56PM +0000, Tomasz Kusmierz wrote:
> Question is pretty simple:
> 
> "How to change node size and leaf size on previously created partition?"
> 
> Now, I know what most people will say: "you should've be smarter while
> typing mkfs.btrfs". Well, I'm intending to convert in place ext4 partition
> but there seems to be no option for leaf and node size in this tool. If it's
> not possible I guess I'll have to create "/" from scratch and copy all my
> content there.

I tried a quick hack to extend the options with nodesize and pass that
further to the convert process, but it does not work (there are probably
some assumptions about blocksize and nodesize that I've missed). Sending
the patch if somebody wants to continue.

david

--- a/convert.c
+++ b/convert.c
@@ -49,6 +49,7 @@
 #define STRIPE_LEN (64 * 1024)
 #define EXT2_IMAGE_SUBVOL_OBJECTID BTRFS_FIRST_FREE_OBJECTID
 
+static int nodesize = 0;
 /*
  * Open Ext2fs in readonly mode, read block allocation bitmap and
  * inode bitmap into memory.
@@ -1806,20 +1807,20 @@ static int prepare_system_chunk_sb(struct btrfs_super_block *super)
 	return 0;
 }
 
-static int prepare_system_chunk(int fd, u64 sb_bytenr, u32 sectorsize)
+static int prepare_system_chunk(int fd, u64 sb_bytenr, u32 nodesize)
 {
 	int ret;
 	struct extent_buffer *buf;
 	struct btrfs_super_block *super;
 
-	BUG_ON(sectorsize < sizeof(*super));
-	buf = malloc(sizeof(*buf) + sectorsize);
+	BUG_ON(nodesize < sizeof(*super));
+	buf = malloc(sizeof(*buf) + nodesize);
 	if (!buf)
 		return -ENOMEM;
 
-	buf->len = sectorsize;
-	ret = pread(fd, buf->data, sectorsize, sb_bytenr);
-	if (ret != sectorsize)
+	buf->len = nodesize;
+	ret = pread(fd, buf->data, nodesize, sb_bytenr);
+	if (ret != nodesize)
 		goto fail;
 
 	super = (struct btrfs_super_block *)buf->data;
@@ -1830,9 +1831,9 @@ static int prepare_system_chunk(int fd, u64 sb_bytenr, u32 sectorsize)
 	if (ret)
 		goto fail;
 
-	csum_tree_block_size(buf, BTRFS_CRC32_SIZE, 0);
-	ret = pwrite(fd, buf->data, sectorsize, sb_bytenr);
-	if (ret != sectorsize)
+	csum_tree_block_size(buf, BTRFS_CRC32_SIZE, 1);
+	ret = pwrite(fd, buf->data, nodesize, sb_bytenr);
+	if (ret != nodesize)
 		goto fail;
 
 	ret = 0;
@@ -2317,14 +2318,14 @@ int do_convert(const char *devname, int datacsum, int packing, int noxattr)
 		goto fail;
 	}
 	ret = make_btrfs(fd, devname, ext2_fs->super->s_volume_name,
-			 blocks, total_bytes, blocksize, blocksize,
+			 blocks, total_bytes, nodesize, nodesize,
 			 blocksize, blocksize);
 	if (ret) {
 		fprintf(stderr, "unable to create initial ctree\n");
 		goto fail;
 	}
 	/* create a system chunk that maps the whole device */
-	ret = prepare_system_chunk(fd, super_bytenr, blocksize);
+	ret = prepare_system_chunk(fd, super_bytenr, nodesize);
 	if (ret) {
 		fprintf(stderr, "unable to update system chunk\n");
 		goto fail;
@@ -2753,13 +2754,36 @@ fail:
 	return -1;
 }
 
+/* copied from mkfs.c */
+static int check_leaf_or_node_size(u32 size, u32 sectorsize)
+{
+	if (size < sectorsize) {
+		fprintf(stderr,
+			"Illegal leafsize (or nodesize) %u (smaller than %u)\n",
+			size, sectorsize);
+		return -1;
+	} else if (size > BTRFS_MAX_METADATA_BLOCKSIZE) {
+		fprintf(stderr,
+			"Illegal leafsize (or nodesize) %u (larger than %u)\n",
+			size, BTRFS_MAX_METADATA_BLOCKSIZE);
+		return -1;
+	} else if (size & (sectorsize - 1)) {
+		fprintf(stderr,
+			"Illegal leafsize (or nodesize) %u (not align to %u)\n",
+			size, sectorsize);
+		return -1;
+	}
+	return 0;
+}
+
 static void print_usage(void)
 {
-	printf("usage: btrfs-convert [-d] [-i] [-n] [-r] device\n");
+	printf("usage: btrfs-convert [-d] [-i] [-n] [-r] [-l size] device\n");
 	printf("\t-d disable data checksum\n");
 	printf("\t-i ignore xattrs and ACLs\n");
 	printf("\t-n disable packing of small files\n");
 	printf("\t-r roll back to ext2fs\n");
+	printf("\t-l set leafsize/nodesize of btrfs metadata\n");
 }
 
 int main(int argc, char *argv[])
@@ -2770,8 +2794,10 @@ int main(int argc, char *argv[])
 	int datacsum = 1;
 	int rollback = 0;
 	char *file;
+
+	nodesize = 4096;
 	while(1) {
-		int c = getopt(argc, argv, "dinr");
+		int c = getopt(argc, argv, "dinrl:");
 		if (c < 0)
 			break;
 		switch(c) {
@@ -2787,6 +2813,11 @@ int main(int argc, char *argv[])
 			case 'r':
 				rollback = 1;
 				break;
+			case 'l':
+				nodesize = parse_size(optarg);
+				if (check_leaf_or_node_size(nodesize, 4096))
+					exit(1);
+				break;
 			default:
 				print_usage();
 				return 1;
-- 
1.8.0.2

