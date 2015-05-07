Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:50789 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751135AbbEGDn7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 6 May 2015 23:43:59 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YqCj3-000594-EY
	for linux-btrfs@vger.kernel.org; Thu, 07 May 2015 05:43:53 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 07 May 2015 05:43:53 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 07 May 2015 05:43:53 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs send/receive for backup of subvolumes
Date: Thu, 7 May 2015 03:43:38 +0000 (UTC)
Message-ID: <pan$bd072$7354a39e$575b04ce$653d5c8a@cox.net>
References: <loom.20150505T131847-769@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

sri posted on Tue, 05 May 2015 11:30:27 +0000 as excerpted:

> Hi
> 
> My query speicific to incremental backup/recovery with btrfs
> send/receive option available for btrfs subvolume backups.
> 
> say i have /b1/s1 subvolume and snapshot of s1 is /b1/snap1_s1
> 
> I run btrfs send /b1/snap_s1 | btrfs receive /backup where /backup is my
> backup btrfs file system.
> 
> 
> Now I will take snapshot of s1 again ( after modifiying data in s1)
> which is /b1/snap2_s1
> 
> Using btrfs send -p snap1_s1 snap2_s2 and destination as /backup I can
> send incremental to backup store.
> 
> My question is is there a way I can have option recover files from
> /backup from incremental backup or full backup (i.e. from copy of
> snap2_s1 or snap1_s1)
> 
> And I do not want to make 2 copies of 1 full and 1 incremetal backup
> since if full backup is 1Gb and if there is 0.6Gb change for
> incremental, I would like to backup only difference for incremental
> backup but still would able to get option to recover files from full or
> incremental from backedup subvolume.
> 
> is there a way I can achieve this using current btrfs send/receive and
> other snapshot and tracking options?

>From a later post it looks like you  probably figured this out on your 
own.  But in case you didn't and for others who may google this thread...

Disclaimer: While I'm a btrfs user and list regular, I'm not a btrfs dev, 
and my own use-case doesn't involve send/receive, so while the following 
is as I understand the functionality based on the wiki documentation and 
previous list discussion, I've never used send/receive myself, so if 
actual functionality appears to conflict with the below, consider me 
wrong and go with actual functionality...

AFAIK, when you btrfs receive a send, btrfs creates a subvolume 
duplicating the one being sent from the send side.

So in the scenario above, you should end up with two different snapshots 
under /backup, one for s1 and one for s2.  Due to the parent relationship 
and the fact that btrfs is copy-on-write, where extents in s1 and s2 
differ, the difference is sent (as a copy of the new extent along with 
metadata describing its place in reference to the parent) and the 
snapshots occupy the space used by both.  Where they do NOT differ, there 
is no difference to send, and the snapshots share the space, so while 
either one can be accessed, they're actually referencing the same shared 
extent and only that shared copy of that extent exists.

So as long as you keep both snapshots, you can access both, but given 1 
GiB in snap_s1 and 0.6 GiB worth of changes between it and snap_s2, the 
total space used by the two should still be only 1.6 GiB, even tho you 
can access the full 1 GiB of either snapshot.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

