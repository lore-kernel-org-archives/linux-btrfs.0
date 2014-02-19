Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f174.google.com ([209.85.192.174]:36851 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753792AbaBSPAG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Feb 2014 10:00:06 -0500
Received: by mail-pd0-f174.google.com with SMTP id z10so474089pdj.33
        for <linux-btrfs@vger.kernel.org>; Wed, 19 Feb 2014 07:00:05 -0800 (PST)
Content-Type: text/plain; charset=GB2312
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: [PATCH 1/4] Btrfs-progs: new helper to parse string to u64 for btrfs
From: Wang Shilong <wangshilong1991@gmail.com>
In-Reply-To: <5304C3DF.90002@giantdisaster.de>
Date: Wed, 19 Feb 2014 22:59:59 +0800
Cc: Wang Shilong <wangsl.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Message-Id: <84FA6252-21FD-46AB-AE68-5BB474D26805@gmail.com>
References: <1392808674-21656-1-git-send-email-wangsl.fnst@cn.fujitsu.com> <1392808674-21656-2-git-send-email-wangsl.fnst@cn.fujitsu.com> <5304C3DF.90002@giantdisaster.de>
To: Stefan Behrens <sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Stefan,

> On Wed, 19 Feb 2014 19:17:51 +0800, Wang Shilong wrote:
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
> 
> "not invalid" :)
> 
oops

>> +				str);
>> +		exit(1);
>> +	}
>> +	if (value == ULONG_MAX) {
> 
> ULLONG_MAX or {errno = 0; value = strtoull(...); if (errno == ERANGE)бн}

Yeah, i will use ULLONG_MAX instead ULONG  to check^_^..

> 
> 
>> +		fprintf(stderr, "ERROR: %s is out of range.\n", str);
>> +		exit(1);
>> +	}
> 
> base = 0 is best BTW since it is able to read hex and octal numbers as
> well. I'd remove the base parameter to btrfs_strtoull() and always use 0.

Right, all comments addressed, thanks for your review.^_^

Thanks,
Wang
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

