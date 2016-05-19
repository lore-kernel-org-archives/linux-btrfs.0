Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:38020 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750790AbcESEJp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 May 2016 00:09:45 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1b3FHK-0006pl-A7
	for linux-btrfs@vger.kernel.org; Thu, 19 May 2016 06:09:42 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 19 May 2016 06:09:42 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 19 May 2016 06:09:42 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Reducing impact of periodic btrfs balance
Date: Thu, 19 May 2016 04:09:31 +0000 (UTC)
Message-ID: <pan$549b5$526f9b98$5d8778de$5121c19f@cox.net>
References: <573C6E47.2080109@cobb.uk.net>
	<d40d8fc7-3766-1ccc-3253-9f870a0f4f85@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Qu Wenruo posted on Thu, 19 May 2016 09:33:19 +0800 as excerpted:

> Graham Cobb wrote on 2016/05/18 14:29 +0100:
>> Hi,
>>
>> I have a 6TB btrfs filesystem I created last year (about 60% used).  It
>> is my main data disk for my home server so it gets a lot of usage
>> (particularly mail). I do frequent snapshots (using btrbk) so I have a
>> lot of snapshots (about 1500 now, although it was about double that
>> until I cut back the retention times recently).
> 
> Even at 1500, it's still quite large, especially when they are all
> snapshots.
> 
> The biggest problem of large amount of snapshots is, it will make any
> backref walk operation very slow. (O(n^3)~O(n^4))
> This includes: btrfs qgroup and balance, even fiemap (recently submitted
> patch will solve fiemap problem though)
> 
> The btrfs design ensures snapshot creation fast, but that comes with the
> cost of backref walk.
> 
> 
> So, unless some super huge rework, I would prefer to keep the number of
> snapshots to a small amount, or avoid balance/qgroup.

Qu and Graham,

As you may have seen on my previous posts, my normal snapshots 
recommendation is to try to keep under 250-300 per subvolume, and 
definitely under 3000 max, 2000 preferably, and 1000 if being 
conservative, per filesystem, thus allowing snapshotting of 6-8 
subvolumes per filesystem before hitting the filesystem cap, due to 
scaling issues like the above that are directly related to number of 
snapshots.  

Also, recognizing that the btrfs quota code dramatically compounds the 
scaling issues, as well as because of the btrfs quota functionality still 
never actually working fully correctly on btrfs, I recommend turning it 
off unless it's definitely and specifically known to be needed, and if 
it's actually needed, I recommend strong consideration be given to use of 
a more mature filesystem where quotas are known to work reliably without 
the scaling issues they present on btrfs.


So to Graham, are these 1.5K snapshots all of the same subvolume, or 
split into snapshots of several subvolumes?  If it's all of the same 
subvolume or of only 2-3 subvolumes, you still have some work to do in 
terms of getting down to recommended snapshot levels.  Also, if you have 
quotas on and don't specifically need them, try turning them off and see 
if that alone makes it workable.

It's worth noting that a reasonable snapshot thinning program can help 
quite a bit here, letting you still keep a reasonable retention, and that 
250-300 snapshots per subvolume fits very well within that model.  
Consider, if you're starting with say hourly snapshots, a year or even 
three months out, are you really going to care what specific hourly 
snapshot you retrieve a file from, or would daily or weekly snapshots do 
just as well and actually make finding an appropriate snapshot easier as 
there's less to go thru?

Generally speaking, most people starting with hourly snapshots can delete 
every other snapshot, thinning by at least half, within a day or two, and 
those doing snapshots even more frequently can thin down to at least 
hourly within hours even, since if you haven't noticed a mistaken 
deletion or whatever within a few hours, chances are good that recovery 
from hourly snapshots is more than practical, and if you haven't noticed 
it within a day or two, recovery from say two-hourly or six-hourly 
snapshots will be fine.  Similarly, a week out, most people can thin to 
twice-daily or daily snapshots, and by 4 weeks out, perhaps to Monday/
Wednesday/Friday snapshots.  By 13 weeks (one quarter) out, weekly 
snapshots are often fine, and by six months (26 weeks) out, thinning to 
quarterly (13-week) snapshots may be practical.  If not, it certainly 
should be within a year, tho well before a year is out, backups to 
separate media should have taken over allowing the oldest snapshots be 
dropped, finally reclaiming the space they were keeping locked up.


And primarily to Qu...

Is that 2K snapshots overall filesystem cap recommendation still too 
high, even if per-subvolume snapshots are limited to 300-ish?  Or is the 
real problem per-subvolume snapshots, and as long as snapshots are 
limited to 300ish per subvolume, for people who have gone subvolume mad 
and have say 50 separate subvolumes being snapshotted (perhaps not too 
unreasonable in a VM context with each VM on its own subvolume), if a 
300ish cap per subvolume is maintained, the 15K total snapshots per 
filesystem should still work reasonably well, so I should be able to drop 
the overall filesystem cap recommendation and simply recommend a per-
subvolume snapshot cap of a few hundred?

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

