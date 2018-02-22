Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44508 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750916AbeBVXlb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Feb 2018 18:41:31 -0500
Date: Fri, 23 Feb 2018 00:39:11 +0100
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: Nikolay Borisov <nborisov@suse.com>, Filipe Manana <fdmanana@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Josef Bacik <josef@toxicpanda.com>
Subject: Re: [PATCH] btrfs: Fix locking during DIO read
Message-ID: <20180222233911.GJ1469@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1519213303-2802-1-git-send-email-nborisov@suse.com>
 <CAL3q7H4aiNyzgtDoziTXYkwuSggUAF+b9uLTWcm15GQSigp1_w@mail.gmail.com>
 <de457af6-6a9c-43f4-b9c6-429b69deec77@suse.com>
 <CAL3q7H7PiYd2yXNeG3Lkx8XVOgwFhx_1-9kaY8wqHBYkXStJ7w@mail.gmail.com>
 <20180221182817.GB9910@lim.localdomain>
 <CAL3q7H4eus5pO-NohXRKDytjPQcMjCXov9s7W_p+5JCuuYe_Lg@mail.gmail.com>
 <20180221223806.GA32259@lim.localdomain>
 <29ab09a7-a6a2-d9d4-13d7-724cf4050c1c@suse.com>
 <20180222190945.GA11675@dhcp-10-211-47-181.usdhcp.oraclecorp.com>
 <20180222192440.GB11675@dhcp-10-211-47-181.usdhcp.oraclecorp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180222192440.GB11675@dhcp-10-211-47-181.usdhcp.oraclecorp.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 22, 2018 at 12:24:40PM -0700, Liu Bo wrote:
> > > > Not even that far, isize is truncated before calling inode_dio_wait()
> > > > and a memory barrier is set to ensure the correct order, so dio read
> > > > would simply return if it's reading past isize.
> > > 
> > > Please, describe concretely which meory barriers pairs with chich in
> > > order to ensure proper visibility. Because I'm of the opinion there are
> > > insufficient memoru barriers to ensure setting READDIO_LOCK is properly
> > > visible in btrfs_direct_IO. Since the latter has no barriers whatsoever.
> > 
> > smp_mb() is supposed to be paired, so there is one missing, I agree.
> >
> 
> So the missing smp_mb() was there (commit
> 2e60a51e62185cce48758e596ae7cb2da673b58f), but was removed in some
> cleanup I guess.

Not a cleanup, and not a single commit:

38851cc19adbfa1def2b47106d8050a80e0a3673
Btrfs: serialize unlocked dio reads with truncate
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>

at this time the i_dio_counter was still used directly and the barrier
was moved before the if-else block, technically still in the right
before the test_bit.

dc59215d4f42084ee13654bafe3e5130b146aeb7
btrfs: remove unnecessary memory barrier in btrfs_direct_IO
Signed-off-by: Nikolay Borisov <nborisov@suse.com>

... simply removes the barrier.
