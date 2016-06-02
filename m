Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:1969 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750740AbcFBECP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Jun 2016 00:02:15 -0400
Subject: Re: How to map extents to files
To: Nikolaus Rath <Nikolaus@rath.org>, <linux-btrfs@vger.kernel.org>
References: <87eg8g5lwt.fsf@vostro.rath.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <06ef9ac3-ed15-9621-9629-4c8965618db6@cn.fujitsu.com>
Date: Thu, 2 Jun 2016 12:01:55 +0800
MIME-Version: 1.0
In-Reply-To: <87eg8g5lwt.fsf@vostro.rath.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 06/02/2016 11:06 AM, Nikolaus Rath wrote:
> Hello,
>
> For one of my btrfs volumes, btrfsck reports a lot of the following
> warnings:
>
> [...]
> checking extents
> bad extent [138477568, 138510336), type mismatch with chunk
> bad extent [140091392, 140148736), type mismatch with chunk
> bad extent [140148736, 140201984), type mismatch with chunk
> bad extent [140836864, 140865536), type mismatch with chunk
> [...]
>
> Is there a way to discover which files are affected by this (in
> particular so that I can take a look at them before and after a btrfsck
> --repair)?
>
>
> Best,
> -Nikolaus
>
Which version is the progs? If the fs is not converted from ext2/3/4, it 
may be a false alert.

Thanks,
Qu


