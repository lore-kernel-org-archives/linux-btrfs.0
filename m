Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:47117 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751213AbaG2BLd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Jul 2014 21:11:33 -0400
Message-ID: <53D6F4BF.9010604@cn.fujitsu.com>
Date: Tue, 29 Jul 2014 09:11:27 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Justin Maggard <jmaggard10@gmail.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs-progs: add always option to restore's looping prompt
References: <1406592211-7726-1-git-send-email-jmaggard10@gmail.com>
In-Reply-To: <1406592211-7726-1-git-send-email-jmaggard10@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Justin,

Thanks for the patch first, comment inlined below.
-------- Original Message --------
Subject: [PATCH] btrfs-progs: add always option to restore's looping prompt
From: Justin Maggard <jmaggard10@gmail.com>
To: <linux-btrfs@vger.kernel.org>
Date: 2014年07月29日 08:03
> If you are using btrfs restore to try to recover a very large or
> fragmented file, you may encounter _lots_ of prompts requiring
> you to press 'y' to continue because we are looping a lot.
>
> Add the option to press 'a', to supress these prompts for the rest
> of the file.
> ---
>   cmds-restore.c | 17 +++++++++++------
>   1 file changed, 11 insertions(+), 6 deletions(-)
>
> diff --git a/cmds-restore.c b/cmds-restore.c
> index 96b97e1..ae95d5a 100644
> --- a/cmds-restore.c
> +++ b/cmds-restore.c
> @@ -410,17 +410,19 @@ static int ask_to_continue(const char *file)
>   	char *ret;
>   
>   	printf("We seem to be looping a lot on %s, do you want to keep going "
> -	       "on ? (y/N): ", file);
> +	       "on ? (y/N/a): ", file);
>   again:
>   	ret = fgets(buf, 2, stdin);
>   	if (*ret == '\n' || tolower(*ret) == 'n')
> -		return 1;
> +		return 0;
> +	if (tolower(*ret) == 'a')
> +		return 2;
>   	if (tolower(*ret) != 'y') {
>   		printf("Please enter either 'y' or 'n': ");
Since option 'a' is added, it would be better to change the prompt and 
add 'a' to it.
>   		goto again;
>   	}
>   
> -	return 0;
> +	return 1;
>   }
If add any comment or change the return value from immediate number to 
more meaningful defined number,
it would be much more easier to understand and expend.
Especially when the return value has difference meaning with original one.
>   
>   
> @@ -588,11 +590,14 @@ static int copy_file(struct btrfs_root *root, int fd, struct btrfs_key *key,
>   	}
>   
>   	while (1) {
> -		if (loops++ >= 1024) {
> +		if (loops >= 0 && loops++ >= 1024) {
>   			ret = ask_to_continue(file);
> -			if (ret)
> +			if (ret == 0)
>   				break;
> -			loops = 0;
> +			else if (ret == 1)
> +				loops = 0;
> +			else if (ret == 2)
> +				loops = -1;
>   		}
>   		if (path->slots[0] >= btrfs_header_nritems(leaf)) {
>   			do {
Also, just a suggestion and you can ignore it without any problem,
utils.c provide ask_to_continue() function to provide similar behavior, 
what about improve the one in utils.c
and reuse the ask_to_continue() function?

Thanks,
Qu
