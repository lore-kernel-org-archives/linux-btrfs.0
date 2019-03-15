Return-Path: <SRS0=BvJc=RS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F10EDC43381
	for <linux-btrfs@archiver.kernel.org>; Fri, 15 Mar 2019 20:31:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B35892186A
	for <linux-btrfs@archiver.kernel.org>; Fri, 15 Mar 2019 20:31:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726360AbfCOUby (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 15 Mar 2019 16:31:54 -0400
Received: from syrinx.knorrie.org ([82.94.188.77]:36974 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726097AbfCOUbx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Mar 2019 16:31:53 -0400
Received: from [IPv6:2001:980:4a41:fb::12] (unknown [IPv6:2001:980:4a41:fb::12])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by syrinx.knorrie.org (Postfix) with ESMTPSA id 105493E925CB9;
        Fri, 15 Mar 2019 21:31:51 +0100 (CET)
Subject: Re: Balancing raid5 after adding another disk does not move/use any
 data on it
To:     Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
        =?UTF-8?Q?Jakub_Hus=c3=a1k?= <jakub@husak.pro>
Cc:     linux-btrfs@vger.kernel.org
References: <7a713010-5db6-2627-2593-8e13092868b1@husak.pro>
 <20190315180123.GJ9995@hungrycats.org>
From:   Hans van Kranenburg <hans@knorrie.org>
Openpgp: preference=signencrypt
Autocrypt: addr=hans@knorrie.org; prefer-encrypt=mutual; keydata=
 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
Message-ID: <3dce71e1-6caa-59ad-1765-6a29c7dd774f@knorrie.org>
Date:   Fri, 15 Mar 2019 21:31:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
MIME-Version: 1.0
In-Reply-To: <20190315180123.GJ9995@hungrycats.org>
Content-Type: text/plain; charset=windows-1252
Content-Language: en_US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 3/15/19 7:01 PM, Zygo Blaxell wrote:
> On Wed, Mar 13, 2019 at 11:11:02PM +0100, Jakub Husák wrote:
>> Sorry, fighting with this technology called "email" :)
>>
>>
>> Hopefully better wrapped outputs:
>>
>> On 13. 03. 19 22:58, Jakub Husák wrote:
>>
>>
>>> Hi,
>>>
>>> I added another disk to my 3-disk raid5 and ran a balance command. After
>>> few hours I looked to output of `fi usage` to see that no data are being
>>> used on the new disk. I got the same result even when balancing my raid5
>>> data or metadata.
>>>
>>> Next I tried to convert my raid5 metadata to raid1 (a good idea anyway)
>>> and the new disk started to fill immediately (even though it received
>>> the whole amount of metadata with replicas being spread among the other
>>> drives, instead of being really "balanced". I know why this happened, I
>>> don't like it but I can live with it, let's not go off topic here :)).
>>>
>>> Now my usage output looks like this:
>>>
>> # btrfs filesystem usage   /mnt/data1
>> WARNING: RAID56 detected, not implemented
>> Overall:
>>     Device size:          10.91TiB
>>     Device allocated:         316.12GiB
>>     Device unallocated:          10.61TiB
>>     Device missing:             0.00B
>>     Used:              58.86GiB
>>     Free (estimated):             0.00B    (min: 8.00EiB)
>>     Data ratio:                  0.00
>>     Metadata ratio:              2.00
>>     Global reserve:         512.00MiB    (used: 0.00B)
>>
>> Data,RAID5: Size:4.59TiB, Used:4.06TiB
>>    /dev/mapper/crypt-sdb       2.29TiB
>>    /dev/mapper/crypt-sdc       2.29TiB
>>    /dev/mapper/crypt-sde       2.29TiB
>>
>> Metadata,RAID1: Size:158.00GiB, Used:29.43GiB
>>    /dev/mapper/crypt-sdb      53.00GiB
>>    /dev/mapper/crypt-sdc      53.00GiB
>>    /dev/mapper/crypt-sdd     158.00GiB
>>    /dev/mapper/crypt-sde      52.00GiB
>>
>> System,RAID1: Size:64.00MiB, Used:528.00KiB
>>    /dev/mapper/crypt-sdc      32.00MiB
>>    /dev/mapper/crypt-sdd      64.00MiB
>>    /dev/mapper/crypt-sde      32.00MiB
>>
>> Unallocated:
>>    /dev/mapper/crypt-sdb     393.04GiB
>>    /dev/mapper/crypt-sdc     393.01GiB
>>    /dev/mapper/crypt-sdd       2.57TiB
>>    /dev/mapper/crypt-sde     394.01GiB
>>
>>>
>>> I'm now running `fi balance -dusage=10` (and rising the usage limit). I
>>> can see that the unallocated space is rising as it's freeing the little
>>> used chunks but still no data are being stored on the new disk.
> 
> That is exactly what is happening:  you are moving tiny amounts of data
> into existing big empty spaces, so no new chunk allocations (which should
> use the new drive) are happening.  You have 470GB of data allocated
> but not used, so you have up to 235 block groups to fill before the new
> drive gets any data.
> 
> Also note that you always have to do a full data balance when adding
> devices to raid5 in order to make use of all the space, so you might
> as well get started on that now.  It'll take a while.  'btrfs balance
> start -dstripes=1..3 /mnt/data1' will work for this case.
> 
>>> I it some bug? Is `fi usage` not showing me something (as it states
>>> "WARNING: RAID56 detected, not implemented")? 
> 
> The warning just means the fields in the 'fi usage' output header,
> like "Free (estimate)", have bogus values because they're not computed
> correctly.

The output of the btrfs-usage-report which comes with the python-btrfs
library (since v11) might be interesting for you here.

It actually will show you pretty accurate numbers, and it also contains
a section that exactly shows you how much currently unallocatable raw
disk space you have on which disk. While moving around things with
balance, you can see the numbers change.

>>> Or is there just too much
>>> free space on the first set of disks that the balancing is not bothering
>>> moving any data?
> 
> Yes.  ;)
> 
>>> If so, shouldn't it be really balancing (spreading) the data among all
>>> the drives to use all the IOPS capacity, even when the raid5 redundancy
>>> constraint is currently satisfied?
> 
> btrfs divides the disks into chunks first, then spreads the data across
> the chunks.  The chunk allocation behavior spreads chunks across all the
> disks.  When you are adding a disk to raid5, you have to redistribute all
> the old data across all the disks to get balanced IOPS and space usage,
> hence the full balance requirement.
> 
> If you don't do a full balance, it will eventually allocate data on
> all disks, but it will run out of space on sdb, sdc, and sde first,
> and then be unable to use the remaining 2TB+ on sdd.

Also, if you have a lot of empty space in the current allocations, btrfs
balance has the tendency to first start packing everything together
before allocating new (4 disk wide) block groups.

This is annoying, because it can result in moving the same data multiple
times during balance (into empty space of another existing block group,
and then when that one has its turn again etc).

So you want to get rid of empty space in existing block groups as soon
as possible. btrfs-balance-least-used can do this, (also an example from
python-btrfs), by doing them in order of most empty one first.

A copy of the script with the following change will filter out block
groups that already span 4 drives:

diff --git a/bin/btrfs-balance-least-used b/bin/btrfs-balance-least-used
index 7005347..0b243a3 100755
--- a/bin/btrfs-balance-least-used
+++ b/bin/btrfs-balance-least-used
@@ -41,6 +41,8 @@ def load_block_groups(fs, max_used_pct):
     for chunk in fs.chunks():
         if not (chunk.type & btrfs.BLOCK_GROUP_DATA):
             continue
+        if len(chunk.stripes) > 3:
+            continue
         try:
             block_group = fs.block_group(chunk.vaddr, chunk.length)
             if block_group.used_pct <= max_used_pct:


https://github.com/knorrie/python-btrfs/tree/master/bin

>> #  uname -a
>> Linux storage 4.19.0-0.bpo.2-amd64 #1 SMP Debian 4.19.16-1~bpo9+1
>> (2019-02-07) x86_64 GNU/Linux
>> #   btrfs --version
>> btrfs-progs v4.17
>> #  btrfs fi show
>> Label: none  uuid: xxxxxxxxxxxxxxxxx
>>     Total devices 4 FS bytes used 4.09TiB
>>     devid    2 size 2.73TiB used 2.34TiB path /dev/mapper/crypt-sdc
>>     devid    3 size 2.73TiB used 2.34TiB path /dev/mapper/crypt-sdb
>>     devid    4 size 2.73TiB used 2.34TiB path /dev/mapper/crypt-sde
>>     devid    5 size 2.73TiB used 158.06GiB path /dev/mapper/crypt-sdd
>>
>> #   btrfs fi df .
>> Data, RAID5: total=4.59TiB, used=4.06TiB
>> System, RAID1: total=64.00MiB, used=528.00KiB
>> Metadata, RAID1: total=158.00GiB, used=29.43GiB
>> GlobalReserve, single: total=512.00MiB, used=0.00B

</commercials break>

Hans

