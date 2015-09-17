Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ns211617.ip-188-165-215.eu ([188.165.215.42]:48492 "EHLO
	mx.speed47.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753976AbbIQICR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Sep 2015 04:02:17 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Thu, 17 Sep 2015 10:02:15 +0200
From: =?UTF-8?Q?St=C3=A9phane_Lesimple?= <stephane_btrfs@lesimple.fr>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: kernel BUG at linux-4.2.0/fs/btrfs/extent-tree.c:1833 on
 rebalance
In-Reply-To: <55FA60C5.5090002@cn.fujitsu.com>
References: <9c864637fe7676a8b7badc5ddd7a4e0c@all.all>
 <2c00c4b7c15e424659fb2e810170e32e@all.all> <55F83181.9010201@fb.com>
 <532aadf0f92d08d3d2b274173548aee1@all.all>
 <pan$e885$1290ceef$c5017ead$b38037f1@cox.net>
 <f81878fadaf2980a72522e54010e0415@all.all> <55F9486F.4040302@googlemail.com>
 <0973de930ee87e102c533c719807b748@all.all>
 <pan$5599c$cb01bfb8$910004c8$d38ea6b6@cox.net>
 <d2f30d85fa83b8b98af3c7e5a862044d@all.all> <55FA2D9A.1060405@cn.fujitsu.com>
 <e80ea6421a1f6a5f84c5d1032fc6a3e8@all.all> <55FA60C5.5090002@cn.fujitsu.com>
Message-ID: <7a6f2d794fb6cbf7d598b92e3470201c@all.all>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le 2015-09-17 08:42, Qu Wenruo a écrit :
> Stéphane Lesimple wrote on 2015/09/17 08:11 +0200:
>> Le 2015-09-17 05:03, Qu Wenruo a écrit :
>>> Stéphane Lesimple wrote on 2015/09/16 22:41 +0200:
>>>> Le 2015-09-16 22:18, Duncan a écrit :
>>>>> Stéphane Lesimple posted on Wed, 16 Sep 2015 15:04:20 +0200 as
>>>>> excerpted:
>>>>> 
>>>> 
>>>> Well actually it's the (d) option ;)
>>>> I activate the quota feature for only one reason : being able to 
>>>> track
>>>> down how much space my snapshots are taking.
>>> 
>>> Yeah, that's completely one of the ideal use case of btrfs qgroup.
>>> 
>>> But I'm quite curious about the btrfsck error report on qgroup.
>>> 
>>> If btrfsck report such error, it means either I'm too confident about
>>> the recent qgroup accounting rework, or btrfsck has some bug which I
>>> didn't take much consideration during the kernel rework.
>>> 
>>> Would you please provide the full result of previous btrfsck with
>>> qgroup error?
>> 
>> Sure, I've saved the log somewhere just in case, here your are :
>> 
>> [...]
> Thanks for your log, pretty interesting result.
> 
> BTW, did you enabled qgroup from old kernel earlier than 4.2-rc1?
> If so, I would be much relaxed as they can be the problem of old 
> kernels.

The mkfs.btrfs was done under 3.19, but I'm almost sure I enabled quota 
under 4.2.0 precisely. My kern.log tends to confirm that (looking for 
'qgroup scan completed').

> If it's OK for you, would you please enable quota after reproducing
> the bug and use for sometime and recheck it?

Sure, I've just reproduced the bug twice as I wanted, and posted the 
info, so now I've cancelled the balance and I can reenable quota. Will 
do it under 4.3.0-rc1. I'll keep you posted if btrfsck complains about 
it in the following days.

Regards,

-- 
Stéphane.

