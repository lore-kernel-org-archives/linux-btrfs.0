Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54967 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750790AbcAOP0B (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Jan 2016 10:26:01 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aK6GB-0000aI-23
	for linux-btrfs@vger.kernel.org; Fri, 15 Jan 2016 16:25:55 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Jan 2016 16:25:55 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Jan 2016 16:25:55 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Recursive delete file from all subvolumes (snapshots)
Date: Fri, 15 Jan 2016 15:25:45 +0000 (UTC)
Message-ID: <pan$96882$cf03c2f8$4732e856$90f35253@cox.net>
References: <15624885.ucZm0n36hp@discus> <20160115140539.3afa66f0@natsu>
	<pan$cd84a$7dd8a74d$a2b00ed6$e26c6f75@cox.net> <5247876.zUN2tVm85X@discus>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Wolfgang Mader posted on Fri, 15 Jan 2016 14:33:27 +0100 as excerpted:

>> Of course that implies that the root containing all the snapshots is
>> itself mounted or otherwise nested in the mounted tree, somewhere.  The
>> recommendation is to keep it unmounted and not directly accessible, by
>> default, only mounting the snapshots root when you are directly working
>> with the snapshots.
> 
> As far as I know, snapper puts its snapshots under .snapshots in the
> root of the snapshoted subvolume. As I want to work with the subvolume,
> it is mounted,
> and with it its snapshots. So, according to your answer, I should figure
> out how to change the location at which snapper places its snapshots.
> The subvolumes snapper creates as ro, which gives some protection
> against unwanted changes.

There's a suggested layout on the wiki:

https://btrfs.wiki.kernel.org/index.php/SysadminGuide#Managing_Snapshots

I'd suggest something like the "even flatter" layout, since it emphasizes 
that snapshots are simply subvolumes that happen to be a snapshot of 
whatever subvolume at some particular moment.

That way, as the wiki discusses, rolling back is simply a matter of 
mounting the appropriate snapshot in place of the what was the working 
copy.

Tho you do have to ensure that toplevel (ID 5) is mounted any time you're 
working with snapshots, which means the snapshot creation script (snapper 
for you I guess) would need to mount it before taking the snapshot, and 
umount it after -- probably using a lockfile to determine whether it 
should umount, so you could create that lockfile any time you're working 
with toplevel mounted manually, to keep the hourly snapshot script from 
umounting it.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

