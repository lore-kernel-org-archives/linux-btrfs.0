Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35546 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751943Ab3DZS0z (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Apr 2013 14:26:55 -0400
Date: Fri, 26 Apr 2013 11:26:52 -0700
From: Zach Brown <zab@redhat.com>
To: David Sterba <dsterba@suse.cz>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: handle errors returned from get_tree_block_key
Message-ID: <20130426182652.GM25389@lenny.home.zabbo.net>
References: <1366822294-9193-1-git-send-email-dsterba@suse.cz>
 <1366980964-14366-1-git-send-email-dsterba@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1366980964-14366-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> @@ -2906,8 +2909,9 @@ int relocate_tree_blocks(struct btrfs_trans_handle *trans,
>  out:
>  	err = finish_pending_nodes(trans, rc, path, err);
>  
> +out_free_path:
>  	btrfs_free_path(path);
> -out_path:
> +out_free_blocks:
>  	free_block_list(blocks);
>  	return err;
>  }
> -- 
> 1.8.2

Yeah, that makes a lot more sense.

Reviewed-by: Zach Brown <zab@redhat.com>

- z
