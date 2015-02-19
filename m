Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:48002 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752018AbbBSXRl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Feb 2015 18:17:41 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YOaLk-0003hs-1i
	for linux-btrfs@vger.kernel.org; Fri, 20 Feb 2015 00:17:40 +0100
Received: from ip18864262.dynamic.kabel-deutschland.de ([24.134.66.98])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Feb 2015 00:17:40 +0100
Received: from hurikhan77 by ip18864262.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Feb 2015 00:17:40 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: BTRFS hot relocation not merged
Date: Fri, 20 Feb 2015 00:07:33 +0100
Message-ID: <lu6irb-klc.ln1@hurikhan77.spdns.de>
References: <54E5CDD1.9040909@gmx.de> <pan$e6dc2$a63e8c87$78de93c6$7e62ee60@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Duncan <1i5t5.duncan@cox.net> schrieb:

> Max Schettler posted on Thu, 19 Feb 2015 12:49:37 +0100 as excerpted:
> 
>> I recently was looking for the status of hot relocation on btrfs.
>> There seemed to be some activity on the mailinglist around 5/2013
>> regarding patches that should provide the functionality.
>> However they have not been merged yet and there hasn`t been further
>> discussion about them (to my knowledge).
>> What is the status of hot relocation?
> 
> The current suggestion is to use something like bcache or dmcache in
> tandem with btrfs.  I'm not sure of dmcache/btrfs status, but there are
> people actually using bcache/btrfs here on this list, with the reports
> I've read generally very positive.

Yes, here's one! :-)

[...]
> There's also this rather vague comment on the wiki, on the main page,
> under Features, additional features in development or planned (so closer
> to News, then scroll up a bit)...
> 
> * Hot data tracking and moving to faster devices (currently being pushed
> as a generic feature available through VFS)
> 
> https://btrfs.wiki.kernel.org/index.php/Main_Page#News
> 
> (and scroll up a bit)
> 
> I'm not sure if that refers to bcache and similar, or something else, tho
> I didn't check the talk and history pages, which may have a hint...

Actually, bcache does not implement hot data tracking. It more or less acts 
as a huge scheduler (so it is in a range with deadline/cfq/... and friends) 
and thus minimizes seek times as its primary focus. This is achieved by 
trying to detect random reads and optionally writes, and caching those in a 
log structured file systems by using access patterns optimized for non-
rotational media. Optionally cached writes are written back lazily in the 
background and reordered to minimize seek and maximize throuput to the 
rotational media. Linear access patterns are directly passed through to the 
rotational media as they are not that bad for those kind of access patterns 
(at least compared with past-generation SSDs). In that regard, even a good 
USB stick could do as a cache, or an internal card reader - tho I'd probably 
strongly recommend against using it.

The nice thing is, that this way, bcache can combine mixed fast SSD random 
access patterns and linear HDD access patterns into one stream with summed 
transfer rates. So it is by definition faster than plain HDD access on its 
own.

But it even goes beyond: The read and write latencies of the cache devices 
are measured, and if it goes above a certain threshold, it will fall back 
fetching the data from the slower device which probably will, and this is a 
heuristic, have the data ready faster then the congested caching device. 
This is pretty neat, as it adds benefit to the summed transfer rates.

With this, if I can trust ksysguard, I get transfer rates of up to 800 MB/s 
in a bcache+3xbtrfs(mraid1,draid0) setup, tho most times it peaks at around 
150 MB/s where I had around 80 MB/s usual peaks without bcache. But this is 
not the main benefit. My access latencies and IO queue depths have gone down 
to virtually zero. And this is probably where the most speedup comes from.

System boot (on systemd, with services like postfix and mariadb, using 
autodefrag and readahead) went down from around 60s to 5s (measured in 
systemd-analyze critical path), with almost no seeking sounds from the 
harddisks. KDE starts a lot faster now (maybe another 60-80s down to around 
10s) and is instantly responsive with all panels, backgrounds and icons 
loaded when the splash fades out while I had a black background and a lot of 
ongoing IO previously after splash faded out.

The cache hit rate is usually above 80% with an 80 GB bcache partition for a 
3x 1TB btrfs volume. My SSD is specified with 550 MB/s reading and 150 MB/s 
writing. Measured it's lower (around 480/130) but still faster than HDD even 
at linear writing.

I'm using writeback. And I had no data loss or inconsistencies yet, even I 
had to hard reboot one time or another. But btrfs without bcache has also 
been rock solid for me in the past few months wrt hard reboots or powerloss. 
Some people actually say, with bcache the probability of loosing data should 
be potentially lower as the data is faster on stable storage and thus 
transactions on btrfs can be closed faster. While bcache will still be in 
dirty state, it will write back data later and replay its log if it didn't 
finish before rebooting. Well, bcache is always in dirty state, by design.

I just wonder what role bcache would play in writeback mode and btrfs-raid 
scenario as a single bcache device covers multiple btrfs devices when btrfs 
itself assumes (and only sees) multiple devices - but it's actually one when 
passed through bcache first. Write errors may go undetected (because bcache 
writes behind) while btrfs still sees good data from the cache. But btrfs 
checksums should probably handle this anyways... I'm not sure. Maybe bcache 
should not allow reading blocks from the cache which are going to be written 
back, and then evict written blocks from the cache before those need to be 
read again from the backing device. It would ensure that btrfs really sees 
what is on the platter instead of what's maybe cached. Probably in the end, 
it's the same problem as bit-rot when bcache and HDD unkowningly don't match 
and later bcache evicts good data from cache and leaves bad data behind.

Ahh, complicated... ;-)

But I trust bcache by now though I didn't forcibly try the big disasters (by 
cutting the power cord during heavy IO or similar funny things). And 
nevertheless, I still have my daily backups around. ;-)

Altogehter, I wonder if having a real hot data cache would bring so much 
additional benefit. Maybe only when it's huge and when it's really fast (I 
mean those SSDs capable of doing 500+ MB/s at reading AND writing).

-- 
Replies to list only preferred.

