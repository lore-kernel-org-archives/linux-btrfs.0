Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:44557 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932647AbbFJHro (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Jun 2015 03:47:44 -0400
Message-ID: <5577EB9A.2030707@cn.fujitsu.com>
Date: Wed, 10 Jun 2015 15:47:38 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Federico Pedemonte <pedemonte@gmail.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: SSD mode on hybrid disk (SSHD)
References: <CAFQiR=S6uSkuC1rvh4coPMSr8AtewMLF8xejEfBdC45iYoqsKw@mail.gmail.com>
In-Reply-To: <CAFQiR=S6uSkuC1rvh4coPMSr8AtewMLF8xejEfBdC45iYoqsKw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> Hi all,
>
> I've replaced my notebook HDD with an SSHD hybrid disk (Seagate ST1000LM).
> contrary to my experience with other similar machines, the disk
> performance are really poor.
>
> I suspect that it depends on btrfs detecting it as an SSD disk
> (according to this dmesg message):
>
> BTRFS: detected SSD devices, enabling SSD mode
>
> is this the way it is supposed to be for hybrid disks?
> is there a way to disable SSD mode (and, is it something I should try?)
Hi,

You can try nossd mount option (mount DEV MNT -o nossd), which will 
disable ssd related optimization.

But according to my experience, even enable ssd mode on HDD, performance 
shouldn't drop too much, and sometimes, especially random write 
performance will even improve hugely.(but at cost of more fragments).

Thanks,
Qu

>
> thanks,
> Federico
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
