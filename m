Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47787 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751396AbaLSQ7E (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Dec 2014 11:59:04 -0500
Message-ID: <54945953.1060107@redhat.com>
Date: Fri, 19 Dec 2014 10:58:59 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 6/6] btrfs-progs: let btrfs_free_path accept NULL
References: <cover.1419005022.git.dsterba@suse.cz> <b0dc8fd2b3473c0daddde7e2bc59cd13e1963907.1419005022.git.dsterba@suse.cz>
In-Reply-To: <b0dc8fd2b3473c0daddde7e2bc59cd13e1963907.1419005022.git.dsterba@suse.cz>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/19/14 10:06 AM, David Sterba wrote:
> Same in kernel and matches semantics of free().
> 
> Resolves-Coverity-CID: 1054881
> Signed-off-by: David Sterba <dsterba@suse.cz>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  ctree.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/ctree.c b/ctree.c
> index bd6cb125b2a2..589efa3db17e 100644
> --- a/ctree.c
> +++ b/ctree.c
> @@ -48,6 +48,8 @@ struct btrfs_path *btrfs_alloc_path(void)
>  
>  void btrfs_free_path(struct btrfs_path *p)
>  {
> +	if (!p)
> +		return;
>  	btrfs_release_path(p);
>  	kfree(p);
>  }
> 

