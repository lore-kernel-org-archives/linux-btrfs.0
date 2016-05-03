Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:39876 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756778AbcECXfV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 May 2016 19:35:21 -0400
Date: Tue, 3 May 2016 16:32:34 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, vegard.nossum@oracle.com, sterba@suse.com
Subject: Re: [PATCH 1/2] Btrfs: add more valid checks for superblock
Message-ID: <20160503233234.GE21008@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1462212951-28113-1-git-send-email-bo.li.liu@oracle.com>
 <9fa04dd7-13c4-6c24-dddc-4521eccea65c@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <9fa04dd7-13c4-6c24-dddc-4521eccea65c@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 03, 2016 at 09:02:56AM +0800, Qu Wenruo wrote:
> 
> 
> Liu Bo wrote on 2016/05/02 11:15 -0700:
> >This adds valid checks for super_total_bytes, super_bytes_used and
> >super_stripesize.
> >
> >Reported-by: Vegard Nossum <vegard.nossum@oracle.com>
> >Reported-by: Quentin Casasnovas <quentin.casasnovas@oracle.com>
> >Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> >---
> > fs/btrfs/disk-io.c | 14 ++++++++++++++
> > 1 file changed, 14 insertions(+)
> >
> >diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> >index 4e47849..988d03f 100644
> >--- a/fs/btrfs/disk-io.c
> >+++ b/fs/btrfs/disk-io.c
> >@@ -4120,6 +4120,20 @@ static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info,
> > 	 * Hint to catch really bogus numbers, bitflips or so, more exact checks are
> > 	 * done later
> > 	 */
> >+	if (btrfs_super_total_bytes(sb) == 0) {
> >+		printk(KERN_ERR "BTRFS: total bytes is zero\n");
> >+		ret = -EINVAL;
> >+	}
> 
> Would it be better if using "6 * nodesize"?
> 
> I'd like to use a precious low limit on total bytes, but we don't have such
> value, so 6 nodesize would be good.

That's good, besides that I'm going to do another check between
btrfs_super_total_bytes(sb) and sb->dev_item.total_bytes.

Thanks,

-liubo

> 
> Thanks,
> Qu
> 
> >+	if (btrfs_super_bytes_used(sb) < 6 * btrfs_super_nodesize(sb)) {
> >+		printk(KERN_ERR "BTRFS: bytes_used is too small %llu\n",
> >+		       btrfs_super_bytes_used(sb));
> >+		ret = -EINVAL;
> >+	}
> >+	if (btrfs_super_stripesize(sb) != 4096) {
> >+		printk(KERN_ERR "BTRFS: invalid stripesize %u\n",
> >+		       btrfs_super_stripesize(sb));
> >+		ret = -EINVAL;
> >+	}
> > 	if (btrfs_super_num_devices(sb) > (1UL << 31))
> > 		printk(KERN_WARNING "BTRFS: suspicious number of devices: %llu\n",
> > 				btrfs_super_num_devices(sb));
> >
> 
> 
