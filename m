Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f53.google.com ([209.85.214.53]:42718 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351AbaBEQWt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 5 Feb 2014 11:22:49 -0500
Received: by mail-bk0-f53.google.com with SMTP id my13so283003bkb.12
        for <linux-btrfs@vger.kernel.org>; Wed, 05 Feb 2014 08:22:47 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <52F264E2.3050507@fb.com>
References: <1391186525-2965-1-git-send-email-wangshilong1991@gmail.com>
	<CAL3q7H7n+L2CqT9whDDT1ZjUzgU378HUhOuQHhjKUp7eiKD=aw@mail.gmail.com>
	<337FC422-D102-4310-A714-FA35538DD402@gmail.com>
	<23FBD0CF-ABE2-4135-8522-7B24E90911B9@gmail.com>
	<52F264E2.3050507@fb.com>
Date: Wed, 5 Feb 2014 16:22:47 +0000
Message-ID: <CAL3q7H6EqpeHt9B85kZb4713Qd6UzjnTah--frTJ_XJ=9LikHQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] Btrfs: switch to btrfs_previous_extent_item()
From: Filipe David Manana <fdmanana@gmail.com>
To: Josef Bacik <jbacik@fb.com>
Cc: Wang Shilong <wangshilong1991@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 5, 2014 at 4:20 PM, Josef Bacik <jbacik@fb.com> wrote:
>
> On 02/05/2014 11:14 AM, Wang Shilong wrote:
>>
>> Hi Filipe,
>>
>>> So i knew what was wrong here, we need found_key while
>>> btrfs_previous_extent_item() did set
>>> it properly..^_^
>>>
>>> I will send a v2 to fix this, thanks!
>>>
>>>
>>>> On Fri, Jan 31, 2014 at 4:42 PM, Wang Shilong
>>>> <wangshilong1991@gmail.com> wrote:
>>>>>
>>>>> From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
>>>>>
>>>>> Since we have introduced btrfs_previous_extent_item() to search
>>>>> previous
>>>>> extent item, just switch into it.
>>>>>
>>>>> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
>>>>
>>>> Hi Shilong,
>>>>
>>>> This patch is making btrfs/004 fail for me, consistently:
>>
>> I was trying to reproduce this xfstest failure(though we have known what's
>> wrong with my previous patch).
>> I did not really hit 004 failure, but i can reproduce btrfs/030 fail
>> consistently, i think you might be interested in this:
>>
> Do you guys have some CONFIG_ONLY_BREAK_FOR_ME=y set or something? I can't
> reproduce this failure either.  Will you send the updated
> btrfs_previous_extent_item patch and then see if you can bisect down why 030
> is failing for you?  Thanks,

I can't reproduce Shilong's 030 failure on latest btrfs-next, neither
with nor without the previous_extent_item patch. And quite surprised,
since the test is very deterministic (hardcoded fs structure).

>
> Josef



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
