Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:57008 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756442AbcBHVwy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 8 Feb 2016 16:52:54 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
	by mailout.nyi.internal (Postfix) with ESMTP id B358520831
	for <linux-btrfs@vger.kernel.org>; Mon,  8 Feb 2016 16:44:19 -0500 (EST)
Received: from ebox.rath.org (ebox.rath.org [45.79.69.51])
	by mail.messagingengine.com (Postfix) with ESMTPA id 5DAE7C00012
	for <linux-btrfs@vger.kernel.org>; Mon,  8 Feb 2016 16:44:19 -0500 (EST)
Received: from thinkpad.rath.org (thinkpad [192.168.12.2])
	by ebox.rath.org (Postfix) with ESMTPS id 872B01CC73C
	for <linux-btrfs@vger.kernel.org>; Mon,  8 Feb 2016 21:44:18 +0000 (UTC)
From: Nikolaus Rath <Nikolaus@rath.org>
To: linux-btrfs@vger.kernel.org
Subject: Re: Use fast device only for metadata?
References: <874mdktk4t.fsf@vostro.rath.org>
	<20160207210713.7e4661a8@jupiter.sol.kaishome.de>
	<1507413.RERLDqpHyU@merkaba>
Date: Mon, 08 Feb 2016 13:44:17 -0800
In-Reply-To: <1507413.RERLDqpHyU@merkaba> (Martin Steigerwald's message of
	"Sun, 07 Feb 2016 21:59:48 +0100")
Message-ID: <87twliri6m.fsf@thinkpad.rath.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Feb 07 2016, Martin Steigerwald <martin@lichtvoll.de> wrote:
> Am Sonntag, 7. Februar 2016, 21:07:13 CET schrieb Kai Krakow:
>> Am Sun, 07 Feb 2016 11:06:58 -0800
>> 
>> schrieb Nikolaus Rath <Nikolaus@rath.org>:
>> > Hello,
>> > 
>> > I have a large home directory on a spinning disk that I regularly
>> > synchronize between different computers using unison. That takes ages,
>> > even though the amount of changed files is typically small. I suspect
>> > most if the time is spend walking through the file system and checking
>> > mtimes.
>> > 
>> > So I was wondering if I could possibly speed-up this operation by
>> > storing all btrfs metadata on a fast, SSD drive. It seems that
>> > mkfs.btrfs allows me to put the metadata in raid1 or dup mode, and the
>> > file contents in single mode. However, I could not find a way to tell
>> > btrfs to use a device *only* for metadata. Is there a way to do that?
>> > 
>> > Also, what is the difference between using "dup" and "raid1" for the
>> > metadata?
>> 
>> You may want to try bcache. It will speedup random access which is
>> probably the main cause for your slow sync. Unfortunately it requires
>> you to reformat your btrfs partitions to add a bcache superblock. But
>> it's worth the efforts.
>> 
>> I use a nightly rsync to USB3 disk, and bcache reduced it from 5+ hours
>> to typically 1.5-3 depending on how much data changed.
>
> An alternative is using dm-cache, I think it doesn´t need to recreate the 
> filesystem.

Yes, I tried that already but it didn't improve things at all. I wrote a
message to the lvm list though, so maybe someone will be able to help.

Otherwise I'll give bcache a shot. I've avoided it so far because of the
need to reformat and because of rumours that it doesn't work well with
LVM or BTRFS. But it sounds as if that's not the case..


Best,
-Nikolaus

-- 
GPG encrypted emails preferred. Key id: 0xD113FCAC3C4E599F
Fingerprint: ED31 791B 2C5C 1613 AF38 8B8A D113 FCAC 3C4E 599F

             »Time flies like an arrow, fruit flies like a Banana.«
