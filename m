From: David Sterba <dave@jikos.cz>
Subject: Re: kernel BUG at /build/buildd/linux-3.2.0/fs/btrfs/extent-tree.c:4816!
Date: Thu, 15 Dec 2011 01:01:10 +0100
Message-ID: <20111215000110.GC7322@twin.jikos.cz>
References: <4ED437CE.3060909@kittilsen.org> <20111129151256.GJ24338@shiny> <4ED4FA72.5050804@kittilsen.org> <20111129154913.GN24338@shiny> <20111129164746.GN12759@twin.jikos.cz> <20111129181214.GO24338@shiny>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Chris Mason <chris.mason@oracle.com>,
	Karl Mardoff Kittilsen <karl@kittilsen.org>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111129181214.GO24338@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 29, 2011 at 01:12:14PM -0500, Chris Mason wrote:
> > Nov 28 00:11:14 karl-workstation kernel: [212918.235050] kernel BUG at
> > /home/apw/COD/linux/fs/btrfs/extent-tree.c:4775!
> > Nov 28 00:11:14 karl-workstation kernel: [212918.235118] RAX:
> > 00000000ea000001 RBX: ffff880412c3ab40 RCX: ffff880380173900
> > ^^^^^^^^^^^^^^^^
> > 
> > 4765                         ret = btrfs_search_slot(trans, extent_root,
> > 4766                                                 &key, path, -1, 1);
> > 4767                         if (ret) {
> > 4768                                 printk(KERN_ERR "umm, got %d back from search"
> > 4769                                        ", was looking for %llu\n", ret,
> > 4770                                        (unsigned long long)bytenr);
> > 4771                                 if (ret > 0)
> > 4772                                         btrfs_print_leaf(extent_root,
> > 4773                                                          path->nodes[0]);
> > 4774                         }
> > 4775                         BUG_ON(ret);
> > 
> > the ret value comes from btrfs_search_slot, returning " < 0" or 1, but
> > RAX has some extra bits set, this could really be a RAM failure.
> 
> Interesting, look at this:
> 
> > karl@karl-precise:~/git/btrfs-progs$ sudo ./btrfsck /dev/md0
> > ref mismatch on [2176962560 8192] extent item 480, found 1
> > Incorrect local backref count on 2176970752 root 5 owner 2101705
> > offset 368640 found 1 wanted 3925868545
> > backpointer mismatch on [2176970752 4096]
> 
> 3925868545 == EA000001

I applied usual first analysis steps (source line, registers, call
chain), search slot could return 1 and taking a memory failure into
account looks possible, though bit count of 'EA' is 5, seems too high.

> Are you sure this is the BUG_ON he was triggering?

This was referring to the second BUG_ON in the logs. I checked the first
BUG_ON again and see:

kernel: [  100.963478] kernel BUG at 
/build/buildd/linux-3.2.0/fs/btrfs/extent-tree.c:4816!

RAX: 00000000ea000001

4815                 if (iref) {
4816                         BUG_ON(!found_extent);
4817                 } else {
4818                         btrfs_set_extent_refs(leaf, ei, refs);
4819                         btrfs_mark_buffer_dirty(leaf);
4820                 }

found_extent is int and modified at

4686         int found_extent = 0;

and

4712                         if (key.type == BTRFS_EXTENT_ITEM_KEY &&
4713                             key.offset == num_bytes) {
4714                                 found_extent = 1;
4715                                 break;
4716                         }


This looks like a crappy memory as well.

> > offset 368640 found 1 wanted 3925868545
> 3925868545 == EA000001

"found 1 wanted 1"


david
