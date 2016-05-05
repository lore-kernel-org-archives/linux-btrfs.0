Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:30287 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753114AbcEEPfq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 May 2016 11:35:46 -0400
Subject: Re: Spare volumes and hot auto-replacement feature
To: Dmitry Katsubo <dma_k@mail.ru>
References: <572A8337.1030505@mail.ru>
From: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <572B684F.5010306@oracle.com>
Date: Thu, 5 May 2016 23:35:43 +0800
MIME-Version: 1.0
In-Reply-To: <572A8337.1030505@mail.ru>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Most of it (like policy tuning/configuring/notification) is through
sysfs interface, However to implement this, we need the existing sysfs
volume patches to be integrated.
We need to think about the implementation of per-FSID spare which I
hope will solve the problem incompatible spare disk.
As of now if auto replace fails, spare device is out of the kernel
device list. If user wants to give a 2nd try then, they should run
btrfs dev scan again. And the degraded vol will continue to look
for the spare device.

Thanks for the feedback.

Anand


On 05/05/2016 07:18 AM, Dmitry Katsubo wrote:
> Dear btrfs community,
>
> I am interested in spare volumes and hot auto-replacement feature [1]. I have a couple of questions:
>
> * Which kernel version this feature will be included?
> * The description says that replacement happens automatically when there is any write failed or flush failed. Is it possible to control the ratio / number of such failures? (e.g. in case it was one-time accidental failure)
> * What happens if spare device is smaller then the (failing) device to be replaced?
> * What happens if during the replacement the spare device fails (write error)?
> * Is it possible for root to be notified in case if drive replacement (successful or unsuccessful) took place? Actually this question is actual for me for overall write/flush failures on btrfs volume (btrfs monitor).
>
> Many thanks!
>
> [1] https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg48209.html
>
