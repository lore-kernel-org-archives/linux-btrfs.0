Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from services.gouders.net ([141.101.32.176]:57340 "EHLO
        services.gouders.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751965AbeCMNBl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Mar 2018 09:01:41 -0400
From: Dirk Gouders <dirk@gouders.net>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Linux BTRFS mailing list <linux-btrfs@vger.kernel.org>
Subject: Re: FS unmountable after RAID/LVM problems
In-Reply-To: <005e24f2-2638-74c3-5034-92c094671d80@gmx.com> (Qu Wenruo's
        message of "Tue, 13 Mar 2018 20:25:08 +0800")
References: <ghlgew5pbq.fsf@lena.gouders.net>
        <005e24f2-2638-74c3-5034-92c094671d80@gmx.com>
Date: Tue, 13 Mar 2018 14:01:32 +0100
Message-ID: <ghwoygxh77.fsf@lena.gouders.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Qu Wenruo <quwenruo.btrfs@gmx.com> writes:

> On 2018年03月13日 16:53, Dirk Gouders wrote:

<SNIP>

>> find-root:
>> 
>> # btrfs-find-root /dev/loop0p1
>> Superblock thinks the generation is 9858294
>> Superblock thinks the level is 1
>> Found tree root at 848773120 gen 9858294 level 1
>
> Tree root is found, find-root won't help much here.
> And if it's really tree root corruption, we should have some kernel
> message for it.
>
>> Well block 832045056(gen: 9858272 level: 1) seems good, but generation/level doesn't match, want gen: 9858294 level: 1
>
> Especially when the next tree block is 22 generation older.
>
> Would you please try to call "btrfs inspect dump-tree <device>" and
> paste the result with *stderr*?
>
> At least we could know which tree block is corrupted.

Here is the result of inspect:

# btrfs inspect dump-tree /dev/loop0p1
btrfs-progs v4.15
checksum verify failed on 363069440 found 296FB15A wanted F0AFE59D
checksum verify failed on 363069440 found 296FB15A wanted F0AFE59D
checksum verify failed on 363069440 found DC09290B wanted C630FD61
checksum verify failed on 363069440 found 296FB15A wanted F0AFE59D
bytenr mismatch, want=363069440, have=17552567724568668829
ERROR: unable to open /dev/loop0p1

Thanks,

Dirk
