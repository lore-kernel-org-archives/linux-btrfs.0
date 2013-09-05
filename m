Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:32914 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757502Ab3IEIcZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 5 Sep 2013 04:32:25 -0400
Message-ID: <52284119.9050009@cn.fujitsu.com>
Date: Thu, 05 Sep 2013 16:30:17 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Anand Jain <Anand.Jain@oracle.com>
CC: Wang Shilong <wangshilong1991@gmail.com>, linux-btrfs@vger.kernel.org,
        dsterba@suse.cz, sandeen@redhat.com
Subject: Re: [PATCH 00/20] fix magic return value in btrfs-progs
References: <1378308157-4621-1-git-send-email-wangshilong1991@gmail.com> <5227E8EE.8090007@oracle.com>
In-Reply-To: <5227E8EE.8090007@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/05/2013 10:14 AM, Anand Jain wrote:
>
> On 09/04/2013 11:22 PM, Wang Shilong wrote:
>> This patchset tries to fix all the magic return value in btrfs-progs.
>> Most commands will have three kinds of return value:
>>
>> 0 success
>> 1 usage of syntax errors
>>
>> Exceptions come from balance/scrub/replace. For example, replace cancel
>> will return 2 if there is no operations in progress.
>
>  Thanks for writing this much needed.
>  Its better to have these return error codes defined
>  in a header. So that it would guide the future developments.
Agree.

We also need update man page.^_^

Thanks,
Wang
>
> Anand
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

