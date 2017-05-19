Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42107 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750831AbdESR3z (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 May 2017 13:29:55 -0400
Date: Fri, 19 May 2017 19:28:56 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/8 v1] utilize bio_clone_fast to clean up
Message-ID: <20170519172856.GW4065@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170517222252.29242-1-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170517222252.29242-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 17, 2017 at 04:22:44PM -0600, Liu Bo wrote:
> v1: - Drop the RFC tag.
>     - Update to use bio_segments accordingly as __bio_segments is removed.
>     - Remove if (!bio) since bio_clone_fast with bioset and GFP_NOFS will
>       never fail.
> 
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
> Here are some numbers collected with the script [1], note that most of
> performance tests usually issue bs=4k dio write/read so our directIO split code
> is not tested as it requires bs > stripe_len(64K), thus I made this simple
> script which writes 2G with bs=128K.
> 
> - vanilla:
> real    0m10.265s
> user    0m0.005s
> sys     0m9.164s
> 
> - patched:
> real    0m8.973s
> user    0m0.006s
> sys     0m7.804s
> 
> [1]:
> #!/bin/bash
> 
> M=/mnt/btrfs
> D1=/dev/pmem0p1
> D2=/dev/pmem0p2
> 
> umount $M
> mkfs.btrfs -f $D1 $D2 >/dev/null || exit
> 
> mount $D1 $M -onodatasum || exit
> 
> xfs_io -f -c "falloc 0 2G" $M/foo
> 
> time xfs_io -d -c "pwrite -b 128K 0 2G" $M/foo
> 
> Liu Bo (8):
>   Btrfs: use bio_clone_fast to clone our bio
>   Btrfs: new helper btrfs_bio_clone_partial
>   Btrfs: use bio_clone_bioset_partial to simplify DIO submit
>   Btrfs: change how we iterate bios in endio
>   Btrfs: record error if one block has failed to retry
>   Btrfs: make check-integrity use bvec_iter
>   Btrfs: unify naming of btrfs_io_bio
>   Btrfs: hardcode GFP_NOFS for btrfs_bio_clone_partial

Added to 4.13 queue, thankgs.
