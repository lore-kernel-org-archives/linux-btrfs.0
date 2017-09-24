Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50302 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753517AbdIXXNj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 24 Sep 2017 19:13:39 -0400
Date: Mon, 25 Sep 2017 00:56:20 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, Goffredo Baroncelli <kreijack@inwind.it>
Subject: Re: [PATCH] Btrfs: fix unexpected result when dio reading corrupted
 blocks
Message-ID: <20170924225620.GX29043@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170915210651.8385-1-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170915210651.8385-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 15, 2017 at 03:06:51PM -0600, Liu Bo wrote:
> commit 4246a0b63bd8 ("block: add a bi_error field to struct bio")
> changed the logic of how dio read endio reports errors.
> 
> For single stripe dio read, %bio->bi_status reflects the error before
> verifying checksum, and now we're updating it when data block matches
> with its checksum, while in the mismatching case, %bio->bi_status is
> not updated to relfect that.
> 
> When some blocks in a file have been corrupted on disk, reading such a
> file ends up with
> 
> 1) checksum errros are reported in kernel log
> 2) read(2) returns successfully with some content being 0x01.
> 
> In order to fix it, we need to report its checksum mismatch error to
> the upper layer (dio layer in this case) as well.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> Reported-by: Goffredo Baroncelli <kreijack@inwind.it>
> cc: Goffredo Baroncelli <kreijack@inwind.it>

Reviewed-by: David Sterba <dsterba@suse.com>
