Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:39618 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753884AbcDDT0o (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Apr 2016 15:26:44 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1anA8x-0002xf-Oz
	for linux-btrfs@vger.kernel.org; Mon, 04 Apr 2016 21:26:35 +0200
Received: from ip5f5ae008.dynamic.kabel-deutschland.de ([95.90.224.8])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Apr 2016 21:26:35 +0200
Received: from hurikhan77 by ip5f5ae008.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Apr 2016 21:26:35 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: btrfsck: backpointer mismatch (and multiple other errors)
Date: Mon, 4 Apr 2016 21:26:28 +0200
Message-ID: <20160404212628.14e83e37@jupiter.sol.kaishome.de>
References: <20160331224452.0753d5c7@jupiter.sol.kaishome.de>
	<CAPmG0jZ6hs4TA_0ozNEP4x6ucn971Nj-6+uempGi1VwTWAdCYQ@mail.gmail.com>
	<20160402110001.0ec354b5@jupiter.sol.kaishome.de>
	<CAPmG0jaJdS26ABbC3Rz_D_FDfCKq8mYMHhmFwqhWYpDRdyFQhw@mail.gmail.com>
	<20160402221634.2e3dc71c@jupiter.sol.kaishome.de>
	<CAJCQCtQ+RnQqghDs060hrLJ850e0n=FiKNn9W8UuUP3DQV9u5g@mail.gmail.com>
	<20160403060202.03e67651@jupiter.sol.kaishome.de>
	<pan$2593b$f74bb320$4b6df891$663eb0b@cox.net>
	<20160404001925.2abc2649@jupiter.sol.kaishome.de>
	<pan$39ed6$7954b891$6122ae15$76baf1b0@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Mon, 4 Apr 2016 04:34:54 +0000 (UTC)
schrieb Duncan <1i5t5.duncan@cox.net>:

> Meanwhile, putting bcache into write-around mode, so it makes no
> further changes to the ssd and only uses it for reads, is probably
> wise, and should help limit further damage.  Tho if in that mode
> bcache still does writeback of existing dirty and cached data to the
> backing store, some further damage could occur from that.  But I
> don't know enough about bcache to know what its behavior and level of
> available configuration in that regard actually are.  As long as it's
> not trying to write anything from the ssd to the backing store, I
> think further damage should be very limited.

bcache has 0 for dirty data most of the time for me - even in write
back mode. It does write back during idle time and at reduced rate,
usually that finishes within a few minutes.

Switching the cache to write-around initiates instant write-back of all
dirty data, so within seconds it goes down to zero and the cache
becomes detachable.

I'll go test the soon-to-die SSD as soon as it replaced. I think it's
still far from failing with bitrot. It was overprovisioned by 30% most
of the time, with the spare space trimmed. It certainly should have a
lot of sectors for wear levelling. In addition, smartctl shows no
sector errors at all - except for one: raw_read_error_rate. I'm not
sure what all those sensors tell me, but that one I'm also seeing on
hard disks which show absolutely no data damage.

In fact, I see those counters for my hard disks. But dd to /dev/null of
the complete raw hard disk shows no sector errors. It seems good. But
well, counting 1+1 together: I currently see data damage. But I guess
that's unrelated.

Is there some documentation somewhere what each of those sensors
technically mean and how to read the raw values and thresh values?

I'm also seeing multi_zone_error_rate on my spinning rust.

According to smartctl health check and smartctl extended selftest,
there's no problems at all - and the smart error log is empty. There
has never been an ATA error in dmesg... No relocated sectors... From my
naive view the drives still look good.

-- 
Regards,
Kai

Replies to list-only preferred.

