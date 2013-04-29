Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48915 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757294Ab3D2Ofi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Apr 2013 10:35:38 -0400
Date: Mon, 29 Apr 2013 16:35:36 +0200
From: David Sterba <dsterba@suse.cz>
To: Stefan Behrens <sbehrens@giantdisaster.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/5] Btrfs: create UUID tree if required
Message-ID: <20130429143536.GQ16427@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1366384796.git.sbehrens@giantdisaster.de>
 <5d01d8b14f6a8046f32ec887ab92da4f57a742a1.1366384796.git.sbehrens@giantdisaster.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5d01d8b14f6a8046f32ec887ab92da4f57a742a1.1366384796.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 19, 2013 at 05:41:04PM +0200, Stefan Behrens wrote:
> @@ -2830,6 +2857,15 @@ retry_root_backup:
>  		return ret;
>  	}
>  
> +	if (need_to_create_uuid_tree) {
> +		ret = btrfs_create_uuid_tree(fs_info, tree_root);
> +		if (ret) {
> +			pr_warn("btrfs: failed to create the UUID tree\n");

Please print the error code

> +			close_ctree(tree_root);
> +			return ret;
> +		}
> +	}
> +
>  	return 0;
>  
>  fail_qgroup:
