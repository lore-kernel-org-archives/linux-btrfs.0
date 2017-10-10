Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40272 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756478AbdJJLIP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Oct 2017 07:08:15 -0400
Subject: Re: [PATCH] btrfs: use appropriate replacements for
 __sb_{start,end}_write calls
To: Rakesh Pandit <rakesh@tuxera.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>, Josef Bacik <jbacik@fb.com>,
        Chris Mason <clm@fb.com>
References: <20171010104803.GA33133@dhcp-216.srv.tuxera.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <6ada5c8b-4ad0-8421-cd76-9d90df5ea24b@suse.com>
Date: Tue, 10 Oct 2017 14:08:11 +0300
MIME-Version: 1.0
In-Reply-To: <20171010104803.GA33133@dhcp-216.srv.tuxera.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 10.10.2017 13:48, Rakesh Pandit wrote:
> Commit a53f4f8e9c8eb ("btrfs: Don't call btrfs_start_transaction() on
> frozen fs to avoid deadlock.") started using internal calls and we
> replace them with more suitable ones.
> 
> Signed-off-by: Rakesh Pandit <rakesh@tuxera.com>
> ---
>  fs/btrfs/super.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 35a128a..99c21ae 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -1205,8 +1205,8 @@ int btrfs_sync_fs(struct super_block *sb, int wait)
>  			 * happens. The pending operations are delayed to the
>  			 * next commit after thawing.
>  			 */
> -			if (__sb_start_write(sb, SB_FREEZE_WRITE, false))
> -				__sb_end_write(sb, SB_FREEZE_WRITE);
> +			if (sb_start_write_trylock(sb))
> +				sb_end_write(sb)
>  			else
>  				return 0;

On second thought, what's to prevent the filesystem to be frozen if
sb_start_write/sb_end_write code executes? Or even after we are in the
middle of btrfs_start_transaction?


>  			trans = btrfs_start_transaction(root, 0);
> 
