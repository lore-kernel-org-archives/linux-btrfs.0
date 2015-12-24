Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:59567 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752071AbbLXXKJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Dec 2015 18:10:09 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aCF1L-0001zm-BS
	for linux-btrfs@vger.kernel.org; Fri, 25 Dec 2015 00:10:07 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Dec 2015 00:10:07 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Dec 2015 00:10:07 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: ssd  not detected on ssd drive
Date: Thu, 24 Dec 2015 23:10:01 +0000 (UTC)
Message-ID: <pan$6abc1$7629c508$e7cccd89$99582a44@cox.net>
References: <4028.1450954582@ccs.covici.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

covici posted on Thu, 24 Dec 2015 05:56:22 -0500 as excerpted:

> Hi.  I was making a few file systems on my ssd drives (using lvm on top)
> and noticed that the ssd was not detected.  The only thing that happened
> is that the metadata is duplicated.  Is this a problem, or a waste of
> space?  If I wanted to remake the file systems -- which I don't want to
> do unless necessary -- how would I prevent this?

SSD detection is based on the value of "rotational" for the device as 
listed in sysfs.  Some virtual-block-device layers aren't transparent in 
this regard and don't reflect the value of the lower levels upward to the 
next.  It would seem lvm is one such non-transparent layer.

Of course you could manually set the rotational value in sysfs yourself, 
or you could create a udev rule to do it for you, but there's really no 
need, as all btrfs does with the value is automatically set some options 
you can already specify directly, and specifying them directly at the 
btrfs level is generally easier and more reliable anyway.

For mkfs.btrfs, the only thing ssd detection does is change the single-
device-btrfs metadata default from its normal dup mode to single, and 
since you can already specify which you want using the -m option, it's no 
big deal.

At runtime, automatic detection simply sets the ssd mount option, which 
again can be set manually, to either ssd or nossd, should you wish to do 
so.  The related ssd_spread and discard mount options are never set 
automatically, because they work better on some ssds than others and are 
thus left to admin option.

I'd recommend enabling the ssd mount option, and would recommend doing 
some research on your ssd, before deciding whether you want dup or single 
metadata.

In general, dup for metadata is more reliable without the high space cost 
dup for data would be, thus the reason it's enabled by default on 
spinning rust.  But some ssds have a firmware translation layer (FTL) 
with compression and deduplication features that would only write the one 
copy to physical media even if btrfs sent it two, in which case 
processing the second copy is simply a waste of cpu cycles and device-bus 
bandwidth.  Sandforce FTLs are known for this, marketing it as a 
feature.  OTOH, other ssds have FTLs that don't do this sort of 
transparent compression and dedup, storing exactly what they are sent, 
and they market /that/ as a feature.  The FTLs on my Corsair Neutrons (I 
forgot what the firmware brand is but google would know as that's where I 
found it when I did my research for this, note that they are _not_ 
Corsair Neutron GTXs, which I believe _may_ have the deduping FTLs) is 
the latter.

So if your ssd FTLs do dedup, single is the correct metadata choice and 
that's why it's the default.  Specifying dup metadata would end up having 
btrfs going thru the motions for nothing.  If they don't do dedup, then 
it's up to you whether you want the slightly increased performance and 
decreased space usage of single metadata due to not having to process 
that second copy, or would prefer the increased reliability of the second 
metadata copy that dup provides.

FWIW, I have btrfs directly on top of (partitioned) ssds, here, and it 
correctly detects them so I don't have to specify the ssd mount option.

As for mkfs.btrfs, most of my btrfs are pair-device raid1 for both data 
and metadata, but /boot is an exception, with a separate working /boot on 
one device and its backup on the other (because grub can point to only 
one /boot and I have the grub on each device pointed at its own /boot, so 
I can select the backup device to boot in BIOS, if an update messed up 
the working /boot or if I just refreshed the backup /boot and am testing 
it).  And I already said my FTLs don't do dedup, so I actually have a 
choice, and for both /boots, working copy and backup, I use dup mode.  
However, they're both very small, under a gig (256 MiB each), so I also 
use mixed-bg mode (mkfs.btrfs option --mixed), which means data and 
metadata are no longer separate but instead, stored on the same shared 
chunks, which means dup for metadata is also dup for data.  Which means 
/everything/ is duplicated, not just metadata, which in turn means those 
256 MiB btrfs are only 128 MiB capacity.  But it *does* mean both working 
and backup /boot still have two copies of both data and metadata, just as 
they would if I were using raid1 mode except both copies are on the same 
device.  Tho with the separate backup /boot on the other device, I still 
have the multi-device redundancy that way.  And that's exactly the way I 
want it. =:^)

(Tho in practice the 128 MiB capacity /boot is a bit smaller than I'd 
like, so next time I repartition, I'll probably make them 384 MiB each 
instead of 256 MiB, taking the space from my /var/log partition, which is 
512 MiB raid1 but never even half used unless I have a runaway logger 
event, so shrinking it to 384 MiB as well, to give the space to /boot and 
its backup, should be fine.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

