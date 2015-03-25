Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32963 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751837AbbCYDXP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Mar 2015 23:23:15 -0400
Date: Wed, 25 Mar 2015 11:23:13 +0800
From: Eryu Guan <eguan@redhat.com>
To: Eric Sandeen <sandeen@redhat.com>
Cc: fstests@vger.kernel.org, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] fstests: fix _filter_transcation_commit_default
Message-ID: <20150325032313.GS4810@dhcp-13-216.nay.redhat.com>
References: <5511DEDB.9040804@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5511DEDB.9040804@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 24, 2015 at 05:02:03PM -0500, Eric Sandeen wrote:
> btrfs has started emitting new information from
> cmd_subvol_delete(), so filter that out or it breaks btrfs/001:
> 
>     -Delete subvolume 'SCRATCH_MNT/snap'
>     +Delete subvolume (no-commit): 'SCRATCH_MNT/snap'
> 
> (Spell "transaction" correctly while we're at it.)
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks good to me.

Reviewed-by: Eryu Guan <eguan@redhat.com>

> ---
> 
> diff --git a/common/filter.btrfs b/common/filter.btrfs
> index ea047c5..9bb6479 100644
> --- a/common/filter.btrfs
> +++ b/common/filter.btrfs
> @@ -57,13 +57,14 @@ _filter_btrfs_device_stats()
>  	sed -e "s/ *$NUMDEVS /<NUMDEVS> /g"
>  }
>  
> -_filter_transcation_commit_default() {
> -	sed -e "/Transaction commit: none (default)/d"
> +_filter_transaction_commit() {
> +	sed -e "/Transaction commit: none (default)/d" | \
> +	sed -e "s/Delete subvolume (.*commit):/Delete subvolume/g"
>  }
>  
>  _filter_btrfs_subvol_delete()
>  {
> -	_filter_scratch | _filter_transcation_commit_default
> +	_filter_scratch | _filter_transaction_commit
>  
>  }
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
