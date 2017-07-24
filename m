Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.163]:15652 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753618AbdGXQoA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Jul 2017 12:44:00 -0400
Received: from mordor.fritz.box (xd932dc59.dyn.telefonica.de [217.50.220.89])
        by smtp.strato.de (RZmta 41.1 DYNA|AUTH)
        with ESMTPSA id z03216t6OGewprV
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate)
        for <linux-btrfs@vger.kernel.org>;
        Mon, 24 Jul 2017 18:40:58 +0200 (CEST)
Message-ID: <1500914457.2781.10.camel@cloud.haefemeier.eu>
Subject: Re: Best Practice: Add new device to RAID1 pool
From: Cloud Admin <admin@cloud.haefemeier.eu>
To: linux-btrfs@vger.kernel.org
Date: Mon, 24 Jul 2017 18:40:57 +0200
In-Reply-To: <4b768b97-2c0b-bf67-dec0-1c5a1f7181b2@gmail.com>
References: <1500895655.2781.6.camel@cloud.haefemeier.eu>
         <18d96f74-00a8-9bb9-dddc-f50940d0971e@gmail.com>
         <1500905566.2781.8.camel@cloud.haefemeier.eu>
         <4b768b97-2c0b-bf67-dec0-1c5a1f7181b2@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Montag, den 24.07.2017, 10:25 -0400 schrieb Austin S. Hemmelgarn:
> On 2017-07-24 10:12, Cloud Admin wrote:
> > Am Montag, den 24.07.2017, 09:46 -0400 schrieb Austin S.
> > Hemmelgarn:
> > > On 2017-07-24 07:27, Cloud Admin wrote:
> > > > Hi,
> > > > I have a multi-device pool (three discs) as RAID1. Now I want
> > > > to
> > > > add a
> > > > new disc to increase the pool. I followed the description on
> > > > https:
> > > > //bt
> > > > rfs.wiki.kernel.org/index.php/Using_Btrfs_with_Multiple_Devices
> > > > and
> > > > used 'btrfs add <device> <btrfs path>'. After that I called a
> > > > balance
> > > > for rebalancing the RAID1 using 'btrfs balance start <btrfs
> > > > path>'.
> > > > Is that anything or should I need to call a resize (for
> > > > example) or
> > > > anything else? Or do I need to specify filter/profile
> > > > parameters
> > > > for
> > > > balancing?
> > > > I am a little bit confused because the balance command is
> > > > running
> > > > since
> > > > 12 hours and only 3GB of data are touched. This would mean the
> > > > whole
> > > > balance process (new disc has 8TB) would run a long, long
> > > > time...
> > > > and
> > > > is using one cpu by 100%.
> > > 
> > > Based on what you're saying, it sounds like you've either run
> > > into a
> > > bug, or have a huge number of snapshots on this filesystem.
> > 
> > It depends what you define as huge. The call of 'btrfs sub list
> > <btrfs
> > path>' returns a list of 255 subvolume.
> 
> OK, this isn't horrible, especially if most of them aren't snapshots 
> (it's cross-subvolume reflinks that are most of the issue when it
> comes 
> to snapshots, not the fact that they're subvolumes).
> > I think this is not too huge. The most of this subvolumes was
> > created
> > using docker itself. I cancel the balance (this will take awhile)
> > and will try to delete such of these subvolumes/snapshots.
> > What can I do more?
> 
> As Roman mentioned in his reply, it may also be qgroup related.  If
> you run:
> btrfs quota disable
It seems quota was one part of it. Thanks for the tip. I disabled and
started balance new.
Now approx. each 5 min. one chunk will be relocated. But if I take the
reported 10860 chunks and calc. the time it will take ~37 days to
finish... So, it seems I have to investigate more time into figure out
the subvolume / snapshots structure created by docker.
A first deeper look shows, there is a subvolume with a snapshot, which
has itself a snapshot, and so forth.
> 
> On the filesystem in question, that may help too, and if you are
> using 
> quotas, turning them off with that command will get you a much
> bigger 
> performance improvement than removing all the snapshots.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-
> btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
