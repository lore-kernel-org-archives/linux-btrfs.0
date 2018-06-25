Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56921 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755588AbeFYOXI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Jun 2018 10:23:08 -0400
Date: Mon, 25 Jun 2018 16:20:15 +0200
From: David Sterba <dsterba@suse.cz>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: unsolvable technical issues?
Message-ID: <20180625142015.GE27958@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <b255d0fb-5cee-36c5-d49f-5f014d20e518@dirtcellar.net>
 <pan$11f2c$c623d7b0$5173b25$c7594479@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <pan$11f2c$c623d7b0$5173b25$c7594479@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jun 23, 2018 at 05:11:52AM +0000, Duncan wrote:
> > According to this:
> > 
> > https://stratis-storage.github.io/StratisSoftwareDesign.pdf Page 4 ,
> > section 1.2
> > 
> > It claims that BTRFS still have significant technical issues that may
> > never be resolved.
> > Could someone shed some light on exactly what these technical issues
> > might be?! What are BTRFS biggest technical problems?
> > 
> > If you forget about the "RAID"5/6 like features then the only annoyances
> > that I have with BTRFS so far is...
> > 
> > 1. Lack of per subvolume "RAID" levels
> > 2. Lack of not using the deviceid to re-discover and re-add dropped
> > devices
> > 
> > And that's about it really...
> 
> ... And those both have solutions on the roadmap, with RFC patches 
> already posted for #2 (tho I'm not sure they use devid) altho 
> realistically they're likely to take years to appear and be tested to 
> stability.  Meanwhile...
> 
> While as the others have said you really need to go to the author to get 
> what was referred to, and I agree, I can speculate a bit.  While this 
> *is* speculation, admittedly somewhat uninformed as I don't claim to be a 
> dev, and I'd actually be interested in what others think so don't be 
> afraid to tell me I haven't a clue, as long as you say why... based on 
> several years reading the list now...
> 
> 1) When I see btrfs "technical issue that may never be resolved", the #1 
> first thing I think of, that AFAIK there are _definitely_ no plans to 
> resolve, because it's very deeply woven into the btrfs core by now, is...
> 
> Filesystem UUID Identification.

> Btrfs takes the UU bit of Universally 
> Unique quite literally, assuming they really *are* unique, at least on 
> that system, and uses them to identify the possibly multiple devices that 
> may be components of the filesystem, a problem most filesystems don't 
> have to deal with since they're single-device-only.  Because btrfs uses 
> this supposedly unique ID to ID devices that belong to the filesystem, it 
> can get *very* mixed up, with results possibly including dataloss, if it 
> sees devices that don't actually belong to a filesystem with the same UUID 
> as a mounted filesystem.
> 
> But technologies such as LVM allow cloning devices and these additional 
> devices naturally have the same filesystem metadata, including filesystem 
> UUID, as the original.  Making the problem worse is udev with its plug-n-
> play style detection, which will normally trigger a btrfs device scan, 
> thus making btrfs aware of new devices containing (a component of) a 
> btrfs, as soon as udev detects the device.

The automatic scanning is partially making it hard and would require
either extending the scanning mechanim to distinguish automatic and
manual scan, and using that information in kernel.

Right now, a cloned device will not be added to the filesystem UUID set
if the fs is mounted, but otherwise it's up to the administrator. The
misisng bit is possibly a way to tell the kernel module to 'forget' a
device (forget and never auto-scan).

> 2) Subvolume and (more technically) reflink-aware defrag.

There was a discussion in the mailinglist recently, some additions to
the interface were requested. The code to avoid the OOM exists but the
original author is not apparently interested and noone else has that
high enough in the todo list.

> 3) N-way-mirroring.

I have a prototype code for that, 3-copy and 4-copy type of profile.
Doning a fully dynamic N-way would become a messs once thre are mixed
N-way chunks for different N. Adding N=5 would not be too hard, but I'm
not sure if this makes sense.

The raid5 write-hole log will build on top of that, but the code has not
been written yet, other than the separate device logging sent by Liu Bo. 

> 4) (Until relatively recently, and still in terms of scaling) Quotas.

That's ongoing WIP, as qgroups touch the core parts.
