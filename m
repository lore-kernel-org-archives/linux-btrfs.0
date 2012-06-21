Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp209.alice.it ([82.57.200.105]:48888 "EHLO smtp209.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755329Ab2FUFrh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Jun 2012 01:47:37 -0400
Message-ID: <4FE2B576.3030301@libero.it>
Date: Thu, 21 Jun 2012 07:47:34 +0200
From: Goffredo Baroncelli <kreijack@libero.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: kreijack@inwind.it, cwillu <cwillu@cwillu.com>, helmut@hullen.de,
        linux-btrfs@vger.kernel.org
Subject: Re: R: Re: Subvolumes and /proc/self/mountinfo
References: <32353828.234981340193742067.JavaMail.defaultUser@defaultHost> <4FE1EE52.20002@zytor.com> <4FE1FB9B.1090203@libero.it> <4FE20B3D.5060704@zytor.com> <4FE21134.9090501@libero.it> <4FE2455E.2090007@zytor.com>
In-Reply-To: <4FE2455E.2090007@zytor.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/20/2012 11:49 PM, H. Peter Anvin wrote:
> On 06/20/2012 11:06 AM, Goffredo Baroncelli wrote:
>>
>> Am not saying that we *should* move the kernel away from /boot. I am
>> only saying that having the kernel near /lib/modules *has* some advantages.
>>
>> Few year ago there are some gains to have a separate /boot (ah, the time
>> when the bios were unable to address the bigger disk), where there are
>> the minimum things to bootstrap the system.
>>
> 
> There still is (in fact this exact problem has made a comeback, as there
> are plenty of BIOSes which have bugs above the 2 TB mark); however,
> there are also issues with RAID (firmware often cannot address all the
> devices in the system -- and no, that isn't ancient history, I have a
> system exactly like that that I bought last year), remote boot media
> (your / might be on an iSCSI device, or even a network filesystem!) and
> all kinds of situations like that.
> 
> The bottom line is that /boot is what the bootloader needs to be able to
> address, whereas / can wait until the kernel has device drivers.  That
> is a *HUGE* difference

This leads to have a separately /boot filesystem. In this case I agree
with you: make sense that the kernel is near the bootloader files.

But if /boot has to be in a separate filesystem, which is the point to
support btrfs at all ? Does make sense to support only a subset of btrfs
features ?

> 
>> Now we have the possibility to move the kernel near the modules, and
>> this could lead some interesting possibility: think about different
>> linux installations, with an own kernel version and an own modules
>> version; what are the reasons to put together under /boot different
>> kernel which potential conflicting names ? de facto standard ?
>> historical reasons ? Nothing wrong here; but also the idea to moving the
>> kernel under /lib/modules is not so wrong.
> 
> No, it is completely, totally and very very seriously wrong.

When a bootloader (and the bioses) will be able to address the whole
diskS, this will change.. Not now

> 
> 	-hpa
> 

