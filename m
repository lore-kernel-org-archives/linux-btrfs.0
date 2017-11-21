Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zougloub.eu ([69.70.16.42]:58698 "EHLO zougloub.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751800AbdKUBFW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 20 Nov 2017 20:05:22 -0500
Date: Mon, 20 Nov 2017 20:06:35 -0500
From: =?UTF-8?B?SsOpcsO0bWU=?= Carretero <cJ-ko@zougloub.eu>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Issues while doing btrfs delete missing in raid6
Message-ID: <20171120200635.01578103@Vantage.cJ>
In-Reply-To: <pan$5ba16$591e9570$7efd0d56$66c0e056@cox.net>
References: <20171120014344.7a5d8bd2@Vantage.cJ>
        <pan$5ba16$591e9570$7efd0d56$66c0e056@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Duncan,

On Mon, 20 Nov 2017 21:57:47 +0000 (UTC)
Duncan <1i5t5.duncan@cox.net> wrote:

> Jérôme Carretero posted on Mon, 20 Nov 2017 01:43:44 -0500 as
> excerpted:
> 
> > While doing a test (to evaluate drives), where I'm filling a bunch
> > of drives in RAID6, one of the disks failed in the process.
> > (System with v4.14 / ECC).  
> 
> FWIW, see raid56 status in the status page (table and below raid56
> note).
> 
> https://btrfs.wiki.kernel.org/index.php/Status
> 
> Basically, after the fixes in 4.12, it mostly works as long as things 
> don't go too badly wrong, but due to the write hole and corner cases
> such as the checksum repair failure you ran into, it's not something
> people on this list can in good conscience recommend for general use,
> because it simply lacks the reliability people tend to want raid56
> for, at least in combination with the file-integrity/checksumming
> features btrfs may be chosen for.  The two together simply aren't as
> reliable as the separate features might imply they should be, and
> there are known to be better alternatives.
> 
> Unfortunately that's likely to remain the case for awhile due to the 
> complexity of a real fix, despite the 4.12 fixes to the worst of the 
> problems.
> 
> One reasonably performant and reliable alternative, tho it's more 
> directly an alternative to btrfs raid10, where it's better performing
> due to btrfs raid10 not yet being performance optimized, is btrfs
> raid1 on top of two raid0s (mdraid0, for instance).

I normally use btrfs RAID1, but wanted to see what's new with RAID6
while "priming" some new disks. There was some click-bait on Phoronix,
the wiki page (status or https://btrfs.wiki.kernel.org/index.php/RAID56)
didn't look very up-to-date and quite vague, and not so many horror
stories on LKML...

Anyway, this was a 200-hour experiment, and apart from the failure, the
speed was low, really far from RAID1 (and there was plenty of CPU left
to compute parity), and "delete missing" was unexpectedly slow, running
at perhaps 10 MB/s average.

TL;DR: As of v4.14 RAID6 is as reliable as RAID0, but slower =)


-- 
Jérôme
