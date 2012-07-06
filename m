Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fredda.webgods.de ([192.166.196.83]:60002 "EHLO
	fredda.webgods.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933199Ab2GFLKa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 6 Jul 2012 07:10:30 -0400
Message-ID: <4FF6C12A.10305@jan-o-sch.net>
Date: Fri, 06 Jul 2012 12:42:50 +0200
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: btrfs GPF in read_extent_buffer() while scrubbing with kernel
 3.4.2
References: <4FF2EF68.6090401@jan-o-sch.net> <20120703135824.GA8908@sli.dy.fi> <4FF3032D.1010007@jan-o-sch.net> <20120703224756.GA21647@sli.dy.fi> <20120704001713.GA8986@sli.dy.fi> <4FF42876.8010309@jan-o-sch.net> <20120704160340.GA9770@sli.dy.fi> <4FF47168.9010405@jan-o-sch.net> <20120704202452.GA8996@sli.dy.fi> <4FF5998D.8020205@jan-o-sch.net> <20120705234739.GA9736@sli.dy.fi>
In-Reply-To: <20120705234739.GA9736@sli.dy.fi>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06.07.2012 01:47, Sami Liedes wrote:
> On Thu, Jul 05, 2012 at 03:41:33PM +0200, Jan Schmidt wrote:
>> I'd like to see if you corrupted your trees on disk in a really strange
>> manner (with matching checksums?), or if data comes from the disk intact
>> and becomes damaged thereafter.
>>
>> Could you store the output of
>> 	btrfs-debug-tree /dev/[whatever]
>> before try number 5 and afterwards? It will be quite a lot if you've got
>> a lot of files in there. Don't send it anywhere right now, just store it
>> away if possible.
> 
> Ok, I have it stored. I mounted the fs read-only to do that just to be
> safe, because when I did it on a live fs I got some (~15) "parent
> transid verify failed" messages.

You can drop that, your data on disk is fine. Furthermore, I'm getting the
feeling that this isn't really related to readahead, but we will find out
later if that's true.

>> Can you double check that there's nothing about corrected errors in your
>> logs? Scrub will correct errors along the way and log that. So maybe
>> we've only a few tries left to find the root cause.
> 
> Nope, definitely nothing there. A few "unlinked orphans" messages at
> mount time, but that's all. I'm sure I would have captured any further
> messages on my netconsole. Also nothing in any earlier logs that I can
> see.

Okay. At least that fits with the "everything is okay on disk" statement.

> Try 6, with your new patch - as a new thing, got checksum errors,
> including one very slightly before the crash and with the same "eb
> start" as in the "invalid parameters" message. Crashed in a couple of
> minutes.
> 
> Now that I look at the the log below it actually has two crashes in
> it, one of btrfs-endio-met pid 1212 and another one of btrfs-endio-met
> pid some 72 seconds later. I didn't notice that until after the fact.
> 
> dm-6 (the device with checksum failures) is on a disk on which I don't
> have anything else besides this partition, so I suppose it could be
> corrupting data without me having noticed. I know it used to work at
> one time, but that doesn't mean too much. Anyway, I'm sure I haven't
> seen any "checksum verify failed" messages until now. None in the logs
> either.
> 
> Ah, one thing I have forgotten to mention. I think I've been using
> this filesystem for maybe a month now. It started as a single-device
> filesystem, but I did restriping to raid-1 on June 12. dm-5 is the
> original device, while dm-6 (the one with the checksum failures in try
> 6) is the added one. I still have logs of the restriping and
> everything after that; grep reveals no unusual lines containing
> "btrfs" in all the logs since then, apart from the crashes. Besides
> the oopses and lines that mention btrfs just because of the kernel
> version 3.4.4+btrfsdebug, this is a summary of all the lines that
> mention btrfs:
> 
>   btrfs: disk space caching is enabled
>   btrfs flagging fs with big metadata feature
>   btrfs: new size for /dev/mapper/rootvg-scratch_crypt is 751617179648
>      * this device is not on the filesystem with problems - although I
>        haven't tried scrubbing this filesystem
>   btrfs: unlinked 104 orphans (10 times with 4 different numbers)
> 
> And during restriping
> 
>   btrfs: found 10008 extents (and similar)
>   btrfs: relocating block group 1019010351104 flags 1 (and similar)
> 
> And two different warnings in the last few days, but I think this is
> only because the debug patches changed the code:
> 
>   WARNING: at fs/btrfs/extent_io.c:4522 read_extent_buffer+0xe6/0x110 [btrfs]()
>   WARNING: at fs/btrfs/extent_io.c:4528 read_extent_buffer+0x167/0x1a0 [btrfs]()
> 
> Another thing that comes to mind that I might well be the only one
> that uses btrfs with raid-1 on two separate dm-crypted devices
> (contrary to the way suggested on Btrfs FAQ - in my experience that
> can actually speed up things, especially on computers without hardware
> crypto, because the kernel has only one kcryptd thread per dm-crypt
> device and therefore only can use a single core per device. Plus I get
> the benefits of btrfs "smart raid".).
> 
> So, try 6. The three first lines are from me starting btrfs-debug-tree
> again just as a quick way to verify that my netconsole setup was
> working. The first checksum failure came pretty much instantly after
> starting scrub:
> 
> ------------------------------------------------------------
> [  168.207151] device fsid f26f08b1-89e6-4f2d-b7f9-857010dd2517 devid 1 transid 151087 /dev/dm-5
> [  168.208541] device fsid f26f08b1-89e6-4f2d-b7f9-857010dd2517 devid 2 transid 151087 /dev/dm-6
> [  168.284668] device fsid ad75beab-b52b-4f63-9d14-956cc8e95fc7 devid 1 transid 5001 /dev/dm-9
> [  188.507789] btrfs: dm-6 checksum verify failed on 2237998628864 wanted C3D64F found DCBF0869 level 88
> [  188.507852] btrfs: node seems invalid now. checksum ok = 1
> [  262.706585] btrfs: dm-6 checksum verify failed on 2246859587584 wanted 3D013CF8 found AD06874A level 77
> [  262.706650] btrfs: node seems invalid now. checksum ok = 1

Here it's getting weird now. The checksums were fine when read from disk, which
was checked ...

> [  262.706822] btrfs: invalid parameters for read_extent_buffer: start (32771) > eb->len (32768). eb start is 2246859587584, level 77, generation 93067543380099401, nritems 21766576. len param 17. debug 2/989/21766576/93067543380099401
> [  262.706929] ------------[ cut here ]------------
> [  262.706992] WARNING: at fs/btrfs/extent_io.c:4529 read_extent_buffer+0x167/0x1a0 [btrfs]()
> [  262.707051] Hardware name: System Product Name
> [  262.707078] Modules linked in: <omitted> [last unloaded: netconsole]
> [  262.707126] Pid: 1212, comm: btrfs-endio-met Tainted: G        W    3.4.4+btrfsdebug #1
> [  262.707169] Call Trace:
> [  262.707193]  [<ffffffff8103905a>] warn_slowpath_common+0x7a/0xb0
> [  262.707229]  [<ffffffff810390a5>] warn_slowpath_null+0x15/0x20
> [  262.707282]  [<ffffffffa01d8fc7>] read_extent_buffer+0x167/0x1a0 [btrfs]
> [  262.707339]  [<ffffffffa01d01fd>] btrfs_node_key+0x1d/0x20 [btrfs]
> [  262.707391]  [<ffffffffa02067af>] __readahead_hook+0x44f/0x500 [btrfs]
> [  262.707444]  [<ffffffffa0206b78>] btree_readahead_hook+0x18/0x40 [btrfs]
> [  262.707497]  [<ffffffffa01ac9d1>] btree_readpage_end_io_hook+0x111/0x270 [btrfs]
                                       ^^^^^^^^^^^^^^^^^^^^^^^^^^
... down here in the stack. The warning is printed from two levels above,
__readahead_hook.

Either I'm absolutely blind and there's code along the (rather short) road
between those two that might do this I haven't seen. Or someone else messes
with our extent buffers or the underlying pages. What really confuses me is
that it happens so reproducibly.

I've no good idea at the moment how to go on. It might help to get a feeling if
it's shifting around at least a little bit or really constant in the timing of
occurrence. So can you please apply the next patch on top of the other two and
give it some more failure tries? The "checksum mismatch [1234]" line will be of
most interest. I'm also curious what the additional debug variables will say in
the extended version of the very first printk. You can leave out the stack
traces if you like, they won't matter much anyway.

Thanks,
-Jan

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 34122c2..df0b347 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -550,6 +550,7 @@ static noinline int check_node(struct btrfs_root *root,
        u32 nritems = btrfs_header_nritems(node);
        u64 generation;
 
+       node->debug[4] = 0xb77f50b77f5;
        if (nritems == 0)
                return 0;
 
@@ -575,6 +576,10 @@ static noinline int check_node(struct btrfs_root *root,
                        return -EIO;
                }
        }
+       node->debug[5] = node->start;
+       node->debug[6] = btrfs_header_level(node);
+       node->debug[6] |= btrfs_header_level(root->node) << 16;
+       node->debug[7] = 0xb22f50b22f5;
 
        return 0;
 }
@@ -686,10 +691,17 @@ static int btree_readpage_end_io_hook(struct page *page, u64 start, u64 end,
                ret = -EIO;
        }
 
+       if (btrfs_csum_tree_block(root, eb))
+               printk(KERN_ERR "btrfs: checksum mismatch 1 on %llu\n",
+                       eb->start);
+
        if (!ret)
                set_extent_buffer_uptodate(eb);
 err:
        if (test_bit(EXTENT_BUFFER_READAHEAD, &eb->bflags)) {
+               if (btrfs_csum_tree_block(root, eb))
+                       printk(KERN_ERR "btrfs: checksum mismatch 2 on %llu\n",
+                               eb->start);
                clear_bit(EXTENT_BUFFER_READAHEAD, &eb->bflags);
                btree_readahead_hook(root, eb, eb->start, ret);
        }
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 099ce6e..7452ecb 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4521,11 +4521,12 @@ void read_extent_buffer(struct extent_buffer *eb, void *dstv,
        unsigned long i = (start_offset + start) >> PAGE_CACHE_SHIFT;
 
        if (start > eb->len) {
-               printk(KERN_ERR "btrfs: invalid parameters for read_extent_buffer: start (%lu) > eb->len (%lu). eb start is %llu, level %d, generation %llu, nritems %d. len param %lu. debug %llu/%llu/%llu/%llu\n",
+               printk(KERN_ERR "btrfs: invalid parameters for read_extent_buffer: start (%lu) > eb->len (%lu). eb start is %llu, level %d, generation %llu, nritems %d. len param %lu. debug %llu/%llu/%llu/%llu/%#llx/%llu/%#llx/%#llx\n",
                        start, eb->len, eb->start, btrfs_header_level(eb),
                        btrfs_header_generation(eb), btrfs_header_nritems(eb),
                        len,
-                       eb->debug[0], eb->debug[1], eb->debug[2], eb->debug[3]);
+                       eb->debug[0], eb->debug[1], eb->debug[2], eb->debug[3],
+                       eb->debug[4], eb->debug[5], eb->debug[6], eb->debug[7]);
                WARN_ON(1);
        }
        WARN_ON(start + len > eb->start + eb->len);
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 1bbf823..51c42f1 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -165,7 +165,7 @@ struct extent_buffer {
        struct page *inline_pages[INLINE_EXTENT_BUFFER_PAGES];
        struct page **pages;
 
-       u64 debug[4];
+       u64 debug[8];
 };
 
 static inline void extent_set_compress_type(unsigned long *bio_flags,
diff --git a/fs/btrfs/reada.c b/fs/btrfs/reada.c
index b659c8d..ea81bd4 100644
--- a/fs/btrfs/reada.c
+++ b/fs/btrfs/reada.c
@@ -130,6 +130,10 @@ static int __readahead_hook(struct btrfs_root *root, struct extent_buffer *eb,
                kref_get(&re->refcnt);
        spin_unlock(&fs_info->reada_lock);
 
+       if (!err && btrfs_csum_tree_block(root, eb))
+               printk(KERN_ERR "btrfs: checksum mismatch 4 on %llu\n",
+                       eb->start);
+
        if (!re)
                return -1;
 
@@ -248,6 +252,9 @@ int btree_readahead_hook(struct btrfs_root *root, struct extent_buffer *eb,
 {
        int ret;
 
+       if (!err && btrfs_csum_tree_block(root, eb))
+               printk(KERN_ERR "btrfs: checksum mismatch 3 on %llu\n",
+                       eb->start);
        ret = __readahead_hook(root, eb, start, err);
 
        reada_start_machine(root->fs_info);
