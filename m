Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from moltke.seatribe.se ([178.63.100.209]:42710 "EHLO
	moltke.seatribe.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932745Ab3BODou (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Feb 2013 22:44:50 -0500
Date: Fri, 15 Feb 2013 04:44:43 +0100 (CET)
From: Fredrik Tolf <fredrik@dolda2000.com>
To: Martin Steigerwald <Martin@lichtvoll.de>
cc: linux-btrfs@vger.kernel.org
Subject: Re: Rebalancing RAID1
In-Reply-To: <201302141544.05747.Martin@lichtvoll.de>
Message-ID: <alpine.DEB.2.02.1302150435450.8810@shack.dolda2000.com>
References: <alpine.DEB.2.02.1302122348460.8810@shack.dolda2000.com> (sfid-20130213_093936_125418_3540CD10) <201302141544.05747.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463765759-56451118-1360899884=:8810"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463765759-56451118-1360899884=:8810
Content-Type: TEXT/PLAIN; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8BIT

On Thu, 14 Feb 2013, Martin Steigerwald wrote:
> Am Mittwoch, 13. Februar 2013 schrieb Fredrik Tolf:
> You started the balance after above btrfs fi show command?

I did.

> Then its obvious to me:
>
> For some reason BTRFS is still trying to write to /dev/sdd, which isn´t
> there anymore. That perfectly explains those lost page writes for me. If
> that is the case, this seems to me like a serious bug in BTRFS.

Now I have disconnected the drive entirely, quite simply, so that I can 
try to do simply what I should do if the drive really had failed 
completely and I had gotten a replacement in its stead. Neither any sdd 
nor any sdi is seen by the system anymore. However, I'm still getting 
kernel messages about being unable to write to sdd:

Feb 15 04:37:41 nerv kernel: [252822.640560] lost page write due to I/O error on /dev/sdd1
Feb 15 04:37:41 nerv kernel: [252822.644531] btrfs: bdev /dev/sdd1 errs: wr 362195, rd 26, flush 1, corrupt 0, gen 0

I can't say I know what conclusions that lead to with regards to your 
observations.

> I´d restart the machine, see that BTRFS is using both devices again and
> then try the balance again.

I mentioned it in another mail, but I'd very much prefer not to do that. 
I'd like to try and solve this as I normally should when a drive fails.

When I'm running btrfs fi show, this is what I'm getting now:

> $ sudo ./btrfs fi show
> Label: none  uuid: 40d346bb-2c77-4a78-8803-1e441bf0aff7
>         Total devices 2 FS bytes used 2.66TB
>         devid    2 size 2.73TB used 2.67TB path /dev/sde1
>         *** Some devices missing

So that's what it should look like when a drive fails, right?

At this point, I'm trying to remove the missing device from the filesystem 
as the Wiki indicates that I should be able to, but alas:

> $ sudo ./btrfs device delete missing /mnt
> ERROR: error removing the device 'missing' - Invalid argument

The dmesg tells me this:

> Feb 15 04:42:22 nerv kernel: [253103.799201] btrfs: unable to go below two devices on raid1

How do I remove the conception of the missing device so that I can replace 
it? Should I simply add the replacement first, and only after that remove 
the missing device?

If the latter, how can I "scratch" the previous btrfs metadata from this 
"replacement" drive so that it doesn't try to autoreinsert it into the 
filesystem when it is detected? I assume it won't be enough be just 
zeroing the first few sectors of the drive, right?

Thanks for replying!

--

Fredrik Tolf
---1463765759-56451118-1360899884=:8810--
