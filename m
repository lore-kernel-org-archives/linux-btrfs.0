Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:60664 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751649AbeBUSUZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Feb 2018 13:20:25 -0500
Date: Wed, 21 Feb 2018 10:14:13 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Nikolay Borisov <nborisov@suse.com>
Cc: fdmanana@gmail.com, linux-btrfs <linux-btrfs@vger.kernel.org>,
        Josef Bacik <josef@toxicpanda.com>
Subject: Re: [PATCH] btrfs: Fix locking during DIO read
Message-ID: <20180221181412.GA9910@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1519213303-2802-1-git-send-email-nborisov@suse.com>
 <CAL3q7H4aiNyzgtDoziTXYkwuSggUAF+b9uLTWcm15GQSigp1_w@mail.gmail.com>
 <de457af6-6a9c-43f4-b9c6-429b69deec77@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <de457af6-6a9c-43f4-b9c6-429b69deec77@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 21, 2018 at 04:15:38PM +0200, Nikolay Borisov wrote:
> 
> 
> On 21.02.2018 15:51, Filipe Manana wrote:
> > On Wed, Feb 21, 2018 at 11:41 AM, Nikolay Borisov <nborisov@suse.com> wrote:
> >> Currently the DIO read cases uses a botched idea from ext4 to ensure
> >> that DIO reads don't race with truncate. The idea is that if we have a
> >> pending truncate we set BTRFS_INODE_READDIO_NEED_LOCK which in turn
> >> forces the dio read case to fallback to inode_locking to prevent
> >> read/truncate races. Unfortunately this is subtly broken for at least
> >> 2 reasons:
> >>
> >> 1. inode_dio_begin in btrfs_direct_IO is called outside of inode_lock
> >> (for the read case). This means that there is no ordering guarantee
> >> between the invocation of inode_dio_wait and the increment of
> >> i_dio_count in btrfs_direct_IO in the tread case.
> > 
> > Also, looking at this changelog, the diff and the code, why is it a
> > problem not calling inode_dio_begin without the inode lock in the dio
> > read path?
> > The truncate path calls inode_dio_wait after setting the bit
> > BTRFS_INODE_READDIO_NEED_LOCK and before clearing it.
> > Assuming the functions to set and clear that bit are correct, I don't
> > see what problem this brings.
> 
> Assume you have a truncate and a dio READ in parallel. So the following 
> execution is possible: 
>  
> T1:                                                           T2:                                                                              
> btrfs_setattr                                            
>  set_bit(BTRFS_INODE_READDIO_NEED_LOCK)
>  inode_dio_wait (reads i_dio_count)                        btrfs_direct_IO   						 
>  clear_bit(BTRFS_INODE_READDIO_NEED_LOCK)                  inode_dio_begin (inc's i_dio_count) 
> 
> Since we have no ordering between beginning a dio and waiting for it then 
> truncate can assume there isn't any pending dio. At the same time 
> btrfs_direct_IO will increment i_dio_count but won't see BTRFS_INODE_READDIO_NEED_LOCK
> ever being set and so will proceed servicing the read.  
>

->setattr here has truncated the inode's isize and
do_blockdev_direct_IO() then checks if the offset to read from is
within the isize, if true, dio read is fine with this truncate, if
not, it returns.

Apart from this, do you have other concerns?

thanks,

-liubo
