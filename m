Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57299 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966020AbcCPKGB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Mar 2016 06:06:01 -0400
Date: Wed, 16 Mar 2016 11:05:35 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz, clm@fb.com
Subject: Re: [PATCH] btrfs: rename save_error_info to set_fs_error
Message-ID: <20160316100535.GH21722@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1458117788-840-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1458117788-840-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 16, 2016 at 04:43:05PM +0800, Anand Jain wrote:
> @@ -171,7 +171,7 @@ void __btrfs_std_error(struct btrfs_fs_info *fs_info, const char *function,
>  #endif
>  
>  	/* Don't go through full error handling during mount */
> -	save_error_info(fs_info);
> +	set_fs_error(fs_info);

The helper is too trivial, can you please drop it and replace by the
it's code here?

>  	if (sb->s_flags & MS_BORN)
>  		btrfs_handle_error(fs_info);
>  }
