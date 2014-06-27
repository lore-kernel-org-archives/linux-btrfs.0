Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:38813 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752626AbaF0F0a (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Jun 2014 01:26:30 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1X0Og8-0003fG-Rq
	for linux-btrfs@vger.kernel.org; Fri, 27 Jun 2014 07:26:28 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 27 Jun 2014 07:26:28 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 27 Jun 2014 07:26:28 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: cancel btrfs delete job
Date: Fri, 27 Jun 2014 05:26:14 +0000 (UTC)
Message-ID: <pan$207f$e9dab0e9$594ccc79$94281c38@cox.net>
References: <1403783232.7657.25.camel@hsew-frn.HIPERSCAN>
	<pan$6d335$5c2b9a29$9bcb428d$7e0aa9cc@cox.net> <61052648.lopAtLMs1F@xev>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Russell Coker posted on Fri, 27 Jun 2014 10:49:40 +1000 as excerpted:

> On Thu, 26 Jun 2014 13:25:09 Duncan wrote:
>> properly.  And if you do automated snapshots, use a good thinning
>> script to thin them down so you're well under 500. (I've posted figures
>> where even starting with per-minute snapshots, thinning down to 10
>> minute, then to half hour within the day, then to say 4/day after two
>> days, 1/day after a week, one a week after four weeks, one every 13
>> weeks aka quarterly after say six months, and clearing them all and
>> relying on off-
>> machine backups after a year or 18 months, runs only 250-ish or so,
>> under 300.)
> 
> What scripts are people using for this?

I don't do much with snapshots here, and definitely don't do auto-
snapshotting, but snapper's a popular one, there's Marc Merlin's script,
and there's several other related links I've not looked closely at on the
wiki, as well.

The use-cases page has a section on time-machine snapshots, with several
links including snapper:

https://btrfs.wiki.kernel.org/index.php/UseCases#How_can_I_use_btrfs_for_backups.2Ftime-machine.3F

I don't see Marc Merlin's script linked there, but it's linked from the
FAQ, snapshot example section:

https://btrfs.wiki.kernel.org/index.php/FAQ#snapshot_example

(Someone with a wiki login could probably add Marc's script to the use-
cases list, and then reword the FAQ entry appropriately and point it to
the use-cases discussion instead of just linking Marc's script.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

