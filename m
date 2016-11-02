Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52018 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753068AbcKBPVy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 2 Nov 2016 11:21:54 -0400
Date: Wed, 2 Nov 2016 16:21:51 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz,
        Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Subject: Re: [PATCH v2 02/14] btrfs-progs: check: introduce function to find
 dir_item
Message-ID: <20161102152151.GH12522@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20160921031604.23334-1-quwenruo@cn.fujitsu.com>
 <20160921031604.23334-3-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160921031604.23334-3-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 21, 2016 at 11:15:52AM +0800, Qu Wenruo wrote:
> From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
> 
> Introduce a new function find_dir_item() to find DIR_ITEM for the given
> key, and check it with the specified INODE_REF/INODE_EXTREF match.
> 
> Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
>  cmds-check.c | 140 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 140 insertions(+)
> 
> diff --git a/cmds-check.c b/cmds-check.c
> index 998ba63..4e25804 100644
> --- a/cmds-check.c
> +++ b/cmds-check.c
> @@ -3848,6 +3848,146 @@ out:
>  	return err;
>  }
>  
> +#define ROOT_DIR_ERROR		(1<<1)	/* bad root_dir */
> +#define DIR_ITEM_MISSING	(1<<2)	/* DIR_ITEM not found */
> +#define DIR_ITEM_MISMATCH	(1<<3)	/* DIR_ITEM found but not match */

What's the reason for another definition of the error codes? They're
mostly copied from te I_ERR_* counterparts. I'd rather have one set of
error codes.
