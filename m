Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:44761 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752013Ab3AaQme (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Jan 2013 11:42:34 -0500
Date: Thu, 31 Jan 2013 11:42:31 -0500
From: Josef Bacik <jbacik@fusionio.com>
To: Miao Xie <miaox@cn.fujitsu.com>
CC: Linux Btrfs <linux-btrfs@vger.kernel.org>,
        Josef Bacik <JBacik@fusionio.com>
Subject: Re: [RFC][PATCH 2/2] Btrfs: implement unlocked dio write
Message-ID: <20130131164231.GQ3660@localhost.localdomain>
References: <510A3BB7.4090201@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <510A3BB7.4090201@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 31, 2013 at 02:39:03AM -0700, Miao Xie wrote:
> This idea is from ext4. By this patch, we can make the dio write parallel,
> and improve the performance.
> 
> We needn't worry about the race between dio write and truncate, because the
> truncate need wait untill all the dio write end.
> 
> And we also needn't worry about the race between dio write and punch hole,
> because we have extent lock to protect our operation.
> 
> I ran fio to test the performance of this feature.
> 
> == Hardware ==
> CPU: Intel(R) Core(TM)2 Duo CPU     E7500  @ 2.93GHz
> Mem: 2GB
> SSD: Intel X25-M 120GB (Test Partition: 60GB)
> 
> == config file ==
> [global]
> ioengine=psync
> direct=1
> bs=4k
> size=32G
> runtime=60
> directory=/mnt/btrfs/
> filename=testfile
> group_reporting
> thread
> 
> [file1]
> numjobs=1 # 2 4
> rw=randwrite
> 
> == result (KBps) ==
> write	1	2	4
> lock	24936	24738	24726
> nolock	24962	30866	32101
> 
> == result (iops) ==
> write	1	2	4
> lock	6234	6184	6181
> nolock	6240	7716	8025

So the one thing I worry about is interactions with fsync.  I've been depending
on the mutex to keep us from getting screwed by writers coming in while I'm
trying to write out the changed extents.  Could you test this with fsync and
make sure it doesn't break anything?  Thanks,

Josef
