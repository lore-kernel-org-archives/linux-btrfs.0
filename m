Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p05-ob.rzone.de ([81.169.146.181]:40112 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226Ab2IEEW7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 5 Sep 2012 00:22:59 -0400
Message-ID: <5046D3A0.6060402@jan-o-sch.net>
Date: Wed, 05 Sep 2012 06:22:56 +0200
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: Gabriel de Perthuis <g2p.code+btrfs@gmail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Warn when skipping snapshots created with older kernels.
References: <1346776858-6208-1-git-send-email-g2p.code+btrfs@gmail.com>
In-Reply-To: <1346776858-6208-1-git-send-email-g2p.code+btrfs@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, September 04, 2012 at 18:40 (+0200), Gabriel de Perthuis wrote:
> This message is more explicit than "ERROR: could not resolve root_id",
> the message that will be shown immediately before `btrfs send` bails.
> 
> Also skip invalid high OIDs.
> 
> Signed-off-by: Gabriel de Perthuis <g2p.code+btrfs@gmail.com>
> ---
>  send-utils.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/send-utils.c b/send-utils.c
> index a43d47e..386aeb3 100644
> --- a/send-utils.c
> +++ b/send-utils.c
> @@ -224,6 +224,7 @@ int subvol_uuid_search_init(int mnt_fd, struct subvol_uuid_search *s)
>  
>  			if ((sh->objectid != 5 &&
>  			    sh->objectid < BTRFS_FIRST_FREE_OBJECTID) ||
> +			    sh->objectid >= BTRFS_LAST_FREE_OBJECTID ||
>  			    sh->objectid == BTRFS_FREE_INO_OBJECTID)
>  				goto skip;

Should be "sh->objectid > BTRFS_LAST_FREE_OBJECTID" (not ">=") and we should
drop the explicit check for BTRFS_FREE_INO_OBJECTID then, because that one is
not between first-free and last-free.

> @@ -231,6 +232,11 @@ int subvol_uuid_search_init(int mnt_fd, struct subvol_uuid_search *s)
>  				/* older kernels don't have uuids+times */
>  				if (sh->len < sizeof(root_item)) {
>  					root_item_valid = 0;
> +					fprintf(stderr,
> +					        "Ignoring subvolume id %llu, "
> +					        "btrfs send needs snapshots "
> +					        "created with kernel 3.6+\n",
> +					        sh->objectid);
>  					goto skip;
>  				}
>  				root_item_ptr = (struct btrfs_root_item *)

Makes sense. Thanks,
-Jan
