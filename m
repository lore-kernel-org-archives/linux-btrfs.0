Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41621 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752412AbdFLOK0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Jun 2017 10:10:26 -0400
Date: Mon, 12 Jun 2017 16:09:21 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH] Btrfs: fix Null pointer dereference in dio read endio
Message-ID: <20170612140921.GN25451@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170606195252.17563-1-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170606195252.17563-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 06, 2017 at 01:52:52PM -0600, Liu Bo wrote:
> With switching to use btrfs_bio_clone_partial() to split bio in
> directIO path, read endio is also adapted to that by recording a
> iterator in btrfs_bio, however, it breaks those bios which are less
> than stripe length thus no need to be split and results in NULL
> pointer dereference.
> 
> This fixes the issue by recording the required bio iterator in
> btrfs_bio_clone() which is used to clone non-split bio in directIO
> path.  It doesn't affect other calls of btrfs_bio_clone() because they
> don't need to use this iterator.
> 
> This bug was caught by fstests/generic/091.
> 
> Cc: David Sterba <dsterba@suse.cz>
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
> Based on David's for-next.
> Fixes: commit "Btrfs: change how we iterate bios in endio"

I'd rather fold this change to the original patch than to have a
separate fixup. The changelog can be updated with description of the
special case.
