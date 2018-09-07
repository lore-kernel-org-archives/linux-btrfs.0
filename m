Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:44722 "EHLO
        mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728004AbeIGR3N (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Sep 2018 13:29:13 -0400
Received: by mail-oi0-f48.google.com with SMTP id l82-v6so26947994oih.11
        for <linux-btrfs@vger.kernel.org>; Fri, 07 Sep 2018 05:48:24 -0700 (PDT)
MIME-Version: 1.0
References: <e1371e79-f5d1-494b-a6ea-3d8d888bf1d3@gmail.com>
 <CAHTTHimFRYwZ9iiacP7vFVhCtTmcUVaik5fFEM0k0tG-Hvnmhw@mail.gmail.com>
 <CAJCQCtQHmk3ViUkynDhsb6_jCjpRHY6dSdZGiDZzg3k=XW9+-A@mail.gmail.com>
 <090f8da0-c29c-da5f-6e5b-ec6961706508@gmail.com> <CAJCQCtTHxM+Bx8akyV+QdYch=y6-0hCf_3r1KonPC2vKsujkxQ@mail.gmail.com>
 <d0223039-5c8f-38db-fe32-0b46b220e699@gmail.com> <CAJCQCtREREvzveNqdahGb8GN62_CJMyeL8GhjxnqmVZqxKiDUA@mail.gmail.com>
 <326f12a3-ee55-0812-5ea6-f54c0362a29b@gmail.com> <CAJCQCtS+ZXzGU0AE=C1iA7yNFrXuRAvZkhssxN40=jPd=x6neA@mail.gmail.com>
In-Reply-To: <CAJCQCtS+ZXzGU0AE=C1iA7yNFrXuRAvZkhssxN40=jPd=x6neA@mail.gmail.com>
From: Stefan Loewen <stefan.loewen@gmail.com>
Date: Fri, 7 Sep 2018 14:47:41 +0200
Message-ID: <CAHTTHimqg_wgqs0AXt73YzOv3ga7cAEUvbwMOVVT2JUVaNbsFQ@mail.gmail.com>
Subject: Re: btrfs send hung in pipe_wait
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Well... It seems it's not the hardware.
I ran a long SMART check which ran through without errors and
reallocation count is still 0.

So I used clonezilla (partclone.btrfs) to mirror the drive to another
drive (same model).
Everything copied over just fine. No I/O error im dmesg.

The new disk shows the same behavior.
So I created another subvolume, reflinked stuff over and found that it
is enough to reflink one file, create a read-only snapshot and try to
btrfs-send that. It's not happening with every file, but there are
definitely multiple different files. The one I tested with is a 3.8GB
ISO file.
Even better:
'btrfs send --no-data snap-one > /dev/null'
(snap-one containing just one iso file) hangs as well.
Still dmesg shows no IO errors, only "INFO: task btrfs-transacti:541
blocked for more than 120 seconds." with associated call trace.
btrfs-send reads some MB in the beginning, writes a few bytes and then
hangs without further IO.

copying the same file without --reflink, snapshotting and sending
works without problems.

I guess that pretty much eleminates bad sectors and points towards
some problem with reflinks / btrfs metadata.


Btw.: Thanks for taking that much time for helping me find the problem
here, Chris. Very much appreciated!
Am Fr., 7. Sep. 2018 um 05:29 Uhr schrieb Chris Murphy
<lists@colorremedies.com>:
>
> On Thu, Sep 6, 2018 at 2:16 PM, Stefan Loewen <stefan.loewen@gmail.com> wrote:
>
> > Data,single: Size:695.01GiB, Used:653.69GiB
> > /dev/sdb1     695.01GiB
> > Metadata,DUP: Size:4.00GiB, Used:2.25GiB
> > /dev/sdb1       8.00GiB
> > System,DUP: Size:40.00MiB, Used:96.00KiB
>
>
> > Does that mean Metadata is duplicated?
>
> Yes. Single copy for data. Duplicate for metadata+system, and there
> are no single chunks for metadata/system.
>
> >
> > Ok so to summarize and see if I understood you correctly:
> > There are bad sectors on disk. Running an extended selftest (smartctl -t
> > long) could find those and replace them with spare sectors.
>
> More likely if it finds a persistently failing sector, it will just
> record the first failing sector LBA in its log, and then abort. You'll
> see this info with 'smartctl -a' or with -x.
>
> It is possible to resume the test using selective option and picking a
> 4K aligned 512 byte LBA value after the 4K sector with the defect.
> Just because only one is reported in dmesg doesn't mean there isn't a
> bad one.
>
> It's unlikely the long test is going to actually fix anything, it'll
> just give you more ammunition for getting a likely under warranty
> device replaced because it really shouldn't have any issues at this
> age.
>
>
> > If it does not I can try calculating the physical (4K) sector number and
> > write to that to make the drive notice and mark the bad sector.
> > Is there a way to find out which file I will be writing to beforehand?
>
> I'm not sure how to do it easily.
>
> >Or is
> > it easier to just write to the sector and then wait for scrub to tell me
> > (and the sector is broken anyways)?
>
> If it's a persistent read error, then it's lost. So you might as well
> overwrite it. If it's data, scrub will tell you what file is corrupted
> (and restore can help you recover the whole file, of course it'll have
> a 4K hole of zeros in it). If it's metadata, Btrfs will fix up the 4K
> hole with duplicate metadata.
>
> Gotcha is to make certain you've got the right LBA to write to. You
> can use dd to test this, by reading the suspect bad sector, and if
> you've got the right one, you'll get an I/O error in user space and
> dmesg will have a message like before with sector value. Use the dd
> skip= flag for reading, but make *sure* you use seek= when writing
> *and* make sure you always use bs=4096 count=1 so that if you make a
> mistake you limit the damage haha.
>
> >
> > For the drive: Not under warranty anymore. It's an external HDD that I had
> > lying around for years, mostly unused. Now I wanted to use it as part of my
> > small DIY NAS.
>
> Gotcha. Well you can read up on smartctl and smartd, and set it up for
> regular extended tests, and keep an eye on rapidly changing values. It
> might give you a 50/50 chance of an early heads up before it dies.
>
> I've got an old Hitachi/Apple laptop drive that years ago developed
> multiple bad sectors in different zones of the drive. They got
> remapped and I haven't had a problem with that drive since. *shrug*
> And in fact I did get a discrete error message from the drive for one
> of those and Btrfs overwrote that bad sector with a good copy (it's in
> a raid1 volume), so working as designed I guess.
>
> Since you didn't get a fix up message from Btrfs, either the whole
> thing just got confused with hanging tasks, or it's possible it's a
> data block.
>
>
> --
> Chris Murphy
