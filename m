Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:45789 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723AbaKQHfu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Nov 2014 02:35:50 -0500
Received: by mail-wg0-f46.google.com with SMTP id x13so24207411wgg.33
        for <linux-btrfs@vger.kernel.org>; Sun, 16 Nov 2014 23:35:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <54699CC7.1050909@swiftspirit.co.za>
References: <CAE8gLhnLUBJmN=3n1SVTc3y0zbBAxSBXtMxe7rhANtwC+3dCow@mail.gmail.com>
	<pan$f02e0$7a5e2052$d1925753$4ad202f9@cox.net>
	<54699CC7.1050909@swiftspirit.co.za>
Date: Mon, 17 Nov 2014 16:35:48 +0900
Message-ID: <CAGC3nLDFYQpc+VGF2K5HLLiNr6TgSoxO0ES9cS581dnvRLNkBg@mail.gmail.com>
Subject: Re: BTRFS messes up snapshot LV with origin
From: Daniel Dressler <danieru.dressler@gmail.com>
To: Brendan Hide <brendan@swiftspirit.co.za>
Cc: "open list:BTRFS FILE SYSTEM" <linux-btrfs@vger.kernel.org>,
        bug-grub@gnu.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If a UUID is not unique enough how will adding a second UUID or
"unique drive identifier" help?

A UUID only serves any purpose when it is unique. Thus duplicate UUIDs
are themselves a failure state.

The solution should be to make it harder to get into this failure
state. Not to make all programs resilient against running under this
failure state. It isn't a btrfs bug that it requires Universal Unique
IDs to be universally unique.

Daniel

2014-11-17 15:59 GMT+09:00 Brendan Hide <brendan@swiftspirit.co.za>:
> cc'd bug-grub@gnu.org for FYI
>
> On 2014/11/17 03:42, Duncan wrote:
>>
>> MegaBrutal posted on Sun, 16 Nov 2014 22:35:26 +0100 as excerpted:
>>
>>> Hello guys,
>>>
>>> I think you'll like this...
>>> https://bugs.launchpad.net/ubuntu/+source/grub2/+bug/1391429
>>
>> UUID is an initialism for "Universally Unique IDentifier".[1]
>>
>> If the UUID isn't unique, by definition, then, it can't be a UUID, and
>> that's a bug in whatever is making the non-unique would-be UUID that
>> isn't unique and thus cannot be a universally unique ID.  In this case
>> that would appear to be LVM.
>
> Perhaps the right question to ask is "Where should this bug be fixed?".
>
> TL;DR: This needs more thought and input from btrfs devs. To LVM, the bug is
> likely seen as being "out of scope". The "correct" fix probably lies in the
> ecosystem design, which requires co-operation from btrfs.
>
> Making a snapshot in LVM is a fundamental thing - and I feel LVM, in making
> its snapshot, is doing its job "exactly as expected".
>
> Additionally, there are other ways to get to a similar state without LVM:
> ddrescue backup, SAN snapshot, old "missing" disk re-introduced, etc.
>
> That leaves two places where this can be fixed: grub and btrfs
>
> Grub is already a little smart here - it avoids snapshots. But in this case
> it is relying on the UUID and only finding it in the snapshot. So possibly
> this is a bug in grub affecting the bug reporter specifically - but perhaps
> the bug is in btrfs where grub is relying on btrfs code.
>
> Yes, I'd rather use btrfs' snapshot mechanism - but this is often a choice
> that is left to the user/admin/distro. I don't think saying "LVM snapshots
> are incompatible with btrfs" is the right way to go either.
>
> That leaves two aspects of this issue which I view as two separate bugs:
> a) Btrfs cannot gracefully handle separate filesystems that have the same
> UUID. At all.
> b) Grub appears to pick the wrong filesystem when presented with two
> filesystems with the same UUID.
>
> I feel a) is a btrfs bug.
> I feel b) is a bug that is more about "ecosystem design" than grub being
> silly.
>
> I imagine a couple of aspects that could help fix a):
> - Utilise a "unique drive identifier" in the btrfs metadata (surely this
> exists already?). This way, any two filesystems will always have different
> drive identifiers *except* in cases like a ddrescue'd copy or a block-level
> snapshot. This will provide a sensible mechanism for "defined behaviour",
> preventing corruption - even if that "defined behaviour" is to simply give
> out lots of "PEBKAC" errors and panic.
> - Utilise a "drive list" to ensure that two unrelated filesystems with the
> same UUID cannot get "mixed up". Yes, the user/admin would likely be the
> culprit here (perhaps a VM rollout process that always gives out the same
> UUID in all its filesystems). Again, does btrfs not already have something
> like this built-in that we're simply not utilising fully?
>
> I'm not exactly sure of the "correct" way to fix b) except that I imagine it
> would be trivial to fix once a) is fixed.
>
> --
> __________
> Brendan Hide
> http://swiftspirit.co.za/
> http://www.webafrica.co.za/?AFF1E97
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
