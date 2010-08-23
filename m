From: Chris Mason <chris.mason@oracle.com>
Subject: Re: 2.6.35 performance results
Date: Mon, 23 Aug 2010 15:33:25 -0400
Message-ID: <20100823193325.GJ26773@think>
References: <4C5C57FB.4090003@dangyankee.net>
 <20100816200444.GJ993@think>
 <4C69B2D0.4010501@dangyankee.net>
 <20100819010031.GI5854@think>
 <4C6FF007.3080800@austin.ibm.com>
 <4C72C871.4040602@austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Steven Pratt <slpratt@austin.ibm.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4C72C871.4040602@austin.ibm.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 23, 2010 at 02:13:53PM -0500, Steven Pratt wrote:
> This did not seem to help, in fact we regressed more with COW
> enabled.. One thing to note, the last 2 sets of runs in the history
> graphs were actually run by Keith and he used stock kernel trees.
> For my recreate, I pulled the latest btrfs-unstable which is based
> on a 2.6.34 tree. Should I retest this on stock 2.6.35?  The high
> time in btrfs_start_one_delalloc_inode still exists.

btrfs-unstable or .35 are both fine.

Is this a fresh mkfs or are you reusing an existing tree?

> 
> Full results can be found here:
> http://btrfs.boxacle.net/repository/raid/perftest/perfpatch/perfpatch.html
> 
> 128 thread random write test that shows the problem:
> 
> http://btrfs.boxacle.net/repository/raid/perftest/perfpatch/perfpatch_Large_file_random_writes._num_threads=128.html

Ok, thanks, I'll try again.

-chris

