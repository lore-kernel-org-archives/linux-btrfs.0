Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:13726 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753925AbcCYR0I (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Mar 2016 13:26:08 -0400
Received: from pps.filterd (m0001255.ppops.net [127.0.0.1])
	by mx0b-00082601.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u2PHKUF9021303
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Mar 2016 10:26:07 -0700
Received: from mail.thefacebook.com ([199.201.64.23])
	by mx0b-00082601.pphosted.com with ESMTP id 21vva6jmwh-1
	(version=TLSv1 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Mar 2016 10:26:06 -0700
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 00/14] Enospc rework
Date: Fri, 25 Mar 2016 13:25:46 -0400
Message-ID: <1458926760-17563-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

1) Huge latency spikes.  One guy starts flushing, he doesn't wake up until the
flushers are finished doing work and then checks to see if he can continue.
Meanwhile everybody is backed up waiting for that guy to finish getting his
reservation.

2) The flushers flush everything.  They have no idea when to stop, so it just
flushes all of delalloc or all of the delayed inodes.  At first they try to
flush a little bit and hope they can get away with it, but the tighter you get
on space the more it becomes flush the world and hope for the best.

3) Some of the flushing isn't async, yay more latency.

The new approach introduces the idea of tickets for reservations.  If you cannot
make your reservation immediately you initialize a ticket with how much space
you need and you put yourselve on a list.  If you cannot flush anything (things
like dirty'ing an inode) then you add yourself to the priority queue and wait
for a little bit.  If you can flush then you add yourself to the normal queue
and wait for flushing to happen.  Each ticket has it's own waitqueue so as we
add space back into the system we can satisfy reservations immediately and
immediately wake the waiters back up, which greatly reduces latencies.

I've been testing these patches for a while and will be building on them from
here, but the results are pretty excellent so far.  In the fs_mark test with all
metadata here are the results (on an empty file system)

Without Patch
Average Files/sec:     212897.2
p50 Files/sec: 207495
p90 Files/sec: 196709
p99 Files/sec: 189682

Creat Max Latency in usec
p50: 264665
p90: 456347.2
p99: 659489.32
max: 1001413

With Patch
Average Files/sec:     238613.4  
p50 Files/sec: 235764  
p90 Files/sec: 223308  
p99 Files/sec: 216291 

Creat Max Latency in usec
p50: 206771.5
p90: 355430.6
p99: 469634.98
max: 512389

So as you can see there is quite a bit better latency and better throughput
overall.  There will be more work as I test the worst case scenarios and get
the worst latencies down further, but this is the initial work.  Thanks,

Josef

