Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from atl4mhfb01.myregisteredsite.com ([209.17.115.55]:56232 "EHLO
	atl4mhfb01.myregisteredsite.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754282Ab3EDSkw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 4 May 2013 14:40:52 -0400
Received: from atl4mhob10.myregisteredsite.com (atl4mhob10.myregisteredsite.com [209.17.115.48])
	by atl4mhfb01.myregisteredsite.com (8.14.4/8.14.4) with ESMTP id r44Iep5r003372
	for <linux-btrfs@vger.kernel.org>; Sat, 4 May 2013 14:40:51 -0400
Received: from mailpod1.hostingplatform.com ([10.30.71.118])
	by atl4mhob10.myregisteredsite.com (8.14.4/8.14.4) with ESMTP id r44IduaD021786
	for <linux-btrfs@vger.kernel.org>; Sat, 4 May 2013 14:39:56 -0400
Message-ID: <518555FF.4020704@chinilu.com>
Date: Sat, 04 May 2013 11:39:59 -0700
From: George Mitchell <george@chinilu.com>
Reply-To: george@chinilu.com
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Scrub CPU usage ...
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I just subscribed to this list so in case this subject has already been 
discussed at length, my apologies.  I have been waiting for btrfs 
forever.  I have been waiting for it to become reasonably stable.  In 
the wake of escalating problems with my old hardware RAID setup, I 
decided now was the time to make the transition.  At this point I have 
been completely transitioned to btrfs for nearly a month with the only 
exception being a backup mirror drive formatted jfs that gets mounted 
and updated hourly via cron'd rsync and then immediately unmounted until 
the next update.  I am using btrfs raid 1 across five 500GB Seagate 
nearline drives and btrfs single on a Seagate 4TB backup drive.  I am 
absolutely delighted with how this system is working.  This is my 
primary day in and day out system.  I have to date hard crashed this 
system at least three times without sustaining any apparent damage to 
the filesystems.  Perhaps I have just been extremely lucky, but it seems 
like most of the major holes have been closed at this point.  Actually I 
have only two significant issues currently with btrfs.

1)  The system fails to boot intermittently due to dracut/initrd issues 
(btrfs: open_ctree failed).  This is being worked on upstream and I am 
seeing a continual flow of patches addressing it, but so far no fix.  
This will take time to fix and it usually leaps to life in 3 attempts or 
less.

2)  My real concern is scrub CPU usage.  Running a scrub simply exhausts 
all available CPU and make they system nearly unusable.  In my case I 
have a whole lot more hard drive resources that CPU resources, so it is 
CPU that gets saturated.  My question is, is there anything being done 
upstream to address this issue?  Like, for example, a command line 
option to limit CPU usage to some predetermined %?  Or, better yet, some 
sort of intellegence that would cause scrub to back off in deference to 
user usage?  I am thinking that this should be something that can happen 
in the background and take twice as long as it does now, but allow other 
processes room to fly at the same time.  Of the few issues I am 
currently facing with btrfs, this is probably the most irritating one 
for me right now.

There are other minor issues that I am seeing that are almost completely 
related to existing utilities not understanding btrfs. These are 
problems that need to be solved by the maintainers of those specific 
utilities.  I am not worried about these.

Thanks for any thoughts anyone might have on these issues!
