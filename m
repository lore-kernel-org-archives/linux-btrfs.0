Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46044 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754754AbbJUOld (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 21 Oct 2015 10:41:33 -0400
Subject: Re: [RFC PATCH 1/3] btrfs-progs: introduce framework to check kernel
 supported features
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, Anand Jain <anand.jain@oracle.com>,
        linux-btrfs@vger.kernel.org
References: <1445417149-804-1-git-send-email-anand.jain@oracle.com>
 <5627564E.2070106@cn.fujitsu.com>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <5627A41B.9070406@redhat.com>
Date: Wed, 21 Oct 2015 09:41:31 -0500
MIME-Version: 1.0
In-Reply-To: <5627564E.2070106@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/21/15 4:09 AM, Qu Wenruo wrote:
>> +static int get_kernel_code()
>> +{
>> +    int ret;
>> +    struct utsname utsbuf;
>> +    char *version;
>> +
>> +    ret = uname(&utsbuf);
>> +    if (ret)
>> +        return -ret;
>> +
>> +    version = strtok(utsbuf.release, "-");
>> +
>> +    return version_to_code(version);
>> +}
> 
> The only problem is, kernel version is never reliable.
> If someone wants, uname output may even contain no numeric value.

yep, I agree.  This will be misery for any custom kernel.

> IIRC, I suggest to maintain similar feature matrix in fstests, but Dave pointed out the above problem.
> 
> So I'm not fan of reading kernel version and generate supported features for that.
> 
> IMHO, just use /sys/fs/btrfs/features is good enough.

*nod*

> And if there is no such file, just ignore it, user is responsible for
> such case.

Yep, 3.14 was over a year and a half ago, I don't see much point in
hardcoding kernel versions for such old kernels in the current
upstream codebase.

The only kernels that old still running are likely distro kernels, and
they can solve this problem by backporting the /sys/fs/btrfs/features
patch.

-Eric
 
> Thanks,
> Qu

