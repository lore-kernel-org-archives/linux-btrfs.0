Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54038 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932558AbaJVHlp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 Oct 2014 03:41:45 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XgqYB-0000E5-J7
	for linux-btrfs@vger.kernel.org; Wed, 22 Oct 2014 09:41:43 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 22 Oct 2014 09:41:43 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 22 Oct 2014 09:41:43 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: 5 _thousand_ snapshots? even 160? (was: device balance times)
Date: Wed, 22 Oct 2014 07:41:32 +0000 (UTC)
Message-ID: <pan$66073$b8603a2$c915bfb9$cd573e99@cox.net>
References: <9cf38edae6c01b900d4ea0068d2dcfdd@admin.virtall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Tomasz Chmielewski posted on Wed, 22 Oct 2014 09:14:14 +0200 as excerpted:

> Remember a given btrfs filesystem is not necessarily a backup
> destination for data from one source.
> 
> It can be, say, 30 or 60 daily snapshots, plus several monthly, for each
> data source * number of data sources.
> 
> So while it probably will make a difference (5000 snapshots from one
> source, vs 5000 snapshots made from many sources) for balance times, I
> wouldn't call a large number of snapshots that unusual.

That's what this paragraph, just above the paragraph you quoted, was all 
about:

>> Tho that is of course per subvolume.  If you have multiple subvolumes
>> on the same filesystem, that can still end up being a thousand or two
>> snapshots per filesystem.  But those are all groups of something under
>> 300 (under 100 with hourly) highly connected to each other, with the
>> interweaving inside each of those groups being the real complexity in
>> terms of btrfs management.

IOW, if you thin down the snapshots per subvolume to something reasonable 
(under 300 for sure, preferably under 100), then depending on the number 
of subvolumes you're snapshotting, you might have a thousand or two.  
However, of those couple thousand, btrfs will only have to deal with the 
under 300 and preferably well under a hundred in the same group, that are 
snapshots of the same thing and thus related to each other, at any given 
time.  The other snapshots will be there but won't be adding to the 
complexity near as much since they're of different subvolumes and aren't 
logically interwoven together with the ones being considered at that 
moment.

But even then, at say 250 snapshots per subvolume, 2000 snapshots is 8 
independent subvolumes.  That could happen.  But 5000 snapshots?  That'd 
be 20 independent subvolumes, which is heading toward the extreme again.  
Yes it could happen, but better if it does to cut down on the per-
subvolume snapshots further, to say the 25 per subvolume I mentioned, or 
perhaps even further.  25 snapshots per subvolume with those same 20 
subvolumes... 500 snapshots total instead of 5000. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

