Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45442 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751082AbaLSQvD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Dec 2014 11:51:03 -0500
Message-ID: <54945770.2060802@redhat.com>
Date: Fri, 19 Dec 2014 10:50:56 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/6] btrfs-progs: fragments, close output file on error
References: <cover.1419005022.git.dsterba@suse.cz> <fe4faae136f941466325234ba2a2f6b347d1dbb4.1419005022.git.dsterba@suse.cz>
In-Reply-To: <fe4faae136f941466325234ba2a2f6b347d1dbb4.1419005022.git.dsterba@suse.cz>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/19/14 10:06 AM, David Sterba wrote:
> Resolves-Coverity-CID: 1258794
> Signed-off-by: David Sterba <dsterba@suse.cz>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  btrfs-fragments.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/btrfs-fragments.c b/btrfs-fragments.c
> index d03c2c3e7319..360f10f87bfa 100644
> --- a/btrfs-fragments.c
> +++ b/btrfs-fragments.c
> @@ -233,7 +233,7 @@ list_fragments(int fd, u64 flags, char *dir)
>  		ret = ioctl(fd, BTRFS_IOC_TREE_SEARCH, &args);
>  		if (ret < 0) {
>  			fprintf(stderr, "ERROR: can't perform the search\n");
> -			return ret;
> +			goto out_close;
>  		}
>  		/* the ioctl returns the number of item it found in nr_items */
>  		if (sk->nr_items == 0)
> @@ -373,7 +373,10 @@ skip:;
>  		fprintf(html, "</p>");
>  	}
>  	fprintf(html, "</body></html>\n");
> -	
> +
> +out_close:
> +	fclose(html);
> +
>  	return ret;
>  }
>  
> 

