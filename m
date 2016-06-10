Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:56555 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750710AbcFJISB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 Jun 2016 04:18:01 -0400
Subject: Re: How to map extents to files
To: Nikolaus Rath <Nikolaus@rath.org>
References: <87eg8g5lwt.fsf@vostro.rath.org>
 <06ef9ac3-ed15-9621-9629-4c8965618db6@cn.fujitsu.com>
 <87zir3skpo.fsf@thinkpad.rath.org>
CC: <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <420018f7-d129-5861-2fc4-bf2f92e46b69@cn.fujitsu.com>
Date: Fri, 10 Jun 2016 16:17:45 +0800
MIME-Version: 1.0
In-Reply-To: <87zir3skpo.fsf@thinkpad.rath.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 06/02/2016 10:56 PM, Nikolaus Rath wrote:
> On Jun 02 2016, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>> At 06/02/2016 11:06 AM, Nikolaus Rath wrote:
>>> Hello,
>>>
>>> For one of my btrfs volumes, btrfsck reports a lot of the following
>>> warnings:
>>>
>>> [...]
>>> checking extents
>>> bad extent [138477568, 138510336), type mismatch with chunk
>>> bad extent [140091392, 140148736), type mismatch with chunk
>>> bad extent [140148736, 140201984), type mismatch with chunk
>>> bad extent [140836864, 140865536), type mismatch with chunk
>>> [...]
>>>
>>> Is there a way to discover which files are affected by this (in
>>> particular so that I can take a look at them before and after a btrfsck
>>> --repair)?
>>
>> Which version is the progs? If the fs is not converted from ext2/3/4,
>> it may be a false alert.
>
> Version is 4.4.1. The fs may very well have been converted from ext4,
> but I can't tell for sure.
>
>
> Best,
> -Nikolaus
>

Sorry for the late reply.

For such case, btrfsck --repair is unable to fix it, as btrfs-progs is 
not able to balance extents.

Normally, a full balance would fix it.


I would try to update btrfs-progs to 4.5 and recheck, to see if it's a 
false alert.
If not, then remove unused snapshots and then do the full balance.

It's recommended to delete unused snapshots, as if there are too many 
snapshots, balance may be quite slow.

Thanks,
Qu


