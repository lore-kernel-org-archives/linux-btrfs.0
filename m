Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33530 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1168481AbcKAKWM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 1 Nov 2016 06:22:12 -0400
Date: Tue, 1 Nov 2016 11:22:09 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 2/4] btrfs-progs: introduce new send-dump object
Message-ID: <20161101102209.GW12522@suse.cz>
Reply-To: dsterba@suse.cz
References: <20161101080147.13163-1-quwenruo@cn.fujitsu.com>
 <20161101080147.13163-3-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161101080147.13163-3-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 01, 2016 at 04:01:44PM +0800, Qu Wenruo wrote:
> +/*
> + * Underlying PRINT_DUMP, the only difference is how we handle
> + * the full path.
> + */
> +static int __print_dump(int subvol, void *user, const char *path,
> +			const char *title, const char *fmt, ...)

printf-like the __attribute__ ((format (printf, ...)))

> +{
> +	struct btrfs_dump_send_args *r = user;
> +	char real_title[TITLE_WIDTH + 1] = { 0 };
> +	char full_path[PATH_MAX] = {0};
> +	char *out_path;
> +	va_list args;
> +	int ret;
> +
> +	if (subvol) {
> +		PATH_CAT_OR_RET(title, r->full_subvol_path, r->root_path, path, ret);
> +		out_path = r->full_subvol_path;
> +	} else {
> +		PATH_CAT_OR_RET(title, full_path, r->full_subvol_path, path, ret);
> +		out_path = full_path;
> +	}
> +	string_escape_inplace(out_path, " \n\t\\");
> +
> +	/* Append ':' to title */
> +	strncpy(real_title, title, TITLE_WIDTH - 1);
> +	strncat(real_title, ":", TITLE_WIDTH);

I'd rather avoid such string operations, ':', just print everything.

> +
> +	/* Unified header, */
> +	printf("%-*s%-*s", TITLE_WIDTH, real_title, PATH_WIDTH, out_path);

PATH_WIDTH is used only here, please hardcode it into the format string.

The rest of the patch looks good. I think I've seen some artifacts in
the output, but we can tune this later.

> +	ret = strftime(dest, max_size, "%Y-%m-%d %H:%M:%S", tm);

We should use the RFC 3339 format, as it's standardized and also is a
string without whitespace.
