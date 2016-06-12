Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47793 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750746AbcFLExb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 12 Jun 2016 00:53:31 -0400
Date: Sun, 12 Jun 2016 12:53:18 +0800
From: Eryu Guan <eguan@redhat.com>
To: Anand Jain <anand.jain@oracle.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 4/6] fstests: btrfs: add helper function to check if
 btrfs is module
Message-ID: <20160612045318.GB5140@eguan.usersys.redhat.com>
References: <1463495530-425-1-git-send-email-anand.jain@oracle.com>
 <1463495530-425-4-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1463495530-425-4-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 17, 2016 at 10:32:08PM +0800, Anand Jain wrote:
> We need btrfs to be a module so that it can unloaded and reloaded,
> so that we can clean up the btrfs internal in memory device list.

It looks like a bug to me if btrfs needs to reload module to clean up
the device list. If a user builds btrfs in kernel then he cannot replace
btrfs device properly? Or it's not totally clear to me why a test needs
to reload btrfs module.

> 
> This patch adds _require_btrfs_unloadable() and _reload_btrfs_ko()
> to help with the same.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  common/rc | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/common/rc b/common/rc
> index f2b39ddbee0c..a9391b4cbf57 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -1403,6 +1403,18 @@ _supported_os()
>      _notrun "not suitable for this OS: $HOSTOS"
>  }
>  
> +_require_btrfs_unloadable()

The name seems misleading, the name indicates that it requires btrfs to
be unloadable, but in the code it _notrun if btrfs is unloadable.

Thanks,
Eryu

> +{
> +	modprobe -r btrfs || _notrun "btrfs unloadable"
> +	modprobe btrfs || _notrun "Can't load btrfs"
> +}
> +
> +_reload_btrfs_ko()
> +{
> +	modprobe -r btrfs || _fail "btrfs unload failed"
> +	modprobe btrfs || _fail "btrfs load failed"
> +}
> +
>  # this test needs a scratch partition - check we're ok & unmount it
>  # No post-test check of the device is required. e.g. the test intentionally
>  # finishes the test with the filesystem in a corrupt state
> -- 
> 2.7.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
