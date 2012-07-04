Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from brockman.in8.de ([85.214.220.56]:36495 "EHLO mail.in8.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932341Ab2GDL0r (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 4 Jul 2012 07:26:47 -0400
Received: from [172.24.1.213] (unknown [192.166.201.94])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.in8.de (Postfix) with ESMTPSA id C74D96AC270
	for <linux-btrfs@vger.kernel.org>; Wed,  4 Jul 2012 13:26:46 +0200 (CEST)
Message-ID: <4FF42876.8010309@jan-o-sch.net>
Date: Wed, 04 Jul 2012 13:26:46 +0200
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: btrfs GPF in read_extent_buffer() while scrubbing with kernel
 3.4.2
References: <20120702230121.GD12755@sli.dy.fi> <4FF2EF68.6090401@jan-o-sch.net> <20120703135824.GA8908@sli.dy.fi> <4FF3032D.1010007@jan-o-sch.net> <20120703224756.GA21647@sli.dy.fi> <20120704001713.GA8986@sli.dy.fi>
In-Reply-To: <20120704001713.GA8986@sli.dy.fi>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04.07.2012 02:17, Sami Liedes wrote:
> On Wed, Jul 04, 2012 at 01:47:56AM +0300, Sami Liedes wrote:
>> I've seen this before: An overly long "Modules linked in:" line causes
>> a large gap in netconsole output.
> 
> I managed to capture the entire output using netconsole by modifying
> the kernel to not output the list of modules.

Okay, thanks for the output. Can you please apply the patch below and capture
especially the line printed before the "cut here" line?

Thanks!
-Jan

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index c9018a0..beabe99 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4519,7 +4519,14 @@ void read_extent_buffer(struct extent_buffer *eb, void *dstv,
        size_t start_offset = eb->start & ((u64)PAGE_CACHE_SIZE - 1);
        unsigned long i = (start_offset + start) >> PAGE_CACHE_SHIFT;
 
-       WARN_ON(start > eb->len);
+       if (start > eb->len) {
+               printk(KERN_ERR "btrfs: invalid parameters for read_extent_buffer: start (%lu) > eb->len (%lu). eb start is %llu, level %d, generation %llu, nritems %d. len param %lu. debug %llu/%llu/%llu/%llu\n",
+                       start, eb->len, eb->start, btrfs_header_level(eb),
+                       btrfs_header_generation(eb), btrfs_header_nritems(eb),
+                       len,
+                       eb->debug[0], eb->debug[1], eb->debug[2], eb->debug[3]);
+               WARN_ON(1);
+       }
        WARN_ON(start + len > eb->start + eb->len);
 
        offset = (start_offset + start) & ((unsigned long)PAGE_CACHE_SIZE - 1);
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index b516c3b..1bbf823 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -164,6 +164,8 @@ struct extent_buffer {
        wait_queue_head_t lock_wq;
        struct page *inline_pages[INLINE_EXTENT_BUFFER_PAGES];
        struct page **pages;
+
+       u64 debug[4];
 };
 
 static inline void extent_set_compress_type(unsigned long *bio_flags,
diff --git a/fs/btrfs/reada.c b/fs/btrfs/reada.c
index ac5d010..d9c1146 100644
--- a/fs/btrfs/reada.c
+++ b/fs/btrfs/reada.c
@@ -168,10 +168,15 @@ static int __readahead_hook(struct btrfs_root *root, struct extent_buffer *eb,
                struct btrfs_key key;
                struct btrfs_key next_key;
 
+               eb->debug[0] = 1;
+               eb->debug[1] = i;
+               eb->debug[2] = nritems;
+               eb->debug[3] = generation;
                btrfs_node_key_to_cpu(eb, &key, i);
-               if (i + 1 < nritems)
+               if (i + 1 < nritems) {
+                       eb->debug[0] = 2;
                        btrfs_node_key_to_cpu(eb, &next_key, i + 1);
-               else
+               } else
                        next_key = re->top;
                bytenr = btrfs_node_blockptr(eb, i);
                n_gen = btrfs_node_ptr_generation(eb, i);
