Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:50495 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750827Ab2ESEKG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 19 May 2012 00:10:06 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1SVazU-0001MT-Qq
	for linux-btrfs@vger.kernel.org; Sat, 19 May 2012 06:10:04 +0200
Received: from rain.gmane.org ([80.91.229.7])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 19 May 2012 06:10:04 +0200
Received: from eternaleye+usenet by rain.gmane.org with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 19 May 2012 06:10:04 +0200
To: linux-btrfs@vger.kernel.org
From: Alex Elsayed <eternaleye+usenet@gmail.com>
Subject: Re: [RFC PATCH 0/7] bcache: md conversion
Date: Fri, 18 May 2012 19:35:11 -0700
Message-ID: <jp70t0$4ru$2@dough.gmane.org>
References: <20120511194327.25770.79292.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Cc: linux-bcache@vger.kernel.org
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dan Williams wrote:

> The consensus from LSF was that bcache need not invent a new interface
> when md and dm can both do the job.  As mentioned in patch 7 this series
> aims to be a minimal conversion.  Other refactoring items like
> deprecating register_lock for mddev->reconfig_mutex are deferred.
> 
> This supports assembly of an already established cache array:
> 
> mdadm -A /dev/md/bcache /dev/sd[ab]
> 
> ...will create the /dev/md/bcache container and a subarray representing
> the cache volume.  "Flash-only", or backing-device only volumes were not
> tested.  "Create" support and hot-add/hot-remove come later.
> 
> Note:
> * When attempting to test with small loopback devices (100MB), assembly
>   soft locks in bcache_journal_read().  That hang went away with larger
>   devices, so there seems to be minimum component device size that needs
>   to be considered in the tooling.

Is there any plan to separate the on-disk layout (per-device headers, etc) 
from the logic for the purpose of reuse? I can think of at least one case 
where this would be extremely useful: integration in BtrFS.

BtrFS already has its own methods for making sure a group of devices are all 
present when the filesystem is mounted, so it doesn't really need the 
formatting of the backing device bcache does to prevent it from being 
mounted solo. Putting bcache under BtrFS would be silly in the same way as 
putting it under a raid array, but bcache can't be put on top of BtrFS.

Logically, in looking at BtrFS' architecture, a cache would likely fit best 
at the 'block group' level, which IIUC would be roughly equivalent to the 
recommended 'over raid, under lvm' method of using bcache.

