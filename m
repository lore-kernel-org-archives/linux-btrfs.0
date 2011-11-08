From: David Sterba <dave@jikos.cz>
Subject: Re: BUG at fs/btrfs/file.c:1656 [for-linus]
Date: Tue, 8 Nov 2011 19:25:17 +0100
Message-ID: <20111108182517.GU12759@twin.jikos.cz>
References: <20111108171347.GS12759@twin.jikos.cz> <20111108174520.GL4954@shiny>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111108174520.GL4954@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 08, 2011 at 12:45:20PM -0500, Chris Mason wrote:
> > 
> > btrfs_fallocate():
> > 1651         while (1) {
> > 1652                 u64 actual_end;
> > 1653
> > 1654                 em = btrfs_get_extent(inode, NULL, 0, cur_offset,
> > 1655                                       alloc_end - cur_offset, 0);
> > 1656                 BUG_ON(IS_ERR_OR_NULL(em));
> > 
> > RAX says its -17 EEXIST. We saw this with raid10 + inode_cache, but this is not
> > the case.
> > 
> > the process that triggered it:
> > 
> > D+   17:52   0:00 rm -rf /mnt/a1/fsstress.8088.1 /mnt/a1/fsstress.8088.2
> > 
> > $ cat /proc/8458/stack
> > [<ffffffff81152205>] vfs_unlink+0x65/0x100
> > [<ffffffff8115243b>] do_unlinkat+0x19b/0x1d0
> > [<ffffffff811532b2>] sys_unlinkat+0x22/0x40
> > [<ffffffff81a1d742>] system_call_fastpath+0x16/0x1b
> > [<ffffffffffffffff>] 0xffffffffffffffff
> 
> In this case, btrfs_get_extent is trying to insert into the rbtree
> mapping offset to disk.  merge_extent_mapping must be failing.
> 
> The only part that confuses me is that we don't fallocate from unlink,
> so that process must have moved on.
> 
> At any rate, mege_extent_mapping is pretty simple, were there any other
> errors in the dmesg?

I had a look into the serial log and found only this:

[  123.817396] device fsid 013ae4d9-587c-4f4e-8cd7-5b540a13c37d devid 1 transid 4 /dev/sda9
[  123.828156] btrfs: force lzo compression
[  123.833103] btrfs: enabling auto defrag
[  123.836883] btrfs: enabling inode map caching
                      ^^^^^^^^^^^^^^^^^^^^^^^^^^
[  123.843357] btrfs: disk space caching is enabled
[  125.227964] device fsid b978b4d7-2681-426e-8b44-9dbd80a3c18d devid 1 transid 4 /dev/sda9
[  125.238488] btrfs: use lzo compression
[  125.243286] btrfs: enabling auto defrag
[  125.246991] btrfs: disk space caching is enabled

but not in the second mount probably in test 002. I have turned off
inode_cache, though I found a duplicate entry in /etc/fstab for

/dev/sda9       /mnt/a2         btrfs   compress-force=lzo,autodefrag,space_cache,inode_cache,noauto 0 0
/dev/sda9       /mnt/a2         btrfs   compress-force=lzo,autodefrag,space_cache,noauto 0 0

the first one was meant to be commented out (but by accident was not and that
would explain the syslog message). But this should not matter wrt crash as it
happens on /dev/sda5 and /mnt/a1 .


david
