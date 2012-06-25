Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:33631 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753464Ab2FYMKe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Jun 2012 08:10:34 -0400
Date: Mon, 25 Jun 2012 14:10:26 +0200
From: David Sterba <dave@jikos.cz>
To: Ilya Dryomov <idryomov@gmail.com>
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@fusionio.com>,
        David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH] Btrfs: do not ignore errors from
 btrfs_cleanup_fs_roots() when mounting
Message-ID: <20120625121026.GB28144@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <1340388853-20897-1-git-send-email-idryomov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1340388853-20897-1-git-send-email-idryomov@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 22, 2012 at 09:14:13PM +0300, Ilya Dryomov wrote:
> There used to be a BUG_ON(ret) there before EH patch (79787eaa) went in.
> Bail out with EINVAL.
> 
> Cc: David Sterba <dsterba@suse.cz>
> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
> ---
>  fs/btrfs/disk-io.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index f06db81..77872da 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -2461,8 +2461,8 @@ retry_root_backup:
>  
>  	if (!(sb->s_flags & MS_RDONLY)) {
>  		ret = btrfs_cleanup_fs_roots(fs_info);
> -		if (ret) {
> -			}
> +		if (ret)
> +			goto fail_trans_kthread;

Oh, right of course. Thanks.

david
