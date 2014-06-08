Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:36687 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708AbaFHLHr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 8 Jun 2014 07:07:47 -0400
Date: Sun, 8 Jun 2014 19:07:40 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Holger =?iso-8859-1?Q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix leaf corruption after __btrfs_drop_extents
Message-ID: <20140608110739.GC9291@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1402035958-30013-1-git-send-email-bo.li.liu@oracle.com>
 <pan.2014.06.06.14.02.07@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <pan.2014.06.06.14.02.07@googlemail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 06, 2014 at 02:02:07PM +0000, Holger Hoffstätte wrote:
> On Fri, 06 Jun 2014 14:25:58 +0800, Liu Bo wrote:
> 
> > Several reports about leaf corruption has been floating on the list, one
> > of them points to __btrfs_drop_extents(), and we find that the leaf
> > becomes corrupted after __btrfs_drop_extents(), it's really a rare case
> > but it does exist.
> 
> Out of curiosity ("..what could go wrong?" :) I applied this to 3.14.6, 
> rebooted and worked a bit on my btrfs drive - rsyncs, create & delete 
> snapshots etc. For the first time in ages I got two kernel messages:
> 
> Jun  6 09:20:56 tux kernel: BTRFS error (device sdb1): block group 
> 351872745472 has wrong amount of free space
> Jun  6 09:20:56 tux kernel: BTRFS error (device sdb1): failed to load 
> free space cache for block group 351872745472
> 
> I remounted without inode_cache & clear_cache, worked some more and so 
> far no more messages. Could the messages be related to this patch? Or am 
> I just looking at a coincidental/unrelated occurrence? Dropping the 
> snapshots correctly freed up several GBs, so I assume that extents were 
> dropped..

Well, I think they're unrelated ;)

We saw similar space cache errors from other reports, but it mainly came from a
unclean shutdown or poweroff.

-liubo

> 
> thanks
> Holger
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
