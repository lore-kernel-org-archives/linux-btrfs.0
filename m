Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:40433 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751378AbaGUCl4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Jul 2014 22:41:56 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1X93Y2-0003QX-Lw
	for linux-btrfs@vger.kernel.org; Mon, 21 Jul 2014 04:41:54 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Jul 2014 04:41:54 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Jul 2014 04:41:54 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: ENOSPC errors during balance
Date: Mon, 21 Jul 2014 02:41:42 +0000 (UTC)
Message-ID: <pan$e47c$3cfacec6$ed70480f$6a4a2ac0@cox.net>
References: <20140719172605.445e8445@marcec>
	<39E33553-3073-483E-9A2A-088212B40D0B@colorremedies.com>
	<pan$c685d$4bb40507$f2be4604$15619074@cox.net>
	<20140720122233.4ef06751@marcec> <20140720134054.3cd6cef3@marcec>
	<20140720214440.398e7e68@marcec>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Marc Joliet posted on Sun, 20 Jul 2014 21:44:40 +0200 as excerpted:

> Am Sun, 20 Jul 2014 13:40:54 +0200 schrieb Marc Joliet <marcec@gmx.de>:
> 
>> Am Sun, 20 Jul 2014 12:22:33 +0200 schrieb Marc Joliet <marcec@gmx.de>:
>> 
>> [...]
>> > I'll try this and see, but I think I have more files >1GB than would
>> > account for this error (which comes towards the end of the balance
>> > when only a few chunks are left).  I'll see what "find /mnt -type f
>> > -size +1G" finds :) .

Note that it's extent's over 1 GiB on the converted former ext4, not 
necessarily files over 1 GiB.  You may have files over a GiB that were 
already broken into extents that are all less than a GiB, and btrfs would 
be able to deal with them fine.  It's only when a single extent ended up 
larger than a GiB on the former ext4 that btrfs can't deal with it.

>> Now that I think about it, though, it sounds like it could explain the
>> sudden surge in total data size: for one very big file, several
>> chunks/extents are created, but the data cannot be copied from the
>> original ext4 extent.

I hadn't thought about that effect, but good deductive reasoning. =:^)

> Well, turns out that was it!
> 
> What I did:
> 
> - delete the single largest file on the file system, a 12 GB VM image,
> along with all subvolumes that contained it
> - rsync it over again - start a full balance
> 
> This time, the balance finished successfully :-) .

Good to read!

We're now two for two on this technique working around this problem! =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

