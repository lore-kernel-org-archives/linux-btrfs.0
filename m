From: Miao Xie <miaox@cn.fujitsu.com>
Subject: Re: Poor creat/delete files performance
Date: Thu, 19 Aug 2010 09:38:13 +0800
Message-ID: <4C6C8B05.2090601@cn.fujitsu.com>
References: <4C6BB21E.3000809@cn.fujitsu.com> <20100818120941.GM5854@think> <4C6C7C46.2000202@cn.fujitsu.com> <20100819005743.GH5854@think>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: Chris Mason <chris.mason@oracle.com>,
	Yan Zheng <zheng.yan@oracle.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100819005743.GH5854@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 18 Aug 2010 20:57:43 -0400, Chris Mason wrote:
> Since the files are empty, and we aren't doing enough files to trigger
> IO, it is really benchmarking the cost of the btree insertions/removals
> in comparison with ext4.  I do expect this to be higher because btrfs is
> indexing the directories twice (once by name and once by sequence number
> for faster backups).
>
> On my machine:
>
> Btrfs defaults:
>
> Create files:
> 	Total files: 50000
> 	Total time: 0.916680
> 	Average time: 0.000018
> Delete files:
> 	Total files: 50000
> 	Total time: 1.329892
> 	Average time: 0.000027
>
> Ext4:
>
> creat_unlink 50000
> Create files:
> 	Total files: 50000
> 	Total time: 0.718190
> 	Average time: 0.000014
> Delete files:
> 	Total files: 50000
> 	Total time: 0.308815
> 	Average time: 0.000006
>
> We're definitely slower than ext4, but as Ric's benchmarks show things
> tend to tilt in our favor once IO is actually done.
>
> There are two big things that would help fix this performance gap:
> Switching the extent buffer rbtree into a radix tree (esp a lockless
> radix tree), and delaying insertion of the inode so that we can do more
> in btree operations in bulk.
>
> The radix tree is a much easier and more contained project.

It is good idea, We will try to do it.

Thanks
Miao Xie
