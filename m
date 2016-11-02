Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:52316 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752109AbcKBAh2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Nov 2016 20:37:28 -0400
Subject: Re: [PATCH v3 2/4] btrfs-progs: introduce new send-dump object
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
References: <20161101080147.13163-1-quwenruo@cn.fujitsu.com>
 <20161101080147.13163-3-quwenruo@cn.fujitsu.com>
 <20161101102209.GW12522@suse.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <e6a2018c-f335-9c6f-7152-87aea55fb5ec@cn.fujitsu.com>
Date: Wed, 2 Nov 2016 08:37:20 +0800
MIME-Version: 1.0
In-Reply-To: <20161101102209.GW12522@suse.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 11/01/2016 06:22 PM, David Sterba wrote:
> On Tue, Nov 01, 2016 at 04:01:44PM +0800, Qu Wenruo wrote:
>> +/*
>> + * Underlying PRINT_DUMP, the only difference is how we handle
>> + * the full path.
>> + */
>> +static int __print_dump(int subvol, void *user, const char *path,
>> +			const char *title, const char *fmt, ...)
>
> printf-like the __attribute__ ((format (printf, ...)))
>
>> +{
>> +	struct btrfs_dump_send_args *r = user;
>> +	char real_title[TITLE_WIDTH + 1] = { 0 };
>> +	char full_path[PATH_MAX] = {0};
>> +	char *out_path;
>> +	va_list args;
>> +	int ret;
>> +
>> +	if (subvol) {
>> +		PATH_CAT_OR_RET(title, r->full_subvol_path, r->root_path, path, ret);
>> +		out_path = r->full_subvol_path;
>> +	} else {
>> +		PATH_CAT_OR_RET(title, full_path, r->full_subvol_path, path, ret);
>> +		out_path = full_path;
>> +	}
>> +	string_escape_inplace(out_path, " \n\t\\");
>> +
>> +	/* Append ':' to title */
>> +	strncpy(real_title, title, TITLE_WIDTH - 1);
>> +	strncat(real_title, ":", TITLE_WIDTH);
>
> I'd rather avoid such string operations, ':', just print everything.

I'm completely OK to remove the ':'.

>
>> +
>> +	/* Unified header, */
>> +	printf("%-*s%-*s", TITLE_WIDTH, real_title, PATH_WIDTH, out_path);
>
> PATH_WIDTH is used only here, please hardcode it into the format string.
>
> The rest of the patch looks good. I think I've seen some artifacts in
> the output, but we can tune this later.

Would you like to share the artifacts so I can handle them in next update?

>
>> +	ret = strftime(dest, max_size, "%Y-%m-%d %H:%M:%S", tm);
>
> We should use the RFC 3339 format, as it's standardized and also is a
> string without whitespace.

Will use RFC 3339 in next version.

Thanks,
Qu


