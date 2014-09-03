Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:50699 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750833AbaICEx5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 3 Sep 2014 00:53:57 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XP2Zr-0008Je-OM
	for linux-btrfs@vger.kernel.org; Wed, 03 Sep 2014 06:53:51 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 03 Sep 2014 06:53:51 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 03 Sep 2014 06:53:51 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Btrfs-progs-3.16: fs metadata is both single and dup?
Date: Wed, 3 Sep 2014 04:53:39 +0000 (UTC)
Message-ID: <pan$5f385$eac97af1$e9cf0e10$15446dc8@cox.net>
References: <pan.2014.09.02.12.05.33@googlemail.com>
	<20140902121349.GF18897@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hugo Mills posted on Tue, 02 Sep 2014 13:13:49 +0100 as excerpted:

> On Tue, Sep 02, 2014 at 12:05:33PM +0000, Holger Hoffstätte wrote:
>> 
>> I updated to progs-3.16 and noticed during testing:

>> root>mkfs.btrfs -f /dev/loop0

>> All fine until here..
>> 
>> root>btrfs filesystem df /tmp/btrfs
>> Data, single: total=8.00MiB, used=64.00KiB
>> System, DUP: total=8.00MiB, used=16.00KiB
>> System, single: total=4.00MiB, used=0.00
>> Metadata, DUP: total=409.56MiB, used=112.00KiB
>> Metadata, single: total=8.00MiB, used=0.00
> 
> Note that the "single" chunks are empty, and will remain so.
> 
>> So where does the confusing initial display come from? [I] don't
>> remember ever seeing this with btrfs-progs-3.14.2.
> 
>    Your memory is faulty, I'm afraid. It's always done that -- at
> least since I started using btrfs, several years ago.
> 
>    I believe it comes from mkfs creating a trivial basic filesystem
> (with the single profiles), and then setting enough flags on it that the
> kernel can bootstrap it with the desired chunks in it -- but I may be
> wrong about that.

Agreed.  It's an artifact of the mkfs.btrfs process and a btrfs fi df on 
a new filesystem always seems to have those extra unused single profile 
lines.

I got so the first thing I'd do on first mount was a balance -- before 
there was anything actually on the filesystem so it was real fast -- to 
get rid of those null entries.

Actually, I had already created a little mkfs.btrfs helper script that 
sets options I normally want, etc, and after doing the mkfs and balance 
drill a few times, I setup the script such that if at the appropriate 
prompt I give it a mountpoint to point balance at, it'll mount the 
filesystem and immediately run a balance, thus automating things and 
making the balance part of the same scripted process that does the 
mkfs.btrfs in the first place.

IOW, those null-entry lines bother me too... enough that even tho I know 
what they are I arranged things so they're automatically and immediately 
eliminated and I don't have to see 'em! =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

