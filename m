Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:45600 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754053AbaLDUKL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Dec 2014 15:10:11 -0500
Date: Thu, 4 Dec 2014 22:00:53 +0200
From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
To: Goffredo Baroncelli <kreijack@gmail.com>
Cc: linux-btrfs@vger.kernel.org, Goffredo Baroncelli <kreijack@inwind.it>
Subject: Re: [PATCH 4/5] Add reference to BTRFS_SKIP_LVM_SNAPSHOT
 environment variable.
Message-ID: <20141204200053.GZ12451@reaktio.net>
References: <1417717470-6298-1-git-send-email-kreijack@inwind.it>
 <1417717470-6298-5-git-send-email-kreijack@inwind.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1417717470-6298-5-git-send-email-kreijack@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 04, 2014 at 07:24:29PM +0100, Goffredo Baroncelli wrote:
> Add reference to BTRFS_SKIP_LVM_SNAPSHOT environment viarble in
>                                                      ^^^^^^^

a small typo.. should be "variable".


-- Pasi


> the btrfs(8) documentation.
> 
> Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
> ---
>  Documentation/btrfs.txt | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/Documentation/btrfs.txt b/Documentation/btrfs.txt
> index 3bdc6b4..889b97c 100644
> --- a/Documentation/btrfs.txt
> +++ b/Documentation/btrfs.txt
> @@ -96,6 +96,14 @@ AVAILABILITY
>  Please refer to the btrfs wiki http://btrfs.wiki.kernel.org for
>  further details.
>  
> +ENVIRONMENT VARIABLES
> +---------------------
> +BTRFS_SKIP_LVM_SNAPSHOT::
> +	Controls if the *lvm snapshots* have to be
> +	ignored. Default "yes"; if you need to consider them, set it to "no".
> +	Pay attention that *btrfs* may be confused if two devices have
> +	the same dev uuid. This is the reason to skip a lvm snapshot.
> +
>  SEE ALSO
>  --------
>  `mkfs.btrfs`(8), `ionice`(1),
> -- 
> 2.1.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
