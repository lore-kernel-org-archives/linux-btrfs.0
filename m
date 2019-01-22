Return-Path: <SRS0=kIOr=P6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9BC7C282C4
	for <linux-btrfs@archiver.kernel.org>; Tue, 22 Jan 2019 14:28:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8501E21721
	for <linux-btrfs@archiver.kernel.org>; Tue, 22 Jan 2019 14:28:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728655AbfAVO2z (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 22 Jan 2019 09:28:55 -0500
Received: from bang.steev.me.uk ([81.2.120.65]:59271 "EHLO smtp.steev.me.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728615AbfAVO2z (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Jan 2019 09:28:55 -0500
Received: from localhost ([::1] helo=webmail.steev.me.uk)
        by smtp.steev.me.uk with esmtp (Exim 4.91)
        id 1glx2r-00058u-C4; Tue, 22 Jan 2019 14:28:53 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Tue, 22 Jan 2019 14:28:53 +0000
From:   Steven Davies <btrfs-list@steev.me.uk>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 2/3] btrfs: add read_mirror_policy parameter devid
In-Reply-To: <24ea40ca-5216-fbe4-2b4b-64da7d8a89fa@oracle.com>
References: <20180516100359.7752-1-anand.jain@oracle.com>
 <20180516100359.7752-3-anand.jain@oracle.com>
 <443d1af2948306c1f776baaa227272ae@steev.me.uk>
 <24ea40ca-5216-fbe4-2b4b-64da7d8a89fa@oracle.com>
Message-ID: <5e35fc5da89e1722caf261f89679d039@steev.me.uk>
X-Sender: btrfs-list@steev.me.uk
User-Agent: Roundcube Webmail/1.3.8
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 2019-01-22 13:43, Anand Jain wrote:
> On 01/21/2019 07:56 PM, Steven Davies wrote:
>> On 2018-05-16 11:03, Anand Jain wrote:

>>> +                break;
>>> +            }
>> 
>> I noticed that it's possible to pass this option multiple times at 
>> mount, which sets multiple devices as read mirrors. While that doesn't 
>> do anything harmful, the code below will only use the first device. It 
>> may be worth at least mentioning this in documentation.
> 
>  There were few feedback if read_mirror_policy should be a mount
>  option or a sysfs or a property. IMO property is better as it would
>  be persistent. In sysfs and mount-option, the user or a config file
>  has to remember. Will fix.

I agree. Would/could this be set at mkfs time? It would then be similar 
to how mdadm's --write-mostly is set up.

>>> +
>>>              ret = -EINVAL;
>>>              goto out;
>>>          case Opt_err:
>>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>>> index 64dba5c4cf33..3a9c3804ff17 100644
>>> --- a/fs/btrfs/volumes.c
>>> +++ b/fs/btrfs/volumes.c
>>> @@ -5220,6 +5220,16 @@ static int find_live_mirror(struct
>>> btrfs_fs_info *fs_info,
>>>          num_stripes = map->num_stripes;
>>> 
>>>      switch(fs_info->read_mirror_policy) {
>>> +    case BTRFS_READ_MIRROR_BY_DEV:
>>> +        preferred_mirror = first;
>>> +        if (test_bit(BTRFS_DEV_STATE_READ_MIRROR,
>>> +                 &map->stripes[preferred_mirror].dev->dev_state))
>>> +            break;
>>> +        if (test_bit(BTRFS_DEV_STATE_READ_MIRROR,
>>> +                 &map->stripes[++preferred_mirror].dev->dev_state)) 
>>> <--[*]
>>> +            break;
>>> +        preferred_mirror = first;
>> 
>> Why set preferred_mirror again? The only effect of re-setting it will 
>> be to use the lowest devid (1) rather than the highest (2). Is there 
>> any difference? Either way it should never happen, because the above 
>> code traps it (except when the BTRFS_DEV_STATE_READ_MIRROR flag has 
>> been changed as mentioned above).
> 
>  Code at [*] above does ++preferred_mirror. So the following
>    preferred_mirror = first;
>  is not redundant.

Yes, but preferred_mirror will be first + num_stripes; meaning that 
without that line the last stripe is preferred and with it the first 
stripe is preferred. It only changes the fallback case from reading from 
devid 2 to devid 1, which barely matters. Perhaps it would be even 
better to fall back to pid % num_stripes in this case anyway?

>>  From Goffredo's comment[1] on Timofey's similar effect patch, if it 
>> becomes possible to have more mirrors in a RAID1/RAID10 fs then this 
>> code will need to be updated to test dev_state for more than two 
>> devices. Would it be sensible to implement this as a for loop straight 
>> away?
> 
>  Right. A loop is better, will add.

Thinking more about this, if it becomes possible to have more than two 
devices in a RAID1 or part-RAID10 then do we also need to consider that 
there may be more than one READ_MIRROR drive? e.g. slow+fast+fast drives 
in a RAID1 with this approach would result in all chunks being read from 
the first drive with READ_MIRROR set if both chunks are on the fast 
drives. This is where Timofey's queue length patch in [1] would become 
useful - in any case, that is an existing problem and probably deserving 
of an entirely new patch.

>> [1]: https://patchwork.kernel.org/patch/10678531/#22315779
> 
> 
>  Thanks,
> Anand.

Steve
