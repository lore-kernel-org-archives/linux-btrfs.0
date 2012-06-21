Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp205.alice.it ([82.57.200.101]:37507 "EHLO smtp205.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759912Ab2FURFh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Jun 2012 13:05:37 -0400
Message-ID: <4FE3546F.4010701@libero.it>
Date: Thu, 21 Jun 2012 19:05:51 +0200
From: Goffredo Baroncelli <kreijack@libero.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Martin Steigerwald <Martin@lichtvoll.de>
CC: linux-btrfs@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        cwillu <cwillu@cwillu.com>, helmut@hullen.de
Subject: Re: R: Re: Subvolumes and /proc/self/mountinfo
References: <32353828.234981340193742067.JavaMail.defaultUser@defaultHost> <4FE2455E.2090007@zytor.com> <4FE2B576.3030301@libero.it> (sfid-20120621_090410_016018_05466806) <201206211346.40683.Martin@lichtvoll.de>
In-Reply-To: <201206211346.40683.Martin@lichtvoll.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/21/2012 01:46 PM, Martin Steigerwald wrote:
> Am Donnerstag, 21. Juni 2012 schrieb Goffredo Baroncelli:
>>>
>>>
>>>> Now we have the possibility to move the kernel near the modules, and
>>>> this could lead some interesting possibility: think about different
>>>> linux installations, with an own kernel version and an own modules
>>>> version; what are the reasons to put together under /boot different
>>>> kernel which potential conflicting names ? de facto standard ?
>>>> historical reasons ? Nothing wrong here; but also the idea to moving
>>>> the kernel under /lib/modules is not so wrong.
>>>
>>>
>>>
>>> No, it is completely, totally and very very seriously wrong.
>>
>> When a bootloader (and the bioses) will be able to address the whole
>> diskS, this will change.. Not now
> 
> Why not the other way around? /boot/modules-3.4 or so.
> 
> But either way, these are different discussions. H. Peter´s question was, 
> if I understood correctly, whether to use subvolid or path?
> 

For which ?
If you want to point the bootloader subvolume (where the 2nd stage
relies), I suggest subvolid=. If you need to point to the kernel
(bzImage/initrd) *for my setup* it would be useful to use the path.
Unfortunately these two requirements are in contrast.

> I tend to lean towards subvolid.

> 
> Ciao,
Ciao
Goffredo

