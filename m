Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:60006 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750829AbaCFSUH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 6 Mar 2014 13:20:07 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WLctn-000665-1f
	for linux-btrfs@vger.kernel.org; Thu, 06 Mar 2014 19:20:03 +0100
Received: from 63.239.65.11 ([63.239.65.11])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 06 Mar 2014 19:20:03 +0100
Received: from ericsbinaryworld by 63.239.65.11 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 06 Mar 2014 19:20:03 +0100
To: linux-btrfs@vger.kernel.org
From: Eric Mesa <ericsbinaryworld@gmail.com>
Subject: Understanding btrfs and backups
Date: Thu, 6 Mar 2014 18:18:15 +0000 (UTC)
Message-ID: <loom.20140306T191655-366@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

apologies if this is a resend - it appeared to me that it was rejected
because of something in how Gmail was formatting the message. I can't find
it in the Gmane archives which leads me to believe it was never delivered.

I was hoping to gain some clarification on btrfs snapshops and how they
function as backups.

I did a bit of Googling and found lots of examples of bash commands, but no
one seemed to explain what was going on to a level that would satisfy me for
my data needs.

I read this Ars Technica article today
http://arstechnica.com/information-technology/2014/01/bitrot-and-atomic-cows-inside-next-gen-filesystems/

First of all, the btrfs-raid1 sounds awesome. Because it helps protect
against one of RAID1's failings - bit rot issues. But raid1 is not backup,
it's just redundancy.

Second, the article mentions using snapshots as a backup method. Page 3
section: Using the features.

He makes a snapshot and sends that. Then he sends what changed the second
time. He mentions that because btrfs knows what's changed it's a quick process.

Right now on my Linux computer I use Back in Time which, I think, is just an
rsync frontend. It takes a long time to complete the backup for my 1 TB
/home drive. The copy part is nice and quick, but the comparison part takes
a long time and hammers the CPU. I have it setup to run at night because if
it runs while I'm using the computer, things can crawl.

So I was wondering if btrfs snapshots are a substitute for this. Right now
if I realize I deleted a file 5 days ago, I can go into Back in Time (the
gui) or just navigate to it on the backup drive and restore that one file.
>From what I've read about btrfs, I'd have to restore the entire home drive,
right? Which means I'd lose all the changes from the past five days. If
that's the case, it wouldn't really solve my problem - although maybe I'm
just not thinking creatively.

Also, if I first do the big snapshot backup and then the increments, how do
I delete the older snapshots? In other words, the way I'm picturing things
working is that I have the main snapshot and every snapshot after that is
just a description of what's changed since then. So wouldn't the entire
chain be necessary to reconstruct where I'm at now?

On a somewhat separate note, I have noticed that many people/utilities for
btrfs mention making snapshots every hour. Are the snapshots generally that
small that such a think wouldn't quickly fill a hard drive?

Thanks for reading my questions, I appreciate the help. When all is said and
done I'd certainly like to publish a how-to from my point of undertanding.


--
Eric Mesa

