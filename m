Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:57362 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751364AbcLFA35 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Dec 2016 19:29:57 -0500
Subject: Re: [SOLVED] Re: system hangs due to qgroups
To: Marc Joliet <marcec@gmx.de>, <linux-btrfs@vger.kernel.org>
References: <1776088.42rHLKPlSp@thetick>
 <5f35cc2d-4c3d-b14c-01f6-4bfb0f22823b@cn.fujitsu.com>
 <29619565.vvZbx4DoIQ@thetick> <4448819.RKs36le3Tk@thetick>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <593ee12d-a353-d834-2390-a68aaf6377a8@cn.fujitsu.com>
Date: Tue, 6 Dec 2016 08:29:48 +0800
MIME-Version: 1.0
In-Reply-To: <4448819.RKs36le3Tk@thetick>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 12/05/2016 10:43 PM, Marc Joliet wrote:
> On Monday 05 December 2016 12:01:28 Marc Joliet wrote:
>>> This seems to be a NULL pointer bug in qgroup relocation fix.
>>>
>>>
>>>
>>> The latest fix (not merged yet) should address it.
>>>
>>>
>>>
>>> You could try the for-next-20161125 branch from David to fix it:
>>> https://github.com/kdave/btrfs-devel/tree/for-next-20161125
>>
>> OK, I'll try that, thanks!  I just have to wait for it to finish cloning...
>>
> [...]
>>> And for your recovery, I'd suggest to install an Archlinux into a USB
>>> HDD or USB stick, and compile David's branch and install it into the USB
>>> HDD.
>>>
>>>
>>>
>>> Then use the USB storage as rescue tool to mount the fs, which should do
>>> RW mount with or without skip_balance mount option.
>>> So you could disable quota then.
>>
>> OK, I'll try that, thanks!
>
> Excellent, thank you, that worked!  My laptop is working normally again.  I'll
> keep an eye on it, but so far two balance operations ran normally (that is,
> they completed within a few minutes and without hanging the system).
>
> (Specifically, since I didn't find out how to get a different kernel onto the
> Arch USB stick, I simply installed the kernel on my desktop, then did
> everything from an initramfs emergency shell, then moved the SSD back into the
> laptop.)
>
> Thanks, everyone!
>
Glad that helped.

I just forgot that you're using gentoo, not archlinux, and kernel 
install script won't work for archlinux.

Anyway, I'm glad that works for you.

BTW, if you haven't yet disable quota, would you please give a report on 
how many qgroup you have?
And how CPU is spinning for balancing with quota enabled?

This would help us to evaluate how qgroup slows down the process if 
there are too many snapshots.

Thanks,
Qu


