Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43251 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750966Ab3HSTUz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 Aug 2013 15:20:55 -0400
Date: Mon, 19 Aug 2013 12:20:52 -0700
From: Zach Brown <zab@redhat.com>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/3] btrfs-progs: move out print in cmd_df to another
 function
Message-ID: <20130819192052.GA1829@lenny.home.zabbo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1376657303-14931-2-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1376657303-14931-1-git-send-email-anand.jain@oracle.com>
 <1376657303-14931-2-git-send-email-anand.jain@oracle.com>

> +static void print_df(struct btrfs_ioctl_space_args *sargs)
> +{
> +	char description[80];
> +	char *total_bytes;
> +	char *used_bytes;
> +	u64 flags;
> +	u64 i;
> +	int written;
> +	char g_str[64];
> +	int g_sz;
>  
> +	for (i = 0; i < sargs->total_spaces; i++) {
> +		flags = sargs->spaces[i].flags;
> +		written = 0;
>  		memset(description, 0, 80);
>  
> +		strcpy(g_str, group_type_str(flags));
> +		g_sz = strlen(g_str);
> +		snprintf(description, g_sz + 1, "%s", g_str);
> +		written += g_sz;

> +		strcpy(g_str, group_profile_str(flags));
> +		g_sz = strlen(g_str);
> +		snprintf(description+written, g_sz + 3, ", %s", g_str);
> +		written += g_sz + 2;

> +		total_bytes = pretty_size(sargs->spaces[i].total_bytes);
> +		used_bytes = pretty_size(sargs->spaces[i].used_bytes);
> +		printf("%s: total=%s, used=%s\n", description, total_bytes,
> +		       used_bytes);

This seems to be a whole lot of code for a simple iterating printf:

	struct space_type_thingy_whatver *sp = sargs->spaces;

	for (i = 0; i < sargs->total_spaces; i++, sp++) {
		printf("%s, %s: total=%s, used=%s\n",
			group_type_str(sp->flags),
			group_profile_str(sp->flags),
			pretty_size(sp->total_bytes),
			pretty_size(sp->used_bytes));
	}

- z
