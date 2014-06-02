Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.domeneshop.no ([194.63.252.54]:54506 "EHLO
	smtp.domeneshop.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442AbaFBH2J (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 Jun 2014 03:28:09 -0400
Message-ID: <538C27C4.2090509@skagestad.org>
Date: Mon, 02 Jun 2014 09:29:08 +0200
From: =?ISO-8859-1?Q?Torbj=F8rn?= <lists@skagestad.org>
MIME-Version: 1.0
To: Marc MERLIN <marc@merlins.org>
CC: Chris Mason <clm@fb.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: 3.15-rc6 - btrfs-transacti:4157 blocked for more than 120 seconds.
References: <5384D53C.9070509@skagestad.org> <5384E2FA.1070509@fb.com> <5384F0B4.7040309@skagestad.org> <5384F8A4.1050206@skagestad.org> <5384FAB2.6000204@fb.com> <5385007A.4000301@fb.com> <538579F1.10106@skagestad.org> <5385E794.1030002@fb.com> <5385F938.9010009@skagestad.org> <20140601212926.GH22161@merlins.org>
In-Reply-To: <20140601212926.GH22161@merlins.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 01. juni 2014 23:29, Marc MERLIN wrote:
> On Wed, May 28, 2014 at 04:56:56PM +0200, Torbjørn wrote:
>> On 05/28/2014 03:41 PM, Chris Mason wrote:
>>> On 05/28/2014 01:53 AM, Torbjørn wrote:
>>>
>>>> It's actually a raid10 array of 11 dm-crypt devices.
>>>> I'm able to read data from the array (accessing files), and also read
>>>> directly from all the underlying dm-crypt devices using dd, if that's
>>>> what you meant.
>>>>
>>>> I have not rebooted the system since that dmesg, so it's still stuck in
>>>> the same state.
>>>> I can keep it like that for some days. The system is not critical at all.
>>>>
>>> Thanks,
>>>
>>> Can you please capture the result of sysrq-t and sysrq-l?  Maybe the IO
>>> is stuck in a thread that isn't in the D state.
>>>
>>> -chris
>> The output of sysrq-t was too much data for pastebin, will send both
>> to you as attachments outside of the list.
> Considering I have experienced this with with 3.15rc but wasn't able to
> save a sysrq since my save file and syslog got lost, did you find out
> anything from that?
>
> Thanks,
> Marc
Hi Marc,

I have not done any real investigation of those yet, so no.

The server is mainly for testing, so I had already netconsole set up for it.
Btrfs only blocked on the one array though. Root is btrfs raid1 with 2 
devices, and it was operating as normal.

If it's of any interest, I can make the captured logs available for 
download.

--
Torbjørn

