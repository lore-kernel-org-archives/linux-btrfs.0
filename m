Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:7725 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751103AbaISChk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Sep 2014 22:37:40 -0400
Message-ID: <541B975C.6010406@cn.fujitsu.com>
Date: Fri, 19 Sep 2014 10:39:24 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: <miaox@cn.fujitsu.com>
MIME-Version: 1.0
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, Chris Mason <clm@fb.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: kernel integration branch updated
References: <541AE9DF.9030401@fb.com> <541B8AAD.4080305@cn.fujitsu.com>
In-Reply-To: <541B8AAD.4080305@cn.fujitsu.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris

On Fri, 19 Sep 2014 09:45:17 +0800, Qu Wenruo wrote:
> Hi Chris,
> 
> 
> I'm sorry that the commit 'btrfs: Fix and enhance merge_extent_mapping() to insert best fitted extent map'
> has a V2 patch, so the one in tree is not up-to-data.
> 
> Although the v2 change is quite small and it's relevantly dependent, so it should not be a pain change.

I think it is better to merge it to v3.17 since it is a regression of v3.17 kernel

Thanks
Miao 

> Thanks,
> Qu
> 
> -------- Original Message --------
> Subject: kernel integration branch updated
> From: Chris Mason <clm@fb.com>
> To: linux-btrfs <linux-btrfs@vger.kernel.org>
> Date: 2014年09月18日 22:19
>> Hi everyone,
>>
>> I've added a few more patches to the kernel integration branch, and
>> rebased onto rc5.  This should be my last rebase before sending into
>> linux-next, please take a look.
>>
>> It's still missing three patches from Josef, which we're updating.  I
>> can put more patches on top, but I'd prefer not to rebase again unless
>> some patches need removing.
>>
>> -chris
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

