Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54099 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752965AbaBYQ2T (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Feb 2014 11:28:19 -0500
Date: Tue, 25 Feb 2014 17:28:16 +0100
From: David Sterba <dsterba@suse.cz>
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] Btrfs-progs: use bitfield instead of integer for
 some variants in fs_info
Message-ID: <20140225162816.GY16073@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1393328937-26171-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
 <1393328937-26171-2-git-send-email-wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1393328937-26171-2-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 25, 2014 at 07:48:57PM +0800, Wang Shilong wrote:
> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
> ---
>  ctree.h | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/ctree.h b/ctree.h
> index 3cc3477..9b461af 100644
> --- a/ctree.h
> +++ b/ctree.h
> @@ -984,9 +984,11 @@ struct btrfs_fs_info {
>  	struct btrfs_fs_devices *fs_devices;
>  	struct list_head space_info;
>  	int system_allocs;
> -	int readonly;
> -	int on_restoring;
> -	int is_chunk_recover;
> +
> +	unsigned int readonly:1;
> +	unsigned int on_restoring:1;
> +	unsigned int is_chunk_recover:1;

Well, the integers are wasteful, but there's only one instance of
fs_info per fsck run, so it saves like 8 bytes in total. I'm not sure
this patch is needed.
