Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:57946 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047AbaEWAXQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 22 May 2014 20:23:16 -0400
Date: Thu, 22 May 2014 17:22:43 -0700
From: Marc MERLIN <marc@merlins.org>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: 3.15.0-rc5: btrfs and sync deadlock: call_rwsem_down_read_failed
 / balance seems to create locks that block everything else
Message-ID: <20140523002243.GE12312@merlins.org>
References: <20140522090921.GA12037@merlins.org>
 <20140522131528.GB22952@merlins.org>
 <pan$ed92c$6d9566f6$dd2041b0$f135597e@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <pan$ed92c$6d9566f6$dd2041b0$f135597e@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 22, 2014 at 08:52:34PM +0000, Duncan wrote:
> > It's been running for at least 15mn in 'cancel mode'. Is that normal?
> 
> I'd guess so.  It's probably in the middle of operations for a single 
> chunk, and only checks for cancel between chunks.  Given the possible 
> complexity of those operations with snapshotting and quotas factored in 
> as well as COW fragmentation, 15 minutes on a single chunk isn't 
> /entirely/ out there.

That's probably what I saw indeed.
 
> That being symptomatic of the whole performance problem they're battling 
> ATM.  They've turned off snapshot-aware-defrag for the time being, and 
> there's the quota handling rework in the pipeline, but...

Right. I'm just surprised that sync would hang too. That feels pretty
bad.

> I've seen patches for at least one related race-related problem (where 
> snapshot deletion could collide with balance or send) go by, and don't 
> believe it's in Linus-mainline yet, tho I haven't closely tracked status 
> beyond that.
 
That's indeed what I've been seeing and since I have snapshots and btrfs
send both from cron, I'm hitting this too often :(
If god forbid scrub kicks in from cron too, then I'm toast.

> Basically, at this point running only one such "major" btrfs operation at 
> a time should drastically reduce the possibility of problems, because 
> there /are/ known races.  Even after the known races are fixed, it's 
> probably a good idea anyway where possible, since just one such operation 
> is complex enough and running more than one at a time is only going to 
> slow them all down as well as requiring more CPU/IO/memory bandwidth, but 
> there /is/ recognition of the very real likelihood that people /will/ end 
> up doing it, especially since one or more of the operations may be cron 

The thing is that scrub takes hours to run.
I run btrfs send and snapshots once an hour for backups.

I'm not took keen on stopping backups for hours while scrub runs.
I understand it's a workaround for now though.

I've just stopped scrub altogether now and will see if I still have
problems.

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
