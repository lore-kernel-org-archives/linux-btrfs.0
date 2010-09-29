From: Sean Bartell <wingedtachikoma@gmail.com>
Subject: Re: BTRFS && SSD
Date: Wed, 29 Sep 2010 13:08:55 -0400
Message-ID: <20100929170855.GA4635@lelouch.nomadic.ncsu.edu>
References: <AANLkTik9qiqtePxAhaJTyM7Q-g1nTgw9krTZFf_DaYxn@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, yhxu@wayne.edu, chris.mason@oracle.com
To: Yuehai Xu <yuehaixu@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTik9qiqtePxAhaJTyM7Q-g1nTgw9krTZFf_DaYxn@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 29, 2010 at 11:30:14AM -0400, Yuehai Xu wrote:
> I know BTRFS is a kind of Log-structured File System, which doesn't do
> overwrite. Here is my question, suppose file A is overwritten by A',
> instead of writing A' to the original place of A, a new place is
> selected to store it. However, we know that the address of a file
> should be recorded in its inode. In such case, the corresponding part
> in inode of A should update from the original place A to the new place
> A', is this a kind of overwrite actually? I think no matter what
> design it is for Log-Structured FS, a mapping table is always needed,
> such as inode map, DAT, etc. When a update operation happens for this
> mapping table, is it actually a kind of over-write? If it is, is it a
> bottleneck for the performance of write for SSD?

In btrfs, this is solved by doing the same thing for the inode--a new
place for the leaf holding the inode is chosen. Then the parent of the
leaf must point to the new position of the leaf, so the parent is moved,
and the parent's parent, etc. This goes all the way up to the
superblocks, which are actually overwritten one at a time.

> What do you think the major work that BTRFS can do to improve the
> performance for SSD? I know FTL has becomes smarter and smarter, the
> idea of log-structured file system is always implemented inside the
> SSD by FTL, in that case, it sounds all the issues have been solved no
> matter what the FS it is in upper stack. But at least, from the
> results of benchmarks on the internet show that the performance from
> different FS are quite different, such as NILFS2 and BTRFS.
