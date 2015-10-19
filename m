Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54862 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750791AbbJSN5j (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 Oct 2015 09:57:39 -0400
Date: Mon, 19 Oct 2015 15:56:25 +0200
From: David Sterba <dsterba@suse.cz>
To: Eryu Guan <guaneryu@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 04/10] btrfs-progs: return -EIO properly in
 restore_metadump()
Message-ID: <20151019135625.GZ27761@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1445254680-11102-1-git-send-email-guaneryu@gmail.com>
 <1445254680-11102-5-git-send-email-guaneryu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1445254680-11102-5-git-send-email-guaneryu@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 19, 2015 at 07:37:54PM +0800, Eryu Guan wrote:
> Error number -EIO is assigned to ret but later ret is overwritten by
> wait_for_worker().
> 
> Signed-off-by: Eryu Guan <guaneryu@gmail.com>
> ---
>  btrfs-image.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/btrfs-image.c b/btrfs-image.c
> index 82eed05..7d3a2f8 100644
> --- a/btrfs-image.c
> +++ b/btrfs-image.c
> @@ -2465,6 +2465,7 @@ static int restore_metadump(const char *input, FILE *out, int old_restore,
>  	u64 bytenr = 0;
>  	FILE *in = NULL;
>  	int ret = 0;
> +	int err = 0;
>  
>  	if (!strcmp(input, "-")) {
>  		in = stdin;
> @@ -2526,7 +2527,7 @@ static int restore_metadump(const char *input, FILE *out, int old_restore,
>  		if (le64_to_cpu(header->magic) != HEADER_MAGIC ||
>  		    le64_to_cpu(header->bytenr) != bytenr) {
>  			fprintf(stderr, "bad header in metadump image\n");
> -			ret = -EIO;
> +			err = -EIO;

Shouldn't we do 'goto out' instead? As this looks likes the metadump is
broken anyway so there's no point in continuing.
