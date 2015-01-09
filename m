Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41239 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758010AbbAISDy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 9 Jan 2015 13:03:54 -0500
Date: Fri, 9 Jan 2015 19:03:53 +0100
From: David Sterba <dsterba@suse.cz>
To: Fan Chengniang <fancn.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: make btrfs qgroups show human readable sizes
Message-ID: <20150109180353.GH3685@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1420786025-7361-1-git-send-email-fancn.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1420786025-7361-1-git-send-email-fancn.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 09, 2015 at 02:47:05PM +0800, Fan Chengniang wrote:
> make btrfs qgroups show human readable sizes, using -h option, example:

Thanks.  Please add all the long options from the 'fi df' subcommands as
well. As the subcommand is not entierly space & size oriented, I'd like
to keep the single letter options unallocated for now.

> @@ -80,53 +81,62 @@ static struct {
>  	char *name;
>  	char *column_name;
>  	int need_print;
> +	int human_readable;

Would be better to make it more generic and store the format type
directly, then use it ...

> @@ -203,11 +221,17 @@ static void print_qgroup_column(struct btrfs_qgroup *qgroup,
>  		print_qgroup_column_add_blank(BTRFS_QGROUP_QGROUPID, len);
>  		break;
>  	case BTRFS_QGROUP_RFER:
> -		len = printf("%llu", qgroup->rfer);
> +		if (btrfs_qgroup_columns[column].human_readable)
> +			len = printf("%s", pretty_size(qgroup->rfer));
> +		else
> +			len = printf("%llu", qgroup->rfer);

... here instead of the switch, something like

	pretty_size_mode(number, btrfs_qgroup_columns[column].format);
