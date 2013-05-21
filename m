Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from atl4mhob04.myregisteredsite.com ([209.17.115.42]:32849 "EHLO
	atl4mhob04.myregisteredsite.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750967Ab3EUFU4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 May 2013 01:20:56 -0400
Received: from mailpod1.hostingplatform.com ([10.30.71.117])
	by atl4mhob04.myregisteredsite.com (8.14.4/8.14.4) with ESMTP id r4L5KsLB031338
	for <linux-btrfs@vger.kernel.org>; Tue, 21 May 2013 01:20:54 -0400
Message-ID: <519B043D.20805@chinilu.com>
Date: Mon, 20 May 2013 22:21:01 -0700
From: George Mitchell <george@chinilu.com>
Reply-To: george@chinilu.com
MIME-Version: 1.0
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
Subject: Re: Virtual Device Support
References: <518CFE3A.3080900@chinilu.com> <20130519171510.54897415@natsu> <262CC063-0DB4-45BD-A776-9FD1E8650E7C@colorremedies.com> <pan$d75cf$ec7daeb9$c2cc055b$98b478d0@cox.net> <519AD943.6060303@chinilu.com> <pan$9855$81c2d2df$c9aa1ca3$2451cc46@cox.net>
In-Reply-To: <pan$9855$81c2d2df$c9aa1ca3$2451cc46@cox.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/20/2013 08:59 PM, Duncan wrote:
> Then I ran into hardware issues that turned out to be bad caps on my 
> 8- year-old mobo (tho it was dual-socket first-gen opteron, which I 
> had upgraded to top-of-its-line dual-core Opteron 290s, thus four 
> cores @ 2.8 GHz, with 8 gigs RAM, so it wasn't as performance-dated as 
> its age might otherwise imply). However, those issues first appeared 
> as storage errors, so knowing the drives were aging, I thought it was 
> them, and I replaced, upgrading for the first time to 2.5" from the 
> older 3.5" drives.
And that is actually an advantage of using btrfs.  Because ... btrfs, 
unlike conventional RAID is very compatible and simple to use with 
SMART.  That way, by watching your system logs or journal, you are 
immediately aware of any hard drive issues.
> But meanwhile, the hardware problems continued, and I found the old 
> reiserfs was MUCH more stable under those conditions than btrfs, which 
> would often be missing entire directory trees after a crash, where 
> reiserfs would be missing maybe the last copied file or two. (I was 
> still trying to copy from the old raid1 to the new single device hard 
> drive, so was copying entire trees over... all on severely unstable 
> motherboard hardware that was frequently timing out SATA commands... 
> sometimes to resume after a couple minutes, sometimes not. Of course 
> at the time I was still blaming it on the old drives since that was 
> what I was copying from. It only became apparent that they weren't the 
> issue once I had enough on the new drive to try running from it with 
> the others detached.)
What can I say?  Hans Reiser, aside from his horrendous character flaws, 
is a software genius.  After a terrifying experience of having a hard 
drive fail and no backups, Hans Reiser and his helpers came to my aid 
and in short order I had all my data back intact.  I found that pretty 
impressive.  After that for a number of years I continued to use 
Reiserfs in a software RAID 1 configuration.  I never ever had any 
complaints about Reiserfs.  I really liked it and still do.  I really 
wanted to see Reiser4 see the light of day, but after Mr Reiser's 
incarceration, that has become more and more unlikely.  So, in 2009 I 
switch to hardware RAID 1 on a pair of old 3ware cards.  But file system 
RAID as offered by btrfs and zfs have the distinct advantage of not 
having to face those terrifying syncs after loss of a drive.  So now, as 
of April 2013, I am 100% on btrfs (well, almost).  I use 5 500GB Seagate 
2½" drives with all but boot filesystem (boot filesystem is spread 
across two Seagate 2½" 80GB drives formatted btrfs)  spread across them 
in RAID1 configuration. Additionally 100% of the content of those drives 
get backed up to another 500GB Seagate drive (formatted JFS) via cron 
every 3hrs AND to a 4TB Seagate drive (formatted btrfs raw, sans 
partitioning) via anacron daily, weekly, monthly, etc.  I also have a 
stripped down maintenance OS running on ext4 that I use to backup the 
main OS itself daily as a manual operation.  I am running this on a 
SuperMicro board with a dual core Pentium processor.  Not a particularly 
muscular system, but a VERY stable one.  I also use a small UPS unit 
which I think is a very good idea if you are doing write caching with 
btrfs, or any other filesystem for that matter. I use a CyberPower unit 
and CyberPower has a very nifty UPS tool for Linux which does 
auto-shutdown on low battery without intervention.

All in all I am very happy with this arrangement so far.  It has worked 
flawlessly in most respects and I really, really like btrfs. The two 
bugs in the ointment for me right now are 1) the infamous boot bug on 
kernel 3.8 whereby one gets repeated boot failures do to "open_ctree 
failure" and can only boot the system successfully after multiple 
attempts.  And 2) the btrfs incompatibilities like the umount issue 
which I script my way around by doing `mount -l` which provides both the 
LABEL and the mount point on the same line then `grep` out the label, 
extract the mount point with a `cut` and feed the verified mount point 
to `umount`.  That all works very sweet even if it is a bit clutzy.  And 
I am well enough aware of the dark side of all of this to steer clear of 
fatal moves with partitioning tools etc that don't have a clue that a 
mounted btrfs partition is ... a mounted btrfs partition even if it is 
NOT the mount point.  My only real concern at this point is the boot 
issue.  Overall, I have a lot less problems now than I did with hardware 
RAID and have not the least desire to go back.  btrfs could be better, 
but its still head and shoulders over any other approach I have tried, 
but that does not include zfs, which I have also heard very good things 
about.

