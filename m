Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38890 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752456AbdFMNaX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Jun 2017 09:30:23 -0400
Date: Tue, 13 Jun 2017 15:29:17 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH v3] Btrfs: change how we iterate bios in endio
Message-ID: <20170613132917.GV25451@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170517222252.29242-5-bo.li.liu@oracle.com>
 <20170612170512.1837-1-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170612170512.1837-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 12, 2017 at 11:05:12AM -0600, Liu Bo wrote:
> Since dio submit has used bio_clone_fast, the submitted bio may not have a
> reliable bi_vcnt, for the bio vector iterations in checksum related
> functions, bio->bi_iter is not modified yet and it's safe to use
> bio_for_each_segment, while for those bio vector iterations in dio read's
> endio, we now save a copy of bvec_iter in struct btrfs_io_bio when cloning
> bios and use the helper __bio_for_each_segment with the saved bvec_iter to
> access each bvec.
> 
> Also for dio reads which don't get split, we also need to save a copy of
> bio iterator in btrfs_bio_clone to let __bio_for_each_segments to access
> each bvec in dio read's endio.  Note that it doesn't affect other calls of
> btrfs_bio_clone() because they don't need to use this iterator.
> 
> Cc: David Sterba <dsterba@suse.cz>
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
> v2: Fix null pointer crash in the case of non-split dio reads.

Perfect, thanks. Patch replaced.
