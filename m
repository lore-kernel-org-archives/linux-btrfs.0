Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f44.google.com ([209.85.215.44]:33669 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798AbbJCOuR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 3 Oct 2015 10:50:17 -0400
Received: by lafb9 with SMTP id b9so17546893laf.0
        for <linux-btrfs@vger.kernel.org>; Sat, 03 Oct 2015 07:50:14 -0700 (PDT)
Received: from [192.168.1.125] (h-46-30.a328.priv.bahnhof.se. [79.136.46.30])
        by smtp.gmail.com with ESMTPSA id g141sm2486921lfe.38.2015.10.03.07.50.13
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 03 Oct 2015 07:50:13 -0700 (PDT)
From: Jim Dowling <jdowling@sics.se>
Subject: raid5 + HDFS
To: linux-btrfs@vger.kernel.org
References: <560F0014.9020905@sics.se>
 <CABL_Pd8q=GAAHOXXOfKRbQanjhumaAGDOGrYBo33cKU5CGFcTw@mail.gmail.com>
 <CAHT4m=XMsr=o0hVCXohi-cT=51qnB0mR_pK8108rhBQ1uQ_RBA@mail.gmail.com>
Message-ID: <560FEB23.4040004@sics.se>
Date: Sat, 3 Oct 2015 16:50:11 +0200
MIME-Version: 1.0
In-Reply-To: <CAHT4m=XMsr=o0hVCXohi-cT=51qnB0mR_pK8108rhBQ1uQ_RBA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Saturday, October 3, 2015, Martin Tippmann <martin.tippmann@gmail.com 
<javascript:_e(%7B%7D,'cvml','martin.tippmann@gmail.com');>> wrote:

    2015-10-03 0:07 GMT+02:00 Jim Dowling <jdowling@sics.se>:
     > Hi

    Hi, I'm not a btrfs developer but we run HDFS on top of btrfs (mainly
    due to other use-cases that profit from checksumming data)

     > I am interested in combining BtrFS RAID-5 with erasure-coded
    replication for
     > HDFS. We have an implementation of Reed-Solomon replication for
    our HDFS
     > distribution called HopsFS (www.hops.io <http://www.hops.io>).

    I only know HDFS as being filesystem agnostic and JBOD is usually
    the way to go.

    You plan to use btrfs directly for storing blocks and want to exploit
    the RAID5 functionality for erasure coding? I'm not familiar with
    hops.io <http://hops.io> and existing approaches to erasure coding
    on btrfs but a few
    questions come to my mind:

    How do you deal with HDFS checksums? AFAIK these are calculated in a
    different way than btrfs does it?
    Do you throw away the whole Java DataNode Idea and replace it with
    somethings that talks directly to the filesystem?


As you point out, hdfs does its own checksumming of blocks, which is 
needed as blocks are transferred over the network. So, yes it is double 
checksumming if you will.

We are keeping the data node as it is. The only change needed will be to 
identify a block device as an "archive" device or a normal device. We're 
interested in archive devices for this work.
The bigger picture is that Apache HDFS are going towards striping blocks 
over different data nodes, losing data locality. We are investigating  
btrfs/raid5 for archived data. It's workload would be much lower
than standard.


     > Some of the nice features of HDFS that make it suitable are:
     > * not many small files
     > * not excessive snapshotting
     > * can probably manage disks being close to capacity, as its
    globally visible
     > and blocks can be re-balanced in HDFS

    HDFS Blocks are mostly 64MB to 512MB - I don't see the connection to
    btrfs that checksums much smaller blocks?


no connection, double checksums. But also double erasure-coding. If a 
single disk in a raid5 array fails, we're ok locally.
If >1 disk in an array fails, we have to re-replicate blocks from that 
DataNode at the HDFS level.


     > What BtrFS could give us:
     > * stripping within a DataNode using RAID-5

    At least for MapReduce Jobs JBOD exploits the fact that you can use a
    disk for a job. Wouldn't RAID5 kind of destroy MapReduce (or random
    access) performance?

yes for many concurrent jobs it will be very slow. However for a single 
task I suspect it will be much faster than reading from a single disk in 
a jbod configuration.



     > * higher throughput read/write for HDFS clients over 10 GbE
    without losing
     > data locality (others are looking at stripping blocks over many
    different
     > nodes).

    We've got machines with 4x4TB disks and I'm seeing that they can reach
    up to 500Mbyte/s on 10GbE in JBOD during shuffle. Would be great if
    you give more details or some hints to read up on it why exactly doing
    RAID5 is better than JBOD.

workloads with one or maybe at most a few concurrent tasks should be 
better they currently are. That is the hypothesis.



     > * true snapshotting for HDFS by providing rollback of HDFS blocks

    This would be great, but how do you deal with lost disks? The historic
    data will be local to the node containing the btrfs file system?

we have erasure coded blocks at the hdfs level as well. Like double 
checksumming 😊
So losing a whole data node is ok, but repairing failed blocks at the 
HDFS level generates a lot of network repair traffic.
For a 5x4 TB array, it would typically generate 10 times that amount of 
network traffic to repair all the blocks on the lost array.


     > I am concerned (actually, excited!) that RAID-5 is not production
    ready. Any
     > guidelines on how mature it is, since the big PR in Feb/March 2015?
     > What about scrubbing for RAID-5?

    As I've said I'm not a dev but from reading the list RAID5 scrubbing
    should work with a recent kernel and recent btrfs-tools (4.1+). There
    where some bugs but AFAIK these are resolved with Linux 4.2+

     > Is there anything else I should know?
     >
     > Btw, here are some links i found about RAID-5:
     >
     >
     > UREs are not as common on commodity disks - RAID-5 is safer than
    assumed:
     >
    *<https://www.high-rely.com/blog/using-raid5-means-the-sky-is-falling/>https://www.high-rely.com/blog/using-raid5-means-the-sky-is-falling/*

    If you have cluster nodes with 12 disks and 2 disks die at the same
    time... can you deal with that? RAID5 means loosing all data on all 12
    disks?


    I expect that a machine with 12 disks would have 2 SATA-3
    controllers. We could setup half of the disks in raid5 as archival
    data. The other half as normal workloads.
    You adapt the number of machines in the cluster with this kind of
    setup, depending on the ratio of archived (cold storage) data in the
    cluster.

     > Btrfs Linux 4.1 with 5 10K RPM spinning disks:
     >
     >
    <http://www.phoronix.com/scan.php?page=article&item=btrfs-raid015610-linux41&num=1>http://www.phoronix.com/scan.php?page=article&item=btrfs-raid015610-linux41&num=1
     >
     > *Raid*-*5 *Results: ~250 MB/s for sequential reads. 559 MB/s for
    sequential
     > writes.

    The ZFS guys try to move the parity calculation to SSE and AVX with
    some good looking performance improvements. See
    https://github.com/zfsonlinux/zfs/pull/3374 - so it's probably
    possible to have a fast enough RAID5 implementation in btrfs - but I'm
    lacking the bigger picture and the explicit use case for btrfs in this
    setup?


    hops.io <http://hops.io> looks very interesting through. Would be
    great if you could
    clarify your ideas a little bit.

    HTH & regards
    Martin

We will hopefully look at zfs too, thanks for the tip.
  So the idea is to erasure code twice, checksum twice. Overall overhead 
will be about 50%, half of this for raid5, half hdfs erasure coding.
Hypothesis: For cold storage data with normal at most one active job per 
data node, jobs will read/write data faster, improving performance, 
particularly over 10GbE




-- 
regards,
--------------
Jim Dowling, PhD,
Senior Scientist, SICS - Swedish ICT
Associate Prof, KTH -Royal Institute of Technology


