Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59739 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750914AbaIVJt6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Sep 2014 05:49:58 -0400
Date: Mon, 22 Sep 2014 11:49:55 +0200
From: David Sterba <dsterba@suse.cz>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: device delete progress
Message-ID: <20140922094955.GI9715@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <201409211209.11875.russell@coker.com.au>
 <pan$1d8a8$448bb26c$d55fc521$929be7e0@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <pan$1d8a8$448bb26c$d55fc521$929be7e0@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Sep 21, 2014 at 08:34:33AM +0000, Duncan wrote:
> Russell Coker posted on Sun, 21 Sep 2014 12:09:11 +1000 as excerpted:
> 
> > We need to have a way to determine the progress of a device delete
> > operation.
> > Also for a balance of a RAID-1 that has more than 2 devices it would be
> > good to know how much space is used on each device.
> > 
> > Could btrfs fi df be extended to show information separately for each
> > device?
> 
> btrfs fi show should give you at least some minimal per-device stats, 
> today.  Enough to at least have some idea of the progress of a balance 
> when adding/removing devices.

Up to now this is the only way to see the progress.

> Longer term, there has been discussion of extending/changing the fi df 
> format and making it far more verbose, including the information found in 
> btrfs fi show as well, and making everything potentially per-device.  I 
> hadn't paid a whole lot of attention to the details, however.
> 
> Alternatively, leave df more or less as it is (perhaps extending it a bit 
> but attempting not to kill existing scripts using it) and put the detail 
> in a new btrfs filesystem usage.  This sounds rather more reasonable to 
> me.
> 
> Either way the idea is to give people a single command that combines the 
> current output of fi show and fi df, ideally displaying per-device and 
> filesystem totals both, in enough verbosity to avoid the unintuitive and 
> arcane btrfs specific knowledge required today to interpret it.
> 
> I had originally presumed that such a change would happen before the 
> experimental labels came off, but it didn't.  I don't know the timetable 
> for it now, or even if it's still planned, as IIRC the discussion died 
> away back in the btrfs-progs 3.12 era and I expected to see it in 3.14 
> and it wasn't there, so I don't know...

The upcomming 3.17 release should contain all the 'new df' patches that
were unfortunatelly delayed. There are some minor issues to be fixed but
I hope it'll be ready close to the kernel 3.17 release.
