Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from brockman.in8.de ([85.214.220.56]:52875 "EHLO mail.in8.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932367Ab2GENlf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 5 Jul 2012 09:41:35 -0400
Received: from [192.168.178.40] (p5DC110AE.dip.t-dialin.net [93.193.16.174])
	(using TLSv1 with cipher AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.in8.de (Postfix) with ESMTPSA id 9B7A86AC26F
	for <linux-btrfs@vger.kernel.org>; Thu,  5 Jul 2012 15:41:33 +0200 (CEST)
Message-ID: <4FF5998D.8020205@jan-o-sch.net>
Date: Thu, 05 Jul 2012 15:41:33 +0200
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: btrfs GPF in read_extent_buffer() while scrubbing with kernel
 3.4.2
References: <20120702230121.GD12755@sli.dy.fi> <4FF2EF68.6090401@jan-o-sch.net> <20120703135824.GA8908@sli.dy.fi> <4FF3032D.1010007@jan-o-sch.net> <20120703224756.GA21647@sli.dy.fi> <20120704001713.GA8986@sli.dy.fi> <4FF42876.8010309@jan-o-sch.net> <20120704160340.GA9770@sli.dy.fi> <4FF47168.9010405@jan-o-sch.net> <20120704202452.GA8996@sli.dy.fi>
In-Reply-To: <20120704202452.GA8996@sli.dy.fi>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 04.07.2012 22:24, Sami Liedes wrote:
> On Wed, Jul 04, 2012 at 06:38:00PM +0200, Jan Schmidt wrote:
>>> [  200.980496] btrfs: invalid parameters for read_extent_buffer: start (32771) > eb->len (32768). eb start is 2243489562624, level 26, generation 3144240307695375391, nritems 620178657. len param 17. debug 2/989/620178657/3144240307695375391
> 
> Let's call this try 1. I ran it three more times, so below we have
> tries 2, 3 and 4.
> 
>> Wow, that's strange. Can you repeat your test once or twice and paste that line,
>> please? I'd like to get a feeling if the values are completely random.
> 
> Curiously, it clearly takes longer for it to crash after starting the
> scrub each time I run it. Also on try 4 I got an entirely different
> crash (backtrace below). Now it scrubs maybe the first 200G or so of
> both devices of the (raid-1) 2.2T filesystem before it crashes.

Can you double check that there's nothing about corrected errors in your
logs? Scrub will correct errors along the way and log that. So maybe
we've only a few tries left to find the root cause.

> start and eb->len seem to be the same (32771 and 32768) every time.

That's the tree block size in your setup.

> eb start varies, but there's some pattern if you view them in hex:
> 
>   Try 1  20a5a660000
>   Try 2  20bb0018000
>   Try 3  20a8bc28000
>   Try 4  (no output, different crash)

I fail to identify a real pattern there.

> The rest of the values seem to me to be completely different every time.

Which is itself interesting.

> Try 4:

That one is not that much different. We read some garbage from a tree
block and started the next read ahead cycle for the alledged children.
That way we came to a logical address that's out of bounds, instead of a
logical address with even more garbage.

I'd like to see if you corrupted your trees on disk in a really strange
manner (with matching checksums?), or if data comes from the disk intact
and becomes damaged thereafter.

Could you store the output of
	btrfs-debug-tree /dev/[whatever]
before try number 5 and afterwards? It will be quite a lot if you've got
a lot of files in there. Don't send it anywhere right now, just store it
away if possible.

What I'd like to get in the next reply is the output of the attached
patch, a single pass should do this time.

NB: As we've already check_leaf doing exta leaf checks after reading
them, we should probably add something like check_node as a general
manner to make btrfs more robust.

Thank you,
-Jan

---
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index a7ffc88..34122c2 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -316,6 +316,11 @@ static int csum_tree_block(struct btrfs_root *root, struct extent_buffer *buf,
        return 0;
 }

+int btrfs_csum_tree_block(struct btrfs_root *root, struct extent_buffer *buf)
+{
+       return csum_tree_block(root, buf, 1);
+}
+
 /*
  * we can't consider a given block up to date unless the transid of the
  * block matches the transid in the parent node's pointer.  This is how we
@@ -471,6 +476,12 @@ static int check_tree_block_fsid(struct btrfs_root *root,
               (unsigned long long)btrfs_header_bytenr(eb),     \
               (unsigned long long)root->objectid, slot)

+#define CORRUPT_NODE(root, node, reason, ...)                  \
+       printk(KERN_CRIT "btrfs: corrupt node block=%llu,"      \
+              "root=%llu: " reason,                            \
+              (unsigned long long)btrfs_header_bytenr(node),   \
+              (unsigned long long)root->objectid, ##__VA_ARGS__)
+
 static noinline int check_leaf(struct btrfs_root *root,
                               struct extent_buffer *leaf)
 {
@@ -532,6 +543,42 @@ static noinline int check_leaf(struct btrfs_root *root,
        return 0;
 }

+static noinline int check_node(struct btrfs_root *root,
+                              struct extent_buffer *node)
+{
+       int i;
+       u32 nritems = btrfs_header_nritems(node);
+       u64 generation;
+
+       if (nritems == 0)
+               return 0;
+
+       if (nritems > BTRFS_NODEPTRS_PER_BLOCK(root)) {
+               CORRUPT_NODE(root, node, "nritems (%lu) too large (%lu)\n",
+                            (unsigned long)nritems,
+                            BTRFS_NODEPTRS_PER_BLOCK(root));
+               return -EIO;
+       }
+
+       if (node->len > root->nodesize) {
+               CORRUPT_NODE(root, node, "length (%lu) too large (%lu)\n",
+                            node->len, (unsigned long)root->nodesize);
+               return -EIO;
+       }
+
+       generation = btrfs_super_generation(root->fs_info->super_copy);
+       for (i = 0; i < nritems; i++) {
+               if (btrfs_node_ptr_generation(node, i) > generation) {
+                       CORRUPT_NODE(root, node, "generation (%llu) too new in slot %d (maximum expected %llu)\n",
+                                    btrfs_node_ptr_generation(node, i), i,
+                                    generation);
+                       return -EIO;
+               }
+       }
+
+       return 0;
+}
+
 struct extent_buffer *find_eb_for_page(struct extent_io_tree *tree,
                                       struct page *page, int max_walk)
 {
@@ -634,6 +681,10 @@ static int btree_readpage_end_io_hook(struct page *page, u64 start, u64 end,
                set_bit(EXTENT_BUFFER_CORRUPT, &eb->bflags);
                ret = -EIO;
        }
+       if (found_level != 0 && check_node(root, eb)) {
+               set_bit(EXTENT_BUFFER_CORRUPT, &eb->bflags);
+               ret = -EIO;
+       }

        if (!ret)
                set_extent_buffer_uptodate(eb);
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index beabe99..099ce6e 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4507,6 +4507,7 @@ unlock_exit:
        return ret;
 }

+extern int btrfs_csum_tree_block(struct btrfs_root *root, struct extent_buffer *buf);
 void read_extent_buffer(struct extent_buffer *eb, void *dstv,
                        unsigned long start,
                        unsigned long len)
diff --git a/fs/btrfs/reada.c b/fs/btrfs/reada.c
index d9c1146..b659c8d 100644
--- a/fs/btrfs/reada.c
+++ b/fs/btrfs/reada.c
@@ -103,6 +103,7 @@ static void __reada_start_machine(struct btrfs_fs_info *fs_info);
 static int reada_add_block(struct reada_control *rc, u64 logical,
                           struct btrfs_key *top, int level, u64 generation);

+extern int btrfs_csum_tree_block(struct btrfs_root *root, struct extent_buffer *buf);
 /* recurses */
 /* in case of err, eb might be NULL */
 static int __readahead_hook(struct btrfs_root *root, struct extent_buffer *eb,
@@ -144,6 +145,10 @@ static int __readahead_hook(struct btrfs_root *root, struct extent_buffer *eb,

        if (err == 0) {
                nritems = level ? btrfs_header_nritems(eb) : 0;
+               if (level > BTRFS_MAX_LEVEL ||
+                   nritems > BTRFS_NODEPTRS_PER_BLOCK(root))
+                       printk(KERN_ERR "btrfs: node seems invalid now. checksum ok = %d\n",
+                               btrfs_csum_tree_block(root, eb));
                generation = btrfs_header_generation(eb);
                /*
                 * FIXME: currently we just set nritems to 0 if this is a leaf,
