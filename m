From: David Sterba <dave@jikos.cz>
Subject: Re: [PATCH] Btrfs: rewrite btrfs_trim_block_group()
Date: Wed, 23 Nov 2011 16:46:57 +0100
Message-ID: <20111123154657.GD12759@twin.jikos.cz>
References: <4EC4B719.30007@cn.fujitsu.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4EC4B719.30007@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 17, 2011 at 03:26:17PM +0800, Li Zefan wrote:
> diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
> index 8c32434..89cc54e 100644
> --- a/fs/btrfs/free-space-cache.c
> +++ b/fs/btrfs/free-space-cache.c
> +static int trim_no_bitmap(struct btrfs_block_group_cache *block_group,
> +			  u64 *total_trimmed, u64 start, u64 end, u64 minlen)
> +{
> +	struct btrfs_free_space_ctl *ctl = block_group->free_space_ctl;
> +	struct btrfs_free_space *entry;
> +	struct rb_node *node;
> +	int ret;
        int ret = 0;

  CC [M]  fs/btrfs/free-space-cache.o
fs/btrfs/free-space-cache.c: In function trim_no_bitmap:
fs/btrfs/free-space-cache.c:2636: warning: ret may be used uninitialized in this function

Although it seems the uninitialized value could never be returned.


david
