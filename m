Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20859 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753425AbcFQGJP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 Jun 2016 02:09:15 -0400
Date: Thu, 16 Jun 2016 23:08:05 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: linux-btrfs@vger.kernel.org, Eryu Guan <guaneryu@gmail.com>,
        David Sterba <dsterba@suse.com>
Subject: Re: [PATCH] Btrfs: let super_stripesize match with sectorsize
Message-ID: <20160617060805.GA12750@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1465940023-27773-1-git-send-email-bo.li.liu@oracle.com>
 <2409903.XvMUHL7gZ9@localhost.localdomain>
 <20160616170141.GB27257@localhost.localdomain>
 <69818794.Hm6NXvuvrY@reserved-192-168-1-6.rchland.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <69818794.Hm6NXvuvrY@reserved-192-168-1-6.rchland.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 17, 2016 at 10:48:05AM +0530, Chandan Rajendra wrote:
> On Thursday, June 16, 2016 10:01:41 AM Liu Bo wrote:
> > On Thu, Jun 16, 2016 at 01:53:59PM +0530, Chandan Rajendra wrote:
> > > On Wednesday, June 15, 2016 05:09:55 PM Liu Bo wrote:
> > > > On Wed, Jun 15, 2016 at 03:50:17PM +0530, Chandan Rajendra wrote:
> > > > > On Wednesday, June 15, 2016 09:12:28 AM Chandan Rajendra wrote:
> > > > > > Hello Liu Bo,
> > > > > > 
> > > > > > We have to fix the following check in check_super() as well,
> > > > > > 
> > > > > >        if (btrfs_super_stripesize(sb) != 4096) {
> > > > > >        
> > > > > >                 error("invalid stripesize %u",
> > > > > >                 btrfs_super_stripesize(sb));
> > > > > >                 goto error_out;
> > > > > >         
> > > > > >         }
> > > > > > 
> > > > > > i.e. btrfs_super_stripesize(sb) must be equal to
> > > > > > btrfs_super_sectorsize(sb).
> > > > > > 
> > > > > > However in btrfs-progs (mkfs.c to be precise) since we had
> > > > > > stripesize
> > > > > > hardcoded to 4096, setting stripesize to the value of sectorsize in
> > > > > > mkfs.c will cause the following to occur when mkfs.btrfs is invoked
> > > > > > for
> > > > > > devices with existing Btrfs filesystem instances,
> > > > > > 
> > > > > > NOTE: Assume we have changed the stripesize validation in
> > > > > > btrfs-progs'
> > > > > > check_super() to,
> > > > > > 
> > > > > >         if (btrfs_super_stripesize(sb) !=
> > > > > >         btrfs_super_sectorsize(sb)) {
> > > > > >         
> > > > > >                 error("invalid stripesize %u",
> > > > > >                 btrfs_super_stripesize(sb));
> > > > > >                 goto error_out;
> > > > > >         
> > > > > >         }
> > > > > > 
> > > > > > main()
> > > > > > 
> > > > > >  for each device file passed as an argument,
> > > > > >  
> > > > > >    test_dev_for_mkfs()
> > > > > >    
> > > > > >      check_mounted
> > > > > >      
> > > > > >        check_mounted_where
> > > > > >        
> > > > > >          btrfs_scan_one_device
> > > > > >          
> > > > > >            btrfs_read_dev_super
> > > > > >            
> > > > > >              check_super() call will fail for existing filesystems
> > > > > >              which
> > > > > > 
> > > > > > have stripesize set to 4k. All existing filesystem instances will
> > > > > > fall
> > > > > > into
> > > > > > this category.
> > > > > > 
> > > > > > This error value is pushed up the call stack and this causes the
> > > > > > device
> > > > > > to
> > > > > > not get added to the fs_devices_mnt list in check_mounted_where().
> > > > > > Hence
> > > > > > we
> > > > > > would fail to correctly check the mount status of the multi-device
> > > > > > btrfs
> > > > > > filesystems.
> > > > > 
> > > > > We can end up in the following scenario,
> > > > > - /dev/loop0, /dev/loop1 and /dev/loop2 are mounted as a single
> > > > > 
> > > > >   filesystem. The filesystem was created by an older version of
> > > > >   mkfs.btrfs
> > > > >   which set stripesize to 4k.
> > > > > 
> > > > > - losetup -a
> > > > > 
> > > > >    /dev/loop0: [0030]:19477 (/root/disk-imgs/file-0.img)
> > > > >    /dev/loop1: [0030]:16577 (/root/disk-imgs/file-1.img)
> > > > >    /dev/loop2: [64770]:3423229 (/root/disk-imgs/file-2.img)
> > > > > 
> > > > > - /etc/mtab lists only /dev/loop0
> > > > > - "losetup /dev/loop4 /root/disk-imgs/file-1.img"
> > > > > 
> > > > >    The new mkfs.btrfs invoked as 'mkfs.btrfs -f /dev/loop4' succeeds
> > > > >    even
> > > > >    though /dev/loop1 has already been mounted and has
> > > > >    /root/disk-imgs/file-1.img as its backing file.
> > > > > 
> > > > > So IMHO the only solution is to have the stripesize check in
> > > > > check_super()
> > > > > to allow both '4k' and 'sectorsize' as valid values i.e.
> > > > > 
> > > > >         if ((btrfs_super_stripesize(sb) != 4096)
> > > > > 	    
> > > > > 	    && (btrfs_super_stripesize(sb) != btrfs_super_sectorsize(sb))) {
> > > > > 	    
> > > > >                 error("invalid stripesize %u",
> > > > >                 btrfs_super_stripesize(sb));
> > > > >                 goto error_out;
> > > > >         
> > > > >         }
> > > > 
> > > > That's a good one.
> > > > 
> > > > But if we go back to the original point, in the kernel side,
> > > > 1. in open_ctree(), root->stripesize = btrfs_super_stripesize();
> > > > 
> > > > 2. in find_free_extent(),
> > > > 
> > > > 	...
> > > > 	search_start = ALIGN(offset, root->stripesize);
> > > > 	...
> > > > 
> > > > 3. in btrfs_alloc_tree_block(),
> > > > 
> > > > 	...
> > > > 	ret = btrfs_reserve_extent(..., &ins, ...);
> > > > 	...
> > > > 	buf = btrfs_init_new_buffer(trans, root, ins.objectid, level);
> > > > 
> > > > 4. in btrfs_init_new_buffer(),
> > > > 
> > > > 	...
> > > > 	buf = btrfs_find_create_tree_block(root, bytenr);
> > > > 	...
> > > > 
> > > > Because 'num_bytes' we pass to find_free_extent() is aligned to
> > > > sectorsize, the free space we can find is aligned to sectorsize,
> > > > which means 'offset' in '1. find_free_extent()' is aligned to
> > > > sectorsize.
> > > > 
> > > > If our stripesize is larger than sectorsize, say 4 * sectorsize,
> > > > for data allocation it's fine while for metadata block allocations it's
> > > > not.  It is possible that when we allocate a new metadata block, we can
> > > > end up with an existing eb returned by '4. in btrfs_init_new_buffer()'.
> > > 
> > > Liu, I am sorry ... I am unable to visualize a scenario where the above
> > > described scenario could happen. Can you please provide an example?
> > 
> > Sure, imagine that sectorsize is 4k and stripesize is 16k,
> > and a tree root's eb has eb->start = 12599296 (12582912 + 16384, a typical
> > bytenr in btrfs) which is aligned to 4k, and when CoW happens on another
> > eb,
> > 
> > __btrfs_cow_block()
> >   ->btrfs_alloc_tree_block()
> >     ->btrfs_reserve_extent()
> >       ->find_free_extent()
> >     ->btrfs_init_new_buffer()
> > 
> > btrfs_reserve_extent() can return 12599296 for the new eb even if what
> > it've found is (12582912 + 4096), but
> >  after 'search_start = ALIGN(offset, root->stripesize)', it gets to
> > 12599296.
> > 
> > In btrfs_init_new_buffer, we search eb tree by bytenr=12599296 and
> > get tree root's eb, the following btrfs_tree_lock will scream.
> > 
> > The example is taken from
> > btrfs-progs/tests/fuzz-tests/images/superblock-stripsize-bogus.raw.xz
> > 
> 
> ah, this is indeed possible when nodesize is same as sectorsize
> i.e. 4k. Thanks for the explaination Liubo.

I don't think nodesize has to be same as sectorsize to make it possible.

> 
> The new validation patches that I have posted
> (http://news.gmane.org/find-root.php?message_id=1466095078%2d25726%2d1%2dgit%2dsend%2demail%2dchandan%40linux.vnet.ibm.com
> and
> http://news.gmane.org/find-root.php?message_id=1466095109%2d26044%2d1%2dgit%2dsend%2demail%2dchandan%40linux.vnet.ibm.com)
> restrict the stripesize to be either sectorsize or 4096. So I think these
> restrictions are good enough to make sure we don't get into the situation
> explained by you.

It's a workaround anyway, I'd rather fix the kernel to not use
stripesize and we can remove all checks against super_stripesize.

The code has evolved a lot to have free space align well to sectorsize,
so stripesize is not as necessary as when it's introduced firstly.

Thanks,

-liubo
