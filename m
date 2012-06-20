Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from terminus.zytor.com ([198.137.202.10]:41794 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755093Ab2FTVtb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Jun 2012 17:49:31 -0400
Message-ID: <4FE2455E.2090007@zytor.com>
Date: Wed, 20 Jun 2012 14:49:18 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
MIME-Version: 1.0
To: kreijack@inwind.it
CC: Goffredo Baroncelli <kreijack@libero.it>, cwillu <cwillu@cwillu.com>,
        helmut@hullen.de, linux-btrfs@vger.kernel.org
Subject: Re: R: Re: Subvolumes and /proc/self/mountinfo
References: <32353828.234981340193742067.JavaMail.defaultUser@defaultHost> <4FE1EE52.20002@zytor.com> <4FE1FB9B.1090203@libero.it> <4FE20B3D.5060704@zytor.com> <4FE21134.9090501@libero.it>
In-Reply-To: <4FE21134.9090501@libero.it>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/20/2012 11:06 AM, Goffredo Baroncelli wrote:
> 
> Am not saying that we *should* move the kernel away from /boot. I am
> only saying that having the kernel near /lib/modules *has* some advantages.
> 
> Few year ago there are some gains to have a separate /boot (ah, the time
> when the bios were unable to address the bigger disk), where there are
> the minimum things to bootstrap the system.
> 

There still is (in fact this exact problem has made a comeback, as there
are plenty of BIOSes which have bugs above the 2 TB mark); however,
there are also issues with RAID (firmware often cannot address all the
devices in the system -- and no, that isn't ancient history, I have a
system exactly like that that I bought last year), remote boot media
(your / might be on an iSCSI device, or even a network filesystem!) and
all kinds of situations like that.

The bottom line is that /boot is what the bootloader needs to be able to
address, whereas / can wait until the kernel has device drivers.  That
is a *HUGE* difference.

> Now we have the possibility to move the kernel near the modules, and
> this could lead some interesting possibility: think about different
> linux installations, with an own kernel version and an own modules
> version; what are the reasons to put together under /boot different
> kernel which potential conflicting names ? de facto standard ?
> historical reasons ? Nothing wrong here; but also the idea to moving the
> kernel under /lib/modules is not so wrong.

No, it is completely, totally and very very seriously wrong.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

