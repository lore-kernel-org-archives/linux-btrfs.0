Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57820 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751308AbaBVA1x (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Feb 2014 19:27:53 -0500
Date: Sat, 22 Feb 2014 01:27:51 +0100
From: David Sterba <dsterba@suse.cz>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 7/9] Btrfs: stop joining the log transaction if sync log
 fails
Message-ID: <20140222002751.GP16073@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1392890939-19044-1-git-send-email-miaox@cn.fujitsu.com>
 <1392890939-19044-7-git-send-email-miaox@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1392890939-19044-7-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 20, 2014 at 06:08:57PM +0800, Miao Xie wrote:
> --- a/fs/btrfs/tree-log.c
> +++ b/fs/btrfs/tree-log.c
> @@ -142,6 +142,12 @@ static int start_log_trans(struct btrfs_trans_handle *trans,
>  
>  	mutex_lock(&root->log_mutex);
>  	if (root->log_root) {
> +		if (ACCESS_ONCE(root->fs_info->last_trans_log_full_commit) ==
> +		    trans->transid) {
> +			ret = -EAGAIN;
> +			goto out;
> +		}

So last_trans_log_full_commit needs special handling, but opencoding it
everywhere is no very clean. Documented set/get helpers would be much
better.
