Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from szxga03-in.huawei.com ([119.145.14.66]:11260 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710AbaEMBpS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 12 May 2014 21:45:18 -0400
Message-ID: <5371790A.6010102@huawei.com>
Date: Tue, 13 May 2014 09:44:42 +0800
From: Zhang Zhen <zhenzhang.zhang@huawei.com>
MIME-Version: 1.0
To: <clm@fb.com>, <jbacik@fb.com>, linux-btrfs <linux-btrfs@vger.kernel.org>,
        David Taylor <davidt-btrfs@yadt.co.uk>
Subject: Re: [PATCH] btrfs: replace simple_strtoul() with kstrtoul()
References: <1399892355-3781-1-git-send-email-zhenzhang.zhang@huawei.com> <5370A9ED.9000106@huawei.com> <20140512112808.GA5103@yadt.co.uk>
In-Reply-To: <20140512112808.GA5103@yadt.co.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2014/5/12 19:28, David Taylor wrote:
> On Mon, 12 May 2014, Zhang Zhen wrote:
> 
>> use the newer and more pleasant kstrtoul() to replace simple_strtoul(),
>> because simple_strtoul() is marked for obsoletion.
> [...]
>> -        devid = simple_strtoull(devstr, &end, 10);
>> +        devid = kstrtoul(devstr, &end, 10);
> 
> kstrtoul appears to take its arguments in a different order:
> 
> unsigned long long simple_strtoull(const char * cp,
>  char ** endp, unsigned int base);
> 
> int kstrtoul(const char *s, unsigned int base, unsigned long *res);
> 
Hi David,

You are right, i made a mistake.
I will soon send the right one .

Thanks for your reply.

