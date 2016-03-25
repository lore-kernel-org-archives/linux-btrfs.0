Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:1127 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752026AbcCYHlp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Mar 2016 03:41:45 -0400
Subject: =?UTF-8?Q?Re:_systemd_:_Timed_out_waiting_for_defice_dev-disk-by?=
 =?UTF-8?B?4oCm?=
To: Vincent Olivier <vincent@up4.com>, <linux-btrfs@vger.kernel.org>
References: <1437763277.673610371@apps.rackspace.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <56F4EBAB.3070206@cn.fujitsu.com>
Date: Fri, 25 Mar 2016 15:41:31 +0800
MIME-Version: 1.0
In-Reply-To: <1437763277.673610371@apps.rackspace.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Although I know the post is almost one year ago, but I'm quite 
interested in the long mount time.

Any info about the fs except it's a 12 x 4T raid10?

We're investigating such long mount time, but unfortunately, we didn't 
find a good idea to reproduce it (although we don't have 12 devices though).

Thanks,
Qu

Vincent Olivier wrote on 2015/07/24 14:41 -0400:
> Hi,
>
> (Sorry if this gets sent twice : one of my mail relay is misbehaving today)
>
> 50% of the time when booting, the system go in safe mode because my 12x 4TB RAID10 btrfs is taking too long to mount from fstab.
>
> When I comment it out from fstab and mount it manually, it’s all good.
>
> I don’t like that. Is there a way to increase the timer or something ?
>
> Thanks,
>
> Vincent
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


