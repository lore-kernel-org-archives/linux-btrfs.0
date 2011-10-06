From: David Sterba <dave@jikos.cz>
Subject: Re: [PATCH] Btrfs: fix recursive auto-defrag
Date: Thu, 6 Oct 2011 16:14:56 +0200
Message-ID: <20111006141456.GB17912@twin.jikos.cz>
References: <4E8D230A.4040801@cn.fujitsu.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E8D230A.4040801@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 06, 2011 at 11:39:54AM +0800, Li Zefan wrote:
> Follow those steps:
> 
>   # mount -o autodefrag /dev/sda7 /mnt
>   # dd if=/dev/urandom of=/mnt/tmp bs=200K count=1
>   # sync
>   # dd if=/dev/urandom of=/mnt/tmp bs=8K count=1 conv=notrunc
> 
> and then it'll go into a loop: writeback -> defrag -> writeback ...
> 
> It's because writeback writes [8K, 200K] and then writes [0, 8K].
> 
> I tried to make writeback know if the pages are dirtied by defrag,
> but the patch was a bit intrusive. Here I simply set writeback_index
> when we defrag a file.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Tested-by: David Sterba <dsterba@suse.cz>

> ---
>  fs/btrfs/ioctl.c |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 970977a..7a10f94 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -1047,6 +1047,13 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
>  	if (!max_to_defrag)
>  		max_to_defrag = last_index - 1;
>  
> +	/*
> +	 * make writeback starts from i, so the defrag range can be
> +	 * written sequentially.
> +	 */
> +	if (i < inode->i_mapping->writeback_index)
> +		inode->i_mapping->writeback_index = i;
> +
>  	while (i <= last_index && defrag_count < max_to_defrag) {
>  		/*
>  		 * make sure we stop running if someone unmounts
> -- 1.7.3.1 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
