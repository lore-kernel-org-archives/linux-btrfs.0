Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:54190 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750977AbaKRGQQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Nov 2014 01:16:16 -0500
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:60795 helo=[192.168.1.126])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:RC4-SHA:128)
	(Exim 4.84)
	(envelope-from <lists@colorremedies.com>)
	id 1Xqc5G-001vM3-Ob
	for linux-btrfs@vger.kernel.org; Mon, 17 Nov 2014 23:16:14 -0700
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: BTRFS messes up snapshot LV with origin
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <CAE8gLh=Lf+z2B_9EXQM_ODSOa5HZsFpFMB=kKGmQXJSjYdy5kg@mail.gmail.com>
Date: Mon, 17 Nov 2014 23:16:13 -0700
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-Id: <27BDAC3B-789C-4477-B065-E703CE425F54@colorremedies.com>
References: <CAE8gLhnLUBJmN=3n1SVTc3y0zbBAxSBXtMxe7rhANtwC+3dCow@mail.gmail.com> <pan$f02e0$7a5e2052$d1925753$4ad202f9@cox.net> <54699CC7.1050909@swiftspirit.co.za> <546A46A5.8030603@inwind.it> <CAE8gLh=VubBbZdeKTAuWRjOxPF7C+ouUeeVvmGfT2ckYWGhQVA@mail.gmail.com> <CAE8gLh=Lf+z2B_9EXQM_ODSOa5HZsFpFMB=kKGmQXJSjYdy5kg@mail.gmail.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Nov 17, 2014, at 12:45 PM, MegaBrutal <megabrutal@gmail.com> wrote:

> 2014-11-17 20:04 GMT+01:00 Goffredo Baroncelli <kreijack@inwind.it>:
>> 
>> Regarding b)
>> I am bit confused: if I understood correctly, the root filesystem was
>> picked from a LVM-snapshot, so grub-probe *correctly* reported that
>> the root device is the snapshot.
> 
> 
> This is not what happens. The system doesn't even get a reboot when
> the mix-up happens.
> 
> You boot from the original device, create an LVM-snapshot*, and mount
> starts to report the snapshot as the root device, while in fact it
> isn’t.

If fstab specifies rootfs as UUID, and there are two volumes with the same UUID, it’s now ambiguous which one at boot time is the intended rootfs. It’s no different than the days of /dev/sdXY where X would change designations between boots = ambiguity and why we went to UUID. 

So we kinda need a way to distinguish derivative volumes. Maybe XFS and ext4 could easily change the volume UUID, but my vague recollection is this is difficult on Btrfs? So that led me to the idea of a way to create an on-the-fly (but consistent) “virtual volume UUID” maybe based on a hash of both the LVM LV and fs volume UUID.


Chris Murphy