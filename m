Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35886 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752161AbeFXPZd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 24 Jun 2018 11:25:33 -0400
Date: Sun, 24 Jun 2018 17:22:41 +0200
From: David Sterba <dsterba@suse.cz>
To: torvalds@linux-foundation.org
Cc: clm@fb.com, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Sterba <DSterba@suse.com>
Subject: Re: [GIT PULL] Btrfs fixes for 4.18-rc1
Message-ID: <20180624152240.GD24375@suse.cz>
Reply-To: dsterba@suse.cz
References: <cover.1529853141.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <cover.1529853141.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jun 24, 2018 at 05:19:58PM +0200, David Sterba wrote:
> The following changes since commit ac0b4145d662a3b9e34085dea460fb06ede9b69b:
> 
>   btrfs: scrub: Don't use inode pages for device replace (2018-06-11 15:59:14 +0200)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-4.18-rc1

The signed tag is there too, I forgot to update it in the mail, sorry:

git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-4.18-rc1-tag

> for you to fetch changes up to c5b4a50b74018b3677098151ec5f4fce07d5e6a0:
> 
>   Btrfs: fix return value on rename exchange failure (2018-06-22 12:59:08 +0200)
> 
> ----------------------------------------------------------------
> Filipe Manana (2):
>       Btrfs: fix physical offset reported by fiemap for inline extents
>       Btrfs: fix return value on rename exchange failure
> 
> Lu Fengqi (1):
>       btrfs: fix invalid-free in btrfs_extent_same
> 
>  fs/btrfs/extent_io.c |  5 ++++-
>  fs/btrfs/inode.c     |  4 +++-
>  fs/btrfs/ioctl.c     | 10 +++++-----
>  3 files changed, 12 insertions(+), 7 deletions(-)
