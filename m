Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:42980 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751609AbbLXPTZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Dec 2015 10:19:25 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aC7fk-0005C2-6b
	for linux-btrfs@vger.kernel.org; Thu, 24 Dec 2015 16:19:20 +0100
Received: from 178-83-240-22.dynamic.hispeed.ch ([178.83.240.22])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 24 Dec 2015 16:19:20 +0100
Received: from auslands-kv by 178-83-240-22.dynamic.hispeed.ch with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 24 Dec 2015 16:19:20 +0100
To: linux-btrfs@vger.kernel.org
From: Neuer User <auslands-kv@gmx.de>
Subject: Re: btrfs und lvm-cache?
Date: Thu, 24 Dec 2015 16:19:14 +0100
Message-ID: <n5h2di$vq7$1@ger.gmane.org>
References: <n5du09$9rn$1@ger.gmane.org>	<1527885.5NheBqth0k@merkaba>	<n5e139$r1h$1@ger.gmane.org>	<CAJCQCtStdF=JU11LOjJ_xLXir_CPzJ7GaQRRqsROEE0eOADFWA@mail.gmail.com>	<567B0245.5000902@gmx.de> <CAJCQCtSLfwmuBnNFHKbyDmUDV5yQg-BWDB3TjFqxtL_OqEm5TA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CAJCQCtSLfwmuBnNFHKbyDmUDV5yQg-BWDB3TjFqxtL_OqEm5TA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am 23.12.2015 um 21:56 schrieb Chris Murphy:
> Btrfs always writes to the 'cache LV' and then it's up to lvmcache to
> determine how and when things are written to the 'cache pool LV' vs
> the 'origin LV' and I have no idea if there's a case with writeback
> mode where things write to the SSD and only later get copied from SSD
> to the HDD, in which case a wildly misbehaving SSD might corrupt data
> on the origin.
> 
> If you use writethrough, the default, then the data on HDDs should be
> fine even if the single SSD goes crazy for some reason. Even if all
> reads go bad, worse case is Btrfs should stop and go read-only. If the
> SSD read errors are more transient, then Btrfs tries to fix them with
> COW writes, so even if these fixes aren't needed on HDD, they should
> arrive safely on both HDDs and hence still no corruption.
> 
Yeah, that's what I hoped for.

> I mean *really* if data integrity is paramount you probably would do
> this with production methods. Anything that has high IOPS like a mail
> server, just write that stuff only to the SSD, and then occasionally
> rsync it to conventionally raided (md or lvm) HDDs with XFS. You could
> even use lvm snapshots and do this often, and now you not only have
> something fast and safe but also you have an integrated backup that's
> mirrored, in a sense you have three copies. Whereas what you're

Something like that is what I used before. Ext4 on LVM with LVM
snapshots and external backups. But it does not help against silent
bitrot. And that is the scary thing, I would like to care for and thus
having a deeper look at btrfs.
http://arstechnica.com/information-technology/2014/01/bitrot-and-atomic-cows-inside-next-gen-filesystems/

> attempting is rather complicated, and while it ought to work and it
> gets testing, you're really being a test candidate not least of which
> is Btrfs but also lvmcache, but you're also combining both tests. I'd
> just say make sure you have regular backups - snapshot the rw
> subvolume regularly and sync it to another filesystem. As often as the
> workflow can tolerate.
> 
Yeah, that's what I thought of. Snapshotting the system and
send/receiving it to a second external disk. Additionally, using
duplicity/rsync with Amazon Glacier.
> 
> Yeah if it's a decent name brand SSD and not one of the ones with
> known crap firmware, then I think it's fine to just have one. Either
> way, each origin LV gets a separate cache pool LV if I understand
> lvmcache correctly.
> 
Is there a list of "SSDs with known crap firmware"? Currently I have a
Toshiba disk Q300 in use.

> Off hand I don't know if you need separate VGs to make sure the 'cache
> LVs' you format with Btrfs in fact use different PVs as origins.
> That's important. The usual lvcreate command has a way to specify one
> or more PVs to use, rather than have it just grab a pile of extents
> from the VG (which could be from either PV), but I don't know if
> that's the way it works in conjunction with lvmcache.
> 
> You're probably best off configuring this, and while doing write, pull
> a device. Do that three times, once for each HDD and once for the SSD,
> and see if you can recover. If it has to be bullet proof, you need to
> spray it with bullets.
> 
Yeah, I should do a test like this. Looks scary, but it is probably the
best.

Thanks for your input!

> 


