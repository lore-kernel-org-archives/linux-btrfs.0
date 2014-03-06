Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fw5a-delaine.wadns.net ([196.220.39.203]:61278 "EHLO
	fw5a.wadns.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751645AbaCFVSj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Mar 2014 16:18:39 -0500
Message-ID: <5318E605.9060802@swiftspirit.co.za>
Date: Thu, 06 Mar 2014 23:17:57 +0200
From: Brendan Hide <brendan@swiftspirit.co.za>
MIME-Version: 1.0
To: Eric Mesa <ericsbinaryworld@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: Understanding btrfs and backups
References: <loom.20140306T202159-329@post.gmane.org>
In-Reply-To: <loom.20140306T202159-329@post.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2014/03/06 09:27 PM, Eric Mesa wrote:
> Brian Wong wrote: a snapshot is different than a backup
> [snip]
>
> ...
>
> Three hard drives: A, B, and C.
>
> Hard drives A and B - btrfs RAID-1 so that if one drive dies I can keep
> using my system until the replacement for the raid arrives.
>
> Hard drive C - gets (hourly/daily/weekly/or some combination of the above)
> snapshots from the RAID. (Starting with the initial state snapshot) Each
> timepoint another snapshot is copied to hard drive C.
>
> [snip]...
>
> So if that's what I'm doing, do snapshots become a way to do backups?
An important distinction for anyone joining the conversation is that 
snapshots are *not* backups, in a similar way that you mentioned that 
RAID is not a backup. If a hard drive implodes, its snapshots go with it.

Snapshots can (and should) be used as part of a backup methodology - and 
your example is almost exactly the same as previous good backup 
examples. I think most of the time there's mention of an external 
"backup server" keeping the backups, which is the only major difference 
compared to the process you're looking at. Btrfs send/receive with 
snapshots can make the process far more efficient compared to rsync. 
Rsync doesn't have any record as to what information has changed so it 
has to compare all the data (causing heavy I/O). Btrfs keeps a record 
and can skip to the part of sending the data.

I do something similar to what you have described on my Archlinux 
desktop - however I haven't updated my (very old) backup script to take 
advantage of btrfs' send/receive functionality. I'm still using rsync. :-/
/ and /home are on btrfs-raid1 on two smallish disks
/mnt/btrfs-backup is on btrfs single/dup on a single larger disk

See https://btrfs.wiki.kernel.org/index.php/Incremental_Backup for a 
basic incremental methodology using btrfs send/receive

-- 
__________
Brendan Hide
http://swiftspirit.co.za/
http://www.webafrica.co.za/?AFF1E97

