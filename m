Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f180.google.com ([209.85.223.180]:36558 "EHLO
	mail-io0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707AbcHOL5k (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Aug 2016 07:57:40 -0400
Received: by mail-io0-f180.google.com with SMTP id b62so77441519iod.3
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Aug 2016 04:57:40 -0700 (PDT)
Subject: Re: About minimal device number for RAID5/6
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, btrfs <linux-btrfs@vger.kernel.org>
References: <d87a7caa-d414-1dbc-7c7e-a051e382114a@cn.fujitsu.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <d27bad69-1041-7771-aff6-c15beb85fbb1@gmail.com>
Date: Mon, 15 Aug 2016 07:57:17 -0400
MIME-Version: 1.0
In-Reply-To: <d87a7caa-d414-1dbc-7c7e-a051e382114a@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-08-15 03:50, Qu Wenruo wrote:
> Hi,
>
> Recently I found that manpage of mkfs is saying minimal device number
> for RAID5 and RAID6 is 2 and 3.
>
> Personally speaking, although I understand that RAID5/6 only requires
> 1/2 devices for parity stripe, it is still quite strange behavior.
>
> Under most case, user use raid5/6 for striping AND parity. For 2 devices
> RAID5, it's just a more expensive RAID1.
>
> IMHO it's better to warn user about 2 devices RAID5 or 3 devices RAID6.
>
> Any comment is welcomed.
>
Based on looking at the code, we do in fact support 2/3 devices for 
raid5/6 respectively.

Personally, I agree that we should warn when trying to do this, but I 
absolutely don't think we should stop it from happening.

