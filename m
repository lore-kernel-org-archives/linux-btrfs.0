Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:54764 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751341AbeAPDuf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 15 Jan 2018 22:50:35 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1ebIEV-0004EN-Dk
        for linux-btrfs@vger.kernel.org; Tue, 16 Jan 2018 04:48:19 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: big volumes only work reliable with ssd_spread
Date: Tue, 16 Jan 2018 03:48:04 +0000 (UTC)
Message-ID: <pan$6f2ed$a4643565$6c45fc9$81b96ddb@cox.net>
References: <344ef7c2-404a-2f79-198c-9de8c5e31629@profihost.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Stefan Priebe - Profihost AG posted on Mon, 15 Jan 2018 10:55:42 +0100 as
excerpted:

> since around two or three years i'm using btrfs for incremental VM
> backups.
> 
> some data:
> - volume size 60TB
> - around 2000 subvolumes
> - each differential backup stacks on top of a subvolume
> - compress-force=zstd
> - space_cache=v2
> - no quote / qgroup
> 
> this works fine since Kernel 4.14 except that i need ssd_spread as an
> option. If i do not use ssd_spread i always end up with very slow
> performance and a single kworker process using 100% CPU after some days.
> 
> With ssd_spread those boxes run fine since around 6 month. Is this
> something expected? I haven't found any hint regarding such an impact.

My understanding of the technical details is "limited" as I'm not a dev, 
and I expect you'll get a more technically accurate response later, but 
sometimes a first not particularly technical response can be helpful as 
long as it's not /wrong/.  (And if it is this is a good way to have my 
understanding corrected as well. =:^)  With that caveat, based on my 
understanding of what I've seen on-list...

The kernel v4.14 ssd mount-option changes apparently primarily affected 
data, not metadata.  Apparently, ssd_spread has a heavier metadata 
effect, and the v4.14 changes moved additional (I believe metadata) 
functionality to ssd-spread that had originally been part of ssd as 
well.  There has been some discussion of metadata tweaks similar to those 
in 4.14 for the ssd option with data, but they weren't deemed as 
demonstrably needed as the ssd option tweaks and needed further 
discussion, so were put off until the effect of the 4.14 tweaks could be 
gauged in more widespread use, after which they were to be reconsidered, 
if necessary.

Meanwhile, in the discussion I saw, Chris Mason mentioned that Facebook 
is using ssd-spread for various reasons there, so it's well-tested with 
their deployments, which I'd assume have many of the same qualities yours 
do, thus implying that your observations about ssd-spread are no accident.

In fact, if I interpreted Chris's comments correctly, they use ssd_spread 
on very large multi-layered non-ssd storage arrays, in part because the 
larger layout-alignment optimizations make sense there as well as on 
ssds.  That would appear to be precisely what you are seeing. =:^)  If 
that's the case, then arguably the option is misnamed and the ssd_spread 
name may well at some point be deprecated in favor of something more 
descriptive of its actual function and target devices.  Purely my own 
speculation here, but perhaps something like vla_spread (very-large-
array)?

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

