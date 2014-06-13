Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30237 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753839AbaFMVqX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Jun 2014 17:46:23 -0400
Message-ID: <539B7131.9070005@redhat.com>
Date: Fri, 13 Jun 2014 16:46:25 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Adam Buchbinder <abuchbinder@google.com>, linux-btrfs@vger.kernel.org
CC: dave@jikos.cz
Subject: Re: [PATCH 2/2] Remove a leading '+'.
References: <1402695276-28104-1-git-send-email-abuchbinder@google.com> <1402695276-28104-2-git-send-email-abuchbinder@google.com>
In-Reply-To: <1402695276-28104-2-git-send-email-abuchbinder@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 6/13/14, 4:34 PM, Adam Buchbinder wrote:
> It was added in commit aab7f3ae3eb02fb7e8a6a31d7e2ada704a3dcd5e,
> most likely as a copy-pasteo.
> 
> Signed-off-by: Adam Buchbinder <abuchbinder@google.com>
> ---
>  btrfs-show-super.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/btrfs-show-super.c b/btrfs-show-super.c
> index f42cd15..ed0311f 100644
> --- a/btrfs-show-super.c
> +++ b/btrfs-show-super.c
> @@ -50,7 +50,7 @@ static void print_usage(void)
>  	fprintf(stderr, "\t-f : print full superblock information\n");
>  	fprintf(stderr, "\t-a : print information of all superblocks\n");
>  	fprintf(stderr, "\t-i <super_mirror> : specify which mirror to print out\n");
> -+	fprintf(stderr, "\t-F : attempt to dump superblocks with bad magic\n");
> +	fprintf(stderr, "\t-F : attempt to dump superblocks with bad magic\n");
>  	fprintf(stderr, "%s\n", BTRFS_BUILD_VERSION);
>  }
>  
> 

Whoa, git blame blames me, but that's not the patch I sent.  ;)

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

thanks,
-Eric

