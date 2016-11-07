Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:39800 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751647AbcKGBUR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 6 Nov 2016 20:20:17 -0500
Date: Sun, 6 Nov 2016 17:20:09 -0800
From: Marc MERLIN <marc@merlins.org>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
Message-ID: <20161107012009.xng7hyhoqwqres3u@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4a5c36c5-3608-ef78-892c-6157bf2f34ae@cn.fujitsu.com>
 <87lgwwnnyf.fsf@notabene.neil.brown.name>
Subject: Re: clearing blocks wrongfully marked as bad if --update=no-bbl
 can't be used?
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 07, 2016 at 09:11:54AM +0800, Qu Wenruo wrote:
> > Well, turns out you were right. My array is 14TB and dd was only able to
> > copy 8.8TB out of it.
> > 
> > I wonder if it's a bug with bcache and source devices that are too big?
> 
> At least we know it's not a problem of btrfs-progs.
> 
> And for bcache/soft raid/encryption, unfortunately I'm not familiar with any
> of them.
> 
> I would recommend to report it to bcache/mdadm/encryption ML after locating
> the layer which returns EINVAL.

So, Neil Brown found the problem.

myth:/sys/block/md5/md# dd if=/dev/md5 of=/dev/null bs=1GiB skip=8190
dd: reading `/dev/md5': Invalid argument
2+0 records in
2+0 records out
2147483648 bytes (2.1 GB) copied, 37.0785 s, 57.9 MB/s
myth:/sys/block/md5/md# dd if=/dev/md5 of=/dev/null bs=1GiB skip=8190 count=3 iflag=direct
3+0 records in
3+0 records out


On Mon, Nov 07, 2016 at 11:16:56AM +1100, NeilBrown wrote:
> EINVAL from a read() system call is surprising in this context.....
> 
> do_generic_file_read can return it:
> 	if (unlikely(*ppos >= inode->i_sb->s_maxbytes))
> 		return -EINVAL;
> 
> s_maxbytes will be MAX_LFS_FILESIZE which, on a 32bit system, is
> 
> #define MAX_LFS_FILESIZE        (((loff_t)PAGE_SIZE << (BITS_PER_LONG-1))-1)
> 
> That is 2^(12+31) or 2^43 or 8TB.
> 
> Is this a 32bit system you are using?  Such systems can only support
> buffered IO up to 8TB.  If you use iflags=direct to avoid buffering, you
> should get access to the whole device.

I am indeed using a 32bit system, and now we know why the kernel can
mount and use my filesystem just fine while btrfs check repair fails to
deal with it.
The filesystem is more than 8TB on a 32bit kernel with 32bit userland.

Since iflag=direct fixes the issue with dd, it sounds like something
similar could be done for btrfs progs, to support filesystems bigger
than 8TB on 32bit systems.

However, could you confirm that filesystems more than 8TB are supported
by the kernel code itself on 32bit systems? (I think so, but just
wanting to make sure)

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
