Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:38193 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378Ab3IJNPX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Sep 2013 09:15:23 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: [PATCH] Btrfs: cleanup redundant code in __btrfs_close_devices()
From: Wang Shilong <wangshilong1991@gmail.com>
In-Reply-To: <CAG5DWogv3meJ3-F5QPCGbxtavMrnjjf=-p1KrGNQYao+Nm+pHA@mail.gmail.com>
Date: Tue, 10 Sep 2013 21:15:15 +0800
Cc: Wang Shilong <wangsl.fnst@cn.fujitsu.com>,
        open list <linux-kernel@vger.kernel.org>,
        Chris Mason <chris.mason@fusionio.com>,
        "open list:BTRFS FILE SYSTEM" <linux-btrfs@vger.kernel.org>
Message-Id: <FCA484B4-67E2-4437-A16F-E3FEF751E2C1@gmail.com>
References: <1378570511-20990-1-git-send-email-a3at.mail@gmail.com> <522D4061.3060404@cn.fujitsu.com> <CAG5DWogv3meJ3-F5QPCGbxtavMrnjjf=-p1KrGNQYao+Nm+pHA@mail.gmail.com>
To: Azat Khuzhin <a3at.mail@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> On Mon, Sep 9, 2013 at 7:28 AM, Wang Shilong <wangsl.fnst@cn.fujitsu.com> wrote:
>> On 09/08/2013 12:15 AM, Azat Khuzhin wrote:
>>> 
>>> Signed-off-by: Azat Khuzhin <a3at.mail@gmail.com>
>>> ---
>>>  fs/btrfs/volumes.c |    2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>> 
>>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>>> index 1d1b595..124228e 100644
>>> --- a/fs/btrfs/volumes.c
>>> +++ b/fs/btrfs/volumes.c
>>> @@ -644,7 +644,7 @@ static int __btrfs_close_devices(struct
>>> btrfs_fs_devices *fs_devices)
>>>                /* Safe because we are under uuid_mutex */
>>>                if (device->name) {
>>>                        name = rcu_string_strdup(device->name->str,
>>> GFP_NOFS);
>>> -                       BUG_ON(device->name && !name); /* -ENOMEM */
>>> +                       BUG_ON(!name); /* -ENOMEM *
>> 
>> Nice catch! out of memory should not trigger BUG_ON()..
>> Maybe we can handle it gracefully.
> 
> Maybe return -ENOMEM ?

Yeah, BUG_On is really unfriendly. And here ENOMEM triggers
BUG_ON() is a lazy approach.

I think we can  return -ENOMEM rather than BUG_ON(), the caller can handle this.

Thanks,
Wang
> 
>> 
>> Thanks,
>> Wang
>> 
>>>                        rcu_assign_pointer(new_device->name, name);
>>>                }
>>>                new_device->bdev = NULL;
>> 
>> 
> 
> 
> 
> -- 
> Respectfully
> Azat Khuzhin
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

