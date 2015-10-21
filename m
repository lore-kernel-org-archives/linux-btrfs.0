Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58951 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750905AbbJUPMe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 21 Oct 2015 11:12:34 -0400
Subject: Re: [RFC PATCH 1/3] btrfs-progs: introduce framework to check kernel
 supported features
To: Anand Jain <anand.jain@oracle.com>, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org
References: <1445417149-804-1-git-send-email-anand.jain@oracle.com>
 <5627564E.2070106@cn.fujitsu.com> <5627A41B.9070406@redhat.com>
 <5627A5FC.60605@oracle.com>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <5627AB61.1020305@redhat.com>
Date: Wed, 21 Oct 2015 10:12:33 -0500
MIME-Version: 1.0
In-Reply-To: <5627A5FC.60605@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/21/15 9:49 AM, Anand Jain wrote:
> 
> 
> On 10/21/2015 10:41 PM, Eric Sandeen wrote:
>> On 10/21/15 4:09 AM, Qu Wenruo wrote:
>>>> +static int get_kernel_code()
>>>> +{
>>>> +    int ret;
>>>> +    struct utsname utsbuf;
>>>> +    char *version;
>>>> +
>>>> +    ret = uname(&utsbuf);
>>>> +    if (ret)
>>>> +        return -ret;
>>>> +
>>>> +    version = strtok(utsbuf.release, "-");
>>>> +
>>>> +    return version_to_code(version);
>>>> +}
>>>
>>> The only problem is, kernel version is never reliable.
>>> If someone wants, uname output may even contain no numeric value.
>>
>> yep, I agree.  This will be misery for any custom kernel.
> 
>  How if we apply this only when kernel version is available ?

The problem is "kernel version" may not match btrfs version.
Distros backport and update subsystems without changing the
kernel version.

>  Otherwise progs will assume all features are supported as in
>  the current design.
> 
> Thanks, Anand

This is only a concern for kernels prior to 3.14, right?
v3.13 was released Sun Jan 19 18:40:23 2014, almost 2 years ago.

What has raised the current concern about these old kernels?
Why does this need fixing in upstream code?

-Eric

