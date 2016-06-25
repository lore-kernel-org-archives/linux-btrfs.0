Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:34128 "EHLO
	mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705AbcFYUyn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 25 Jun 2016 16:54:43 -0400
Received: by mail-oi0-f51.google.com with SMTP id s66so157199939oif.1
        for <linux-btrfs@vger.kernel.org>; Sat, 25 Jun 2016 13:54:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160625211024.Horde.pL6RMZNJL6tnjtpglBZjDaB@mail.sapo.pt>
References: <loom.20160623T205347-371@post.gmane.org> <CAJCQCtRO+FYrsfHF_ARSnPfoS7uzvLR4hB1V-TJ_YN4NcA6srw@mail.gmail.com>
 <5356822.A3RRKHDHNy@linux-omuo> <CAJCQCtQ-xYrERT5R4gSC1C7OkoeP2LeS9W9UL5VY5SmDBXk71w@mail.gmail.com>
 <20160625010610.Horde.tUycS31CmgVWfy3CPu7qJCD@mail.sapo.pt>
 <CAJCQCtSGZO8JVXqVOwifT84KTLCkciux+Y6A_na4AA-PxPjjbw@mail.gmail.com> <20160625211024.Horde.pL6RMZNJL6tnjtpglBZjDaB@mail.sapo.pt>
From: Chris Murphy <lists@colorremedies.com>
Date: Sat, 25 Jun 2016 14:54:41 -0600
Message-ID: <CAJCQCtQ+q90r=Q38mtVKoBeAmXmPJPP2cp=dfLj3kBiEv66bzA@mail.gmail.com>
Subject: Re: Bad hard drive - checksum verify failure forces readonly mount
To: Vasco Almeida <vascomalmeida@sapo.pt>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jun 25, 2016 at 2:10 PM, Vasco Almeida <vascomalmeida@sapo.pt> wrote:
> Citando Chris Murphy <lists@colorremedies.com>:

>>
>> I would do a couple things in order:
>> 1. Mount ro and copy off what you want in case the whole thing gets
>> worse and can't ever be mounted again.
>> 2. Mount with only these options: -o skip_balance,subvolid=5,nospace_cache
>
>
> I have mounted with that options and was readwrite first and then it forces
> readonly. You can see a delay between first BTRFS messages and the "BTRFS
> info: forced readonly" message in dmesg.
>
> /dev/mapper/vg_pupu-lv_opensuse_root on /mnt type btrfs
> (ro,relatime,seclabel,nospace_cache,skip_balance,subvolid=5,subvol=/)
>
>
>> If it mounts rw, don't do anything with it, just see if it cleans up
>> after itself. It also looks from the previous trace it was trying to
>> remove a snapshot and there are complaints of problems in that
>> snapshot. So hopefully just waiting 5 minutes doing nothing and it'll
>> clean up after itself (you can check with top to see if there are any
>> btrfs related transactions that run including the btrfs-cleaner
>> process) wait until they're done.
>
>
> I can see that btrfs processes including btrfs-cleaner but they may be not
> doing much since device was forced readonly after mounting it.

Readonly just refers to user space to and including VFS, is my
understanding. The file system itself can still write to the block
device.


> I have umount it normally (umount /mnt) after more than 20 minutes since
> mounting it.
>
>> 3. btrfs-image so that devs can see what's causing the problem that
>> the current code isn't handling well enough.
>
>
> btrfs-image does not create dump image:
>
> # btrfs-image /dev/mapper/vg_pupu-lv_opensuse_root
> btrfs-lv_opensuse_root.image
> checksum verify failed on 437944320 found 8BF8C752 wanted 39F456C8
> checksum verify failed on 437944320 found 8BF8C752 wanted 39F456C8
> checksum verify failed on 437944320 found 8BF8C752 wanted 39F456C8
> checksum verify failed on 437944320 found 8BF8C752 wanted 39F456C8
> Csum didn't match
> Error reading metadata block
> Error adding block -5
> checksum verify failed on 437944320 found 8BF8C752 wanted 39F456C8
> checksum verify failed on 437944320 found 8BF8C752 wanted 39F456C8
> checksum verify failed on 437944320 found 8BF8C752 wanted 39F456C8
> checksum verify failed on 437944320 found 8BF8C752 wanted 39F456C8
> Csum didn't match
> Error reading metadata block
> Error flushing pending -5
> create failed (Success)
> # echo $?
> 1

Well it's pretty strange to have DUP metadata and for the checksum
verify to fail on both copies. I don't have much optimism that brfsck
repair can fix it either. But still it's worth a shot since there's
not much else to go on.


-- 
Chris Murphy
