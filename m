From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/3] xfstests 265: add a prealloc and reserve test
Date: Tue, 15 Nov 2011 14:08:21 -0500
Message-ID: <20111115190821.GA15331@infradead.org>
References: <4EB20505.7070005@cn.fujitsu.com>
 <4EB205CC.6010509@cn.fujitsu.com>
 <20111115182113.GD29840@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: WuBo <wu.bo@cn.fujitsu.com>, linux-fsdevel@vger.kernel.org,
	Linux Btrfs <linux-btrfs@vger.kernel.org>, xfs@oss.sgi.com
To: Ben Myers <bpm@sgi.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111115182113.GD29840@sgi.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 15, 2011 at 12:21:13PM -0600, Ben Myers wrote:
> Hi Wu Bo,
> 
> On Thu, Nov 03, 2011 at 11:09:00AM +0800, WuBo wrote:
> > This test is for preallocation test. If the disk is full, just with a prealloc
> > file has some free space that prealloc early. We need to check whether the write
> > to the free space is success or not.
> > 
> > Signed-off-by: Wu Bo <Wu.Bo@cn.fujitsu.com>
> 
> This test is failing for me because I don't have fallocate installed.  I
> suggest the test could to be changed to check for binaries it uses,
> possibly the version of those binaries, and then not run unless the
> right ones are installed.  But the best I can do right now is make a
> note of it.

It might be even better to just use the xfs_io falloc command as we
generally expect an uptodate xfs_io for use with xfstests.

