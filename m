Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44300 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933302AbdCaRLB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 31 Mar 2017 13:11:01 -0400
Date: Fri, 31 Mar 2017 19:10:16 +0200
From: David Sterba <dsterba@suse.cz>
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Cc: Adam Borowski <kilobyte@angband.pl>, David Sterba <dsterba@suse.com>,
        Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: drop the nossd flag when remounting with -o ssd
Message-ID: <20170331171016.GN4781@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <0939c5df-3abd-ec68-16ef-538ad04251aa@mendix.com>
 <20170331151904.4091-1-kilobyte@angband.pl>
 <b289c1a8-d0d4-c147-ca65-7c954f05a7e5@mendix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <b289c1a8-d0d4-c147-ca65-7c954f05a7e5@mendix.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 31, 2017 at 06:00:08PM +0200, Hans van Kranenburg wrote:
> On 03/31/2017 05:19 PM, Adam Borowski wrote:
> > The opposite case was already handled right in the very next switch entry.
> > 
> > Reported-by: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
> > Signed-off-by: Adam Borowski <kilobyte@angband.pl>
> > ---
> > Not sure if setting NOSSD should also disable SSD_SPREAD, there's currently
> > no way to disable that option once set.

Missing inverse of ssd_spread is probably unintentional, as we once
added all complementary no* options, this one was forgotten.

And yes, nossd should turn off ssd and ssd_spread, as ssd_spread without
ssd does not nothing anyway.

> > 
> >  fs/btrfs/super.c | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> > index 06bd9b332e18..7342399951ad 100644
> > --- a/fs/btrfs/super.c
> > +++ b/fs/btrfs/super.c
> > @@ -549,11 +549,13 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
> >  		case Opt_ssd:
> >  			btrfs_set_and_info(info, SSD,
> >  					   "use ssd allocation scheme");
> > +			btrfs_clear_opt(info->mount_opt, NOSSD);
> >  			break;
> >  		case Opt_ssd_spread:
> >  			btrfs_set_and_info(info, SSD_SPREAD,
> >  					   "use spread ssd allocation scheme");
> >  			btrfs_set_opt(info->mount_opt, SSD);
> > +			btrfs_clear_opt(info->mount_opt, NOSSD);
> >  			break;
> >  		case Opt_nossd:
> >  			btrfs_set_and_info(info, NOSSD,
> 
> How did you test this?
> 
> This was also my first thought, but here's a weird thing:
> 
> -# mount -o nossd /dev/sdx /mnt/btrfs/
> 
> BTRFS info (device sdx): not using ssd allocation scheme
> 
> -# mount -o remount,ssd /mnt/btrfs/
> 
> BTRFS info (device sdx): use ssd allocation scheme
> 
> -# mount -o remount,nossd /mnt/btrfs/
> 
> BTRFS info (device sdx): use ssd allocation scheme
> 
> That means that the case Opt_nossd: is never reached when doing this?
> 
> And... what should be the result of doing:
> -# mount -o remount,nossd,ssd /mnt/btrfs/
> 
> I guess it should be that the last one in the sequence wins?

The last one wins.

> The fact that nossd,ssd,ssd_spread are different options complicates the
> whole thing, compared to e.g. autodefrag, noautodefrag.

I think the the ssd flags reflect the autodetection of ssd, unlike
autodefrag and others.

The ssd options says "enable the ssd mode", but it could be also
auto-detected if the non-rotational device is detected.

nossd says, "do not do the autodetection, even if it's a non-rot
device, also disable all ssd modes".

The manual page is not entirely clear about that, I'll update it.

So Adam's patch needs to be updated so NOSSD also disables SSD_SPREAD.
Adding the 'nossd_spread' would be good to have, even if it might be
just a marginal usecase.
