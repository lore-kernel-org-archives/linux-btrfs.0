Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45462 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750980AbcKGKUa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 7 Nov 2016 05:20:30 -0500
Date: Mon, 7 Nov 2016 11:20:27 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH v4 1/4] btrfs-progs: utils: Introduce function to escape
 characters
Message-ID: <20161107102027.GK12522@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20161103040734.8098-1-quwenruo@cn.fujitsu.com>
 <20161103040734.8098-2-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161103040734.8098-2-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 03, 2016 at 12:07:31PM +0800, Qu Wenruo wrote:
> Introduce new function, escape_string_inplace(), to escape specified
> characters in place.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
>  utils.c | 24 ++++++++++++++++++++++++
>  utils.h | 14 ++++++++++++++
>  2 files changed, 38 insertions(+)
> 
> diff --git a/utils.c b/utils.c
> index 3f54245..3c50d84 100644
> --- a/utils.c
> +++ b/utils.c
> @@ -4251,3 +4251,27 @@ unsigned int rand_range(unsigned int upper)
>  	 */
>  	return (unsigned int)(jrand48(rand_seed) % upper);
>  }
> +
> +static void escape_one_char(char *restrict string, char escape)
> +{
> +	int i = 0;
> +	int j = 0;
> +
> +	while (string[j] != '\0') {
> +		if (string[j] != escape) {
> +			string[i] = string[j];
> +			i++;
> +		}

So how does this actually escape the characters? I don't see anything
inserted. I think we don't have a common understanding of what's
supposed to be done here. I mean C-string-like escaping. And this cannot
be done inplace, as it increases string length. I've implemented it in a
different way, so this patch is left out. The final stream dump output
is preserved.
