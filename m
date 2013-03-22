Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-da0-f47.google.com ([209.85.210.47]:37189 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698Ab3CVNZr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Mar 2013 09:25:47 -0400
Received: by mail-da0-f47.google.com with SMTP id s35so2261888dak.6
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Mar 2013 06:25:47 -0700 (PDT)
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: [PATCH] Btrfs-progs: fix overflow when printing qgroup info
From: Wang Shilong <wangshilong1991@gmail.com>
In-Reply-To: <4BEA1935-2ED7-4701-A45E-4CA4E739064B@gmail.com>
Date: Fri, 22 Mar 2013 21:25:39 +0800
Cc: linux-btrfs@vger.kernel.org, koen.de.wit@oracle.com,
        Arne Jansen <sensille@gmx.net>
Message-Id: <7E786495-6A2A-4BDA-8E69-8AB7CBAB7BBC@gmail.com>
References: <1363953208-2342-1-git-send-email-wangshilong1991@gmail.com> <514C4FD9.30504@jan-o-sch.net> <4BEA1935-2ED7-4701-A45E-4CA4E739064B@gmail.com>
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Hello,

> Hello,
> 
>> 
>> On Fri, March 22, 2013 at 12:53 (+0100), Wang Shilong wrote:
>>> From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
>>> 
>>> Since btrfs quota rescan has not been implemented yet,
>>> a user complains that "btrfs qgroup show" lists qgroup
>>> referenced/exclusive be negative. However, this should
>>> not happen even if overflow happens,because the type for
>>> qgroup referenced/exclusive is u64,fix it.
>>> 
>>> Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
>>> Reported-by: Koen De Wit <koen.de.wit@oracle.com>
>>> ---
>>> cmds-qgroup.c | 2 +-
>>> 1 file changed, 1 insertion(+), 1 deletion(-)
>>> 
>>> diff --git a/cmds-qgroup.c b/cmds-qgroup.c
>>> index 60ca33d..fc4cb13 100644
>>> --- a/cmds-qgroup.c
>>> +++ b/cmds-qgroup.c
>>> @@ -105,7 +105,7 @@ static int qgroup_create(int create, int argc, char **argv)
>>> 
>>> void print_qgroup_info(u64 objectid, struct btrfs_qgroup_info_item *info)
>>> {
>>> -	printf("%llu/%llu %lld %lld\n", objectid >> 48,
>>> +	printf("%llu/%llu %llu %llu\n", objectid >> 48,
>>> 		objectid & ((1ll << 48) - 1),
>>> 		btrfs_stack_qgroup_info_referenced(info),
>>> 		btrfs_stack_qgroup_info_exclusive(info));
>>> 
>> 
>> I don't like that change. Seeing negative numbers is what you should expect in
>> the current situation.
>> 
>> Once anyone come across negative numbers with a volume holding more data than
>> what can be tracked with 63 bit, I may come to agree to your change. For now, it
>> will confuse more than help.
> 
> Maybe, you are right.
> 
> But the type for referenced/exclusive is u64. Considering the following case:
> 
> overflow happens, referenced/exclusive changes into a big positive integer, so next time,
> when we doing accounting, it may return edquot. So i think the check in the kernel is necessary.

For the above case, From the user view, the referenced/exclusive is negative, 
but user can't continue to write data. How strange it is!

So, i think to have a check in the kernel and making the referenced/exclusive to be 0
and give a warning in the kernel is better than current situation.

If you agree with my approach, i will make the patch and send it next week. ~_~

Thanks,
Wang

> 
> Or am i missing something ?
> 
> Thanks,
> Wang
> 
> 
>> 
>> -Jan
> 

