Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp206.alice.it ([82.57.200.102]:36111 "EHLO smtp206.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754594Ab2FTSGo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Jun 2012 14:06:44 -0400
Message-ID: <4FE21134.9090501@libero.it>
Date: Wed, 20 Jun 2012 20:06:44 +0200
From: Goffredo Baroncelli <kreijack@libero.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: kreijack@inwind.it, cwillu <cwillu@cwillu.com>, helmut@hullen.de,
        linux-btrfs@vger.kernel.org
Subject: Re: R: Re: Subvolumes and /proc/self/mountinfo
References: <32353828.234981340193742067.JavaMail.defaultUser@defaultHost> <4FE1EE52.20002@zytor.com> <4FE1FB9B.1090203@libero.it> <4FE20B3D.5060704@zytor.com>
In-Reply-To: <4FE20B3D.5060704@zytor.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

HI,
On 06/20/2012 07:41 PM, H. Peter Anvin wrote:
> On 06/20/2012 09:34 AM, Goffredo Baroncelli wrote:
>>
>> At the first I tough that having the /boot separate could be a good
>> thing. Unfortunately /boot contains both the bootloader code and the
>> kernel image. The kernel image should be in sync with the contents of
>> /lib/modules/....
>>
>> This is the tricky point. If I handle /boot inside the filesystem
>> submodule a de-sync between the bootloader code and the boot sector
>> could happens. In I handle /boot as separate subvolume/filesystem a
>> de-sync between the kernel image and the modules could happens.
>>
>> Anyway, from a bootloader POV I think that /boot should be handle
>> separately (or as filesystem or as subvolume identified by specific ID).
>> The best could be move the kernel in the same subvolume as /lib/modules,
>> so a switch of the subvolume as root filesystem would be coherent.
>>
> 
> You're not really answering the question.   "The best could be move the
> kernel in the same subvolume as /lib/modules" isn't really going to
> happen... the whole *point* of /boot is that /boot contains everything
> needed to get to the point of kernel initialization.

??
Am not saying that we *should* move the kernel away from /boot. I am
only saying that having the kernel near /lib/modules *has* some advantages.

Few year ago there are some gains to have a separate /boot (ah, the time
when the bios were unable to address the bigger disk), where there are
the minimum things to bootstrap the system.

Now we have the possibility to move the kernel near the modules, and
this could lead some interesting possibility: think about different
linux installations, with an own kernel version and an own modules
version; what are the reasons to put together under /boot different
kernel which potential conflicting names ? de facto standard ?
historical reasons ? Nothing wrong here; but also the idea to moving the
kernel under /lib/modules is not so wrong.

> So, sorry, you're out to sea here...

True, the sea is far away from my house :-)

> 
> 	-hpa
> 
> .
> 

