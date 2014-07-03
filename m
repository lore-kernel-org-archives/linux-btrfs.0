Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:39857 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750758AbaGCIce convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Jul 2014 04:32:34 -0400
Message-ID: <53B51560.2040603@cn.fujitsu.com>
Date: Thu, 3 Jul 2014 16:33:36 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Tobias Geerinckx-Rice <tobias.geerinckx.rice@gmail.com>
CC: <kreijack@inwind.it>, <linux-btrfs@vger.kernel.org>
Subject: Re: [RFC PATCH] Revert "btrfs: allow mounting btrfs subvolumes with
 different ro/rw options"
References: <1404207001-7510-1-git-send-email-quwenruo@cn.fujitsu.com> <53B445F5.6060709@libero.it> <53B4A3C7.1020805@cn.fujitsu.com> <CAKFHe2T3FaXcO2k8NQoLx2x_xyep903hTnNRdOE62uEf+iu42Q@mail.gmail.com>
In-Reply-To: <CAKFHe2T3FaXcO2k8NQoLx2x_xyep903hTnNRdOE62uEf+iu42Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: [RFC PATCH] Revert "btrfs: allow mounting btrfs subvolumes 
with different ro/rw options"
From: Tobias Geerinckx-Rice <tobias.geerinckx.rice@gmail.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Date: 2014年07月03日 16:06
> [List CCd. I hate Gmail.]
>
> Noob alert.
>
> On 3 July 2014 02:28, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>> Subject: Re: [RFC PATCH] Revert "btrfs: allow mounting btrfs subvolumes w=
> ith
>> different ro/rw options"
>> From: Goffredo Baroncelli <kreijack@libero.it>
>> To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
>> Date: 2014=E5=B9=B407=E6=9C=8803=E6=97=A5 01:48
>>> On 07/01/2014 11:30 AM, Qu Wenruo wrote:
>>>> This commit has the following problem:
>>>> 1) Break the ro mount rule.
>>>> When users mount the whole btrfs ro, it is still possible to mount
>>>> subvol rw and change the contents. Which make the whole fs ro mount
>>>> non-sense.
>>> Where is the problem ? I see an use case when I want a conservative
>>> default: mount all ro except some subvolumes.
>>>
>>> In any case it is not a security problem because if the user has the
>>> capability to mount a subvolume, also he has the capability to remount,r=
> w
>>> the whole filesystem.
>>>
>>>
>>>
>> Not security problem but behavior not consistent.
>> If user mount the whole disk ro, he or she want the fs read only and noth=
> ing
>> will change in it.
>> If you mount a subvol rw, then the whole disk ro expectation is broken.
>> Things will change even the whole
>> disk is readonly.
> This assumption seems wrong and untenable if considered from a
> different angle: one doesn't mount the "whole disk" ro, merely the
> default subvolume.
>
> # mount -o ro /dev/sda1 /mnt
>
> is merely convenient short-hand for
>
> # mount -o ro,subvol=3D@ [or whatever] /dev/sda1 /mnt
>
> and anyone who expects this to magically protect the whole disk is,
> frankly, confused.
>
> Substituting partitions for subvolumes: mounting /dev/sda2 read-only
> should have no effect on /dev/sda3.
> Even if you went a bit batty and decided to make /dev/sda2 the
> "default partition":
>
> # ln -sf /dev/sda2 /dev/sda
> # mount -o ro /dev/sda /mnt/this/is/silly
>
> syntactic sugar doesn't change anything.
>
> Subvolumes are logically discrete entities, the fact that they share
> trees on-disk is merely a (very nice) implementation detail. It is
> impossible to mount a "whole disk" under btrfs.
Oh, sorry for my confusing words.
To make it clear, when mentioning 'the whole disk(or partition 
whatever)' I mean the FS_TREE.
(Of course not the default subvolume)

The problem is that, even you mount a subvolume ro, you can still change 
contents in the subvolume
through its rw parent subvolume.
And if a subvolume can still be modified, the ro mount lose it meaning.

So we need special rules to prevent such things.

Thanks,
Qu
>
> Tobias
>
>> The problem also happens when a parent subvol is mounted rw but child sub=
> vol
>> is mounted ro.
>> User can still modify the child subvol through parent subvol, still broke
>> the readonly rule.
> This makes sense, though.

