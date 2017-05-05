Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aquinas.techsquare.com ([75.125.237.226]:43298 "EHLO
        techsquare.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753245AbdEENYh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 May 2017 09:24:37 -0400
To: pg@btrfs.list.sabi.co.UK, linux-btrfs@vger.kernel.org
References: <22795.14626.978819.534566@tree.ty.sabi.co.uk>
From: Matt McKinnon <matt@techsquare.com>
Message-ID: <f1bbe501-0897-c8e0-36ff-2f4cf005fa45@techsquare.com>
Date: Fri, 5 May 2017 09:24:32 -0400
MIME-Version: 1.0
In-Reply-To: <22795.14626.978819.534566@tree.ty.sabi.co.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Subject: Re: Struggling with file system slowness
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

 > Too little information. Is IO happening at the same time? Is
 > compression on? Deduplicated? Lots of subvolumes? SSD? What
 > kind of workload and file size/distribution profile?

Only write IO during the load spikes.  No compression, no deduplication. 
  12 volumes (including snapshots).  Spinning disks.  Medium workload; 
file sizes are all over the map since this hold about 30 user home 
directories.

Interestingly enough, the problems which had persisted for many weeks 
went away when all snapshots were removed.  btrfs-transaction spikes 
disappeared.  Memory usage went from 30G to under 2G.

-Matt


