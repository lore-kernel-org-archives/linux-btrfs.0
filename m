Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43294 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751156AbaLSQ4r (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Dec 2014 11:56:47 -0500
Message-ID: <549458C9.2040603@redhat.com>
Date: Fri, 19 Dec 2014 10:56:41 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 4/6] btrfs-progs: check result of first_cache_extent
References: <cover.1419005022.git.dsterba@suse.cz> <813550c84636f7d570c541c22eee60b11346b4f3.1419005022.git.dsterba@suse.cz>
In-Reply-To: <813550c84636f7d570c541c22eee60b11346b4f3.1419005022.git.dsterba@suse.cz>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/19/14 10:06 AM, David Sterba wrote:
> If the tree's empty, we'll get NULL and dereference it.

Hm, but this is under an explicit check for not empty:

        while (!cache_tree_empty(roots_info_cache)) {

sooo?  Maybe it's just defensive?  Nothing really wrong
with being defensive, I suppose, so:

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> Resolves-Coverity-CID: 1248828
> Signed-off-by: David Sterba <dsterba@suse.cz>
> ---
>  cmds-check.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/cmds-check.c b/cmds-check.c
> index 6eea36c2f52c..3e7a4ebdce44 100644
> --- a/cmds-check.c
> +++ b/cmds-check.c
> @@ -8075,6 +8075,8 @@ static void free_roots_info_cache(void)
>  		struct root_item_info *rii;
>  
>  		entry = first_cache_extent(roots_info_cache);
> +		if (!entry)
> +			break;
>  		remove_cache_extent(roots_info_cache, entry);
>  		rii = container_of(entry, struct root_item_info, cache_extent);
>  		free(rii);
> 

