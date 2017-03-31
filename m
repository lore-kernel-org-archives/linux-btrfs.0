Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:48182 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754898AbdCaUIc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 31 Mar 2017 16:08:32 -0400
From: Adam Borowski <kilobyte@angband.pl>
To: David Sterba <dsterba@suse.cz>,
        Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        linux-btrfs@vger.kernel.org
Cc: Adam Borowski <kilobyte@angband.pl>
Date: Fri, 31 Mar 2017 22:08:50 +0200
Message-Id: <20170331200850.7067-1-kilobyte@angband.pl>
In-Reply-To: <20170331171016.GN4781@twin.jikos.cz>
References: <20170331171016.GN4781@twin.jikos.cz>
Subject: [PATCH v2] btrfs: drop the nossd flag when remounting with -o ssd
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

And when turning on nossd, drop ssd_spread.

Reported-by: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Signed-off-by: Adam Borowski <kilobyte@angband.pl>
---
On Fri, Mar 31, 2017 at 07:10:16PM +0200, David Sterba wrote:
> On Fri, Mar 31, 2017 at 06:00:08PM +0200, Hans van Kranenburg wrote:
> > On 03/31/2017 05:19 PM, Adam Borowski wrote:
> > > Not sure if setting NOSSD should also disable SSD_SPREAD, there's currently
> > > no way to disable that option once set.
> 
> Missing inverse of ssd_spread is probably unintentional, as we once
> added all complementary no* options, this one was forgotten.
> 
> And yes, nossd should turn off ssd and ssd_spread, as ssd_spread without
> ssd does not nothing anyway.

Added that.

> > How did you test this?
> > 
> > This was also my first thought, but here's a weird thing:
> > 
> > -# mount -o nossd /dev/sdx /mnt/btrfs/
> > 
> > BTRFS info (device sdx): not using ssd allocation scheme
> > 
> > -# mount -o remount,ssd /mnt/btrfs/
> > 
> > BTRFS info (device sdx): use ssd allocation scheme
> > 
> > -# mount -o remount,nossd /mnt/btrfs/
> > 
> > BTRFS info (device sdx): use ssd allocation scheme
> > 
> > That means that the case Opt_nossd: is never reached when doing this?

Seems to work for me:

[/tmp]# mount -onoatime foo /mnt/vol1 
[  619.436745] BTRFS: device fsid 954fd6c3-b3ce-4355-b79a-60ece7a6a4e0 devid 1 transid 5 /dev/loop0
[  619.438625] BTRFS info (device loop0): disk space caching is enabled
[  619.438627] BTRFS info (device loop0): has skinny extents
[  619.438629] BTRFS info (device loop0): flagging fs with big metadata feature
[  619.441989] BTRFS info (device loop0): creating UUID tree
[/tmp]# mount -oremount,ssd /mnt/vol1
[  629.755584] BTRFS info (device loop0): use ssd allocation scheme
[  629.755589] BTRFS info (device loop0): disk space caching is enabled
[/tmp]# mount -oremount,nossd /mnt/vol1
[  633.675867] BTRFS info (device loop0): not using ssd allocation scheme
[  633.675872] BTRFS info (device loop0): disk space caching is enabled

> > The fact that nossd,ssd,ssd_spread are different options complicates the
> > whole thing, compared to e.g. autodefrag, noautodefrag.
> 
> I think the the ssd flags reflect the autodetection of ssd, unlike
> autodefrag and others.

The autodetection works for /dev/sd* and /dev/mmcblk*, but not for most
other devices.

Two examples:
nbd to a piece of rotating rust says:
[45697.575192] BTRFS info (device nbd0): detected SSD devices, enabling SSD mode
loop on tmpfs (and in case it spills, all swap is on ssd):
claims it's rotational

> The ssd options says "enable the ssd mode", but it could be also
> auto-detected if the non-rotational device is detected.
> 
> nossd says, "do not do the autodetection, even if it's a non-rot
> device, also disable all ssd modes".

These two options are nice whenever the autodetection goes wrong.

> So Adam's patch needs to be updated so NOSSD also disables SSD_SPREAD.

M'kay, updated this patch.

> Adding the 'nossd_spread' would be good to have, even if it might be
> just a marginal usecase.

Not sure if there's much point.  In any case, that's a separate patch.
Should I add one while we're here?


Meow!

 fs/btrfs/super.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 06bd9b332e18..ac1ca22d0c34 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -549,16 +549,19 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
 		case Opt_ssd:
 			btrfs_set_and_info(info, SSD,
 					   "use ssd allocation scheme");
+			btrfs_clear_opt(info->mount_opt, NOSSD);
 			break;
 		case Opt_ssd_spread:
 			btrfs_set_and_info(info, SSD_SPREAD,
 					   "use spread ssd allocation scheme");
 			btrfs_set_opt(info->mount_opt, SSD);
+			btrfs_clear_opt(info->mount_opt, NOSSD);
 			break;
 		case Opt_nossd:
 			btrfs_set_and_info(info, NOSSD,
 					     "not using ssd allocation scheme");
 			btrfs_clear_opt(info->mount_opt, SSD);
+			btrfs_clear_opt(info->mount_opt, SSD_SPREAD);
 			break;
 		case Opt_barrier:
 			btrfs_clear_and_info(info, NOBARRIER,
-- 
2.11.0

