Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:13918 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434Ab2EYRts (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 May 2012 13:49:48 -0400
Message-ID: <4FBFC63B.6050403@giantdisaster.de>
Date: Fri, 25 May 2012 19:49:47 +0200
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 0/3] Btrfs: add IO error device stats
References: <1337954770-10086-1-git-send-email-sbehrens@giantdisaster.de> <20120525151854.GA23362@infradead.org>
In-Reply-To: <20120525151854.GA23362@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It would be helpful if already the generic block layer would offer 
device error counters. Then btrfs could read them, add own counters for 
its checksum detected errors, and store everything persistently in the 
filesystem.

The goal is to replace disks that have an increased error rate with 
spare disks, and the goal is to repair this degenerated RAID state quickly.


On 05/25/2012 17:18, Christoph Hellwig wrote:
> Can you explain why the device error counters should be in a filesystem
> instead of generic block layer code?
>
> On Fri, May 25, 2012 at 04:06:07PM +0200, Stefan Behrens wrote:
[...]
>> The goal is to detect when drives start to get an increased error rate,
>> when drives should be replaced soon. Therefore statistic counters are
>> added that count IO errors (read, write and flush). Additionally, the
>> software detected errors like checksum errors and corrupted blocks are
>> counted.
>>
>> An ioctl interface is added to get the device statistic counters.
>> A second ioctl is added to atomically get and reset these counters.
>>
>> The device statistics are written into the device tree with each
>> transaction commit. Only modified statistics are written.
>> When a filesystem is mounted, the device statistics for each involved
>> device are read from the device tree and used to initialize the
>> counters.
>>
>> A patch for the btrfs-progs world will also be sent.
>>
>> Stefan Behrens (3):
>>    Btrfs: add device counters for detected IO and checksum errors
>>    Btrfs: add ioctl to get and reset the device stats
>>    Btrfs: read device stats on mount, write modified ones during commit
>>
>>   fs/btrfs/ctree.h       |   38 ++++++
>>   fs/btrfs/disk-io.c     |   20 +++-
>>   fs/btrfs/extent_io.c   |   18 ++-
>>   fs/btrfs/ioctl.c       |   26 +++++
>>   fs/btrfs/ioctl.h       |   33 ++++++
>>   fs/btrfs/print-tree.c  |    3 +
>>   fs/btrfs/scrub.c       |   65 ++++++++---
>>   fs/btrfs/transaction.c |    4 +
>>   fs/btrfs/volumes.c     |  304 +++++++++++++++++++++++++++++++++++++++++++++++-
>>   fs/btrfs/volumes.h     |   52 +++++++++
>>   10 files changed, 539 insertions(+), 24 deletions(-)
>>
>> --
>> 1.7.10.2
