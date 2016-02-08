Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mxout015.mail.hostpoint.ch ([217.26.49.175]:55068 "EHLO
	mxout015.mail.hostpoint.ch" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756293AbcBHWvS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 8 Feb 2016 17:51:18 -0500
Received: from [10.0.2.46] (helo=asmtp013.mail.hostpoint.ch)
	by mxout015.mail.hostpoint.ch with esmtp (Exim 4.84 (FreeBSD))
	(envelope-from <btrfs@bueechi.net>)
	id 1aSu9x-0004Er-8u
	for linux-btrfs@vger.kernel.org; Mon, 08 Feb 2016 23:19:53 +0100
Received: from 217-162-125-82.dynamic.hispeed.ch ([217.162.125.82] helo=imac.lan)
	by asmtp013.mail.hostpoint.ch with esmtpa (Exim 4.84 (FreeBSD))
	(envelope-from <btrfs@bueechi.net>)
	id 1aSu9x-00043d-77
	for linux-btrfs@vger.kernel.org; Mon, 08 Feb 2016 23:19:53 +0100
From: boli <btrfs@bueechi.net>
Content-Type: text/plain; charset=utf-8
Subject: "layout" of a six drive raid10
Date: Mon, 8 Feb 2016 23:19:52 +0100
To: linux-btrfs@vger.kernel.org
Message-Id: <1E2010FD-CBFD-44BD-B5DB-9ECD5C009391@bueechi.net>
Mime-Version: 1.0 (Mac OS X Mail 9.2 \(3112\))
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi

I'm trying to figure out what a six drive btrfs raid10 would look like. The example at <https://btrfs.wiki.kernel.org/index.php/FAQ#What_are_the_differences_among_MD-RAID_.2F_device_mapper_.2F_btrfs_raid.3F> seems ambiguous to me.

It could mean that stripes are split over two raid1 sets of three devices each. The sentence "Every stripe is split across to exactly 2 RAID-1 sets" would lead me to believe this.

However, earlier it says for raid0 that "stripe[s are] split across as many devices as possible". Which for six drives would be: stripes are split over three raid1 sets of two devices each.

Can anyone enlighten me as to which is correct?


Reason I'm asking is that I'm deciding on a suitable raid level for a new DIY NAS box. I'd rather not use btrfs raid6 (for now). The first alternative I thought of was raid10. Later I learned how btrfs raid1 works and figured it might be better suited for my use case: Striping the data over multiple raid1 sets doesn't really help, as transfer from/to my box will be limited by gigabit ethernet anyway, and a single drive can saturate that.

Thoughts on this would also be appreciated.


As a bonus I was wondering how btrfs raid1 are layed out in general, in particular with even and odd numbers of drives. A pair is trivial. For three drives I think a "ring setup" with each drive sharing half of its data with another drive. But how is it with four drives – are they organized as two pairs, or four-way, or …

Cheers, boli