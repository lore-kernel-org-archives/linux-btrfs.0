Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38022 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752363AbcD2Qhm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Apr 2016 12:37:42 -0400
Date: Fri, 29 Apr 2016 18:37:27 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, clm@fb.com
Subject: Re: [PATCH 0/2] [RFC] btrfs: create degraded-RAID1 chunks
Message-ID: <20160429163727.GD29353@suse.cz>
Reply-To: dsterba@suse.cz
References: <1461812780-538-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1461812780-538-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 28, 2016 at 11:06:18AM +0800, Anand Jain wrote:
> From the comments that commit[1] deleted
> 
> - /*
> - * we add in the count of missing devices because we want
> - * to make sure that any RAID levels on a degraded FS
> - * continue to be honored.
> - *
> 
> appear to me that automatic reduced-chunk-allocation
> when RAID1 is degraded wasn't in the original design.
> 
> which also introduced unpleasant things like automatically
> allocating single chunks when RAID1 is mounted in degraded
> mode, which will hinder further RAID1 mount in degraded
> mode.

Agreed. As the automatic conversion cannot be turned off, it causes some
surprises. We've opposed against such things in the past, so I'm for
not doing the 'single' allocations. Independly, I got a feedback from a
user who liked the proposed change.

> And now to fix the original issue that is - chunk allocation
> fails when RAID1 is degraded, The reason for the problem
> seems to be that we had the devs_min attribute for RAID1
> set wrongly. Correcting this also means that its time to
> fix the RAID1 fixmes in the functions __btrfs_alloc_chunk()
> patch [2] does that, and is for review.

This means we'd allow full writes to a degraded raid1 filesystem. This
can bring surprises as well. The question is what to do if the device
pops out, some writes happen, and then is added.

One option is to set some bit in the degraded filesystem that degraded
writes happened. After that, mounting the whole filesystem would
recommend running scrub before dropping the bit. Forcing a read-only
mount here would be similar to read-only degraded mount, so I guess we'd
have to somehow deal with the missing writes.

I haven't thought about all details, the raid1 auto-repair can handle
corrupted data, I think missing metadata should be handled as well and
repaired.
