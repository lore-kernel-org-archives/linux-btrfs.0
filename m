Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f51.google.com ([209.85.215.51]:33812 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859AbbJBXwG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Oct 2015 19:52:06 -0400
Received: by labzv5 with SMTP id zv5so100823720lab.1
        for <linux-btrfs@vger.kernel.org>; Fri, 02 Oct 2015 16:52:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <560F0014.9020905@sics.se>
References: <560F0014.9020905@sics.se>
From: Martin Tippmann <martin.tippmann@gmail.com>
Date: Sat, 3 Oct 2015 01:51:44 +0200
Message-ID: <CABL_Pd8q=GAAHOXXOfKRbQanjhumaAGDOGrYBo33cKU5CGFcTw@mail.gmail.com>
Subject: Re: raid5 + HDFS
To: Jim Dowling <jdowling@sics.se>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2015-10-03 0:07 GMT+02:00 Jim Dowling <jdowling@sics.se>:
> Hi

Hi, I'm not a btrfs developer but we run HDFS on top of btrfs (mainly
due to other use-cases that profit from checksumming data)

> I am interested in combining BtrFS RAID-5 with erasure-coded replication for
> HDFS. We have an implementation of Reed-Solomon replication for our HDFS
> distribution called HopsFS (www.hops.io).

I only know HDFS as being filesystem agnostic and JBOD is usually the way to go.

You plan to use btrfs directly for storing blocks and want to exploit
the RAID5 functionality for erasure coding? I'm not familiar with
hops.io and existing approaches to erasure coding on btrfs but a few
questions come to my mind:

How do you deal with HDFS checksums? AFAIK these are calculated in a
different way than btrfs does it?
Do you throw away the whole Java DataNode Idea and replace it with
somethings that talks directly to the filesystem?

> Some of the nice features of HDFS that make it suitable are:
> * not many small files
> * not excessive snapshotting
> * can probably manage disks being close to capacity, as its globally visible
> and blocks can be re-balanced in HDFS

HDFS Blocks are mostly 64MB to 512MB - I don't see the connection to
btrfs that checksums much smaller blocks?

> What BtrFS could give us:
> * stripping within a DataNode using RAID-5

At least for MapReduce Jobs JBOD exploits the fact that you can use a
disk for a job. Wouldn't RAID5 kind of destroy MapReduce (or random
access) performance?

> * higher throughput read/write for HDFS clients over 10 GbE without losing
> data locality (others are looking at stripping blocks over many different
> nodes).

We've got machines with 4x4TB disks and I'm seeing that they can reach
up to 500Mbyte/s on 10GbE in JBOD during shuffle. Would be great if
you give more details or some hints to read up on it why exactly doing
RAID5 is better than JBOD.

> * true snapshotting for HDFS by providing rollback of HDFS blocks

This would be great, but how do you deal with lost disks? The historic
data will be local to the node containing the btrfs file system?

> I am concerned (actually, excited!) that RAID-5 is not production ready. Any
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
> UREs are not as common on commodity disks - RAID-5 is safer than assumed:
> *<https://www.high-rely.com/blog/using-raid5-means-the-sky-is-falling/>https://www.high-rely.com/blog/using-raid5-means-the-sky-is-falling/*

If you have cluster nodes with 12 disks and 2 disks die at the same
time... can you deal with that? RAID5 means loosing all data on all 12
disks?

> Btrfs Linux 4.1 with 5 10K RPM spinning disks:
>
> <http://www.phoronix.com/scan.php?page=article&item=btrfs-raid015610-linux41&num=1>http://www.phoronix.com/scan.php?page=article&item=btrfs-raid015610-linux41&num=1
>
> *Raid*-*5 *Results: ~250 MB/s for sequential reads. 559 MB/s for sequential
> writes.

The ZFS guys try to move the parity calculation to SSE and AVX with
some good looking performance improvements. See
https://github.com/zfsonlinux/zfs/pull/3374 - so it's probably
possible to have a fast enough RAID5 implementation in btrfs - but I'm
lacking the bigger picture and the explicit use case for btrfs in this
setup?

hops.io looks very interesting through. Would be great if you could
clarify your ideas a little bit.

HTH & regards
Martin
