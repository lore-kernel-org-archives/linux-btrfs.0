Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:27763 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750724AbbALDBo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 11 Jan 2015 22:01:44 -0500
Message-ID: <54B338E7.1060604@cn.fujitsu.com>
Date: Mon, 12 Jan 2015 11:00:55 +0800
From: =?UTF-8?B?RmFuIENoZW5nbmlhbmcv5qiK5oiQ6YW/?=
	<fancn.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: <dsterba@suse.cz>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs-progs: make btrfs qgroups show human readable sizes
References: <1420786025-7361-1-git-send-email-fancn.fnst@cn.fujitsu.com> <20150109180353.GH3685@twin.jikos.cz>
In-Reply-To: <20150109180353.GH3685@twin.jikos.cz>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


在 2015年01月10日 02:03, David Sterba 写道:
> On Fri, Jan 09, 2015 at 02:47:05PM +0800, Fan Chengniang wrote:
>> make btrfs qgroups show human readable sizes, using -h option, example:
> Thanks.  Please add all the long options from the 'fi df' subcommands as
> well. As the subcommand is not entierly space & size oriented, I'd like
> to keep the single letter options unallocated for now.
>
I will use --human to subsititute -h option. Should I add other long 
options like --kbytes --mbytes --gbytes --tbytes --si --iec?
>> @@ -80,53 +81,62 @@ static struct {
>>   	char *name;
>>   	char *column_name;
>>   	int need_print;
>> +	int human_readable;
> Would be better to make it more generic and store the format type
> directly, then use it ...
I will merge need_print and human_readable into one variable.
>> @@ -203,11 +221,17 @@ static void print_qgroup_column(struct btrfs_qgroup *qgroup,
>>   		print_qgroup_column_add_blank(BTRFS_QGROUP_QGROUPID, len);
>>   		break;
>>   	case BTRFS_QGROUP_RFER:
>> -		len = printf("%llu", qgroup->rfer);
>> +		if (btrfs_qgroup_columns[column].human_readable)
>> +			len = printf("%s", pretty_size(qgroup->rfer));
>> +		else
>> +			len = printf("%llu", qgroup->rfer);
> ... here instead of the switch, something like
>
> 	pretty_size_mode(number, btrfs_qgroup_columns[column].format);
I wiil try to remove switch.
