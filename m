Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f49.google.com ([209.85.218.49]:32867 "EHLO
	mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbcGMQ3D (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Jul 2016 12:29:03 -0400
Received: by mail-oi0-f49.google.com with SMTP id j185so71658570oih.0
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Jul 2016 09:29:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <49f1ec8e-1c39-d401-9ed3-73887de24c5e@rz.uni-freiburg.de>
References: <49f1ec8e-1c39-d401-9ed3-73887de24c5e@rz.uni-freiburg.de>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 13 Jul 2016 10:28:50 -0600
Message-ID: <CAJCQCtTOnnvDMoNOd6R1HCT555RTd9wvAcP3EokELygwSiobNw@mail.gmail.com>
Subject: Re: ERROR: ioctl(DEV_REPLACE_START) failed on "/mnt": Read-only file system
To: Tamas Baumgartner-Kis <Tamas.Baumgartner-Kis@rz.uni-freiburg.de>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 13, 2016 at 4:24 AM, Tamas Baumgartner-Kis
<Tamas.Baumgartner-Kis@rz.uni-freiburg.de> wrote:
> Hi Duncan,
>
> many many thanks for your nice explanation and pointing it out
> what could happened.
>
>> This reveals the problem.  You have single chunks in addition
>> to the raid1 chunks.  Current btrfs will refuse to mount
>> writable with a device missing in such a case, in ordered
>> to prevent further damage.
>
>
>> But meanwhile, while the above btrfs fi df reveals
>> the problem as we see it on the existing filesystem,
>> it says nothing about how it got that way.  Your
>> sequence above doesn't mention mounting the
>> degraded raid1 writable once, for it to create those
>> single-mode chunks that are now blocking writable
>> mount, but that's one way it could have happened.
>
>
> You're right, I booted first in to the installed system on the harddisk
> and ended up in the rescueshell because obviously the "degraded" option
> in the fstab is missing. So I mounted the harddisk manually with
> the "degraded" option. But after that I decided to do the repairing
> in a LiveSystem... I assume that is where the problem come from.
> Because in the LiveSystem I wasn't able to mount the harddisk only
> with the degraded option.
>
> So as you mentioned either you fix the missing harddisk during the
> running of the System or after that you have one shot (for example in
> a LiveSystem), otherwise you have to copy from the readonly mounted
> harddisk.
>
>> Another way would be if the balance-conversion from
>> single mode to raid1 never properly completed in the
>> first place.  But I'm assuming it did and that you
>> had a full raid1 btrfs fi df report at one point.
>
>> A third way would be if some other bug triggered
>> btrfs to suddenly start writing single mode
>> chunks.  There were some bugs like that in the
>> past, but they've been fixed for some time.  But
>> perhaps there are similar newer bugs, or perhaps
>> you ran the filesystem on an old kernel with
>> that bug.


Yeah I've run into this several times.

The particularly vicious scenario is Drive A goes offline or is
unavailable, and Drive B is mounted degraded, silently gets single
chunks to which data is written, and then Drive A is replaced but
these single chunks still exist only on Drive B. If Drive B dies, you
have data loss, for a volume that is ostensibly raid 1.

The flaw is the allocation of single chunks when degraded, it should
write only into raid1 chunks, existing or newly allocated. It's data
loss waiting to happen.


-- 
Chris Murphy
