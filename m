Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bl2on0124.outbound.protection.outlook.com ([65.55.169.124]:29696
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932091AbbLNJ1N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Dec 2015 04:27:13 -0500
From: "Wang, Zhiye" <Zhiye.Wang@Arcserve.com>
To: "bo.li.liu@oracle.com" <bo.li.liu@oracle.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: RE: freeze_bdev and scrub/re-balance
Date: Mon, 14 Dec 2015 09:27:10 +0000
Message-ID: <CY1PR10MB0428D9B9F5ED1E9E5080EA2EE4ED0@CY1PR10MB0428.namprd10.prod.outlook.com>
References: <CY1PR10MB0428B98E759584F476DB4CF3E40B0@CY1PR10MB0428.namprd10.prod.outlook.com>
 <CY1PR10MB0428E36B7C37C92740306A60E40B0@CY1PR10MB0428.namprd10.prod.outlook.com>
 <20151209172143.GA30753@localhost.localdomain>
In-Reply-To: <20151209172143.GA30753@localhost.localdomain>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thank you liubo for your reply.

But I am very clear with your meaning of "It should be like that with COW enabled"

I'd like to confirm, if defragment/scrub/rebalance is in progress, and my code calls "freeze_bdev" (in kernel code, or in user space code via ioctl), I can get a consistent file system state. "consistent file system state" means, if I run a LVM snapshot (or hardware snapshot, or even "dd" if it can do that quickly) after call freeze_bdev, the snapshot is file system consistent.


Thanks
Mike


-----Original Message-----
From: Liu Bo [mailto:bo.li.liu@oracle.com] 
Sent: Thursday, December 10, 2015 1:22 AM
To: Wang, Zhiye
Cc: linux-btrfs@vger.kernel.org
Subject: Re: freeze_bdev and scrub/re-balance

On Sat, Dec 05, 2015 at 09:57:18AM +0000, Wang, Zhiye wrote:
> Hi all,
> 
> 
> If I understand it correctly, defragment operation is done in user space tools, while scrub/re-balance is done in kernel thread.

Defragment is done via a IOCTL, so it also works in the kernel.

> 
> 
> So, if my kernel module calls freeze_bdev when scrub/re-balance is in progress, will I still be able to get a consistent file system state?

It should be like that with COW enabled.

Thanks,

-liubo
