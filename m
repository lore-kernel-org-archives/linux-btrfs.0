Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:15981 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962Ab2G0LJ4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Jul 2012 07:09:56 -0400
Message-ID: <50127701.7040603@giantdisaster.de>
Date: Fri, 27 Jul 2012 13:09:53 +0200
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Nageswara R Sastry <nasastry@in.ibm.com>
CC: linux-btrfs@vger.kernel.org, chandanrmail@gmail.com
Subject: Re: [PATCH] btrfs-progs: btrfs-image.c: Added NULL pointer check.
References: <1343385254-8299-1-git-send-email-nasastry@in.ibm.com>
In-Reply-To: <1343385254-8299-1-git-send-email-nasastry@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 27 Jul 2012 16:04:14 +0530, Nageswara R Sastry wrote:
> Check for the return value of 'open_ctree()' before dereferencing it.
> 
> Signed-off-by: Nageswara R Sastry <nasastry@in.ibm.com>
> ---
>  btrfs-image.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/btrfs-image.c b/btrfs-image.c
> index f2bbcc8..2a33a55 100644
> --- a/btrfs-image.c
> +++ b/btrfs-image.c
> @@ -491,6 +491,7 @@ static int create_metadump(const char *input, FILE *out, int num_threads,
>  	int ret;
>  
>  	root = open_ctree(input, 0, 0);
> +	BUG_ON(!root);
>  	BUG_ON(root->nodesize != root->leafsize);
>  
>  	ret = metadump_init(&metadump, root, out, num_threads,
> 

In general, explicit BUG_ON() checks for a NULL pointer are not added to
the Linux kernel if the pointer is dereferenced afterwards. When the
NULL area is accessed, you get a general protection fault including the
call trace and a dump of all registers. Adding explicit BUG_ON(ptr !=
NULL) adds overhead without bringing any additional information.
