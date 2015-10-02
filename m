Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f53.google.com ([209.85.215.53]:32868 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245AbbJBWHU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Oct 2015 18:07:20 -0400
Received: by lafb9 with SMTP id b9so11570995laf.0
        for <linux-btrfs@vger.kernel.org>; Fri, 02 Oct 2015 15:07:18 -0700 (PDT)
Received: from [192.168.1.125] (h-46-30.a328.priv.bahnhof.se. [79.136.46.30])
        by smtp.gmail.com with ESMTPSA id q142sm1883758lfq.37.2015.10.02.15.07.17
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 02 Oct 2015 15:07:17 -0700 (PDT)
From: Jim Dowling <jdowling@sics.se>
Subject: raid5 + HDFS
To: linux-btrfs@vger.kernel.org
Message-ID: <560F0014.9020905@sics.se>
Date: Sat, 3 Oct 2015 00:07:16 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi
I am interested in combining BtrFS RAID-5 with erasure-coded replication 
for HDFS. We have an implementation of Reed-Solomon replication for our 
HDFS distribution called HopsFS (www.hops.io).

Some of the nice features of HDFS that make it suitable are:
* not many small files
* not excessive snapshotting
* can probably manage disks being close to capacity, as its globally 
visible and blocks can be re-balanced in HDFS

What BtrFS could give us:
* stripping within a DataNode using RAID-5
* higher throughput read/write for HDFS clients over 10 GbE without 
losing data locality (others are looking at stripping blocks over many 
different nodes).
* true snapshotting for HDFS by providing rollback of HDFS blocks

I am concerned (actually, excited!) that RAID-5 is not production ready. 
Any guidelines on how mature it is, since the big PR in Feb/March 2015?
What about scrubbing for RAID-5?

Is there anything else I should know?

Btw, here are some links i found about RAID-5:


UREs are not as common on commodity disks - RAID-5 is safer than assumed:
*<https://www.high-rely.com/blog/using-raid5-means-the-sky-is-falling/>https://www.high-rely.com/blog/using-raid5-means-the-sky-is-falling/* 


*

Btrfs Linux 4.1 with 5 10K RPM spinning disks:

<http://www.phoronix.com/scan.php?page=article&item=btrfs-raid015610-linux41&num=1>http://www.phoronix.com/scan.php?page=article&item=btrfs-raid015610-linux41&num=1

*Raid*-*5 *Results: ~250 MB/s for sequential reads. 559 MB/s for 
sequential writes.

*

