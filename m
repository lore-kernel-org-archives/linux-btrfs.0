From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Poor creat/delete files performance
Date: Wed, 18 Aug 2010 20:57:43 -0400
Message-ID: <20100819005743.GH5854@think>
References: <4C6BB21E.3000809@cn.fujitsu.com>
 <20100818120941.GM5854@think>
 <4C6C7C46.2000202@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Yan Zheng <zheng.yan@oracle.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Miao Xie <miaox@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4C6C7C46.2000202@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 19, 2010 at 08:35:18AM +0800, Miao Xie wrote:
> On Wed, 18 Aug 2010 08:09:41 -0400, Chris Mason wrote:
> >>We did some performance test and found the create/delete files performance
> >>of btrfs is very poor.
> >>
> >>The test is that we create 50000 files and measure the file-create time
> >>first, and then delete these 50000 files and measure the file-delete time.
> >>(The attached file is the reproduce program)
> >>
> >>The result is following:
> >>(Unit: second)
> >>   Create file performance
> >>		BtrFS		Ext4
> >>   Total times:	2.462625	1.449550
> >>   Average:	0.000049	0.000029
> >>
> >>   Delete file performance
> >>		BtrFS		Ext4
> >>   Total times:	3.312796	0.997946
> >>   Average:	0.000066	0.000020
> >>
> >>The results were measured on a x86_64 server with 4 cores and 2 SAS disks.
> >>By debuging, we found the btrfs spent a lot of time on searching and
> >>inserting/removing items in the ctree.
> >>
> >>Is anyone looking at this issue?
> >
> >I'm looking at it now, which kernel were you on?  We do spend some CPU
> >time on the btree but it shouldn't be a big bottleneck compared to the
> >disk.
> 
> I tested it on v2.6.35 kernel.

Sorry, I misread your first email slightly, I didn't realize the files
from the benchmark program were empty.

Since the files are empty, and we aren't doing enough files to trigger
IO, it is really benchmarking the cost of the btree insertions/removals
in comparison with ext4.  I do expect this to be higher because btrfs is
indexing the directories twice (once by name and once by sequence number
for faster backups).

On my machine:

Btrfs defaults:

Create files:
	Total files: 50000
	Total time: 0.916680
	Average time: 0.000018
Delete files:
	Total files: 50000
	Total time: 1.329892
	Average time: 0.000027

Ext4:

creat_unlink 50000
Create files:
	Total files: 50000
	Total time: 0.718190
	Average time: 0.000014
Delete files:
	Total files: 50000
	Total time: 0.308815
	Average time: 0.000006

We're definitely slower than ext4, but as Ric's benchmarks show things
tend to tilt in our favor once IO is actually done.

There are two big things that would help fix this performance gap:
Switching the extent buffer rbtree into a radix tree (esp a lockless
radix tree), and delaying insertion of the inode so that we can do more
in btree operations in bulk.

The radix tree is a much easier and more contained project.

-chris

