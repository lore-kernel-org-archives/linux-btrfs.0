Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cloud1-vm154.de-nserver.de ([178.250.10.56]:63910 "EHLO
        cloud1-vm154.de-nserver.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752044AbcKWS60 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 Nov 2016 13:58:26 -0500
Subject: Re: resend: Re: Btrfs: adjust len of writes if following a
 preallocated extent
To: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>,
        Liu Bo <bo.li.liu@oracle.com>, linux-btrfs@vger.kernel.org
References: <1478287254-5458-1-git-send-email-bo.li.liu@oracle.com>
 <b600e06c-f946-853a-d868-eed429f9097b@profihost.ag>
 <5835DEAA.8020602@applied-asynchrony.com>
Cc: David Sterba <dsterba@suse.cz>
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Message-ID: <65a1ca55-d82e-845a-2270-769281a44358@profihost.ag>
Date: Wed, 23 Nov 2016 19:58:22 +0100
MIME-Version: 1.0
In-Reply-To: <5835DEAA.8020602@applied-asynchrony.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Am 23.11.2016 um 19:23 schrieb Holger Hoffstätte:
> On 11/23/16 18:21, Stefan Priebe - Profihost AG wrote:
>> Am 04.11.2016 um 20:20 schrieb Liu Bo:
>>> If we have
>>>
>>> |0--hole--4095||4096--preallocate--12287|
>>>
>>> instead of using preallocated space, a 8K direct write will just
>>> create a new 8K extent and it'll end up with
>>>
>>> |0--new extent--8191||8192--preallocate--12287|
>>>
>>> It's because we find a hole em and then go to create a new 8K
>>> extent directly without adjusting @len.
>>
>> after applying that one on top of my 4.4 btrfs branch (includes patches
>> up to 4.10 / next). i'm getting deadlocks in btrfs.
> 
> *ctrl+f sectorsize* .. 
> 
> That's not surprising if you did what I suspect. If your tree is based
> on my - now really very retired - 4.4.x queue, then you are likely missing
> _all the other blocksize/sectorsize patches_ that came in from Chandra
> Seetharaman et al., which I _really_ carefully patched around, for many
> good reasons.

*arg* that makes sense. Still not easy to find out which ones to skip.
Yes that one is based on yours.

thanks,
Stefan

> 
> -h
> 
