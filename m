Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60011 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755866AbdJJNV7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Oct 2017 09:21:59 -0400
Date: Tue, 10 Oct 2017 15:20:13 +0200
From: David Sterba <dsterba@suse.cz>
To: Rakesh Pandit <rakesh@tuxera.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Sterba <dsterba@suse.com>, Josef Bacik <jbacik@fb.com>,
        Chris Mason <clm@fb.com>
Subject: Re: [PATCH] btrfs: use appropriate replacements for
 __sb_{start,end}_write calls
Message-ID: <20171010132013.GN3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171010104803.GA33133@dhcp-216.srv.tuxera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20171010104803.GA33133@dhcp-216.srv.tuxera.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 10, 2017 at 01:48:05PM +0300, Rakesh Pandit wrote:
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

  CC [M]  fs/btrfs/print-tree.o
fs/btrfs/super.c: In function ‘btrfs_sync_fs’:
fs/btrfs/super.c:1210:4: error: expected ‘;’ before ‘else’
    else
    ^~~~

will be fixed.
