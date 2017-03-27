Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57954 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751344AbdC0RIE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Mar 2017 13:08:04 -0400
Date: Mon, 27 Mar 2017 19:07:15 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH] Btrfs: fix wrong failed mirror_num of read-repair on
 raid56
Message-ID: <20170327170715.GL4781@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1490382822-25344-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1490382822-25344-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 24, 2017 at 12:13:42PM -0700, Liu Bo wrote:
> In raid56 senario, after trying parity recovery, we didn't set
> mirror_num for btrfs_bio with failed mirror_num, hence
> end_bio_extent_readpage() will report a random mirror_num in dmesg
> log.
> 
> Cc: David Sterba <dsterba@suse.cz>
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
>  fs/btrfs/volumes.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 73d56ee..be64e4a 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -6197,6 +6197,7 @@ int btrfs_map_bio(struct btrfs_fs_info *fs_info, struct bio *bio,
>  		} else {
>  			ret = raid56_parity_recover(fs_info, bio, bbio,
>  						    map_length, mirror_num, 1);
> +			btrfs_io_bio(bio)->mirror_num = mirror_num;

Should the mirror be set inside raid56_parity_recover? There's another
caller, scrub_submit_raid56_bio_wait, that does not update the
bio->mirror_num. I am not sure if this is the same case though.

>  		}
>  
>  		btrfs_bio_counter_dec(fs_info);
