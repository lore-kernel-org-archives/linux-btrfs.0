Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47785 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753570AbaFRQcb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Jun 2014 12:32:31 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 38356ACA1
	for <linux-btrfs@vger.kernel.org>; Wed, 18 Jun 2014 16:32:30 +0000 (UTC)
Date: Wed, 18 Jun 2014 18:32:29 +0200
From: David Sterba <dsterba@suse.cz>
To: Jeff Mahoney <jeffm@suse.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH] btrfs-progs: canonicalize pathnames for device commands
Message-ID: <20140618163229.GY1903@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <538F84DF.3090300@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <538F84DF.3090300@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 04, 2014 at 04:43:11PM -0400, Jeff Mahoney wrote:
> --- a/utils.c
> +++ b/utils.c
> @@ -987,6 +987,63 @@ static int blk_file_in_dev_list(struct b
>  }
>  
>  /*
> + * Resolve a pathname to a device mapper node to /dev/mapper/<name>
> + * Returns NULL on invalid input or malloc failure; Other failures
> + * will be handled by the caller using the input pathame.
> + */
> +char *canonicalize_dm_name(const char *ptname)
> +{
> +	FILE	*f;
> +	size_t	sz;
> +	char	path[256], name[256], *res = NULL;

FYI, I've changed this to PATH_MAX
