Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57966 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751899AbdEEOYz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 5 May 2017 10:24:55 -0400
Date: Fri, 5 May 2017 16:24:47 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/6 RFC] utilize bio_clone_fast to clean up
Message-ID: <20170505142447.GC10575@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1492478187-24875-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1492478187-24875-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 17, 2017 at 06:16:21PM -0700, Liu Bo wrote:
> This attempts to use bio_clone_fast() in the places where we clone bio,
> such as when bio got cloned for multiple disks and when bio got split
> during dio submit.
> 
> One benefit is to simplify dio submit to avoid calling bio_add_page one by
> one.
> 
> Another benefit is that comparing to bio_clone_bioset, bio_clone_fast is
> faster because of copying the vector pointer directly, and bio_clone_fast
> doesn't modify bi_vcnt, so the extra work is to fix up bi_vcnt usage we
> currently have to use bi_iter to iterate bvec.
> 
> Liu Bo (6):
>   Btrfs: use bio_clone_fast to clone our bio

Please extend the changelog of this patch, use the text in the cover
letter.

>   Btrfs: use bio_clone_bioset_partial to simplify DIO submit

This patch is too big, can you split it to smaller chunks? I was not
able to review it, it seems to touch several things at once, it's hard
to keep the context.

>   Btrfs: change how we iterate bios in endio
>   Btrfs: record error if one block has failed to retry
>   Btrfs: change check-integrity to use bvec_iter
>   Btrfs: unify naming of btrfs_io_bio

The rest looks ok.

Have you done perofrmance tests? Not that it's necessary, but would be
interesting to see the effects. The effects of simplified code are
likely unmeasurable, but the _fast version skips some mempool exercises
so this could lead to improvements under memory pressure. And these is
hardly deterministic conditions, could be hard. I'me expecting some
latency improvemtnest.
