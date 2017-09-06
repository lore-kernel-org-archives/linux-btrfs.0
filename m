Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58883 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932553AbdIFOjg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 6 Sep 2017 10:39:36 -0400
Date: Wed, 6 Sep 2017 16:38:06 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: use the new helper wbc_to_write_flags
Message-ID: <20170906143806.GQ31874@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170825001948.7759-1-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170825001948.7759-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 24, 2017 at 06:19:48PM -0600, Liu Bo wrote:
> This updates btrfs to use the helper wbc_to_write_flags which has been
> applied in ext4/xfs/f2fs/block.

Added in commit 7637241e651ec36e4094 in 11/2016, I wonder why btrfs
wasn't been changed as well as it uses the same code patterns as the
other filesystems.

> Please note that, with this, btrfs's dirty pages written by a
> writeback job will carry the flag REQ_BACKGROUND, which is currently
> used by writeback-throttle to determine whether it should go to get a
> request or wait.

Which in my understanding of the WBT behaviour is what we want, right?

> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.com>

I'm still expecting some surprises (== performance drop) from the recent
WBT changes, as we still may miss some request flags, but more subtle
than eg. the superblock REQ_ tags.
