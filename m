Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:31799 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752743AbaBTAun (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Feb 2014 19:50:43 -0500
Message-ID: <530550FB.1090709@cn.fujitsu.com>
Date: Thu, 20 Feb 2014 08:48:59 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Eric Sandeen <sandeen@redhat.com>
CC: kreijack@inwind.it, Wang Shilong <wangshilong1991@gmail.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/4] Btrfs-progs: new helper to parse string to u64 for
 btrfs
References: <1392808674-21656-1-git-send-email-wangsl.fnst@cn.fujitsu.com> <1392808674-21656-2-git-send-email-wangsl.fnst@cn.fujitsu.com> <5304D1F6.8040902@libero.it> <282C2CC4-898B-40A6-82CB-27461AD77C5C@gmail.com> <5304DC5B.9050707@inwind.it> <5304E891.8040606@redhat.com>
In-Reply-To: <5304E891.8040606@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/20/2014 01:23 AM, Eric Sandeen wrote:
> On 2/19/14, 10:31 AM, Goffredo Baroncelli wrote:
> ...
>
>   
>> The error message says that the value is out of range. But doesn't tell which
>> is the parameter involved.
>> If you have a command which has several arguments, and the user pass a string
>> instead of a number, the error returned doesn't tell which argument is wrong.
>> This is the reason of my complaint.
>>
>> At least add a fourth parameter which contains the name of the parameter
>> parsed in order to improve the error message.
>>
>> I.E.
>>
>> 	subvol_id = btrfs_strtoull(argv[i], 10, "subvolume ID");
>>
>> If the user pass a path instead of a number the error message would be
>>
>>    ERROR: xxxx is not a valid unsigned long long integer for the parameter 'subvolume ID'.
>>
>> Or something like that.
> I'm not so sure that this is needed.  Adding it makes the code a little more complicated,
> and requires each caller to send in a string which may get out of sync with the actual
> argument name (or the manpage, or the help/usage text).
>
> The user has *just* typed it in, so it won't be too hard to see which one
> was wrong even without naming the parameter, i.e. -
>
> # btrfs foo-command 12345 0 123notanumber
> Error: 123notanumber is not a valid numeric value
>
> or
>
> # btrfs baz-command 0xFFFFFFFFFFFFFFFF 12345 0
> Error: numeric value 0xFFFFFFFFFFFFFFFF is too large.
>
> would probably suffice, without bothering to name the parameter.
Sounds more reasonable.:-)
>
> I'd also suggest not referring to "unsigned long long" or "out of range" which
> might not mean much to people who aren't programmers; "not a valid value"
> or "too large" might be clearer.
Will update it.
>
> Also, what if someone enters a negative number?  Right now it happily
> accepts it and converts it to an unsigned value:
>
> # ./test-64bit -123
> Parsed as 18446744073709551493
So Let's add a '-' check before calling strtoull. something like:

if (str[0] == '-')
     fprintf(stderr, "ERROR: this may be a negative integer: %s\n", str);

Thanks,
Wang
>
> but an inadvertent negative sign might lead to highly unexpected results.
>
> Just my $0.02.
>
> -Eric
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

