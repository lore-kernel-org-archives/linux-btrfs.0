Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f50.google.com ([209.85.213.50]:34761 "EHLO
        mail-vk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727067AbeH2C6t (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Aug 2018 22:58:49 -0400
Received: by mail-vk0-f50.google.com with SMTP id l143-v6so1644263vke.1
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Aug 2018 16:04:57 -0700 (PDT)
MIME-Version: 1.0
References: <CAN4oSBdfDVGmG8L2vS9h9McEs5aSuP5RfTGREB2ZhGwmAg4JhA@mail.gmail.com>
 <CAJCQCtSq5K90gpfGQN8JhqQddBg62m8EG_bFuWN5XyzdNStDfw@mail.gmail.com>
 <CAN4oSBeHwnsm5Ecz1hAQLk6s6utHfn5XeR8xMhnZpmT-sb-_iw@mail.gmail.com>
 <CAJCQCtQ=CiB5cY8RL4tzps21d=umjzNM=BKjdUBCc7WiP0QF9A@mail.gmail.com>
 <CAJCQCtSGV1gz66X9BJAJosuhMTvd2=Me-X2tVDwJ0Eg9PA7BPA@mail.gmail.com>
 <CAN4oSBfAS75x7+D2Ms93NGB5H5MG-AOR5mHg2czGCECg6api3Q@mail.gmail.com>
 <CAJCQCtT3PrcFwFq3oAyPyQTNBRdSjevFEE7V5_AoKD6hEDgvyA@mail.gmail.com>
 <CAN4oSBdLEXS8DzZ+8Y-z5BxSe_7EUsA4ZEp4OAhWOhhZMwkM=w@mail.gmail.com> <CAJCQCtRPxtqqfCE_fRwzbfFAFMHCdO34T+riXQfd6-=BJX37SQ@mail.gmail.com>
In-Reply-To: <CAJCQCtRPxtqqfCE_fRwzbfFAFMHCdO34T+riXQfd6-=BJX37SQ@mail.gmail.com>
From: Cerem Cem ASLAN <ceremcem@ceremcem.net>
Date: Wed, 29 Aug 2018 02:04:44 +0300
Message-ID: <CAN4oSBezSLqwLaYu-OPrgomcK-RnaJhkukMoun=8JKQbMfqSWA@mail.gmail.com>
Subject: Re: DRDY errors are not consistent with scrub results
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

What I want to achive is that I want to add the problematic disk as
raid1 and see how/when it fails and how BTRFS recovers these fails.
While the party goes on, the main system shouldn't be interrupted
since this is a production system. For example, I would never expect
to be ended up with such a readonly state while trying to add a disk
with "unknown health" to the system. Was it somewhat expected?

Although we know that disk is about to fail, it still survives.
Shouldn't we expect in such a scenario that when system tries to read
or write some data from/to that BROKEN_DISK and when it recognizes it
failed, it will try to recover the part of the data from GOOD_DISK and
try to store that recovered data in some other part of the
BROKEN_DISK? Or did I misunderstood the whole thing?
Chris Murphy <lists@colorremedies.com>, 29 Ağu 2018 Çar, 00:07
tarihinde şunu yazdı:
>
> On Tue, Aug 28, 2018 at 12:50 PM, Cerem Cem ASLAN <ceremcem@ceremcem.net> wrote:
> > I've successfully moved everything to another disk. (The only hard
> > part was configuring the kernel parameters, as my root partition was
> > on LVM which is on LUKS partition. Here are the notes, if anyone
> > needs: https://github.com/ceremcem/smith-sync/blob/master/create-bootable-backup.md)
> >
> > Now I'm seekin for trouble :) I tried to convert my new system (booted
> > with new disk) into raid1 coupled with the problematic old disk. To do
> > so, I issued:
> >
> > sudo btrfs device add /dev/mapper/master-root /mnt/peynir/
> > /dev/mapper/master-root appears to contain an existing filesystem (btrfs).
> > ERROR: use the -f option to force overwrite of /dev/mapper/master-root
> > aea@aea3:/mnt$ sudo btrfs device add /dev/mapper/master-root /mnt/peynir/ -f
> > ERROR: error adding device '/dev/mapper/master-root': Input/output error
> > aea@aea3:/mnt$ sudo btrfs device add /dev/mapper/master-root /mnt/peynir/
> > sudo: unable to open /var/lib/sudo/ts/aea: Read-only file system
> >
> > Now I ended up with a readonly file system. Isn't it possible to add a
> > device to a running system?
>
> Yes.
>
> The problem is the 2nd error message:
>
> ERROR: error adding device '/dev/mapper/master-root': Input/output error
>
> So you need to look in dmesg to see what Btrfs kernel messages
> occurred at that time. I'm gonna guess it's a failed write. You have a
> few of those in the smartctl log output. Any time a write failure
> happens, the operation is always fatal regardless of the file system.
>
>
>
> --
> Chris Murphy
