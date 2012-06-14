Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:32551 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755094Ab2FNB5n (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Jun 2012 21:57:43 -0400
Message-ID: <4FD9437C.3070009@cn.fujitsu.com>
Date: Thu, 14 Jun 2012 09:50:52 +0800
From: Liu Bo <liubo2009@cn.fujitsu.com>
MIME-Version: 1.0
To: Zach Brown <zab@zabbo.net>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/4] Btrfs: use radix tree for checksum
References: <1339582751-32029-1-git-send-email-liubo2009@cn.fujitsu.com> <1339582751-32029-2-git-send-email-liubo2009@cn.fujitsu.com> <4FD8BAC9.2020108@zabbo.net>
In-Reply-To: <4FD8BAC9.2020108@zabbo.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/14/2012 12:07 AM, Zach Brown wrote:

> 
>>   int set_state_private(struct extent_io_tree *tree, u64 start, u64
>> private)
>>   {
> [...]
>> +    ret = radix_tree_insert(&tree->csum, (unsigned long)start,
>> +                   (void *)((unsigned long)private<<  1));
> 
> Will this fail for 64bit files on 32bit hosts?


In theory it will fail, but crc32c return u32, so private will be originally u32,
and it'd be ok on 32bit hosts.

> 
>> +    BUG_ON(ret);
> 
> I wonder if we can patch BUG_ON() to break the build if its only
> argument is "ret".
> 


why?

thanks,
liubo

> - z
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


