Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.domeneshop.no ([194.63.252.54]:47502 "EHLO
	smtp.domeneshop.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752060AbaE1O5K (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 28 May 2014 10:57:10 -0400
Message-ID: <5385F938.9010009@skagestad.org>
Date: Wed, 28 May 2014 16:56:56 +0200
From: =?ISO-8859-1?Q?Torbj=F8rn?= <lists@skagestad.org>
MIME-Version: 1.0
To: Chris Mason <clm@fb.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: 3.15-rc6 - btrfs-transacti:4157 blocked for more than 120 seconds.
References: <5384D53C.9070509@skagestad.org> <5384E2FA.1070509@fb.com> <5384F0B4.7040309@skagestad.org> <5384F8A4.1050206@skagestad.org> <5384FAB2.6000204@fb.com> <5385007A.4000301@fb.com> <538579F1.10106@skagestad.org> <5385E794.1030002@fb.com>
In-Reply-To: <5385E794.1030002@fb.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/28/2014 03:41 PM, Chris Mason wrote:
> On 05/28/2014 01:53 AM, Torbjørn wrote:
>
>> It's actually a raid10 array of 11 dm-crypt devices.
>> I'm able to read data from the array (accessing files), and also read
>> directly from all the underlying dm-crypt devices using dd, if that's
>> what you meant.
>>
>> I have not rebooted the system since that dmesg, so it's still stuck in
>> the same state.
>> I can keep it like that for some days. The system is not critical at all.
>>
> Thanks,
>
> Can you please capture the result of sysrq-t and sysrq-l?  Maybe the IO
> is stuck in a thread that isn't in the D state.
>
> -chris
The output of sysrq-t was too much data for pastebin, will send both to 
you as attachments outside of the list.

--
Torbjørn
