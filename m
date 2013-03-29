Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:59169 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754781Ab3C2OMY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Mar 2013 10:12:24 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 96A937C0681
	for <linux-btrfs@vger.kernel.org>; Fri, 29 Mar 2013 08:12:24 -0600 (MDT)
Date: Fri, 29 Mar 2013 10:12:22 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Harald Glatt <mail@hachre.de>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Space usage metering
Message-ID: <20130329141222.GF1876@localhost.localdomain>
References: <CAFWF=an6K-qa0krj_PKA-QvBV-Wv21Na0C1Pc3r4eP1_9-MNCg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAFWF=an6K-qa0krj_PKA-QvBV-Wv21Na0C1Pc3r4eP1_9-MNCg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 29, 2013 at 07:58:40AM -0600, Harald Glatt wrote:
> Hi,
> 
> I'm somewhat confused with who is right on what when it comes to
> showing disk usage and space free.
> 
> I have a file system that I'm using for testing with a full linux
> installed as well as X and a desktop. I've created a good amount of
> snapshots and I've also done a lot of changes to the system throuhgout
> the process.
> 
> I've run a balance before taking these meassurements:
> 
> -> df -h reports 59G total space, 18G used, 7G free.
> -> btrfs fi df / reports the following:
> Data, RAID0: total=16.00GB, used=15.58GB
> System, RAID1: total=32.00MB, used=4.00KB
> System: total=4.00MB, used=0.00
> Metadata, RAID1: total=6.00GB, used=974.36MB
> 
> So from what I garther the df reports used space somewhat correctly.
> Is it true that my total disk usage should only be around 16.6G now?
> Does that include all space required to store the snapshots as well?
> I'd be pretty amazed at that number because I've changed A LOT between
> snapshots.
> 
> Why is df reporting only 7G free? Wouldn't it be possible to make it
> report the sum of total minus used instead which would be at least a
> lot closer to the truth?
> 

So you need to include btrfs fi show to get at why df -h reports what it
reports.  Basically df does this

total = total bytes
used = total data used * raid multiplier + total system used * raid multiplier +
metadata used * raid multiplier
avail (or free) = (data total - data used) + (total bytes - allocated)

where allocated is the sum of all the data chunks * their raid multipliers.  How
many disks do you have in this array?  Take whatever that number is and multiply
it by the numbers for the RAID1 chunks and thats how much real space is used.
Thanks,

Josef
