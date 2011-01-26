From: Cyrille =?ISO-8859-1?Q?Ch=E9p=E9lov?= <cyrille@chepelov.org>
Subject: Re: full btrfs partition, became unmountable (+ a solution that
 thankfully worked for me)
Date: Wed, 26 Jan 2011 08:46:08 +0100
Message-ID: <1296027969.29117.26.camel@hestia>
References: <1295981200.29117.19.camel@hestia>
	 <BC28BE23-1017-456E-9EAA-74A840809085@me.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-TovPMUBbcwNB5a+bSJwV"
Cc: linux-btrfs@vger.kernel.org
To: Shawn Stricker <kb1ibt@me.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BC28BE23-1017-456E-9EAA-74A840809085@me.com>
List-ID: <linux-btrfs.vger.kernel.org>


--=-TovPMUBbcwNB5a+bSJwV
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit

Le mardi 25 janvier 2011 à 23:38 -0500, Shawn Stricker a écrit :
> Not sure where you pulled your source from but a fresh checkout of either master or next of git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs-unstable.git does not compile properly.
> They both fail with 
> 
> cc1: warnings being treated as errors
> disk-io.c: In function ‘btrfs_read_dev_super’:
> disk-io.c:937: error: format ‘%lu’ expects type ‘long unsigned int’, but argument 4 has type ‘unsigned int’
> disk-io.c:957: error: implicit declaration of function ‘uuid_unparse’
> 
> am I patching/compiling from the wrong source or is there something I am missing?

uh, I had been compiling with CFLAGS=-g, where the makefile specifies
"-O2 -Werror"

-Werror causes warnings to be treated as errors, which is a good thing
in a way (makes sure stuff as this gets caught :) )

fixes are:
	* line 937 (patched), should be %llu instead of %lu
	* line 957, there should be a prototype for uuid_unparse(), most
certainly by including <uuid/uuid.h>

please try this patch instead.

Thanks for the feedback!

	-- Cyrille

> On Jan 25, 2011, at 1:46 PM, Cyrille Chépélov wrote:
> 
> > Hello all,
> > 
> > Last Friday, the /var and /home partition on one of my appliances became
> > full. This should normally not be much of a problem, except that after
> > the incident, I had been unable to mount the partition back again.
> > 
> > The appliance runs 2.6.32 as provided by Debian during the last two
> > months. 
> > The rescue computer runs 2.6.37; both exhibited the same behaviour at
> > mount: an infinite loop-and-abort cycle (I unfortunately did not write
> > down the exact messages, but in a nutshell, there was not enough free
> > space to replay the log, so it aborted).
> > 
> > After pulling the SD card (yes) to break the loop, I ended up with a
> > corrupt file system. Any attempt to mount, debug or fsck (using
> > btrfs-tools 0.19+20100601 as shipped by Debian, or compiled from git
> > 1b444cd2e6ab8dcafdd) aborted with the following message:
> >    btrfs-debug-tree: disk-io.c:741: open_ctree_fd: Assertion `!(!
> > tree_root->node)' failed.
> > 
> > After much scavenging on the disk image, I finally managed to recover,
> > using the (dirty) patch attached here. Since apparently other people had
> > similar issues, I'm posting it in the hope it might be useful.
> > 
> >    -- Cyrille
> > 
> > PS: Chris, if btrfs-images of "before" and "after" my butcher fix would
> > be useful to you, just let me know. 
> > <scavenge.patch>
> 


--=-TovPMUBbcwNB5a+bSJwV
Content-Disposition: attachment; filename="scavenge-2.patch"
Content-Type: text/x-patch; name="scavenge-2.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

diff --git a/btrfsck.c b/btrfsck.c
index 63e44d1..1e6bc32 100644
--- a/btrfsck.c
+++ b/btrfsck.c
@@ -2823,13 +2823,17 @@ int main(int ac, char **av)
 	u64 bytenr = 0;
 	int ret;
 	int num;
+	int emergency_super = 0;
 
 	while(1) {
 		int c;
-		c = getopt(ac, av, "s:");
+		c = getopt(ac, av, "es:");
 		if (c < 0)
 			break;
 		switch(c) {
+			case 'e':
+				emergency_super = 1;
+				break;
 			case 's':
 				num = atol(optarg);
 				bytenr = btrfs_sb_offset(num);
@@ -2861,6 +2865,12 @@ int main(int ac, char **av)
 	if (root == NULL)
 		return 1;
 
+	if (root->fs_info->emergency_root_tree && (!emergency_super)) {
+		printf("DANGEROUS: had to use a synthetic super. Please run with '-e' flag if you know why you do it.\n");
+		printf("      ... and have perfect backups.\n");
+		return 1;
+	}
+
 	ret = check_extents(root);
 	if (ret)
 		goto out;
@@ -2869,6 +2879,27 @@ int main(int ac, char **av)
 		goto out;
 
 	ret = check_root_refs(root, &root_cache);
+	if (ret)
+		goto out;
+
+
+	if (root->fs_info->emergency_root_tree) {
+		printf("DANGEROUS: had to use a scavenged root. Apparently could figure out the primary trees ?\n" 
+		       "   Now writing supers, knock wood.\n");
+		free_root_recs(&root_cache);
+		close_ctree(root);
+		
+		cache_tree_init(&root_cache);
+		root = open_ctree(av[optind], bytenr, 1 /* WRITES! */);
+
+		ret = write_all_supers(root);
+		if (ret) {
+			printf("Error writing superblocks.\n");		
+			goto out;			
+		}
+		printf("Wrote back superblocks.\n");
+	}
+
 out:
 	free_root_recs(&root_cache);
 	close_ctree(root);
@@ -2897,6 +2928,7 @@ out:
 	printf("file data blocks allocated: %llu\n referenced %llu\n",
 		(unsigned long long)data_bytes_allocated,
 		(unsigned long long)data_bytes_referenced);
+
 	printf("%s\n", BTRFS_BUILD_VERSION);
 	return ret;
 }
diff --git a/ctree.h b/ctree.h
index b79e238..7439d87 100644
--- a/ctree.h
+++ b/ctree.h
@@ -728,6 +728,7 @@ struct btrfs_fs_info {
 	struct list_head space_info;
 	int system_allocs;
 	int readonly;
+	int emergency_root_tree;
 };
 
 /*
diff --git a/disk-io.c b/disk-io.c
index a6e1000..0b4e7f9 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -23,6 +23,7 @@
 #include <stdlib.h>
 #include <sys/types.h>
 #include <sys/stat.h>
+#include <uuid/uuid.h>
 #include <fcntl.h>
 #include <unistd.h>
 #include "kerncompat.h"
@@ -41,8 +42,11 @@ static int check_tree_block(struct btrfs_root *root, struct extent_buffer *buf)
 	struct btrfs_fs_devices *fs_devices;
 	int ret = 1;
 
-	if (buf->start != btrfs_header_bytenr(buf))
+	if (buf->start != btrfs_header_bytenr(buf)) {
+		fprintf(stderr, "start place mismatch, buf says %llu  btrfs_hdr says %llu\n",
+			buf->start, btrfs_header_bytenr(buf));
 		return ret;
+	}
 
 	fs_devices = root->fs_info->fs_devices;
 	while (fs_devices) {
@@ -204,16 +208,26 @@ struct extent_buffer *read_tree_block(struct btrfs_root *root, u64 bytenr,
 		eb->dev_bytenr = multi->stripes[0].physical;
 		kfree(multi);
 		ret = read_extent_from_disk(eb);
-		if (ret == 0 && check_tree_block(root, eb) == 0 &&
-		    csum_tree_block(root, eb, 1) == 0 &&
-		    verify_parent_transid(eb->tree, eb, parent_transid) == 0) {
-			btrfs_set_buffer_uptodate(eb);
-			return eb;
+		if (ret == 0) {
+			
+		    if (check_tree_block(root, eb) == 0) {
+			/* fprintf(stderr, "checked tree block %p for %p -- %llu \n", root, eb, eb->start);*/
+			if (csum_tree_block(root, eb, 1) == 0) {
+				/* fprintf(stderr, "tree block csum %p for %p--%llu is OK\n", root, eb, eb->start); */
+				if (verify_parent_transid(eb->tree, eb, parent_transid) == 0) {
+					/*fprintf(stderr, "tree block %p--%llu has correct transid, setting uptodate\n",  eb, eb->start);				*/
+				
+					btrfs_set_buffer_uptodate(eb);
+					return eb;
+				}
+			}	
+		   }
+
 		}
 		num_copies = btrfs_num_copies(&root->fs_info->mapping_tree,
 					      eb->start, eb->len);
 		if (num_copies == 1) {
-			break;
+			//break;
 		}
 		mirror_num++;
 		if (mirror_num > num_copies) {
@@ -581,7 +595,7 @@ struct btrfs_root *open_ctree(const char *filename, u64 sb_bytenr, int writes)
 
 	fp = open(filename, flags, 0600);
 	if (fp < 0) {
-		fprintf (stderr, "Could not open %s\n", filename);
+		fprintf (stderr, "Could not open %s: %s\n", filename, strerror(errno));
 		return NULL;
 	}
 	root = open_ctree_fd(fp, filename, sb_bytenr, writes);
@@ -590,6 +604,102 @@ struct btrfs_root *open_ctree(const char *filename, u64 sb_bytenr, int writes)
 	return root;
 }
 
+#define MAX_EMERG_BUCKETS 30
+static int try_emergency_tree_fixup(struct btrfs_super_block *disk_super, 
+		struct btrfs_root *chunk_root, 
+		struct btrfs_root *tree_root) 
+{
+	struct btrfs_header* buf;
+	u64 ofs, oldofs;
+	u32 blocksize;
+	u64 generation;
+	int ret, i;
+
+	u64 best_gen[MAX_EMERG_BUCKETS];
+	u64 best_bytenr[MAX_EMERG_BUCKETS];
+
+	memset(&best_gen, 0, sizeof(best_gen));
+	memset(&best_bytenr, 0, sizeof(best_bytenr));
+
+	blocksize = btrfs_level_size(tree_root,
+				     btrfs_super_chunk_root_level(disk_super));
+	generation = btrfs_super_chunk_root_generation(disk_super);
+	buf = (struct btrfs_header*)malloc(blocksize);
+
+	oldofs = btrfs_super_bytenr(disk_super);
+	for (ofs = oldofs; 
+	     ofs < btrfs_super_total_bytes(disk_super);	
+	     ofs += blocksize) {
+	     
+             ret = pread(chunk_root->node->fd, buf, blocksize, ofs);
+	     if (ret == blocksize) {
+		u64 blockofs = le64_to_cpu(buf->bytenr);
+		if (blockofs != ofs) continue;
+
+		char* src = chunk_root->node->data + (long)btrfs_header_fsid(chunk_root->node); 
+		char* dst = (char*) &(buf->fsid);
+		if (memcmp(src, dst, sizeof(buf->fsid)) != 0) 
+			continue;
+
+		u64 blockgen = le64_to_cpu(buf->generation);
+		u64 blockowner = le64_to_cpu(buf->owner);
+		u32 blocknritems = le32_to_cpu(buf->nritems); 
+		u8  blocklevel = le8_to_cpu(buf->level);
+
+		/*
+		fprintf(stderr,
+			"     found valid header at %llu(+%llu) -- gen=%llu owner=%llu nritems=%u level=%u ",
+			ofs, ofs-oldofs, blockgen, blockowner, blocknritems, blocklevel);
+		*/
+
+		if ((blockowner < 0ull) && (blockowner > -11ull)) { blockowner += 30; /* hack */ }
+
+		if ((blockowner >= 0) && (blockowner < MAX_EMERG_BUCKETS)) {
+			if (blockgen > best_gen[blockowner]) {
+				best_gen[blockowner] = blockgen;
+				best_bytenr[blockowner] = ofs;
+
+				fprintf(stderr,
+					"     found valid header at %llu(+%llu) -- gen=%llu owner=%llu nritems=%u level=%u ",
+					ofs, ofs-oldofs, blockgen, blockowner, blocknritems, blocklevel);
+
+				fprintf(stderr,
+					" ... new best gen for ObjectID %llu  at %llu\n", blockowner, ofs);
+			} else {
+			}
+		} else {
+		}
+
+		oldofs = ofs;
+	     }
+	}
+	fprintf(stderr,"*** done scanning, at offset %llu ***\n", ofs);
+	for ( i = 0; i < MAX_EMERG_BUCKETS; ++i) {
+		fprintf(stderr,"  for ObjectID: %d, max gen=%llu at %llu\n", i, best_gen[i], best_bytenr[i]);
+	}
+
+
+	free(buf);
+
+#if 1	
+	if (best_gen[BTRFS_CSUM_TREE_OBJECTID] == best_gen[BTRFS_ROOT_TREE_OBJECTID]) {
+		/* now we try to do the repair */
+		fprintf(stderr,
+			" ATTEMPTING DANGEROUS REPAIR with root gen=%llu bytenr=%llu\n",
+			best_gen[BTRFS_ROOT_TREE_OBJECTID], best_bytenr[BTRFS_ROOT_TREE_OBJECTID]);
+		btrfs_set_super_generation(disk_super, best_gen[BTRFS_ROOT_TREE_OBJECTID]);
+		btrfs_set_super_root(disk_super, best_bytenr[BTRFS_ROOT_TREE_OBJECTID]);
+		
+		/* not actually changing the on-disk super. Debug should proceed, 
+		   fsck should eventually rewrite the super ?*/
+		tree_root->fs_info->emergency_root_tree = 1;
+		return 0;				
+	}
+#endif
+
+	return 1; /* nothing done */
+}
+
 struct btrfs_root *open_ctree_fd(int fp, const char *path, u64 sb_bytenr,
 				 int writes)
 {
@@ -736,7 +846,26 @@ struct btrfs_root *open_ctree_fd(int fp, const char *path, u64 sb_bytenr,
 	tree_root->node = read_tree_block(tree_root,
 					  btrfs_super_root(disk_super),
 					  blocksize, generation);
+	if (!tree_root->node) {
+		fprintf(stderr,"*** did not find a root, about to abort ***\n");
+		fprintf(stderr,"*** will attempt to find useful trees before bailing out anyway: ***\n");
+		ret = try_emergency_tree_fixup(disk_super, chunk_root, tree_root);
+		if (!ret) {
+			fprintf(stderr,"a repair happened, trying again (once):\n");
+			
+			generation = btrfs_super_generation(disk_super);
+			tree_root->node = read_tree_block(tree_root,
+							  btrfs_super_root(disk_super),
+							  blocksize, generation);
+			if (!tree_root->node) {
+				fprintf(stderr,"*** again, did not find a root, about to abort, for good. ***\n");
+			}
+		}	
+	}
 	BUG_ON(!tree_root->node);
+	if (!tree_root->node) {
+		fprintf(stderr,"*** huh?  ***\n");
+	}
 	ret = find_and_setup_root(tree_root, fs_info,
 				  BTRFS_EXTENT_TREE_OBJECTID, extent_root);
 	BUG_ON(ret);
@@ -774,12 +903,15 @@ struct btrfs_root *open_ctree_fd(int fp, const char *path, u64 sb_bytenr,
 int btrfs_read_dev_super(int fd, struct btrfs_super_block *sb, u64 sb_bytenr)
 {
 	u8 fsid[BTRFS_FSID_SIZE];
+	char up_fsid[37], up_ofsid[37];
 	struct btrfs_super_block buf;
 	int i;
 	int ret;
 	u64 transid = 0;
 	u64 bytenr;
 
+
+
 	if (sb_bytenr != BTRFS_SUPER_INFO_OFFSET) {
 		ret = pread64(fd, &buf, sizeof(buf), sb_bytenr);
 		if (ret < sizeof(buf))
@@ -796,24 +928,63 @@ int btrfs_read_dev_super(int fd, struct btrfs_super_block *sb, u64 sb_bytenr)
 
 	for (i = 0; i < BTRFS_SUPER_MIRROR_MAX; i++) {
 		bytenr = btrfs_sb_offset(i);
+		fprintf(stderr, "trying potential super #%d at bytenr %llu \n",
+			i, bytenr);
+
+
 		ret = pread64(fd, &buf, sizeof(buf), bytenr);
-		if (ret < sizeof(buf))
+		if (ret < sizeof(buf)) {
+			fprintf(stderr, "    got only %d bytes instead of %lu\n",
+				ret, sizeof(buf));
 			break;
+		}
 
-		if (btrfs_super_bytenr(&buf) != bytenr ||
-		    strncmp((char *)(&buf.magic), BTRFS_MAGIC,
-			    sizeof(buf.magic)))
+
+		if (btrfs_super_bytenr(&buf) != bytenr) {
+			fprintf(stderr, "    misplaced block thinks it's at %llu\n",
+				btrfs_super_bytenr(&buf));
+			continue;
+		}
+
+		if (strncmp((char *)(&buf.magic), BTRFS_MAGIC,
+			    sizeof(buf.magic))) {
+			fprintf(stderr, "    invalid magic\n");
 			continue;
+		}
 
 		if (i == 0)
 			memcpy(fsid, buf.fsid, sizeof(fsid));
-		else if (memcmp(fsid, buf.fsid, sizeof(fsid)))
+		else if (memcmp(fsid, buf.fsid, sizeof(fsid))) {
+			uuid_unparse(fsid, up_fsid);
+			uuid_unparse(buf.fsid, up_ofsid);
+			fprintf(stderr, "    wrong fsid %s expected %s \n", up_fsid, up_ofsid);
+			
 			continue;
+		}
+
+		if (btrfs_super_generation(&buf) < transid) {		
+			fprintf(stderr, "super #%d at bytenr %llu has older generation %llu than %llu, skipping\n",
+				i, bytenr, btrfs_super_generation(&buf), transid);
+			continue;
+		}
+
+		if (btrfs_super_generation(&buf) == transid) {		
+			fprintf(stderr, "super #%d at bytenr %llu has same generation %llu than %llu, skipping\n",
+				i, bytenr, btrfs_super_generation(&buf), transid);
 
-		if (btrfs_super_generation(&buf) > transid) {
-			memcpy(sb, &buf, sizeof(*sb));
-			transid = btrfs_super_generation(&buf);
+			if (memcmp(sb, &buf, sizeof(*sb))) {
+				fprintf(stderr, "   warning: super #%d at bytenr %llu has different contents!\n",
+				i, bytenr);
+			}
+			continue;
 		}
+
+		/* btrfs_super_generation(&buf) > transid */
+		fprintf(stderr, "super #%d at bytenr %llu has better generation %llu than %llu, using that\n",
+			i, bytenr, btrfs_super_generation(&buf), transid);
+
+		memcpy(sb, &buf, sizeof(*sb));
+		transid = btrfs_super_generation(&buf);
 	}
 
 	return transid > 0 ? 0 : -1;
@@ -930,7 +1101,12 @@ static int close_all_devices(struct btrfs_fs_info *fs_info)
 	struct list_head *next;
 	struct btrfs_device *device;
 
-	return 0;
+	if (!fs_info->emergency_root_tree) {
+		/* huh? there was a "return 0" sitting here. Yes we leaked fd's. 
+		   Leaving it on when not doing funky desperate things. 
+		*/
+		return 0;
+	}
 
 	list = &fs_info->fs_devices->devices;
 	list_for_each(next, list) {
diff --git a/disk-io.h b/disk-io.h
index 49e5692..0af98b4 100644
--- a/disk-io.h
+++ b/disk-io.h
@@ -64,6 +64,7 @@ int btrfs_buffer_uptodate(struct extent_buffer *buf, u64 parent_transid);
 int btrfs_set_buffer_uptodate(struct extent_buffer *buf);
 int wait_on_tree_block_writeback(struct btrfs_root *root,
 				 struct extent_buffer *buf);
+int write_all_supers(struct btrfs_root *root);
 u32 btrfs_csum_data(struct btrfs_root *root, char *data, u32 seed, size_t len);
 void btrfs_csum_final(u32 crc, char *result);
 

--=-TovPMUBbcwNB5a+bSJwV--

