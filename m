Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:38615 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752638AbdC2Ezd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 29 Mar 2017 00:55:33 -0400
Date: Tue, 28 Mar 2017 21:54:24 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix wrong failed mirror_num of read-repair on
 raid56
Message-ID: <20170329045424.GB306@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1490382822-25344-1-git-send-email-bo.li.liu@oracle.com>
 <20170327170715.GL4781@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170327170715.GL4781@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 27, 2017 at 07:07:15PM +0200, David Sterba wrote:
> On Fri, Mar 24, 2017 at 12:13:42PM -0700, Liu Bo wrote:
> > In raid56 senario, after trying parity recovery, we didn't set
> > mirror_num for btrfs_bio with failed mirror_num, hence
> > end_bio_extent_readpage() will report a random mirror_num in dmesg
> > log.
> > 
> > Cc: David Sterba <dsterba@suse.cz>
> > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> > ---
> >  fs/btrfs/volumes.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> > index 73d56ee..be64e4a 100644
> > --- a/fs/btrfs/volumes.c
> > +++ b/fs/btrfs/volumes.c
> > @@ -6197,6 +6197,7 @@ int btrfs_map_bio(struct btrfs_fs_info *fs_info, struct bio *bio,
> >  		} else {
> >  			ret = raid56_parity_recover(fs_info, bio, bbio,
> >  						    map_length, mirror_num, 1);
> > +			btrfs_io_bio(bio)->mirror_num = mirror_num;
> 
> Should the mirror be set inside raid56_parity_recover? There's another
> caller, scrub_submit_raid56_bio_wait, that does not update the
> bio->mirror_num. I am not sure if this is the same case though.
>

scrub_submit_raid56_bio_wait doesn't need to, but yes, we could set the
mirror inside raid56_parity_recover iff @generic_io is 1.

Thanks,

-liubo

> >  		}
> >  
> >  		btrfs_bio_counter_dec(fs_info);

