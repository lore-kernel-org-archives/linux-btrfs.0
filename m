Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47956 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727029AbeITWtq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 20 Sep 2018 18:49:46 -0400
Date: Thu, 20 Sep 2018 19:05:19 +0200
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@osandov.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        David Sterba <dsterba@suse.com>
Subject: Re: [PATCH v8 5/6] Btrfs: rename get_chunk_map() and make it
 non-static
Message-ID: <20180920170519.GC5847@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1537419652.git.osandov@fb.com>
 <3b86717cc05109318d986b2b9fbde8b26e774c1f.1537419652.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <3b86717cc05109318d986b2b9fbde8b26e774c1f.1537419652.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 19, 2018 at 10:02:16PM -0700, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> The Btrfs swap code is going to need it, so give it a btrfs_ prefix and
> make it non-static.
> 
> Reviewed-by: Nikolay Borisov <nborisov@suse.com>
> Signed-off-by: Omar Sandoval <osandov@fb.com>
> ---
>  fs/btrfs/volumes.c | 29 ++++++++++++++++++-----------
>  fs/btrfs/volumes.h |  2 ++
>  2 files changed, 20 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index a2761395ed22..fe66b635c023 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -2714,8 +2714,15 @@ static int btrfs_del_sys_chunk(struct btrfs_fs_info *fs_info, u64 chunk_offset)
>  	return ret;
>  }
>  
> -static struct extent_map *get_chunk_map(struct btrfs_fs_info *fs_info,
> -					u64 logical, u64 length)
> +/**

Minor nit, I'll fix that eventually: the /** is for kernel doc but as the
function is internal to btrfs and there's no documentation generated
from that, it's better to use plain /* . The parameter formatting
according to the kernel doc documentation is fine but does not strictly
need to conform as long as it's human readable.

Otherwise patch is ok.
