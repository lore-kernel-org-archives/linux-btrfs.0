From: Chris Mason <chris.mason@oracle.com>
Subject: Re: kernel BUG at
 /build/buildd/linux-3.2.0/fs/btrfs/extent-tree.c:4816!
Date: Tue, 29 Nov 2011 13:12:14 -0500
Message-ID: <20111129181214.GO24338@shiny>
References: <4ED437CE.3060909@kittilsen.org>
 <20111129151256.GJ24338@shiny>
 <4ED4FA72.5050804@kittilsen.org>
 <20111129154913.GN24338@shiny>
 <20111129164746.GN12759@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Karl Mardoff Kittilsen <karl@kittilsen.org>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111129164746.GN12759@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 29, 2011 at 05:47:46PM +0100, David Sterba wrote:
> On Tue, Nov 29, 2011 at 10:49:13AM -0500, Chris Mason wrote:
> > The good news about this one is that it is very clear cut.  The hard
> > part is figuring out where these bogus link counts came from.
> > 
> > I'd suggest that you spend some time running memtest on the machine.
> 
> Just to add some evidence from the log:
> 
> Nov 28 00:11:14 karl-workstation kernel: [212918.235050] kernel BUG at
> /home/apw/COD/linux/fs/btrfs/extent-tree.c:4775!
> Nov 28 00:11:14 karl-workstation kernel: [212918.235118] RAX:
> 00000000ea000001 RBX: ffff880412c3ab40 RCX: ffff880380173900
> ^^^^^^^^^^^^^^^^
> 
> 4765                         ret = btrfs_search_slot(trans, extent_root,
> 4766                                                 &key, path, -1, 1);
> 4767                         if (ret) {
> 4768                                 printk(KERN_ERR "umm, got %d back from search"
> 4769                                        ", was looking for %llu\n", ret,
> 4770                                        (unsigned long long)bytenr);
> 4771                                 if (ret > 0)
> 4772                                         btrfs_print_leaf(extent_root,
> 4773                                                          path->nodes[0]);
> 4774                         }
> 4775                         BUG_ON(ret);
> 
> the ret value comes from btrfs_search_slot, returning " < 0" or 1, but
> RAX has some extra bits set, this could really be a RAM failure.
> 
> 
> david

Interesting, look at this:

> karl@karl-precise:~/git/btrfs-progs$ sudo ./btrfsck /dev/md0
> ref mismatch on [2176962560 8192] extent item 480, found 1
> Incorrect local backref count on 2176970752 root 5 owner 2101705
> offset 368640 found 1 wanted 3925868545
> backpointer mismatch on [2176970752 4096]

3925868545 == EA000001

Are you sure this is the BUG_ON he was triggering?

-chris

