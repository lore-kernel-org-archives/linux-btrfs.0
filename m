Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:49940 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749Ab3KDRFm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Nov 2013 12:05:42 -0500
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id DF6E69A06AF
	for <linux-btrfs@vger.kernel.org>; Mon,  4 Nov 2013 10:05:41 -0700 (MST)
Date: Mon, 4 Nov 2013 12:05:38 -0500
From: Josef Bacik <jbacik@fusionio.com>
To: Miao Xie <miaox@cn.fujitsu.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 0/7] Btrfs: improve the latency of the space reservation
Message-ID: <20131104170538.GI16855@localhost.localdomain>
References: <1383578006-22691-1-git-send-email-miaox@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1383578006-22691-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 04, 2013 at 11:13:19PM +0800, Miao Xie wrote:
> This patchset improve the latency of the space reservation when doing the
> delalloc inode flush. As we know, the current code would wait for
> the completion all the ordered extents in the filesystem. It was unnecessary,
> we can finish the wait and try to do reservation once again earlier if we
> get enough free space. It can reduce the wait time and make the perfermance
> up.
> 
> We did the buffered write test by the sysbench on my box, the following
> is the result.
>  Memory:	2GB
>  CPU:		2Cores * 1CPU
>  Partition:	20GB(SSD)
> 				w/		w/o
>  rndwr-512KB-1Thread-2GB	120.38MB/s	110.08MB/s
>  rndwr-512KB-8Threads-2GB	119.43MB/s	110.96MB/s
>  seqwr-512KB-1Thread-2GB	99.676MB/s	98.53MB/s
>  seqwr-512KB-8Threads-2GB	111.79MB/s	99.176MB/s
> 
>  rndwr-128KB-1Thread-2GB	139.23MB/s	95.864MB/s
>  rndwr-128KB-8Threads-2GB	126.16MB/s	96.686MB/s
>  seqwr-128KB-1Thread-2GB	100.24MB/s	100.95.MB/s
>  seqwr-128KB-8Threads-2GB	126.51MB/s	100.26MB/s
> 
> rndwr: random write test
> seqwr: sequential write test
> 512KB,128KB: the size of each request
> 1Thread, 8Threads: the number of the test threads
> 2GB: The total file size
> 
> Miao Xie (7):
>   Btrfs: remove unnecessary initialization and memory barrior in shrink_delalloc()
>   Btrfs: wait for the ordered extent only when we want
>   Btrfs: pick up the code for the item number calculation in flush_space()
>   Btrfs: fix the confusion between delalloc bytes and metadata bytes
>   Btrfs: don't wait for all the async delalloc when shrinking delalloc
>   Btrfs: don't wait for the completion of all the ordered extents
>   Btrfs: rename btrfs_start_all_delalloc_inodes
> 

Thank you for this, I've been wanting to do this for months but I keep getting
sucked into bug hell, remind me to kiss you at LSF.

Josef
