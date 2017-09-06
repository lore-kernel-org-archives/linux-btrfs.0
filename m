Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:51874 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750852AbdIFWcE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Sep 2017 18:32:04 -0400
Date: Wed, 6 Sep 2017 15:28:31 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: use the new helper wbc_to_write_flags
Message-ID: <20170906222831.GA16924@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <20170825001948.7759-1-bo.li.liu@oracle.com>
 <20170906143806.GQ31874@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170906143806.GQ31874@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 06, 2017 at 04:38:06PM +0200, David Sterba wrote:
> On Thu, Aug 24, 2017 at 06:19:48PM -0600, Liu Bo wrote:
> > This updates btrfs to use the helper wbc_to_write_flags which has been
> > applied in ext4/xfs/f2fs/block.
> 
> Added in commit 7637241e651ec36e4094 in 11/2016, I wonder why btrfs
> wasn't been changed as well as it uses the same code patterns as the
> other filesystems.
>

/me is curious, too.

> > Please note that, with this, btrfs's dirty pages written by a
> > writeback job will carry the flag REQ_BACKGROUND, which is currently
> > used by writeback-throttle to determine whether it should go to get a
> > request or wait.
> 
> Which in my understanding of the WBT behaviour is what we want, right?
>

Yes, it gives a hint to WBT whether it should wait or not.

> > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> 
> Reviewed-by: David Sterba <dsterba@suse.com>
> 
> I'm still expecting some surprises (== performance drop) from the recent
> WBT changes, as we still may miss some request flags, but more subtle
> than eg. the superblock REQ_ tags.

Looks like this is the only missing flag I could find, the missing
REQ_META (in another patch) doesn't have an impact on WBT.

thanks,
-liubo
