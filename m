Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45052 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750714AbcKKLhO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 Nov 2016 06:37:14 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id E1AACAC34
        for <linux-btrfs@vger.kernel.org>; Fri, 11 Nov 2016 11:37:12 +0000 (UTC)
Date: Fri, 11 Nov 2016 12:37:10 +0100
From: David Sterba <dsterba@suse.cz>
To: jeffm@suse.com
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] btrfs: increment ctx->pos for every emitted or
 skipped dirent in readdir
Message-ID: <20161111113710.GG12522@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1478366795-27009-1-git-send-email-jeffm@suse.com>
 <1478366795-27009-2-git-send-email-jeffm@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1478366795-27009-2-git-send-email-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Nov 05, 2016 at 01:26:35PM -0400, jeffm@suse.com wrote:
> From: Jeff Mahoney <jeffm@suse.com>
> 
> If we process the last item in the leaf and hit an I/O error while
> reading the next leaf, we return -EIO without having adjusted the
> position.  Since we have emitted dirents, getdents() will return
> the byte count to the user instead of the error.  Subsequent callers
> will emit the last successful dirent again, and return -EIO again,
> with the same result.  Callers loop forever.
> 
> Instead, if we always increment ctx->pos after emitting or skipping
> the dirent, we'll be sure that we won't hit the same one again.  When
> we go to process the next leaf, we won't have emitted any dirents
> and the -EIO will be returned to the user properly.  We also don't
> need to track if we've emitted a dirent already or if we've changed
> the position yet.
> 
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>
