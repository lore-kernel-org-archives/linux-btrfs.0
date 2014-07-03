Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f171.google.com ([209.85.213.171]:59403 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755913AbaGCIGt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Jul 2014 04:06:49 -0400
Received: by mail-ig0-f171.google.com with SMTP id h18so7615844igc.16
        for <linux-btrfs@vger.kernel.org>; Thu, 03 Jul 2014 01:06:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <53B4A3C7.1020805@cn.fujitsu.com>
References: <1404207001-7510-1-git-send-email-quwenruo@cn.fujitsu.com>
 <53B445F5.6060709@libero.it> <53B4A3C7.1020805@cn.fujitsu.com>
From: Tobias Geerinckx-Rice <tobias.geerinckx.rice@gmail.com>
Date: Thu, 3 Jul 2014 10:06:28 +0200
Message-ID: <CAKFHe2T3FaXcO2k8NQoLx2x_xyep903hTnNRdOE62uEf+iu42Q@mail.gmail.com>
Subject: Re: [RFC PATCH] Revert "btrfs: allow mounting btrfs subvolumes with
 different ro/rw options"
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: kreijack@inwind.it, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[List CCd. I hate Gmail.]

Noob alert.

On 3 July 2014 02:28, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
> Subject: Re: [RFC PATCH] Revert "btrfs: allow mounting btrfs subvolumes w=
ith
> different ro/rw options"
> From: Goffredo Baroncelli <kreijack@libero.it>
> To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
> Date: 2014=E5=B9=B407=E6=9C=8803=E6=97=A5 01:48
>>
>> On 07/01/2014 11:30 AM, Qu Wenruo wrote:
>>>
>>> This commit has the following problem:
>>> 1) Break the ro mount rule.
>>> When users mount the whole btrfs ro, it is still possible to mount
>>> subvol rw and change the contents. Which make the whole fs ro mount
>>> non-sense.
>>
>> Where is the problem ? I see an use case when I want a conservative
>> default: mount all ro except some subvolumes.
>>
>> In any case it is not a security problem because if the user has the
>> capability to mount a subvolume, also he has the capability to remount,r=
w
>> the whole filesystem.
>>
>>
>>
> Not security problem but behavior not consistent.
> If user mount the whole disk ro, he or she want the fs read only and noth=
ing
> will change in it.
> If you mount a subvol rw, then the whole disk ro expectation is broken.
> Things will change even the whole
> disk is readonly.

This assumption seems wrong and untenable if considered from a
different angle: one doesn't mount the "whole disk" ro, merely the
default subvolume.

# mount -o ro /dev/sda1 /mnt

is merely convenient short-hand for

# mount -o ro,subvol=3D@ [or whatever] /dev/sda1 /mnt

and anyone who expects this to magically protect the whole disk is,
frankly, confused.

Substituting partitions for subvolumes: mounting /dev/sda2 read-only
should have no effect on /dev/sda3.
Even if you went a bit batty and decided to make /dev/sda2 the
"default partition":

# ln -sf /dev/sda2 /dev/sda
# mount -o ro /dev/sda /mnt/this/is/silly

syntactic sugar doesn't change anything.

Subvolumes are logically discrete entities, the fact that they share
trees on-disk is merely a (very nice) implementation detail. It is
impossible to mount a "whole disk" under btrfs.

Tobias

> The problem also happens when a parent subvol is mounted rw but child sub=
vol
> is mounted ro.
> User can still modify the child subvol through parent subvol, still broke
> the readonly rule.

This makes sense, though.
