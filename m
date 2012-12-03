Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:55377 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322Ab2LCJxB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Dec 2012 04:53:01 -0500
Received: by mail-ob0-f174.google.com with SMTP id ta14so2249432obb.19
        for <linux-btrfs@vger.kernel.org>; Mon, 03 Dec 2012 01:53:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20121202224635.GA7289@carfax.org.uk>
References: <CAEx9m478rbpHCSSNsSv4yyOk3-yrAuSk0DQQ23X+iFWMocAhzg@mail.gmail.com>
 <20121202224635.GA7289@carfax.org.uk>
From: Aastha Mehta <aasthakm@gmail.com>
Date: Mon, 3 Dec 2012 10:52:41 +0100
Message-ID: <CAEx9m46ua1pQSUTeon6R0kBXoBq3iPxLtsrKjcXeafjT0Bor3Q@mail.gmail.com>
Subject: Re: basic questions regarding some btrfs features
To: Hugo Mills <hugo@carfax.org.uk>, Aastha Mehta <aasthakm@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

Thank you so much for your prompt response. Few more questions inline.

On 2 December 2012 23:46, Hugo Mills <hugo@carfax.org.uk> wrote:
> On Sun, Dec 02, 2012 at 11:17:26PM +0100, Aastha Mehta wrote:
>> I am looking at btrfs to understand some of its features. One of them
>> is the snapshot feature. Please tell me if my following understanding
>> about snapshots in btrfs is correct or not.
>>
>> Btrfs supports both readonly and writeable snapshots. Writeable
>> snapshots are like clone volumes (or subvolumes as in btrfs). We get a
>> point in time copy of the subvolume in both case.
>>
>> I looked through the kernel code and it seems that creating a
>> subvolume and taking a snapshot (readonly and writeable) all have a
>> common ioctl interface.
>>
>> What I am not completely clear about is whether snapshots get same
>> fsid as the source subvolume fsid or different.
>
>    Yes, it's the same UUID, because they're all part of the same
> filesystem.
>
Just to clarify, apart from UUID, is the FSID in the fs_info of the
root also same for all snapshots of a subvolume?

>> Also, I do not understand what does it mean to be able to take
>> snapshot of a snapshot.
>
>    Snapshots are completely equal partners with their original
> subvolumes. This is not the case in, say, LVM.
>
>> What are benefits compared to say, being able to take snapshots only
>> of the active subvolume and not of the snapshots?
>
>    Let's say you take a snapshot (B) of your root filesystem (A). Then
> you decide to "roll back" to using the old version, so you mount B as
> root instead of A. Later that night, your backup process starts up and
> tries to take a temporary read-only snapshot (C) of your root
> filesystem (which is now B) so that it can make a stable backup.
> That's a snapshot of a snapshot.
>
Okay, but still the snapshot can be taken only for a subvolume in use.
Is that correct? In your example, C is taken on B after file system
was rolled back to version B. What happens when the file system
version mounted is A (which contains snapshot B) and we take another
snapshot D on this mounted version. Does the snapshot D contain B or
only the active contents of A?

>> Probably before that, I need to get some clarity on why does a
>> subvolume always belong in the directory of some parent subvolume. Is
>> it possible to have more than one root subvolumes or more than one
>> subvolumes in the same parent subvolume directory?
>
>    No, there's precisely one top-level subvolume (subvolid=5).
> Everything else in the filesystem lives within that. However, you can
> have as many subvolumes as you like below that, and in whatever
> directories or subvolumes you want.
>
>    Hugo.
>
> --
> === Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
>   PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
>            --- Quidquid latine dictum sit,  altum videtur. ---


Thanks again,
Aastha.
