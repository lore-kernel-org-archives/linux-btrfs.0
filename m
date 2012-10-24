Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:43205 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933474Ab2JXKNL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Oct 2012 06:13:11 -0400
Received: by mail-pa0-f46.google.com with SMTP id hz1so265110pad.19
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Oct 2012 03:13:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5087BCEB.8070303@cn.fujitsu.com>
References: <50853089.6010801@cn.fujitsu.com>
	<CAE5mzvhaQLZEMgyAPGZ7pFbNR9c17ke1FGRXUfY86vD31_3viQ@mail.gmail.com>
	<5087BCEB.8070303@cn.fujitsu.com>
Date: Wed, 24 Oct 2012 04:13:11 -0600
Message-ID: <CAE5mzviYi-txm=6sBapqB2jXWVYbF2-mQ6O0xWpM_vhKe-OVzw@mail.gmail.com>
Subject: Re: [PATCH 2/2] Btrfs: do not delete a subvolume which is in a R/O subvolume
From: cwillu <cwillu@cwillu.com>
To: miaox@cn.fujitsu.com
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 24, 2012 at 4:03 AM, Miao Xie <miaox@cn.fujitsu.com> wrote:
> On Mon, 22 Oct 2012 05:57:12 -0600, cwillu wrote:
>> On Mon, Oct 22, 2012 at 5:39 AM, Miao Xie <miaox@cn.fujitsu.com> wrote:
>>> Step to reproduce:
>>>  # mkfs.btrfs <disk>
>>>  # mount <disk> <mnt>
>>>  # btrfs sub create <mnt>/subv0
>>>  # btrfs sub snap <mnt> <mnt>/subv0/snap0
>>>  # change <mnt>/subv0 from R/W to R/O
>>>  # btrfs sub del <mnt>/subv0/snap0
>>>
>>> We deleted the snapshot successfully. I think we should not be able to delete
>>> the snapshot since the parent subvolume is R/O.
>>
>> snap0 isn't read-only in that case, right?  From a user interaction
>> standpoint, this seems like it just forces a user to rm -rf rather
>> btrfs sub del, which strikes me as a bit ham-handed when all we really
>> care about is leaving a (the?) directory entry where snap0 used to be.
>>
>
> I don't think we can identify "btrfs sub del" with "rm -rf", because "rm -rf"
> will check the permission of the parent directory of each file/directory which
> is going to be deleted, but "btrfs sub del" doesn't do it, it will see all the
> file/directory in the subvolume as one, so I think it seems like a special
> "rmdir". From this standpoint, deleting a snapshot whose parent subvolume
> is readonly should be forbidden.

Sorry; reading back, I misunderstood you to mean that subv0 was marked
as a readonly subvolume, as opposed to marking the mountpoint
readonly.  The former can't work at all (it would make the pair
undeletable, as the subv0 can't be deleted while it contains another
subvolume).

I'm still not sure that the latter is quite right, but I care a lot
less as one could always remount it rw (unlike ro subvolumes, as I
understand them).
