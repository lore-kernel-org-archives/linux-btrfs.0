Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:63395 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753998AbaBSQIs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Feb 2014 11:08:48 -0500
Received: by mail-pa0-f44.google.com with SMTP id kq14so579939pab.17
        for <linux-btrfs@vger.kernel.org>; Wed, 19 Feb 2014 08:08:47 -0800 (PST)
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: [PATCH 1/4] Btrfs-progs: new helper to parse string to u64 for btrfs
From: Wang Shilong <wangshilong1991@gmail.com>
In-Reply-To: <5304D1F6.8040902@libero.it>
Date: Thu, 20 Feb 2014 00:08:41 +0800
Cc: Wang Shilong <wangsl.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Message-Id: <282C2CC4-898B-40A6-82CB-27461AD77C5C@gmail.com>
References: <1392808674-21656-1-git-send-email-wangsl.fnst@cn.fujitsu.com> <1392808674-21656-2-git-send-email-wangsl.fnst@cn.fujitsu.com> <5304D1F6.8040902@libero.it>
To: kreijack@inwind.it
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Goffredo,

> Hi Wang,
> 
> On 02/19/2014 12:17 PM, Wang Shilong wrote:
>> There are many places that need parse string to u64 for btrfs commands,
>> in fact, we do such things *too casually*, using atoi/atol/atoll..is not
>> right at all, and even we don't check whether it is a valid string.
>> 
>> Let's do everything more gracefully, we introduce a new helper
>> btrfs_strtoull() which will do all the necessary checks.If we fail to
>> parse string to u64, we will output message and exit directly, this is
>> something like what usage() is doing. It is ok to not return erro to
>> it's caller, because this function should be called when parsing arg
>> (just like usage!)
> 
> Please don't do that !
> 
> The error reporting of btrfs_strtoull is insufficient.
> In case of invalid value the user is not able to 
> understand what is the the wrong parameter. This because the error
> reporting is handled by the function itself. We should improve the error 
> messages, not hide them.
> 
> 
> From my point of view, you have only two choices:
> 1) change the api as
> 	u64 btrfs_strtoull(char *str, int *error)
>   or 
> 	int btrfs_strtoull(char *str, u64 *value)
> 
> and let the function to return the error code in case of parsing error.
> The caller has the responsibility to inform the user of the error.
> 
> 2) change the api as
> 
> 	u64 btrfs_strtoull(char *str, char *parameter_name)
> 
> so the function in case of error, is able to tell which parameters is wrong.
> 
> I prefer the #1.

I know what you are considering here, i was thinking the way you talked about.
I chose this way for three reasons:

#1 btrfs_strtoul() itself  would output message why we fail before exit.
#2 btrfs_strtoull() is called when arg parsing just like we use the function usage() which will call exit(1).
#3 if we return error message to the caller, just think there are many caller that will deal the same thing, check
     and output error messages….which is a little polluted information….

So i think it is ok that we output message in btrfs_strtoull() itself and return directly.(It is ok because during
arg parsing we don't involve memory allocation etc…)

I understand your suggestions is more common,  but for this case, I am more inclined to the current way
to deal with the issue.^_^

Thanks,
Wang
> 
> BR
> G.Baroncelli
> 
>> 
>> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
>> ---
>> utils.c | 19 +++++++++++++++++++
>> utils.h |  1 +
>> 2 files changed, 20 insertions(+)
>> 
>> diff --git a/utils.c b/utils.c
>> index 97e23d5..0698d8d 100644
>> --- a/utils.c
>> +++ b/utils.c
>> @@ -1520,6 +1520,25 @@ scan_again:
>> 	return 0;
>> }
>> 
>> +u64 btrfs_strtoull(char *str, int base)
>> +{
>> +	u64 value;
>> +	char *ptr_parse_end = NULL;
>> +	char *ptr_str_end = str + strlen(str);
>> +
>> +	value = strtoull(str, &ptr_parse_end, base);
>> +	if (ptr_parse_end != ptr_str_end) {
>> +		fprintf(stderr, "ERROR: %s is not an invalid unsigned long long integer.\n",
>> +				str);
>> +		exit(1);
>> +	}
>> +	if (value == ULONG_MAX) {
>> +		fprintf(stderr, "ERROR: %s is out of range.\n", str);
>> +		exit(1);
>> +	}
>> +	return value;
>> +}
>> +
>> u64 parse_size(char *s)
>> {
>> 	int i;
>> diff --git a/utils.h b/utils.h
>> index 04b8c45..094f41d 100644
>> --- a/utils.h
>> +++ b/utils.h
>> @@ -71,6 +71,7 @@ int pretty_size_snprintf(u64 size, char *str, size_t str_bytes);
>> int get_mountpt(char *dev, char *mntpt, size_t size);
>> int btrfs_scan_block_devices(int run_ioctl);
>> u64 parse_size(char *s);
>> +u64 btrfs_strtoull(char *str, int base);
>> int open_file_or_dir(const char *fname, DIR **dirstream);
>> void close_file_or_dir(int fd, DIR *dirstream);
>> int get_fs_info(char *path, struct btrfs_ioctl_fs_info_args *fi_args,
>> 
> 
> 
> -- 
> gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
> Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

