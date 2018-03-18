Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.domeneshop.no ([194.63.252.55]:48057 "EHLO
        smtp.domeneshop.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754775AbeCRWwe (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 18 Mar 2018 18:52:34 -0400
Reply-To: waxhead@dirtcellar.net
Subject: Re: Crashes running btrfs scrub
To: Liu Bo <obuil.liubo@gmail.com>, Mike Stevens <michael.stevens@bayer.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <06b1fdb0d1884406a2d4c2e8be75e289@MOXDE7.na.bayer.cnb>
 <5389894b-5553-27b8-f9b3-4f6938bd75dd@dirtcellar.net>
 <3a6b6a6fb7d441b5a8081300067d6e02@MOXDE7.na.bayer.cnb>
 <CANQeFDDEtYYummhR7gZAxidQxTjbCbzEpLsR5L=HtykFkP2BBQ@mail.gmail.com>
 <1a292eab288a4c90bf6dbf804dc92c86@MOXDE7.na.bayer.cnb>
 <CANQeFDCSv9pwrGOqimQnb0kW8ZBJY=smF2MbZ7zcmEev-M7YzQ@mail.gmail.com>
 <CANQeFDB5pu+h++p3-GTUO28DE52r9JiW6TyLdy+rYGfUwjOfGA@mail.gmail.com>
From: waxhead <waxhead@dirtcellar.net>
Message-ID: <fa53b8c8-1cf9-2d3d-4a9b-70e760ec45bb@dirtcellar.net>
Date: Sun, 18 Mar 2018 23:52:31 +0100
MIME-Version: 1.0
In-Reply-To: <CANQeFDB5pu+h++p3-GTUO28DE52r9JiW6TyLdy+rYGfUwjOfGA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Liu Bo wrote:
> On Sat, Mar 17, 2018 at 5:26 PM, Liu Bo <obuil.liubo@gmail.com> wrote:
>> On Fri, Mar 16, 2018 at 2:46 PM, Mike Stevens <michael.stevens@bayer.com> wrote:
>>>> Could you please paste the whole dmesg, it looks like it hit
>>>> btrfs_abort_transaction(),
>>>> which should give us more information about where goes wrong.
>>>
>>> The whole thing is here https://pastebin.com/4ENq2saQ
>>
>> Given this,
>>
>> [  299.410998] BTRFS: error (device sdag) in
>> btrfs_create_pending_block_groups:10192: errno=-27 unknown
>>
>> it refers to -EFBIG, so I think the warning comes from
>>
>> btrfs_add_system_chunk()
>> {
>> ...
>>          if (array_size + item_size + sizeof(disk_key)
>>
>>                          > BTRFS_SYSTEM_CHUNK_ARRAY_SIZE) {
>>
>>                  mutex_unlock(&fs_info->chunk_mutex);
>>
>>                  return -EFBIG;
>>
>>          }
>>
>> If that's the case, we need to check this earlier during mount.
>>
> 
> I didn't realize this until now,  we do have a limitation on up to how
> many disks btrfs could handle, in order to make balance/scrub work
> properly (where system chunks may be set readonly),
> 
> ((BTRFS_SYSTEM_CHUNK_ARRAY_SIZE / 2) - sizeof(struct btrfs_chunk)) /
> sizeof(struct btrfs_stripe) + 1
> 
> will be the number of disks btrfs can handle at most.

Am I understanding this correct, BTRFS have limit to the number of 
physical devices it can handle?! (max 30 devices?!)

Or are this referring to the number of devices BTRFS can utilize in a 
stripe (in which case 30 actually sounds like a high number).

30 devices is really not that much, heck you get 90 disks top load JBOD 
storage chassis these days and BTRFS does sound like an attractive 
choice for things like that.
