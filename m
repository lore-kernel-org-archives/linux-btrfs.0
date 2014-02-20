Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:57951 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752104AbaBTBos (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Feb 2014 20:44:48 -0500
Message-ID: <53055DA5.6080604@cn.fujitsu.com>
Date: Thu, 20 Feb 2014 09:43:01 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Eric Sandeen <sandeen@redhat.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 1/4] Btrfs-progs: new helper to parse string to u64
 for btrfs
References: <1392859852-15829-1-git-send-email-wangsl.fnst@cn.fujitsu.com> <1392859852-15829-2-git-send-email-wangsl.fnst@cn.fujitsu.com> <53055CEB.5000808@redhat.com>
In-Reply-To: <53055CEB.5000808@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/20/2014 09:39 AM, Eric Sandeen wrote:
> On 2/19/14, 7:30 PM, Wang Shilong wrote:
>> There are many places that need parse string to u64 for btrfs commands,
>> in fact, we do such things *too casually*, using atoi/atol/atoll..is not
>> right at all, and even we don't check whether it is a valid string.
>>
>> Let's do everything more gracefully, we introduce a new helper
>> arg_strtou64() which will do all the necessary checks.If we fail to
>> parse string to u64, we will output message and exit directly, this is
>> something like what usage() is doing. It is ok to not return erro to
>> it's caller, because this function should be called when parsing arg
>> (just like usage!)
>>
>> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
>> ---
>>   utils.c | 33 +++++++++++++++++++++++++++++++++
>>   utils.h |  1 +
>>   2 files changed, 34 insertions(+)
>>
>> diff --git a/utils.c b/utils.c
>> index 97e23d5..d570967 100644
>> --- a/utils.c
>> +++ b/utils.c
>> @@ -1520,6 +1520,39 @@ scan_again:
>>   	return 0;
>>   }
>>   
>> +/*
>> + * This function should be only used when parsing
>> + * command arg, it won't return error to it's
>> + * caller and rather exit directly just like usage().
>> + */
>> +u64 arg_strtou64(const char *str)
>> +{
>> +	u64 value;
>> +	char *ptr_parse_end = NULL;
>> +	char *ptr_str_end = (char *)str + strlen(str);
>> +
>> +	/*
>> +	 * if we pass a negative number to strtoull,
>> +	 * it will return an unexpected number to us,
>> +	 * so let's do the check ourselves firstly.
>> +	 */
>> +	if (str[0] == '-') {
>> +		fprintf(stderr, "ERROR: %s may be negative value.\n", str);
> well, it _is_ a negative value right?  (vs. "may be")
>
> So perhaps:
>
> fprintf(stderr, "ERROR: %s: negative value is invalid.\n", str);
I use "may be" because the following case:

-123xxxx, -abcd..... something like these, these string are invalid,
but they are not negative number...So i have not thought a better idea
to tell user what is wrong with input.:-)

>
>
>> +		exit(1);
>> +	}
>> +
>> +	value = strtoull(str, &ptr_parse_end, 0);
>> +	if (ptr_parse_end != ptr_str_end) {
>> +		fprintf(stderr, "ERROR: %s is not valid value.\n", str);
> maybe:
>
> fprintf(stderr, "ERROR: %s is not a valid numeric value.\n", str);
Hm, better and better!
>
> Otherwise, this looks fine to me.  We'll see what the others on the thread
> think.  :)
>
> thanks,
> -Eric
>
>> +		exit(1);
>> +	}
>> +	if (value == ULLONG_MAX) {
>> +		fprintf(stderr, "ERROR: %s is too large.\n", str);
>> +		exit(1);
>> +	}
>> +	return value;
>> +}
>> +
>>   u64 parse_size(char *s)
>>   {
>>   	int i;
>> diff --git a/utils.h b/utils.h
>> index 04b8c45..a201085 100644
>> --- a/utils.h
>> +++ b/utils.h
>> @@ -71,6 +71,7 @@ int pretty_size_snprintf(u64 size, char *str, size_t str_bytes);
>>   int get_mountpt(char *dev, char *mntpt, size_t size);
>>   int btrfs_scan_block_devices(int run_ioctl);
>>   u64 parse_size(char *s);
>> +u64 arg_strtou64(const char *str);
>>   int open_file_or_dir(const char *fname, DIR **dirstream);
>>   void close_file_or_dir(int fd, DIR *dirstream);
>>   int get_fs_info(char *path, struct btrfs_ioctl_fs_info_args *fi_args,
>>
>

