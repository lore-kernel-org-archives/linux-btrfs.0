Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f171.google.com ([209.85.220.171]:36021 "EHLO
        mail-qk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751226AbdH1HTm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 28 Aug 2017 03:19:42 -0400
Received: by mail-qk0-f171.google.com with SMTP id o63so21838732qkb.3
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Aug 2017 00:19:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170826161524.xz5xylimnqfucdte@angband.pl>
References: <CAP9W88g3Pr=JYqj=QOKpeP=6uKaQkXsx9xegefeJsZ+wApiZ9g@mail.gmail.com>
 <7e12fa55-d01a-6c02-f798-2b63cf3b4a6d@jp.fujitsu.com> <CAP9W88gfFUj3QBjmztDjYamR9MKSh7Gsv66X7vJ-M9FNq3F=eA@mail.gmail.com>
 <pan$e34b7$dc9b9508$835301e3$9a80c4d6@cox.net> <20170826161524.xz5xylimnqfucdte@angband.pl>
From: shally verma <shallyvermacavium@gmail.com>
Date: Mon, 28 Aug 2017 12:49:10 +0530
Message-ID: <CAP9W88geH+nqhjb=qRkU2WSfXG0x9dz-O_6QC-zfdc31UQ3-CA@mail.gmail.com>
Subject: Re: status of inline deduplication in btrfs
To: Adam Borowski <kilobyte@angband.pl>
Cc: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Aug 26, 2017 at 9:45 PM, Adam Borowski <kilobyte@angband.pl> wrote:
> On Sat, Aug 26, 2017 at 01:36:35AM +0000, Duncan wrote:
>> The second has to do with btrfs scaling issues due to reflinking, which
>> of course is the operational mechanism for both snapshotting and dedup.
>> Snapshotting of course reflinks the entire subvolume, so it's reflinking
>> on a /massive/ scale.  While normal file operations aren't affected much,
>> btrfs maintenance operations such as balance and check scale badly enough
>> with snapshotting (due to the reflinking) that keeping the number of
>> snapshots per subvolume under 250 or so is strongly recommended, and
>> keeping them to double-digits or even single-digits is recommended if
>> possible.
>>
>> Dedup works by reflinking as well, but its effect on btrfs maintenance
>> will be far more variable, depending of course on how effective the
>> deduping, and thus the reflinking, is.  But considering that snapshotting
>> is effectively 100% effective deduping of the entire subvolume (until the
>> snapshot and active copy begin to diverge, at least), that tends to be
>> the worst case, so figuring a full two-copy dedup as equivalent to one
>> snapshot is a reasonable estimate of effect.  If dedup only catches 10%,
>> only once, than it would be 10% of a snapshot's effect.  If it's 10% but
>> there's 10 duplicated instances, that's the effect of a single snapshot.
>> Assuming of course that the dedup domain is the same as the subvolume
>> that's being snapshotted.

This looks to me a debate between using inline dedup Vs snapshotting
or more precisely, doing a dedupe via snapshots?
Did I understand it correct? if yes, does it mean people are still in
thoughts if current design and proposal to inline dedup
is right way to go for?

>
> Nope, snapshotting is not anywhere near the worst case of dedup:
>
> [/]$ find /bin /sbin /lib /usr /var -type f -exec md5sum '{}' +|
> cut -d' ' -f1|sort|uniq -c|sort -nr|head
>
> Even on the system parts (ie, ignoring my data) of my desktop, top files
> have the following dup counts: 532 384 373 164 123 122 101.  On this small
> SSD, the system parts are reflinked by snapshots with 10 dailies, and by
> deduping with 10 regular chroots, 11 sbuild chroots and 3 full-system lxc
> containers (chroots are mostly a zoo of different architectures).
>
> This is nothing compared to the backup server, which stores backups of 46
> machines (only system/user and small data, bulky stuff is backed up
> elsewhere), 24 snapshots each (a mix of dailies, 1/11/21, monthlies and
> yearly).  This worked well enough until I made the mistake of deduping the
> whole thing.
>
> But, this is still not the worst horror imaginable.  I'd recommend using
> whole-file dedup only as this avoids this pitfall: take two VM images, run
> block dedup on them.  Identical blocks in them will be cross-reflinked.  And
> there's _many_.  The vast majority of duplicate blocks are all-zero: I just
> ran fallocate -d on a 40G win10 VM and it shrank to 19G.  AFAIK
> file_extent_same is not yet smart enough to dedupe them to a hole instead.
>

Am bit confused over here, is your description based on offline-dedupe
here Or its with inline deduplication?

Thanks
Shally

>
> Meow!
> --
> ⢀⣴⠾⠻⢶⣦⠀
> ⣾⠁⢰⠒⠀⣿⡁ Vat kind uf sufficiently advanced technology iz dis!?
> ⢿⡄⠘⠷⠚⠋⠀                                 -- Genghis Ht'rok'din
> ⠈⠳⣄⠀⠀⠀⠀
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
