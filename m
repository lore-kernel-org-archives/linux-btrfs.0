Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:37821 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750784Ab2KOFSC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 15 Nov 2012 00:18:02 -0500
Message-ID: <50A47B16.6040308@cn.fujitsu.com>
Date: Thu, 15 Nov 2012 13:18:14 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
CC: Sage Weil <sage@inktank.com>,
        "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Josef Bacik <jbacik@fusionio.com>
Subject: Re: problem with ceph and btrfs patch: set journal_info in async
 trans commit worker
References: <50A39FAF.50602@profihost.ag>
In-Reply-To: <50A39FAF.50602@profihost.ag>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, Stefan

On wed, 14 Nov 2012 14:42:07 +0100, Stefan Priebe - Profihost AG wrote:
> Hello list,
> 
> i wanted to try out ceph with latest vanilla kernel 3.7-rc5. I was seeing a massive performance degration. I see around 22x btrfs-endio-write processes every 10-20 seconds and they run a long time while consuming a massive amount of CPU.
> 
> So my performance of 23.000 iops drops to an up and down of 23.000 iops to 0 - avg is now 2500 iops instead of 23.000.
> 
> Git bisect shows me commit: e209db7ace281ca347b1ac699bf1fb222eac03fe "Btrfs: set journal_info in async trans commit worker" as the problematic patch.
> 
> When i revert this one everything is fine again.
> 
> Is this known?

Could you try the following patch?

http://marc.info/?l=linux-btrfs&m=135175512030453&w=2

I think the patch

  Btrfs: set journal_info in async trans commit worker

is not the real reason that caused the regression.

I guess it is caused by the bug of the reservation. When we join the
same transaction handle more than 2 times, the pointer of the reservation
in the transaction handle would be lost, and the statistical data in the
reservation would be corrupted. And then we would trigger the space flush,
which may block your tasks.

Thanks
Miao

> 
> Greets,
> Stefan
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

