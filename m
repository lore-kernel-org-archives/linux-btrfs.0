Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39248 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754270AbcCCRSY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 3 Mar 2016 12:18:24 -0500
Date: Thu, 3 Mar 2016 18:18:06 +0100
From: David Sterba <dsterba@suse.cz>
To: Vytas Dauksa <vytas.dauksa@smoothwall.net>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH] btrfs-convert: document -O|--features flag
Message-ID: <20160303171806.GF29310@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1456934428-2420-1-git-send-email-vytas.dauksa@smoothwall.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1456934428-2420-1-git-send-email-vytas.dauksa@smoothwall.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 02, 2016 at 04:00:28PM +0000, Vytas Dauksa wrote:
> Copy-pasted description found at mkfs.btrfs. I did not bother with
> feature list as it seemed to be incomplete.

Convert has smaller set of supported features, so it's better to leave
the list out and refer to the -O list-all command. Applied, thanks.

> ---
>  Documentation/btrfs-convert.asciidoc | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/Documentation/btrfs-convert.asciidoc b/Documentation/btrfs-convert.asciidoc
> index ca3417f..3ec7d55 100644
> --- a/Documentation/btrfs-convert.asciidoc
> +++ b/Documentation/btrfs-convert.asciidoc
> @@ -83,6 +83,13 @@ rollback to the original ext2/3/4 filesystem if possible
>  set filesystem label during conversion
>  -L|--copy-label::
>  use label from the converted filesystem
> +-O|--features <feature1>[,<feature2>...]::
> +A list of filesystem features turned on at btrfs-convert time. Not all features
> +are supported by old kernels. To disable a feature, prefix it with '^'.
> ++
> +To see all available features that btrfs-convert supports run:
> ++
> ++btrfs-convert -O list-all+
>  -p|--progress::
>  show progress of conversion, on by default
>  --no-progress::
> -- 
> 1.9.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
