Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36846 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751862AbeC0QyL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Mar 2018 12:54:11 -0400
Date: Tue, 27 Mar 2018 18:51:43 +0200
From: David Sterba <dsterba@suse.cz>
To: robbieko <robbieko@synology.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/2]  btrfs fiemap related BUG fix.
Message-ID: <20180327165143.GC30422@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1520410819-32405-1-git-send-email-robbieko@synology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1520410819-32405-1-git-send-email-robbieko@synology.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 07, 2018 at 04:20:17PM +0800, robbieko wrote:
> From: Robbie Ko <robbieko@synology.com>
> 
> This patchset intends to fix btrfs fiemap related bug.
> 
> The fiemap has the following problems:
> 
> 1) Wrong extent count when fm_extent_count is zero.
> 
> 
> 2) SHARED bit is not correct
> I have two ideas, but I do not know which one is the best.
> 
> Like:
>  # dd if=/dev/zero bs=16K count=2 oflag=dsync of=/mnt/btrfs/file
>  # xfs_io -c "fiemap -v" /mnt/btrfs/file
>      /mnt/btrfs/file:
>      EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
>        0: [0..63]:         4241424..4241487    64   0x1
>  # cloner -s $((16*1024)) /mnt/btrfs/file /mnt/btrfs/file_clone
> 
> 1. When any extent is shared in extent map, the entire extent map is shared
>  # xfs_io -c "fiemap -v" /mnt/btrfs/file
>      /mnt/btrfs/file:
>      EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
>        0: [0..63]:         4241424..4241487   64  0x2001
> 
> 2. Split into different extent
>  # xfs_io -c "fiemap -v" /mnt/btrfs/file
>      /mnt/btrfs/file:
>      EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
>        0: [0..31]:         4241424..4241455   32  0x0
>        1: [32..63]:        4241456..4241487   32  0x2001
> 
> Robbie Ko (2):
>   Btrfs: fiemap: pass correct bytenr when fm_extent_count is zero
>   Btrfs: fix fiemap extent SHARED flag error with range clone.

There were a lot of comments, I'm not sure I have a clear picture of
what and how is addressed. Can you please update the patches and resend?
Thanks.
