Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:45955 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844AbcEDRpT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 May 2016 13:45:19 -0400
Date: Wed, 4 May 2016 10:44:36 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: dsterba@suse.cz, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org, vegard.nossum@oracle.com, sterba@suse.com
Subject: Re: [PATCH 1/2] Btrfs: add more valid checks for superblock
Message-ID: <20160504174436.GB14909@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1462212951-28113-1-git-send-email-bo.li.liu@oracle.com>
 <9fa04dd7-13c4-6c24-dddc-4521eccea65c@cn.fujitsu.com>
 <20160504132329.GT29353@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160504132329.GT29353@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 04, 2016 at 03:23:29PM +0200, David Sterba wrote:
> On Tue, May 03, 2016 at 09:02:56AM +0800, Qu Wenruo wrote:
> > 
> > 
> > Liu Bo wrote on 2016/05/02 11:15 -0700:
> > > This adds valid checks for super_total_bytes, super_bytes_used and
> > > super_stripesize.
> > >
> > > Reported-by: Vegard Nossum <vegard.nossum@oracle.com>
> > > Reported-by: Quentin Casasnovas <quentin.casasnovas@oracle.com>
> > > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> > > ---
> > >  fs/btrfs/disk-io.c | 14 ++++++++++++++
> > >  1 file changed, 14 insertions(+)
> > >
> > > diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> > > index 4e47849..988d03f 100644
> > > --- a/fs/btrfs/disk-io.c
> > > +++ b/fs/btrfs/disk-io.c
> > > @@ -4120,6 +4120,20 @@ static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info,
> > >  	 * Hint to catch really bogus numbers, bitflips or so, more exact checks are
> > >  	 * done later
> > >  	 */
> > > +	if (btrfs_super_total_bytes(sb) == 0) {
> > > +		printk(KERN_ERR "BTRFS: total bytes is zero\n");
> > > +		ret = -EINVAL;
> > > +	}
> > 
> > Would it be better if using "6 * nodesize"?
> > 
> > I'd like to use a precious low limit on total bytes, but we don't have 
> > such value, so 6 nodesize would be good.
> 
> An early check can compare against some reasonable value, but the
> total_bytes value must be equal to the sum of all device sizes
> (disk_total_bytes). I'm not sure if we have enough information to verify
> that at this point though.

That's what I had in mind, the problem is that only the first device information is recorded in superblock.

At this moment We have device_num but we don't know the size of other devices.

Thanks,

-liubo
