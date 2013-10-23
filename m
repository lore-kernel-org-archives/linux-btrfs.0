Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:39856 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751623Ab3JWPjS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Oct 2013 11:39:18 -0400
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Itermittent data corruption and dmesg spam
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <6844836.rMEZUtNbVg@noether>
Date: Wed, 23 Oct 2013 09:39:05 -0600
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-Id: <EF448C4E-AE96-4DE9-AB0F-2D8BC038C988@colorremedies.com>
References: <6844836.rMEZUtNbVg@noether>
To: Henry de Valence <hdevalence@hdevalence.ca>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Oct 22, 2013, at 9:58 PM, Henry de Valence <hdevalence@hdevalence.ca> wrote:
> 
> 
> btrfs: bdev /dev/bcache0 errs: wr 0, rd 0, flush 0, corrupt 16, gen 0
> 
> but when I run btrfs scrub I get:
> 
> scrub status for 56118d27-c9a8-483c-afaa-e429d59884e9
>     scrub started at Tue Oct 22 22:46:17 2013 and finished after 2802 seconds
>     total bytes scrubbed: 426.03GB with 0 errors

Well it sounds to me like there was some kind of corruption at some point, and possibly btrfs fixed this (maybe it was metadata corruption and it was simple for it to fix because it keeps two copies of metadata). Note that this mount info line, the first instance you report, is a persistent counter. Within the last 2-3 weeks there's a post on here, I think by Hugo or Duncan, on how to reset that counter. The 2nd instance, the scrub status, is not persistent, it shows the values for the most recently run scrub.

So it seems clear to me that there were 16 corruptions encountered during normal operation, were fixed by the time you ran the scrub. So overall I'd say you probably are OK but you'd need to go back through syslog or journalctl and see if you can find the first instances of the original corruption. I know there were some issues with bcache and btrfs and dirty data, although my vague recollection is that this discussion wasn't on this list but rather lkml. You might do an lkml search for "overstreet btrfs" and see what hits you get.

> 
> My setup is a btrfs partition on a bcache device, which has a new-ish hard 
> drive as the backing store and a partition on an older SSD as the cache. The 
> bcache documentation suggests that sequential reads bypass the cache device. 
> Is it possible that I have some bad blocks on my SSD, which cause the errors 
> and data corruption, but the data corruption doesn’t show up with btrfs scrub 
> because the disk accesses in the scrub are bypassing the cache?

That seems doubtful or this would be persistently occurring in the scrubs, yet your scrub is clean. You just have a persistent counter that says since the counter was last reset, there have been 16 corruptions found. It seems clear since then they've been fixed. So the question is why they occurred in the first place because there's probably a better chance of this being a bug rather than bad hardware just because this combination is not significantly tested yet.



Chris Murphy

