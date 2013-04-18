Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:33823 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754627Ab3DRTsW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Apr 2013 15:48:22 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1USuoe-0003ds-F0
	for linux-btrfs@vger.kernel.org; Thu, 18 Apr 2013 21:48:20 +0200
Received: from rain.gmane.org ([80.91.229.7])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Apr 2013 21:48:20 +0200
Received: from eternaleye by rain.gmane.org with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Apr 2013 21:48:20 +0200
To: linux-btrfs@vger.kernel.org
From: Alex Elsayed <eternaleye@gmail.com>
Subject: Re: RAID device nomination (Feature request)
Date: Thu, 18 Apr 2013 12:48:10 -0700
Message-ID: <kkpilp$kdd$1@ger.gmane.org>
References: <kkotdg$o1e$1@ger.gmane.org> <20130418140604.GL7639@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hugo Mills wrote:

> On Thu, Apr 18, 2013 at 02:45:24PM +0100, Martin wrote:
>> Dear Devs,
<snip>
>> Note that esata shows just the disks as individual physical disks, 4 per
>> disk pack. Can physical disks be grouped together to force the RAID data
>> to be mirrored across all the nominated groups?
> 
>    Interesting you should ask this: I realised quite recently that
> this could probably be done fairly easily with a modification to the
> chunk allocator.
<snip>

One thing that might be an interesting approach:

Ceph is already in mainline, and uses CRUSH in a similar way to what's 
described (topology-aware placement+replication). Ceph does it by OSD nodes 
rather than disk, and the units are objects rather than chunks, but it could 
potentially be a rather good fit.

CRUSH does it by describing a topology hierarchy, and allocating the OSD ids 
to that hierarchy. It then uses that to map from a key to one-or-more 
locations. If we use chunk ID as the key, and use UUID_SUB in place of the 
OSD id, it could do the job.

