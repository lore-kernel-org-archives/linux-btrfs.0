Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:38343 "EHLO
	mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832AbcF2SML (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 Jun 2016 14:12:11 -0400
Received: by mail-wm0-f45.google.com with SMTP id r201so85453643wme.1
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Jun 2016 11:12:10 -0700 (PDT)
Received: from system (dslb-092-074-022-141.092.074.pools.vodafone-ip.de. [92.74.22.141])
        by smtp.gmail.com with ESMTPSA id yr4sm4861201wjc.18.2016.06.29.11.12.08
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 29 Jun 2016 11:12:08 -0700 (PDT)
Date: Wed, 29 Jun 2016 20:12:08 +0200
From: Saint Germain <saintger@gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Kernel bug during RAID1 replace
Message-ID: <20160629201208.275b37ad@system>
In-Reply-To: <CAJCQCtS=kd31tOe_YCX96W1K85sH2_qTAsxggyyP5kWzZrauoQ@mail.gmail.com>
References: <20160627233612.662d2a9a@system>
	<CAJCQCtT_vbOzbvMOuV6wgvz4iMHcpQmAhX-y1-dkOi6F323KRg@mail.gmail.com>
	<20160628002602.022258bf@system>
	<CAJCQCtR3FQ-Pe40dOcKGgd+8paraHuCoNCw5Kk+2G7bOOJF1rw@mail.gmail.com>
	<CAJCQCtRm3=7fkBcTA4o4r10cLqC-bzcsKunb5k+uA-siyZmMnQ@mail.gmail.com>
	<20160628010618.58e235fa@system>
	<CAJCQCtRoPcYQyHmkXT6yBQ31YTXLWeC+097=x0SVp+FeQ8M04w@mail.gmail.com>
	<20160628024940.3b323b26@system>
	<CAJCQCtRSu0GwLRqgvzj9pv80gqoqb6vnjVMLwMmnWF-rvR0tcg@mail.gmail.com>
	<20160629005208.5e9addcf@system>
	<CAJCQCtQnNfpu6xoFy2W_hfikphhp_AbUDVmm4Lr2Rsncrx_EsA@mail.gmail.com>
	<20160629115055.29018e6a@system>
	<CAJCQCtS=kd31tOe_YCX96W1K85sH2_qTAsxggyyP5kWzZrauoQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 29 Jun 2016 11:28:24 -0600, Chris Murphy
<lists@colorremedies.com> wrote :

> > Already got a backup. I just really want to try to repair it (in
> > order to test BTRFS).
> 
> I don't know that this is a good test because I think the file system
> has already been sufficient corrupted that it can't be fixed. Part of
> the problem is that Btrfs isn't aware of faulty drives like mdadm or
> lvm yet, so it looks like it'll try to write to all devices and it's
> possible for significant confusion to happen if they're each getting
> different generation writes. Significant as in, currently beyond
> repair.
> 
> >> > On the other hand it seems interesting to repair instead of just
> >> > giving up. It gives a good look at BTRFS resiliency/reliability.
> >>
> >> On the one hand Btrfs shouldn't become inconsistent in the first
> >> place, that's the design goal. On the other hand, I'm finding from
> >> the problems reported on the list that Btrfs increasingly mounts
> >> at least read only and allows getting data off, even when the file
> >> system isn't fully functional or repairable.
> >>
> >> In your case, once there are metadata problems even with raid 1,
> >> it's difficult at best. But once you have the backup you could try
> >> some other things once it's certain the hardware isn't adding to
> >> the problems, which I'm still not yet certain of.
> >>
> >
> > I'm ready to try anything. Let's experiment.
> 
> I kinda think it's a waste of time. Someone else maybe has a better
> idea?
> 
> I think your time is better spent finding out when and why the device
> with all of these write errors happened. It must have gone missing for
> a while, and you need to find out why that happened and prevent it; OR
> you have to be really vigilent at every mount time to make sure both
> devices have the same transid (generation). In my case when I tried to
> sabotage this, being of by a generation of 1 wasn't a problem for
> Btrfs to automatically fix up but I suspect it was only a generation
> mismatch in the superblock.
> 

Ok I will follow your advice and start over with a fresh BTRFS volume.
As explained on another email, rsync doesn't support reflink, so do you
think it is worth trying with BTRFS send instead ?
Is it safe to copy this way or rsync is more reliable in case of faulty
BTRFS volume ?

Many thanks !
