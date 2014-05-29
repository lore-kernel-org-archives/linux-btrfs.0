Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:32747 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751842AbaE2Akt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 28 May 2014 20:40:49 -0400
Message-ID: <5386824F.1040503@cn.fujitsu.com>
Date: Thu, 29 May 2014 08:41:51 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs-progs: Improve the parse_size() error message.
References: <1400572305-19818-1-git-send-email-quwenruo@cn.fujitsu.com> <20140528172017.GS5346@twin.jikos.cz>
In-Reply-To: <20140528172017.GS5346@twin.jikos.cz>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks for the commenting.

-------- Original Message --------
Subject: Re: [PATCH] btrfs-progs: Improve the parse_size() error message.
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Date: 2014年05月29日 01:20
> On Tue, May 20, 2014 at 03:51:45PM +0800, Qu Wenruo wrote:
>> When using parse_size(), even non-numeric value is passed, it will only
>> give error message "ERROR: size value is empty", which is quite
>> confusing for end users.
>>
>> This patch will introduce more meaningful error message for the
>> following new cases
>> 1) Invalid size string (non-numeric string)
>> 2) Minus size value (like "-1K")
> That's great. A few things below
>
>>   u64 parse_size(char *s)
>>   {
>> -	int i;
>>   	char c;
>>   	u64 mult = 1;
>> -
>> -	for (i = 0; s && s[i] && isdigit(s[i]); i++) ;
>> -	if (!i) {
>> -		fprintf(stderr, "ERROR: size value is empty\n");
>> -		exit(50);
>> -	}
>> -
>> -	if (s[i]) {
>> -		c = tolower(s[i]);
>> +	long long int ret = 0;
>> +	char *endptr;
>> +
>> +	if (!s)
>> +		goto empty;
>> +	ret = strtoll(s, &endptr, 10);
>> -	return strtoull(s, NULL, 10) * mult;
> Now it does not parse sizes from the range LLONG_MAX to ULLONG_MAX (8EiB
> to 16EiB). Though we don't have problems with such sizes in real life,
> I'd rather keep strtoull so it matches the advertised maximum filesystem
> size.
>
> Negative numbers can be simply identified by leading '-'. The only case
> where negative number is allowed is in 'fi resize', but the string is
> passed to kernel as-is.
In fact the leading '-' charactor judgment comes to me first, but "-0" 
will make things complicated,
so I choose to use strtoll to deal with them.

To achieve the ULLONG_MAX, i would like to run strtoull after strtoll, 
will it be OK for you?
>
>> +empty:
>> +	fprintf(stderr, "ERROR: Size value is empty\n");
>> +	exit(50);
>> +suffix:
>> +	fprintf(stderr, "ERROR: Illegal suffix contains character '%c' in wrong position\n",
>> +		endptr[1]);
>> +	exit(51);
>> +descriptor:
>> +	fprintf(stderr, "ERROR: Unknown size descriptor '%c'\n", c);
>> +	exit(52);
>> +invalid:
>> +	fprintf(stderr, "ERROR: Size value '%s' is invalid\n", s);
>> +	exit(53);
>> +minus:
>> +	fprintf(stderr, "ERROR: Size value '%s' is less equal than 0\n", s);
>> +	exit(54);
> Please get rid of the error codes, use exit(1). The messages should be
> enough to find out what's wrong.
Exit(1) will make things quite easy. I will use them.

Thanks,
Qu
