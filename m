Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ea0-f178.google.com ([209.85.215.178]:37974 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760180Ab3BHRi0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Feb 2013 12:38:26 -0500
Received: by mail-ea0-f178.google.com with SMTP id a14so1862908eaa.9
        for <linux-btrfs@vger.kernel.org>; Fri, 08 Feb 2013 09:38:25 -0800 (PST)
Message-ID: <51153846.7020304@gmail.com>
Date: Fri, 08 Feb 2013 18:39:18 +0100
From: Goffredo Baroncelli <kreijack@gmail.com>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Ian Kumlien <pomac@demius.net>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/6] Btrfs-progs: add btrfsck functionality to btrfs
References: <1360283822-23452-1-git-send-email-pomac@demius.net> <1360283822-23452-3-git-send-email-pomac@demius.net>
In-Reply-To: <1360283822-23452-3-git-send-email-pomac@demius.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

H Iam,

On 02/08/2013 01:36 AM, Ian Kumlien wrote:
> This patch includes the functionality of btrfs, it's
> found as "btrfs check" however it makes the binary
> behave differently depending on what it's run as.
[...]

>  
> +static int cmd_dummy(int argc, char **argv)
> +{
> +	return 0;

I think we should warn that fsck.btrfs does nothing. Something like:
 +	fprintf(stderr, "WARNING: fsck.btrfs does nothing. "
		"Try 'btrfs check'\n");



> +}
> +
> +/* change behaviour depending on what we're called */
> +const struct cmd_group function_cmd_group = {
> +	NULL, NULL,
> +	{
> +		{ "btrfsck", cmd_check, NULL, NULL, 0 },
> +		{ "fsck.btrfs", cmd_dummy, NULL, NULL, 0 },
> +		{ 0, 0, 0, 0, 0 }
> +	},
> +};
> +
>  int main(int argc, char **argv)
>  {
>  	const struct cmd_struct *cmd;
> +	char *called_as = strrchr(argv[0], '/');
> +	if (called_as)
> +		argv[0] = ++called_as;
>  
>  	crc32c_optimization_init();
>  
> -	argc--;
> -	argv++;
> -	handle_options(&argc, &argv);
> -	if (argc > 0) {
> -		if (!prefixcmp(argv[0], "--"))
> -			argv[0] += 2;
> -	} else {
> -		usage_command_group(&btrfs_cmd_group, 0, 0);
> -		exit(1);
> -	}
> +	/* if we have cmd, we're started as a sub command */
> +	if (parse_one_exact_token(argv[0], &function_cmd_group, &cmd) < 0)
> +	{
> +		argc--;
> +		argv++;
>  
> -	cmd = parse_command_token(argv[0], &btrfs_cmd_group);
> +		handle_options(&argc, &argv);
> +		if (argc > 0) {
> +			if (!prefixcmp(argv[0], "--"))
> +				argv[0] += 2;

I can't understand the reason to skip '--' ? But this question is not
related to your patch...

> +		} else {
> +			usage_command_group(&btrfs_cmd_group, 0, 0);
[...]

-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
