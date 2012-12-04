Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ia0-f174.google.com ([209.85.210.174]:37940 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545Ab2LDPH5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 4 Dec 2012 10:07:57 -0500
Received: by mail-ia0-f174.google.com with SMTP id y25so3122658iay.19
        for <linux-btrfs@vger.kernel.org>; Tue, 04 Dec 2012 07:07:56 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20121203120226.GD7289@carfax.org.uk>
References: <CAEx9m478rbpHCSSNsSv4yyOk3-yrAuSk0DQQ23X+iFWMocAhzg@mail.gmail.com>
 <20121202224635.GA7289@carfax.org.uk> <CAEx9m46ua1pQSUTeon6R0kBXoBq3iPxLtsrKjcXeafjT0Bor3Q@mail.gmail.com>
 <20121203120226.GD7289@carfax.org.uk>
From: Aastha Mehta <aasthakm@gmail.com>
Date: Tue, 4 Dec 2012 16:07:27 +0100
Message-ID: <CAEx9m454vU1W6h05Wi4nzVGPqvSbV3UQg_xB4rxm-+CK-im+bw@mail.gmail.com>
Subject: Re: basic questions regarding some btrfs features
To: Hugo Mills <hugo@carfax.org.uk>, Aastha Mehta <aasthakm@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks a lot for the explanation.

Regards,
Aastha.

On 3 December 2012 13:02, Hugo Mills <hugo@carfax.org.uk> wrote:
> On Mon, Dec 03, 2012 at 10:52:41AM +0100, Aastha Mehta wrote:
>> On 2 December 2012 23:46, Hugo Mills <hugo@carfax.org.uk> wrote:
>> > On Sun, Dec 02, 2012 at 11:17:26PM +0100, Aastha Mehta wrote:
>> >> I am looking at btrfs to understand some of its features. One of them
>> >> is the snapshot feature. Please tell me if my following understanding
>> >> about snapshots in btrfs is correct or not.
>> >>
>> >> Btrfs supports both readonly and writeable snapshots. Writeable
>> >> snapshots are like clone volumes (or subvolumes as in btrfs). We get a
>> >> point in time copy of the subvolume in both case.
>> >>
>> >> I looked through the kernel code and it seems that creating a
>> >> subvolume and taking a snapshot (readonly and writeable) all have a
>> >> common ioctl interface.
>> >>
>> >> What I am not completely clear about is whether snapshots get same
>> >> fsid as the source subvolume fsid or different.
>> >
>> >    Yes, it's the same UUID, because they're all part of the same
>> > filesystem.
>> >
>> Just to clarify, apart from UUID, is the FSID in the fs_info of the
>> root also same for all snapshots of a subvolume?
>>
>> >> Also, I do not understand what does it mean to be able to take
>> >> snapshot of a snapshot.
>> >
>> >    Snapshots are completely equal partners with their original
>> > subvolumes. This is not the case in, say, LVM.
>> >
>> >> What are benefits compared to say, being able to take snapshots only
>> >> of the active subvolume and not of the snapshots?
>> >
>> >    Let's say you take a snapshot (B) of your root filesystem (A). Then
>> > you decide to "roll back" to using the old version, so you mount B as
>> > root instead of A. Later that night, your backup process starts up and
>> > tries to take a temporary read-only snapshot (C) of your root
>> > filesystem (which is now B) so that it can make a stable backup.
>> > That's a snapshot of a snapshot.
>> >
>> Okay, but still the snapshot can be taken only for a subvolume in use.
>> Is that correct?
>
>    Well, it depends on what you mean by "in use". You can't snapshot
> something which doesn't appear somewhere in your directory hierarchy.
>
>> In your example, C is taken on B after file system
>> was rolled back to version B. What happens when the file system
>> version mounted is A (which contains snapshot B) and we take another
>> snapshot D on this mounted version. Does the snapshot D contain B or
>> only the active contents of A?
>
>    Snapshots are not recursive. If you have a subvolume inside another:
>
> subv1/subv2
>
> and then snapshot that
>
> # btrfs sub snap subv1 subv1-A
>
> you will end up with a subvolume subv1-A, containing an empty
> directory called subv2.
>
>    Note that you don't have to have subvolumes inside subvolumes at
> all, if you don't use the top level of your filesystem as anything
> other than a place to store and manage subvolumes.
>
>    Consider this btrfs filesystem layout:
>
> /               subvolid=5 (=0)
>     root        subvolid=256  (default subvol)
>     home        subvolid=257
>     snapshots   directory
>
> With this in fstab:
>
> /dev/sda        /                               btrfs   subvolid=256
> /dev/sda        /home                   btrfs   subvolid=257
> /dev/sda        /media/btrfs    btrfs   subvolid=5,noauto
>
> We get this filesystem hierarchy:
>
> /                 subvolid=256
>     home          subvolid=257
>     media         directory
>                 btrfs     subvolid=5
>
>    Note that the mount of the full filesystem on /media/btrfs isn't
> done automatically -- it only needs to be done when you're managing
> subvolumes.
>
>    So, we can take a snapshot of /, for example:
>
> # mount /media/btrfs
> # btrfs sub snap /media/btrfs/root /media/btrfs/snapshots/root.2012-12-03
> # umount /media/btrfs
>
> The FS (from its top level) now looks like this:
>
> /                           subvolid=5 (=0)
>     root                    subvolid=256  (default subvol)
>     home                    subvolid=257
>     snapshots               directory
>         root.2012-12-03     subvolid=258
>
> To "roll back" root temporarily to the earlier version, you can edit
> your boot manager's config to supply "subvolid=258" as a mount
> parameter. To do so permanently, you can set the default subvolume to
> 258, and optionally move the snapshot to /root within the btrfs
> filesystem:
>
> # mount /media/btrfs
> # mv /media/btrfs/root /media/btrfs/root.old
> # mv /media/btrfs/snapshots/root.2012-12-03 /media/btrfs/root
> # umount /media/btrfs
>
>    Hugo.
>
> --
> === Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
>   PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
>          --- I'm on a 30-day diet. So far I've lost 18 days. ---
