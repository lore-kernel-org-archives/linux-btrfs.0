From: David Woodhouse <dwmw2@infradead.org>
Subject: Re: raidz-like operation?
Date: Sat, 11 Jul 2009 15:59:50 +0100
Message-ID: <1247324390.17811.9.camel@macbook.infradead.org>
References: <952FC056-F524-420A-9826-F8A287BB2139@karlsbakk.net>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <952FC056-F524-420A-9826-F8A287BB2139@karlsbakk.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 2009-07-10 at 10:58 +0200, Roy Sigurd Karlsbakk wrote:
> I know it's not in yet, but is there a plan to implement raid-z(2)- 
> like operation? I have heard of plans to integrate with the existing  
> md-subsystem in the kernel, but I'm not sure if this will be  
> appropriate comparing this to how things are done in zfs/raid-z.

I'm currently working on the basic implementation of RAID5/RAID6 (qv).
I don't think there'll be much integration with the md subsystem --
we'll probably just shift the cunning GF arithmetic out into lib/raid6
or something, then let them both use it from there.

We do want to do full stripe writes to the RAID[56] parts, so we're
going to want to do something like falling back to RAID1 (or to a RAID5
chunk with smaller stripe length) for smaller allocations. That's
basically what you're talking about, isn't it?

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

