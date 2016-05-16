Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout1.freenet.de ([195.4.92.91]:35754 "EHLO mout1.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751973AbcEPAOl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 15 May 2016 20:14:41 -0400
Received: from [195.4.92.141] (helo=mjail1.freenet.de)
	by mout1.freenet.de with esmtpa (ID master.b.at.raven@chefmail.de) (port 25) (Exim 4.85 #1)
	id 1b26BD-0008Fs-0e
	for linux-btrfs@vger.kernel.org; Mon, 16 May 2016 02:14:39 +0200
Received: from localhost ([::1]:38253 helo=mjail1.freenet.de)
	by mjail1.freenet.de with esmtpa (ID master.b.at.raven@chefmail.de) (Exim 4.85 #1)
	id 1b26BC-00035m-T7
	for linux-btrfs@vger.kernel.org; Mon, 16 May 2016 02:14:39 +0200
Received: from mx13.freenet.de ([195.4.92.23]:55640)
	by mjail1.freenet.de with esmtpa (ID master.b.at.raven@chefmail.de) (Exim 4.85 #1)
	id 1b268t-0006uU-8r
	for linux-btrfs@vger.kernel.org; Mon, 16 May 2016 02:12:15 +0200
Received: from ppp-88-217-14-247.dynamic.mnet-online.de ([88.217.14.247]:54884 helo=[192.168.1.209])
	by mx13.freenet.de with esmtpsa (ID master.b.at.raven@chefmail.de) (TLSv1.2:DHE-RSA-AES128-SHA:128) (port 465) (Exim 4.85 #1)
	id 1b268t-0006Jp-5f
	for linux-btrfs@vger.kernel.org; Mon, 16 May 2016 02:12:15 +0200
To: linux-btrfs@vger.kernel.org
From: g6094199@freenet.de
Subject: Re: Re: [PATCH] btrfs-progs: add always option to restore's looping
 prompt
Message-ID: <4f8afda5-6a8e-937b-f38b-881ddf1c075d@chefmail.de>
Date: Mon, 16 May 2016 02:12:16 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

He Guys,

i'm doing some restore right now. In fakt about 8TB.
I saw Justin sending the patch below in 2014 adding the "all" option when hitting the looping promt.
It would be nice to have this as command switch to, because if you have to recover the amount of data as i do atm, you probably get hundreds of looping promts
where you have to inactivly apply the "a" every time. This gets annoying after a while.
I also saw a similar request by Karl Richter some time ago (https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg36458.html)


So please for all users that will have similar probs in the future the option *btrfs restore -a* (or similar).



regads
Sash





Hi Justin,

Thanks for the patch first, comment inlined below.
-------- Original Message --------
Subject: [PATCH] btrfs-progs: add always option to restore's looping prompt
From: Justin Maggard <jmaggard10 <at> gmail.com>
To: <linux-btrfs <at> vger.kernel.org>
Date: 2014年07月29日 08:03
> If you are using btrfs restore to try to recover a very large or
> fragmented file, you may encounter __lots__ of prompts requiring
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
>  <at>  <at>  -410,17 +410,19  <at>  <at>  static int ask_to_continue(const char *file)
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
>  <at>  <at>  -588,11 +590,14  <at>  <at>  static int copy_file(struct btrfs_root *root, int fd, struct btrfs_key *key,
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
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo <at> vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

