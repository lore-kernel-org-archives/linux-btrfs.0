Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:30550 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509AbbLIRVu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Dec 2015 12:21:50 -0500
Date: Wed, 9 Dec 2015 09:21:43 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: "Wang, Zhiye" <Zhiye.Wang@Arcserve.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: freeze_bdev and scrub/re-balance
Message-ID: <20151209172143.GA30753@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <CY1PR10MB0428B98E759584F476DB4CF3E40B0@CY1PR10MB0428.namprd10.prod.outlook.com>
 <CY1PR10MB0428E36B7C37C92740306A60E40B0@CY1PR10MB0428.namprd10.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <CY1PR10MB0428E36B7C37C92740306A60E40B0@CY1PR10MB0428.namprd10.prod.outlook.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

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
