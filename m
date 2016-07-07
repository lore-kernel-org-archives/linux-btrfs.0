Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:44555 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932235AbcGGAct convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Jul 2016 20:32:49 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1bKxFH-0000Pb-Km
	for linux-btrfs@vger.kernel.org; Thu, 07 Jul 2016 02:32:47 +0200
Received: from ip1f11faed.dynamic.kabel-deutschland.de ([31.17.250.237])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 07 Jul 2016 02:32:47 +0200
Received: from hurikhan77 by ip1f11faed.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 07 Jul 2016 02:32:47 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: btrfs RAID 10 truncates files over 2G to 4096 bytes.
Date: Thu, 7 Jul 2016 02:32:41 +0200
Message-ID: <20160707023241.2429383a@jupiter.sol.kaishome.de>
References: <CAKinxcVHevoWzgYO+1tjiGOow=shc=oBpvRrTSedeAn1raUrXA@mail.gmail.com>
	<CAPmG0jYfdYt81E8oaky53eYmy69tWgpLkRFWXRxGF_d3g3Uhjg@mail.gmail.com>
	<EDF51D2D-A311-47DF-BFF7-F5C855B9E96D@gmail.com>
	<CAPmG0jaUz1JeRiu_cAqQXM-mAhBcTLKrmxfTu=OqcrHLBRLA+A@mail.gmail.com>
	<0EBF76CB-A350-4108-91EF-076A73932061@gmail.com>
	<CAPmG0jaUeisyZD6eApjaf=e3OdTaCWFDCoT_8Msc1HUadyNWug@mail.gmail.com>
	<EE95D9F3-84A2-4F45-B1FE-D54557374EF3@gmail.com>
	<20160707012246.3559fd0a@jupiter.sol.kaishome.de>
	<F384DE2D-A7F5-4E08-BFC9-6C334E1C4D75@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Thu, 7 Jul 2016 00:51:16 +0100
schrieb Tomasz Kusmierz <tom.kusmierz@gmail.com>:

> > On 7 Jul 2016, at 00:22, Kai Krakow <hurikhan77@gmail.com> wrote:
> > 
> > Am Wed, 6 Jul 2016 13:20:15 +0100
> > schrieb Tomasz Kusmierz <tom.kusmierz@gmail.com>:
> >   
> >> When I think of it, I did move this folder first when filesystem
> >> was RAID 1 (or not even RAID at all) and then it was upgraded to
> >> RAID 1 then RAID 10. Was there a faulty balance around August
> >> 2014 ? Please remember that I’m using Ubuntu so it was probably
> >> kernel from Ubuntu 14.04 LTS
> >> 
> >> Also, I would like to hear it from horses mouth: dos & donts for a
> >> long term storage where you moderately care about the data: RAID10
> >> - flaky ? would RAID1 give similar performance ?  
> > 
> > The current implementation of RAID0 in btrfs is probably not very
> > optimized. RAID0 is a special case anyways: Stripes have a defined
> > width - I'm not sure what it is for btrfs, probably it's per chunk,
> > so it's 1GB, maybe it's 64k **. That means your data is usually not
> > read from multiple disks in parallel anyways as long as requests
> > are below stripe width (which is probably true for most access
> > patterns except copying files) - there's no immediate performance
> > benefit. This holds true for any RAID0 with read and write patterns
> > below the stripe size. Data is just more evenly distributed across
> > devices and your application will only benefit performance-wise if
> > accesses spread semi-random across the span of the whole file. And
> > at least last time I checked, it was stated that btrfs raid0 does
> > not submit IOs in parallel yet but first reads one stripe, then the
> > next - so it doesn't submit IOs to different devices in parallel.
> > 
> > Getting to RAID1, btrfs is even less optimized: Stripe decision is
> > based on process pids instead of device load, read accesses won't
> > distribute evenly to different stripes per single process, it's
> > only just reading from the same single device - always. Write
> > access isn't faster anyways: Both stripes need to be written -
> > writing RAID1 is single device performance only.
> > 
> > So I guess, at this stage there's no big difference between RAID1
> > and RAID10 in btrfs (except maybe for large file copies), not for
> > single process access patterns and neither for multi process access
> > patterns. Btrfs can only benefit from RAID1 in multi process access
> > patterns currently, as can btrfs RAID0 by design for usual small
> > random access patterns (and maybe large sequential operations). But
> > RAID1 with more than two disks and multi process access patterns is
> > more or less equal to RAID10 because stripes are likely to be on
> > different devices anyways.
> > 
> > In conclusion: RAID1 is simpler than RAID10 and thus its less
> > likely to contain flaws or bugs.
> > 
> > **: Please enlighten me, I couldn't find docs on this matter.  
> 
> :O 
> 
> It’s an eye opener - I think that this should end up on btrfs WIKI …
> seriously !
> 
> Anyway my use case for this is “storage” therefore I predominantly
> copy large files. 

Then RAID10 may be your best option - for local operations. Copying
large files, even a modern single SATA spindle can saturate a gigabit
link. So, if your use case is NAS, and you don't use server side copies
(like modern versions of NFS and Samba support), you won't benefit from
RAID10 vs RAID1 - so just use the simpler implementation.

My personal recommendation: Add a small, high quality SSD to your array
and configure btrfs on top of bcache, configure it for write-around
caching to get best life-time and data safety. This should cache mostly
meta data access in your usecase and improve performance much better
than RAID10 over RAID1. I can recommend Crucial MX series from
personal experience, choose 250GB or higher as 120GB versions of
Crucial MX suffer much lower durability for caching purposes. Adding
bcache to an existing btrfs array is a little painful but easily doable
if you have enough free space to temporarily sacrifice one disk.

BTW: I'm using 3x 1TB btrfs mraid1/draid0 with a single 500GB bcache
SSD in write-back mode and local operation (it's my desktop machine).
The performance is great, bcache decouples some of the performance
downsides the current btrfs raid implementation has. I do daily
backups, so write-back caching is not a real problem (in case it
fails), and btrfs draid0 is also not a problem (mraid1 ensures meta
data integrity, so only file contents are at risk, and covered by
backups). With this setup I can easily saturate my 6Gb onboard SATA
controller, the system boots to usable desktop in 30 seconds from cold
start (including EFI firmware), including autologin to full-blown
KDE, autostart of Chrome and Steam, 2 virtual machine containers
(nspawn-based, one MySQL instance, one ElasticSearch instance), plus
local MySQL and ElasticSearch service (used for development and staging
purposes), and a local postfix service. Without bcache this machine
needs around 2-3 minutes to boot to a usable state.

BTW: I found this but it's old:
https://btrfs.wiki.kernel.org/index.php/Multi-device_Benchmarks

However, it should give you a rough overview about your usage patterns.
You can see that RAID1 would saturate a 1 Gb link for single process
operations, this is if your usecase is NAS, you're good to go.
Simultaneous read+write isn't covered by the test but performance will
probably be killed by seek overhead anyways then, except you use
bcache (it greatly reduces seeks and, especially in write-back mode,
converts them to sequential access patterns but you need to watch the
SSD wear closely in write-back mode and swap the SSD early before it
dies... in write-around mode, bcache dying is irrelevant to btrfs
integrity... write-through doesn't make sense for your usecase).

-- 
Regards,
Kai

Replies to list-only preferred.


