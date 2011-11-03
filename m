From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/3] xfstests 264: add a copy and reserve test
Date: Thu, 3 Nov 2011 02:55:25 -0400
Message-ID: <20111103065525.GA6800@infradead.org>
References: <4EB20505.7070005@cn.fujitsu.com>
 <4EB205C7.6010906@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org,
	Linux Btrfs <linux-btrfs@vger.kernel.org>, xfs@oss.sgi.com
To: WuBo <wu.bo@cn.fujitsu.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <4EB205C7.6010906@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 03, 2011 at 11:08:55AM +0800, WuBo wrote:
> This test is a stress test. It creates a set of threads for coping small files 
> into disk. I use a 2G disk for test, the ENOSPC arises usually but the disk is 
> not full under kenerl 3.0 with intel64.

It seems like you really want to use _scratch_mkfs_sized instead of the
btrfs-specific resize option and make the test generic.  Also we already
have used up these test numbers in the xfstests-dev repository, and I
will commit another batch of tests today.

