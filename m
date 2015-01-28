Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:60915 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932361AbbA1BPe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 27 Jan 2015 20:15:34 -0500
Message-ID: <54C8383E.3030500@cn.fujitsu.com>
Date: Wed, 28 Jan 2015 09:15:42 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Hugo Mills <hugo@carfax.org.uk>, <linux-btrfs@vger.kernel.org>,
        <dsterba@suse.cz>
Subject: Re: [PATCH 1/2] btrfs-progs: Make option parsing more robust to code
 modifications
References: <1422371153-17355-1-git-send-email-hugo@carfax.org.uk>
In-Reply-To: <1422371153-17355-1-git-send-email-hugo@carfax.org.uk>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: [PATCH 1/2] btrfs-progs: Make option parsing more robust to 
code modifications
From: Hugo Mills <hugo@carfax.org.uk>
To: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>
Date: 2015年01月27日 23:05
> The current approach to option parsing, where long-only options are
> selected on the basis of their position in the long_options array is
> fragile and painful to modify if options are to be inserted into the
> list, rather than appended.
>
> Instead, use the last field of struct option to return a value which
> cannot be a char (and hence a short option), and simply switch on those
> within the case statement.
This is much much better than original immediate number.
The original way always takes me extra time to count the number.
>
> Signed-off-by: Hugo Mills <hugo@carfax.org.uk>
> ---
>   cmds-check.c | 49 +++++++++++++++++++++++++++----------------------
>   1 file changed, 27 insertions(+), 22 deletions(-)
>
> diff --git a/cmds-check.c b/cmds-check.c
> index f06e029..a1226c6 100644
> --- a/cmds-check.c
> +++ b/cmds-check.c
> @@ -8403,13 +8403,15 @@ out:
>   	return bad_roots;
>   }
>   
> +enum { OPT_REPAIR = 257, OPT_INIT_CSUM, OPT_INIT_EXTENT, OPT_CHECK_CSUM };
> +
I'm a little interested in why assigning 257 to OPT_REPAIR.
Does it have any extra meaning?
>   static struct option long_options[] = {
>   	{ "super", 1, NULL, 's' },
> -	{ "repair", 0, NULL, 0 },
> -	{ "init-csum-tree", 0, NULL, 0 },
> -	{ "init-extent-tree", 0, NULL, 0 },
> -	{ "check-data-csum", 0, NULL, 0 },
> -	{ "backup", 0, NULL, 0 },
> +	{ "repair", 0, NULL, OPT_REPAIR },
> +	{ "init-csum-tree", 0, NULL, OPT_INIT_CSUM },
> +	{ "init-extent-tree", 0, NULL, OPT_INIT_EXTENT },
> +	{ "check-data-csum", 0, NULL, OPT_CHECK_CSUM },
> +	{ "backup", 0, NULL, 'b' },
>   	{ "subvol-extents", 1, NULL, 'E' },
>   	{ "qgroup-report", 0, NULL, 'Q' },
>   	{ "tree-root", 1, NULL, 'r' },
> @@ -8483,23 +8485,26 @@ int cmd_check(int argc, char **argv)
>   			case '?':
>   			case 'h':
>   				usage(cmd_check_usage);
> -		}
> -		if (option_index == 1) {
> -			printf("enabling repair mode\n");
> -			repair = 1;
> -			ctree_flags |= OPEN_CTREE_WRITES;
> -		} else if (option_index == 2) {
> -			printf("Creating a new CRC tree\n");
> -			init_csum_tree = 1;
> -			repair = 1;
> -			ctree_flags |= OPEN_CTREE_WRITES;
> -		} else if (option_index == 3) {
> -			init_extent_tree = 1;
> -			ctree_flags |= (OPEN_CTREE_WRITES |
> -					OPEN_CTREE_NO_BLOCK_GROUPS);
> -			repair = 1;
> -		} else if (option_index == 4) {
> -			check_data_csum = 1;
> +			case OPT_REPAIR:
> +				printf("enabling repair mode\n");
> +				repair = 1;
> +				ctree_flags |= OPEN_CTREE_WRITES;
> +				break;
> +			case OPT_INIT_CSUM:
> +				printf("Creating a new CRC tree\n");
> +				init_csum_tree = 1;
> +				repair = 1;
> +				ctree_flags |= OPEN_CTREE_WRITES;
> +				break;
> +			case OPT_INIT_EXTENT:
> +				init_extent_tree = 1;
> +				ctree_flags |= (OPEN_CTREE_WRITES |
> +						OPEN_CTREE_NO_BLOCK_GROUPS);
> +				repair = 1;
> +				break;
> +			case OPT_CHECK_CSUM:
> +				check_data_csum = 1;
> +				break;
>   		}
>   	}
>   	argc = argc - optind;
The rest looks good to me.

Thanks,
Qu
