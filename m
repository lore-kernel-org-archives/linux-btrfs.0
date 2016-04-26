Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36165 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751101AbcDZKGz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Apr 2016 06:06:55 -0400
Date: Tue, 26 Apr 2016 12:06:43 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH] btrfs-progs: fsck: Fix found bytes accounting error
Message-ID: <20160426100643.GF29353@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1461638989-5048-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1461638989-5048-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 26, 2016 at 10:49:49AM +0800, Qu Wenruo wrote:
> In the new add_extent_rec_nolookup() function, we add bytes_used to
> update found bytes accounting.
> 
> However there is a typo that we used tmpl->nr, which should be rec->nr.
> This will make us to add 1 for data backref, instead the correct size.

I'm not able to trace that back to the original code, the value template
is just filled from the parameters and I don't see where bytes_used
would get set from the rec->nr value.

> --- a/cmds-check.c
> +++ b/cmds-check.c
> @@ -4550,7 +4550,7 @@ static int add_extent_rec_nolookup(struct cache_tree *extent_cache,
>  	rec->cache.size = tmpl->nr;
>  	ret = insert_cache_extent(extent_cache, &rec->cache);
>  	BUG_ON(ret);
> -	bytes_used += tmpl->nr;
> +	bytes_used += rec->nr;

ie. this would be just 'nr' before the refactoring.
