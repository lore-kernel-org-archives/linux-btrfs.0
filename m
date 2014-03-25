Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:37266 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752846AbaCYMOE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Mar 2014 08:14:04 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WSQF0-0004eg-1Z
	for linux-btrfs@vger.kernel.org; Tue, 25 Mar 2014 13:14:02 +0100
Received: from cpc21-stap10-2-0-cust974.12-2.cable.virginm.net ([86.0.163.207])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Mar 2014 13:14:02 +0100
Received: from m_btrfs by cpc21-stap10-2-0-cust974.12-2.cable.virginm.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Mar 2014 13:14:02 +0100
To: linux-btrfs@vger.kernel.org
From: Martin <m_btrfs@ml1.co.uk>
Subject: Re: How to debug very very slow file delete? (btrfs on md-raid5)
Date: Tue, 25 Mar 2014 12:13:50 +0000
Message-ID: <lgrrtf$el3$1@ger.gmane.org>
References: <20140325014956.GG11533@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
In-Reply-To: <20140325014956.GG11533@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 25/03/14 01:49, Marc MERLIN wrote:
> I had a tree with some amount of thousand files (less than 1 million)
> on top of md raid5.
> 
> It took 18H to rm it in 3 tries:


> Data, single: total=3.28TiB, used=2.70TiB
> System, DUP: total=8.00MiB, used=384.00KiB
> System, single: total=4.00MiB, used=0.00
> Metadata, DUP: total=73.50GiB, used=62.46GiB
> Metadata, single: total=8.00MiB, used=0.00
> 
> This is running from
> md8 : active raid5 sdf1[6] sdb1[5] sda1[3] sde1[2] sdd1[1]
>       7814045696 blocks super 1.2 level 5, 512k chunk, algorithm 2 [5/5] [UUUUU]
>       bitmap: 0/15 pages [0KB], 65536KB chunk
> 
> The filesystem is pretty new, it shouldn't be fragmented much.


> The problem does not seem to be just rm though, du is taking way way too
> long too. I started one, it's been running for 30mn now.
> Interestingly, sending ^C to that du takes 15 seconds to respond, so it
> seems that each system call is just slow.
> 
> I checked that btrfs scrub is not running.
> What else can I check from here?

"noatime" set?

What's your cpu hardware wait time?


And is not *the 512kByte raid chunk* going to give you horrendous write
amplification?! For example, rm updates a few bytes in one 4kByte
metadata block and the system has to then do a read-modify-write on
512kBytes...

Also, the 64MByte chunk bit-intent map will add a lot of head seeks to
anything you do on that raid. (The map would be better on a separate SSD
or other separate drive.)

So... That sort of setup is fine for archived data that is effectively
read-only. You'll see poor performance for small writes/changes.


Hope that helps,
Martin



