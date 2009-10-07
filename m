From: Diego Calleja <diegocg@gmail.com>
Subject: Re: Warning and BUG using btrfs-vol -b
Date: Wed, 7 Oct 2009 23:27:56 +0200
Message-ID: <200910072327.56700.diegocg@gmail.com>
References: <200910062048.32381.diegocg@gmail.com> <200910072110.28958.diegocg@gmail.com> <20091007194529.GN3757@think>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Cc: "linux-btrfs" <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20091007194529.GN3757@think>
List-ID: <linux-btrfs.vger.kernel.org>

By the way, i think it'd be useful if debug-tree would tell which policy
the fs is applying to each chunk. Something like this:

        item 4 key (FIRST_CHUNK_TREE CHUNK_ITEM 8379826176) itemoff 3495 itemsize 112
                chunk length 319881216 owner 2 type 17 (data on RAID1) num_stripes 2
                        stripe 0 devid 2 offset 2265382912
                        stripe 1 devid 1 offset 989003776


Index: btrfs-progs-unstable/print-tree.c
===================================================================
--- btrfs-progs-unstable.orig/print-tree.c	2009-10-07 16:44:53.013210615 +0200
+++ btrfs-progs-unstable/print-tree.c	2009-10-07 21:37:46.162546261 +0200
@@ -79,15 +79,37 @@
 	return 0;
 }
 
+static void print_chunk_type(u64 chunk_flags)
+{
+	printf(" type %llu (", chunk_flags);
+
+	if (chunk_flags & BTRFS_BLOCK_GROUP_DATA)
+		printf("data");
+	if (chunk_flags & BTRFS_BLOCK_GROUP_METADATA)
+		printf("metadata");
+	if (chunk_flags & BTRFS_BLOCK_GROUP_SYSTEM)
+		printf("system??");
+	if (chunk_flags & BTRFS_BLOCK_GROUP_DUP)
+		printf("dup??");
+	if (chunk_flags & BTRFS_BLOCK_GROUP_RAID0)
+		printf(" on RAID0");
+	if (chunk_flags & BTRFS_BLOCK_GROUP_RAID1)
+		printf(" on RAID1");
+	if (chunk_flags & BTRFS_BLOCK_GROUP_RAID10)
+		printf(" on RAID10");
+	printf(") ");
+}
+
 static void print_chunk(struct extent_buffer *eb, struct btrfs_chunk *chunk)
 {
 	int num_stripes = btrfs_chunk_num_stripes(eb, chunk);
 	int i;
-	printf("\t\tchunk length %llu owner %llu type %llu num_stripes %d\n",
+	printf("\t\tchunk length %llu owner %llu",
 	       (unsigned long long)btrfs_chunk_length(eb, chunk),
-	       (unsigned long long)btrfs_chunk_owner(eb, chunk),
-	       (unsigned long long)btrfs_chunk_type(eb, chunk),
-	       num_stripes);
+	       (unsigned long long)btrfs_chunk_owner(eb, chunk));
+	print_chunk_type((unsigned long long)btrfs_chunk_type(eb, chunk));
+	printf("num_stripes %d\n", num_stripes);
+
 	for (i = 0 ; i < num_stripes ; i++) {
 		printf("\t\t\tstripe %d devid %llu offset %llu\n", i,
 		      (unsigned long long)btrfs_stripe_devid_nr(eb, chunk, i),
