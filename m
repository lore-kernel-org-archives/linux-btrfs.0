Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:49517 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753073Ab3LGRJj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 7 Dec 2013 12:09:39 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VpLNq-0006iE-5x
	for linux-btrfs@vger.kernel.org; Sat, 07 Dec 2013 18:09:38 +0100
Received: from dyndsl-080-228-187-169.ewe-ip-backbone.de ([80.228.187.169])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 07 Dec 2013 18:09:38 +0100
Received: from hurikhan77+btrfs by dyndsl-080-228-187-169.ewe-ip-backbone.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 07 Dec 2013 18:09:38 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77+btrfs@gmail.com>
Subject: Re: Extremely slow metadata performance
Date: Sat, 07 Dec 2013 18:10:09 +0100
Message-ID: <hc1cna-pru.ln1@hurikhan77.spdns.de>
References: <52A0BD44.9030509@complete.org> <pan$950f8$ef940490$829198f6$4f5f85c7@cox.net> <20131207092216.GL22683@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Marc MERLIN <marc@merlins.org> schrieb:

> I'm one of those people who uses cp -al and rsync to do backups. Indeed
> I should likely rework the flow to use subvolumes and snapshots.
> You also mentioned reflinks, and it sounds like I can use
> cp -a --reflink instead of cp -al.
> 
> Also, would the dedupe code in btrfs effectively allow for the same
> thing after the fact if you use cp without --reflink? Is it stable
> enough nowadays?

You may want to try my backup script as a starting point:

https://gist.github.com/kakra/5520370

It uses a scratch area to create a mirror of your system, then - if it was 
successful - take a snapshot of it. Next time the backup runs, the scratch 
area is updated with rsync using its features for in-file delta updates, so 
you get optimal small deltas between each snapshot. Normally, rsync would 
create a new copy of each file in local mode, so using these features is 
important.

My script is meant to be run from systemd with auto-mount backup disk. But 
it should be easy to adapt to cron if you need to. All the work is done 
within the bash script.

You may wonder about the scratch area. I took this route to ensure that 
snapshots always contain clean and consistent backups. If there was a 
problem during rsync, there will be no snapshot. It's that easy. Usually I 
see other solutions taking a snapshot first, then modify this snapshot. So 
you never know if snapshots are clean and consistent. With my approach you 
get clean snapshots and even if the last backup broke and you are thus 
missing a snapshot, you still have data in the scratch area to recover from.

In my scenario my backup script is able to hold several weeks of daily 
backups in the backlog. The destination is mounted with compress-force=zlib 
so I get good compression, too. However, I still had no time for 
implementing automatic cleanup of old snapshots. Feel free to add it.

HTH
Kai

