Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:39663 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751985AbcDEChP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Apr 2016 22:37:15 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1anGrc-0008OS-DV
	for linux-btrfs@vger.kernel.org; Tue, 05 Apr 2016 04:37:08 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 05 Apr 2016 04:37:08 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 05 Apr 2016 04:37:08 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Scrub priority, am I using it wrong?
Date: Tue, 5 Apr 2016 02:37:01 +0000 (UTC)
Message-ID: <pan$603b6$4c4f876d$1daf06de$ec75378d@cox.net>
References: <CA+WRLO-vu4B8X3Td12F0gueU70G6KwjRTD07MNwDrJfodAscNA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Gareth Pye posted on Tue, 05 Apr 2016 09:36:48 +1000 as excerpted:

> I've got a btrfs file system set up on 6 drbd disks running on 2Tb
> spinning disks. The server is moderately loaded with various regular
> tasks that use a fair bit of disk IO, but I've scheduled my weekly btrfs
> scrub for the best quiet time in the week.
> 
> The command that is run is:
> /usr/local/bin/btrfs scrub start -Bd -c idle /data
> 
> Which is my best attempt to try and get it to have a low impact on user
> operations
> 
> But iotop shows me:
> 
> 1765 be/4 root       14.84 M/s    0.00 B/s  0.00 % 96.65 % btrfs scrub
> start -Bd -c idle /data
>  1767 be/4 root       14.70 M/s    0.00 B/s  0.00 % 95.35 % btrfs
> scrub start -Bd -c idle /data
>  1768 be/4 root       13.47 M/s    0.00 B/s  0.00 % 92.59 % btrfs
> scrub start -Bd -c idle /data
>  1764 be/4 root       12.61 M/s    0.00 B/s  0.00 % 88.77 % btrfs
> scrub start -Bd -c idle /data
>  1766 be/4 root       11.24 M/s    0.00 B/s  0.00 % 85.18 % btrfs
> scrub start -Bd -c idle /data
>  1763 be/4 root        7.79 M/s    0.00 B/s  0.00 % 63.30 % btrfs
> scrub start -Bd -c idle /data
> 28858 be/4 root        0.00 B/s  810.50 B/s  0.00 % 61.32 % [kworker/
u16:25]
> 
> 
> Which doesn't look like an idle priority to me. And the system sure
> feels like a system with a lot of heavy io going on. Is there something
> I'm doing wrong?

Two points:

1) It appears btrfs scrub start's -c option only takes numeric class, so 
try -c3 instead of -c idle.

Works for me with the numeric class (same results as you with spelled out 
class), tho I'm on ssd with multiple independent btrfs on partitions, the 
biggest of which is 24 GiB, 18.something GiB used, which scrubs in all of 
20 seconds, so I don't need and hadn't tried the -c option at all until 
now. 

2) What a difference an ssd makes!

$$ sudo btrfs scrub start -c3 /p
scrub started on /p, [...]

$$ sudo iotop -obn1
Total DISK READ :     626.53 M/s | Total DISK WRITE :       0.00 B/s
Actual DISK READ:     596.93 M/s | Actual DISK WRITE:       0.00 B/s
 TID  PRIO  USER     DISK READ  DISK WRITE  SWAPIN      IO    COMMAND
 872 idle root      268.40 M/s    0.00 B/s  0.00 %  0.00 % btrfs scrub 
start -c3 /p
 873 idle root      358.13 M/s    0.00 B/s  0.00 %  0.00 % btrfs scrub 
start -c3 /p

CPU bound, 0% IOWait even at idle IO priority, in addition to the 
hundreds of M/s values per thread/device, here.  You OTOH are showing 
under 20 M/s per thread/device on spinning rust, with an IOWait near 90%, 
thus making it IO bound.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

