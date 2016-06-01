Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:36154 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932360AbcFABbS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 31 May 2016 21:31:18 -0400
Subject: Re: [PATCH] Improve balance performance when qgroups are turned on
To: Mark Fasheh <mfasheh@suse.de>
References: <20160527001806.GX7633@wotan.suse.de>
 <f65fce82-4985-8fc5-604d-399fbc7b5e3c@cn.fujitsu.com>
 <20160601005008.GD7633@wotan.suse.de>
CC: <linux-btrfs@vger.kernel.org>, David Sterba <dsterba@suse.com>,
        Josef Bacik <jbacik@fb.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <32fe4f1d-0ad8-da6f-ccca-becd551b4bee@cn.fujitsu.com>
Date: Wed, 1 Jun 2016 09:31:14 +0800
MIME-Version: 1.0
In-Reply-To: <20160601005008.GD7633@wotan.suse.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 06/01/2016 08:50 AM, Mark Fasheh wrote:
> On Mon, May 30, 2016 at 03:48:14PM +0800, Qu Wenruo wrote:
>>
>>
>> Mark Fasheh wrote on 2016/05/26 17:18 -0700:
>>> The btrfs balance operation is significantly slower when qgroups are
>>> enabled. To the best of my knowledge, a balance shouldn't have an effect on
>>> qgroups counts (extents are not changing between subvolumes), so we don't
>>> need to actually run the qgroup code when we balance.
>>
>> This assumption is questionable.
>>
>> When balancing, it's true we will set the chunk to ro, so new
>> *allocation* won't happen in that chunk.
>>
>> However we can still de-refer an extent during balance.
>>
>> If that happens and we skipped the qgroup accounting, corruption happens.
>> As the extent before and after balance won't go through qgroup, so
>> it's de-reference won't be accounted.
>
> Ok, thanks for the review. I was afraid that this was the case.
>
>
>> While without your patch, the final qgroup is stable with 16KiB.
>
> Qgroups in general are broken with respect to balance. The following script
> reproduces an inconsistency every time I run it. You'll notice that qgroups
> aren't even turned on until before we do the balance op. Like the snap
> create bug, I believe you simply need a non-trivial amount of data on the fs
> for testing.
>
>
> #!/bin/bash -x
>
> MNT="/btrfs"
> DEV="/dev/vdb1"
>
> mkfs.btrfs -f $DEV
> mount -t btrfs $DEV $MNT
>
> mkdir $MNT/snaps
> echo "populate $MNT with some data"
> #cp -a /usr/share/fonts $MNT/
> cp -a /usr/ $MNT/ &
> for i in `seq -w 0 8`; do
>         S="$MNT/snaps/snap$i"
>         echo "create and populate $S"
>         btrfs su snap $MNT $S;
>         cp -a /boot $S;
> done;
>
> #let the cp from above finish
> wait
>
> btrfs fi sync $MNT
>
> btrfs quota enable $MNT
> btrfs quota rescan -w $MNT
> btrfs qg show $MNT
>
> umount $MNT
>
> mount -t btrfs $DEV $MNT
>
>
> time btrfs balance start --full-balance $MNT
>
> umount $MNT
>
> btrfsck $DEV
>

Thanks　for the test case.
It would be better if you could submit a test case for it.

Reproduced the problem. I'll track it down.
Seems to be related with metadata.

Thanks,
Qu

>
>
>> The xfstest case will follow soon.
>
> Ok, that will help the next time someone tries to fix this, thanks.
> 	--Mark
>
> --
> Mark Fasheh
>
>


