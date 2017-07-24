Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f177.google.com ([209.85.223.177]:38193 "EHLO
        mail-io0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751370AbdGXOZT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Jul 2017 10:25:19 -0400
Received: by mail-io0-f177.google.com with SMTP id g13so43591683ioj.5
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Jul 2017 07:25:19 -0700 (PDT)
Subject: Re: Best Practice: Add new device to RAID1 pool
To: Cloud Admin <admin@cloud.haefemeier.eu>, linux-btrfs@vger.kernel.org
References: <1500895655.2781.6.camel@cloud.haefemeier.eu>
 <18d96f74-00a8-9bb9-dddc-f50940d0971e@gmail.com>
 <1500905566.2781.8.camel@cloud.haefemeier.eu>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <4b768b97-2c0b-bf67-dec0-1c5a1f7181b2@gmail.com>
Date: Mon, 24 Jul 2017 10:25:15 -0400
MIME-Version: 1.0
In-Reply-To: <1500905566.2781.8.camel@cloud.haefemeier.eu>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-07-24 10:12, Cloud Admin wrote:
> Am Montag, den 24.07.2017, 09:46 -0400 schrieb Austin S. Hemmelgarn:
>> On 2017-07-24 07:27, Cloud Admin wrote:
>>> Hi,
>>> I have a multi-device pool (three discs) as RAID1. Now I want to
>>> add a
>>> new disc to increase the pool. I followed the description on https:
>>> //bt
>>> rfs.wiki.kernel.org/index.php/Using_Btrfs_with_Multiple_Devices and
>>> used 'btrfs add <device> <btrfs path>'. After that I called a
>>> balance
>>> for rebalancing the RAID1 using 'btrfs balance start <btrfs path>'.
>>> Is that anything or should I need to call a resize (for example) or
>>> anything else? Or do I need to specify filter/profile parameters
>>> for
>>> balancing?
>>> I am a little bit confused because the balance command is running
>>> since
>>> 12 hours and only 3GB of data are touched. This would mean the
>>> whole
>>> balance process (new disc has 8TB) would run a long, long time...
>>> and
>>> is using one cpu by 100%.
>>
>> Based on what you're saying, it sounds like you've either run into a
>> bug, or have a huge number of snapshots on this filesystem.
> 
> It depends what you define as huge. The call of 'btrfs sub list <btrfs
> path>' returns a list of 255 subvolume.
OK, this isn't horrible, especially if most of them aren't snapshots 
(it's cross-subvolume reflinks that are most of the issue when it comes 
to snapshots, not the fact that they're subvolumes).
> I think this is not too huge. The most of this subvolumes was created
> using docker itself. I cancel the balance (this will take awhile) and will try to delete such of these subvolumes/snapshots.
> What can I do more?
As Roman mentioned in his reply, it may also be qgroup related.  If you run:
btrfs quota disable

On the filesystem in question, that may help too, and if you are using 
quotas, turning them off with that command will get you a much bigger 
performance improvement than removing all the snapshots.
