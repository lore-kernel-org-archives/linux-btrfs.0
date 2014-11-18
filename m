Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:60638 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754023AbaKRTRb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Nov 2014 14:17:31 -0500
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: BTRFS messes up snapshot LV with origin
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <546B68F8.6080008@ubuntu.com>
Date: Tue, 18 Nov 2014 12:17:26 -0700
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-Id: <FC0BA13C-21E3-44DD-A87C-4BEAE4FBF9EA@colorremedies.com>
References: <CAE8gLhnLUBJmN=3n1SVTc3y0zbBAxSBXtMxe7rhANtwC+3dCow@mail.gmail.com> <pan$f02e0$7a5e2052$d1925753$4ad202f9@cox.net> <54699CC7.1050909@swiftspirit.co.za> <546A46A5.8030603@inwind.it> <CAE8gLh=VubBbZdeKTAuWRjOxPF7C+ouUeeVvmGfT2ckYWGhQVA@mail.gmail.com> <CAE8gLh=Lf+z2B_9EXQM_ODSOa5HZsFpFMB=kKGmQXJSjYdy5kg@mail.gmail.com> <27BDAC3B-789C-4477-B065-E703CE425F54@colorremedies.com> <546B68F8.6080008@ubuntu.com>
To: Phillip Susi <psusi@ubuntu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Nov 18, 2014, at 8:42 AM, Phillip Susi <psusi@ubuntu.com> wrote:

> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> On 11/18/2014 1:16 AM, Chris Murphy wrote:
>> If fstab specifies rootfs as UUID, and there are two volumes with
>> the same UUID, it’s now ambiguous which one at boot time is the
>> intended rootfs. It’s no different than the days of /dev/sdXY where
>> X would change designations between boots = ambiguity and why we
>> went to UUID.
> 
> He already said he has NOT rebooted, so there is no way that the
> snapshot has actually been mounted, even if it were UUID confusion.
> 
>> So we kinda need a way to distinguish derivative volumes. Maybe
>> XFS and ext4 could easily change the volume UUID, but my vague 
>> recollection is this is difficult on Btrfs? So that led me to the 
>> idea of a way to create an on-the-fly (but consistent) “virtual 
>> volume UUID” maybe based on a hash of both the LVM LV and fs
>> volume UUID.
> 
> When using LVM, you should be referring to the volume by the LVM name
> rather than UUID.  LVM names are stable, and don't have the duplicate
> uuid problem.

What if you have a Btrfs raid1 volume using two LV’s and then snapshot both LV’s?

Of course I’d specify one of the devices by VG-LV name. But Btrfs finds additional devices itself, it doesn’t support explicitly naming additional member devices. And in this example, there are two identical candidates, so it’s ambiguous to Btrfs which one to use. And further it’s unknown to the user which one Btrfs chose because neither mount, nor /proc/mounts right now shows anything other than the first device that’s mounted. So it’s using one of those two VG-LV’s automatically but not informing us which one.

I think there’s some metadata that can be set on each LV whether it’s automatically activated (at e.g. boot time) so I think the thing to do would be to make sure the snapshot LV’s are not activated, therefore their UUID’s shouldn’t be visible to Btrfs and it won’t automatically discover and use the wrong LV. But I haven’t tested this.


Chris Murphy