Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:6367 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751730AbaG2CMB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Jul 2014 22:12:01 -0400
Message-ID: <53D702EE.1030707@cn.fujitsu.com>
Date: Tue, 29 Jul 2014 10:11:58 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Justin Maggard <jmaggard10@gmail.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2] btrfs-progs: add always option to restore's looping
 prompt
References: <1406598909-9658-1-git-send-email-jmaggard10@gmail.com>
In-Reply-To: <1406598909-9658-1-git-send-email-jmaggard10@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: [PATCH v2] btrfs-progs: add always option to restore's looping 
prompt
From: Justin Maggard <jmaggard10@gmail.com>
To: <linux-btrfs@vger.kernel.org>
Date: 2014年07月29日 09:55
> If you are using btrfs restore to try to recover a very large or
> fragmented file, you may encounter _lots_ of prompts requiring
> you to press 'y' to continue because we are looping a lot.
>
> Add the option to press 'a', to supress these prompts for the rest
> of the file.
>
> Signed-off-by: Justin Maggard <jmaggard10@gmail.com>
Reviewed-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Thanks,
Qu
> ---
>   cmds-restore.c |   31 ++++++++++++++++++++++---------
>   1 file changed, 22 insertions(+), 9 deletions(-)
>
> diff --git a/cmds-restore.c b/cmds-restore.c
> index 3465f84..059194d 100644
> --- a/cmds-restore.c
> +++ b/cmds-restore.c
> @@ -410,23 +410,31 @@ out:
>   	return ret;
>   }
>   
> -static int ask_to_continue(const char *file)
> +enum loop_response {
> +	LOOP_STOP,
> +	LOOP_CONTINUE,
> +	LOOP_DONTASK
> +};
> +
> +static enum loop_response ask_to_continue(const char *file)
>   {
>   	char buf[2];
>   	char *ret;
>   
>   	printf("We seem to be looping a lot on %s, do you want to keep going "
> -	       "on ? (y/N): ", file);
> +	       "on ? (y/N/a): ", file);
>   again:
>   	ret = fgets(buf, 2, stdin);
>   	if (*ret == '\n' || tolower(*ret) == 'n')
> -		return 1;
> +		return LOOP_STOP;
> +	if (tolower(*ret) == 'a')
> +		return LOOP_DONTASK;
>   	if (tolower(*ret) != 'y') {
> -		printf("Please enter either 'y' or 'n': ");
> +		printf("Please enter one of 'y', 'n', or 'a': ");
>   		goto again;
>   	}
>   
> -	return 0;
> +	return LOOP_CONTINUE;
>   }
>   
>   
> @@ -594,11 +602,16 @@ static int copy_file(struct btrfs_root *root, int fd, struct btrfs_key *key,
>   	}
>   
>   	while (1) {
> -		if (loops++ >= 1024) {
> -			ret = ask_to_continue(file);
> -			if (ret)
> +		if (loops >= 0 && loops++ >= 1024) {
> +			enum loop_response resp;
> +
> +			resp = ask_to_continue(file);
> +			if (resp == LOOP_STOP)
>   				break;
> -			loops = 0;
> +			else if (resp == LOOP_CONTINUE)
> +				loops = 0;
> +			else if (resp == LOOP_DONTASK)
> +				loops = -1;
>   		}
>   		if (path->slots[0] >= btrfs_header_nritems(leaf)) {
>   			do {
