Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm02.jp.fujitsu.com ([202.219.69.169]:27804 "EHLO
	mgwkm02.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906AbcCOX3S (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Mar 2016 19:29:18 -0400
Received: from m3050.s.css.fujitsu.com (msm.b.css.fujitsu.com [10.134.21.208])
	by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 62D9DAC00D5
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Mar 2016 08:29:14 +0900 (JST)
Subject: Re: [PATCH 2/4] btrfs-progs: fix a reression that "property" with -t
 option doesn't work
To: dsterba@suse.cz,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <56E5FF9A.4020609@jp.fujitsu.com>
 <56E601F4.9070908@jp.fujitsu.com> <20160314122315.GB18908@twin.jikos.cz>
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Message-ID: <56E89AAF.90709@jp.fujitsu.com>
Date: Wed, 16 Mar 2016 08:28:47 +0900
MIME-Version: 1.0
In-Reply-To: <20160314122315.GB18908@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016/03/14 21:23, David Sterba wrote:
> On Mon, Mar 14, 2016 at 09:12:36AM +0900, Satoru Takeuchi wrote:
>> --- a/cmds-property.c
>> +++ b/cmds-property.c
>> @@ -379,9 +379,7 @@ static int cmd_property_get(int argc, char **argv)
>>   	char *name = NULL;
>>   	int types = 0;
>>
>> -	clean_args_no_options(argc, argv, cmd_property_get_usage);
>> -
>> -	if (check_argc_min(argc, 2) || check_argc_max(argc, 5))
>> +	if (check_argc_min(argc, 2))
>>   		usage(cmd_property_get_usage);
>>
>>   	parse_args(argc, argv, cmd_property_get_usage, &types, &object, &name,
>
> We still need to check the number of non-option arguments here, when the
> optind is set from parse_args.

OK, I'll send a patch which checks the number after getopt.

Thanks,
Satoru

>
>> @@ -415,9 +413,7 @@ static int cmd_property_set(int argc, char **argv)
>> -	if (check_argc_min(argc, 4) || check_argc_max(argc, 6))
>> +	if (check_argc_min(argc, 4))
>>   		usage(cmd_property_set_usage);
>
> ...
>
>>   	parse_args(argc, argv, cmd_property_set_usage, &types,
>> @@ -446,9 +442,7 @@ static int cmd_property_list(int argc, char **argv)
>> -	if (check_argc_min(argc, 2) || check_argc_max(argc, 4))
>> +	if (check_argc_min(argc, 2))
>
> ...
>
