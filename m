Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:46030 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751202AbcCSANo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Mar 2016 20:13:44 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ah4WR-0004yD-Bj
	for linux-btrfs@vger.kernel.org; Sat, 19 Mar 2016 01:13:39 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 19 Mar 2016 01:13:39 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 19 Mar 2016 01:13:39 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Blocks changed since previous snapshot of subvolume
Date: Sat, 19 Mar 2016 00:13:34 +0000 (UTC)
Message-ID: <pan$7e7ac$bd9bc70$d69021d4$d407b0e8@cox.net>
References: <1458211640-13106-1-git-send-email-dsterba@suse.com>
	<loom.20160317T145003-730@post.gmane.org>
	<loom.20160317T213216-965@post.gmane.org>
	<loom.20160318T133531-909@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

sri posted on Fri, 18 Mar 2016 13:36:50 +0000 as excerpted:

> Henk Slager <eye1tm <at> gmail.com> writes:
> 
>> sri <toyours_sridhar <at> yahoo.co.in> writes:
>> > 
>> > I Would like to know between 2 snapshots of a subvolume, can we
>> > identify what all blocks modified particular to that subvolume ?
>> > 
>> > there can be many subvolume and snapshots present on the btrfs but i
>> > want only blocks modified since first snapshot for the specific
>> > subvolume.  blocks should include metadata and data blocks.
>> 
>> Not directly diff blocks, rather files, you could do something like
>> this:
>> 
>> btrfs subvolume find-new [...]
>> 
>> 
> Thank you. As I checked only blocks related to file are shown.
> 
> is there a way to get other blocks modified such as meta data such as
> inodes blocks modified and corresponding directory inode blocks along
> with files?

This would include the change data itself as well, and I'm not sure if 
the format once the actual binary level changes themselves are removed is 
practically consumable by humans or not, but it occurs to me that this is 
precisely the information that btrfs send -p provides.  If you can strip 
the changes themselves out and what's left is either human readable or 
can be processed to human readable, then it should be exactly what you're 
after, the changed blocks, for data and metadata both.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

