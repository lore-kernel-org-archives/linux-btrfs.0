From: David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH] Btrfs: release space on error in page_mkwrite
Date: Wed, 11 Jan 2012 15:27:09 +0100
Message-ID: <20120111142709.GE21513@ds.suse.cz>
References: <1326223218-5342-1-git-send-email-josef@redhat.com>
Reply-To: dsterba@suse.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1326223218-5342-1-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 10, 2012 at 02:20:18PM -0500, Josef Bacik wrote:
> If updating the inode gave us an ENOSPC we were just returning in page_mkwrite,
> which is a problem since we make our reservation right before trying to update
> the inode, so fix the out label so that we actually free our reservation.
> Thanks,
> 
> Signed-off-by: Josef Bacik <josef@redhat.com>
Tested-by: David Sterba <dsterba@suse.cz>

reproducer:

while :;do ./check 209;done

and some writeback activity, i used compilation or multithreaed random
writes via fio. the warning

WARNING: at fs/btrfs/extent-tree.c:7283 btrfs_free_block_groups+0x25b/0x370

appeared within minutes.


david
