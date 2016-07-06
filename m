Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:36372 "EHLO
	mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755788AbcGFXvi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Jul 2016 19:51:38 -0400
Received: by mail-wm0-f48.google.com with SMTP id f126so191146104wma.1
        for <linux-btrfs@vger.kernel.org>; Wed, 06 Jul 2016 16:51:19 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Subject: Re: btrfs RAID 10 truncates files over 2G to 4096 bytes.
From: Tomasz Kusmierz <tom.kusmierz@gmail.com>
In-Reply-To: <20160707012246.3559fd0a@jupiter.sol.kaishome.de>
Date: Thu, 7 Jul 2016 00:51:16 +0100
Cc: linux-btrfs@vger.kernel.org
Message-Id: <F384DE2D-A7F5-4E08-BFC9-6C334E1C4D75@gmail.com>
References: <CAKinxcVHevoWzgYO+1tjiGOow=shc=oBpvRrTSedeAn1raUrXA@mail.gmail.com> <CAPmG0jYfdYt81E8oaky53eYmy69tWgpLkRFWXRxGF_d3g3Uhjg@mail.gmail.com> <EDF51D2D-A311-47DF-BFF7-F5C855B9E96D@gmail.com> <CAPmG0jaUz1JeRiu_cAqQXM-mAhBcTLKrmxfTu=OqcrHLBRLA+A@mail.gmail.com> <0EBF76CB-A350-4108-91EF-076A73932061@gmail.com> <CAPmG0jaUeisyZD6eApjaf=e3OdTaCWFDCoT_8Msc1HUadyNWug@mail.gmail.com> <EE95D9F3-84A2-4F45-B1FE-D54557374EF3@gmail.com> <20160707012246.3559fd0a@jupiter.sol.kaishome.de>
To: Kai Krakow <hurikhan77@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


> On 7 Jul 2016, at 00:22, Kai Krakow <hurikhan77@gmail.com> wrote:
> 
> Am Wed, 6 Jul 2016 13:20:15 +0100
> schrieb Tomasz Kusmierz <tom.kusmierz@gmail.com>:
> 
>> When I think of it, I did move this folder first when filesystem was
>> RAID 1 (or not even RAID at all) and then it was upgraded to RAID 1
>> then RAID 10. Was there a faulty balance around August 2014 ? Please
>> remember that I’m using Ubuntu so it was probably kernel from Ubuntu
>> 14.04 LTS
>> 
>> Also, I would like to hear it from horses mouth: dos & donts for a
>> long term storage where you moderately care about the data: RAID10 -
>> flaky ? would RAID1 give similar performance ?
> 
> The current implementation of RAID0 in btrfs is probably not very
> optimized. RAID0 is a special case anyways: Stripes have a defined
> width - I'm not sure what it is for btrfs, probably it's per chunk, so
> it's 1GB, maybe it's 64k **. That means your data is usually not read
> from multiple disks in parallel anyways as long as requests are below
> stripe width (which is probably true for most access patterns except
> copying files) - there's no immediate performance benefit. This holds
> true for any RAID0 with read and write patterns below the stripe size.
> Data is just more evenly distributed across devices and your
> application will only benefit performance-wise if accesses spread
> semi-random across the span of the whole file. And at least last time I
> checked, it was stated that btrfs raid0 does not submit IOs in parallel
> yet but first reads one stripe, then the next - so it doesn't submit
> IOs to different devices in parallel.
> 
> Getting to RAID1, btrfs is even less optimized: Stripe decision is based
> on process pids instead of device load, read accesses won't distribute
> evenly to different stripes per single process, it's only just reading
> from the same single device - always. Write access isn't faster anyways:
> Both stripes need to be written - writing RAID1 is single device
> performance only.
> 
> So I guess, at this stage there's no big difference between RAID1 and
> RAID10 in btrfs (except maybe for large file copies), not for single
> process access patterns and neither for multi process access patterns.
> Btrfs can only benefit from RAID1 in multi process access patterns
> currently, as can btrfs RAID0 by design for usual small random access
> patterns (and maybe large sequential operations). But RAID1 with more
> than two disks and multi process access patterns is more or less equal
> to RAID10 because stripes are likely to be on different devices anyways.
> 
> In conclusion: RAID1 is simpler than RAID10 and thus its less likely to
> contain flaws or bugs.
> 
> **: Please enlighten me, I couldn't find docs on this matter.

:O 

It’s an eye opener - I think that this should end up on btrfs WIKI … seriously !

Anyway my use case for this is “storage” therefore I predominantly copy large files. 


> -- 
> Regards,
> Kai
> 
> Replies to list-only preferred.
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

