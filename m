From: David Sterba <dsterba@suse.cz>
Subject: Re: don't fetch the inode size beforehand.
Date: Tue, 6 Sep 2011 16:15:58 +0200
Message-ID: <20110906141558.GB8882@ds.suse.cz>
References: <4E57A07D.7090306@oracle.com>
Reply-To: dsterba@suse.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Jeff Liu <jeff.liu@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E57A07D.7090306@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On Fri, Aug 26, 2011 at 09:32:45PM +0800, Jeff Liu wrote:
> I think we don't need to fetch the inode size in advance. :-P.

yes, the value is not used and rewritten a few lines below anyway.
Please send a patch with proper header and signed-off line to be
accepted.

david


> 
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index e7872e4..f8ad957 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -1698,7 +1698,7 @@ static int find_desired_extent(struct inode
> *inode, loff_t *offset, int origin)
>      u64 lockend = i_size_read(inode);
>      u64 start = *offset;
>      u64 orig_start = *offset;
> -    u64 len = i_size_read(inode);
> +    u64 len;
>      u64 last_end = 0;
>      int ret = 0;
> 
> 
> Thanks,
> -Jeff
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
