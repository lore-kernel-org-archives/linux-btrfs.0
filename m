Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:60093 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755523Ab3C2N7C (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Mar 2013 09:59:02 -0400
Received: by mail-lb0-f177.google.com with SMTP id r10so338090lbi.22
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Mar 2013 06:59:00 -0700 (PDT)
MIME-Version: 1.0
From: Harald Glatt <mail@hachre.de>
Date: Fri, 29 Mar 2013 14:58:40 +0100
Message-ID: <CAFWF=an6K-qa0krj_PKA-QvBV-Wv21Na0C1Pc3r4eP1_9-MNCg@mail.gmail.com>
Subject: Space usage metering
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I'm somewhat confused with who is right on what when it comes to
showing disk usage and space free.

I have a file system that I'm using for testing with a full linux
installed as well as X and a desktop. I've created a good amount of
snapshots and I've also done a lot of changes to the system throuhgout
the process.

I've run a balance before taking these meassurements:

-> df -h reports 59G total space, 18G used, 7G free.
-> btrfs fi df / reports the following:
Data, RAID0: total=16.00GB, used=15.58GB
System, RAID1: total=32.00MB, used=4.00KB
System: total=4.00MB, used=0.00
Metadata, RAID1: total=6.00GB, used=974.36MB

So from what I garther the df reports used space somewhat correctly.
Is it true that my total disk usage should only be around 16.6G now?
Does that include all space required to store the snapshots as well?
I'd be pretty amazed at that number because I've changed A LOT between
snapshots.

Why is df reporting only 7G free? Wouldn't it be possible to make it
report the sum of total minus used instead which would be at least a
lot closer to the truth?

Thanks
