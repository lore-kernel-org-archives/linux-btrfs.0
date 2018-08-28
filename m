Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua1-f53.google.com ([209.85.222.53]:45029 "EHLO
        mail-ua1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727101AbeH1Wnx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Aug 2018 18:43:53 -0400
Received: by mail-ua1-f53.google.com with SMTP id m11-v6so1661416uao.11
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Aug 2018 11:50:55 -0700 (PDT)
MIME-Version: 1.0
References: <CAN4oSBdfDVGmG8L2vS9h9McEs5aSuP5RfTGREB2ZhGwmAg4JhA@mail.gmail.com>
 <CAJCQCtSq5K90gpfGQN8JhqQddBg62m8EG_bFuWN5XyzdNStDfw@mail.gmail.com>
 <CAN4oSBeHwnsm5Ecz1hAQLk6s6utHfn5XeR8xMhnZpmT-sb-_iw@mail.gmail.com>
 <CAJCQCtQ=CiB5cY8RL4tzps21d=umjzNM=BKjdUBCc7WiP0QF9A@mail.gmail.com>
 <CAJCQCtSGV1gz66X9BJAJosuhMTvd2=Me-X2tVDwJ0Eg9PA7BPA@mail.gmail.com>
 <CAN4oSBfAS75x7+D2Ms93NGB5H5MG-AOR5mHg2czGCECg6api3Q@mail.gmail.com> <CAJCQCtT3PrcFwFq3oAyPyQTNBRdSjevFEE7V5_AoKD6hEDgvyA@mail.gmail.com>
In-Reply-To: <CAJCQCtT3PrcFwFq3oAyPyQTNBRdSjevFEE7V5_AoKD6hEDgvyA@mail.gmail.com>
From: Cerem Cem ASLAN <ceremcem@ceremcem.net>
Date: Tue, 28 Aug 2018 21:50:43 +0300
Message-ID: <CAN4oSBdLEXS8DzZ+8Y-z5BxSe_7EUsA4ZEp4OAhWOhhZMwkM=w@mail.gmail.com>
Subject: Re: DRDY errors are not consistent with scrub results
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've successfully moved everything to another disk. (The only hard
part was configuring the kernel parameters, as my root partition was
on LVM which is on LUKS partition. Here are the notes, if anyone
needs: https://github.com/ceremcem/smith-sync/blob/master/create-bootable-backup.md)

Now I'm seekin for trouble :) I tried to convert my new system (booted
with new disk) into raid1 coupled with the problematic old disk. To do
so, I issued:

sudo btrfs device add /dev/mapper/master-root /mnt/peynir/
/dev/mapper/master-root appears to contain an existing filesystem (btrfs).
ERROR: use the -f option to force overwrite of /dev/mapper/master-root
aea@aea3:/mnt$ sudo btrfs device add /dev/mapper/master-root /mnt/peynir/ -f
ERROR: error adding device '/dev/mapper/master-root': Input/output error
aea@aea3:/mnt$ sudo btrfs device add /dev/mapper/master-root /mnt/peynir/
sudo: unable to open /var/lib/sudo/ts/aea: Read-only file system

Now I ended up with a readonly file system. Isn't it possible to add a
device to a running system?

Chris Murphy <lists@colorremedies.com>, 28 Ağu 2018 Sal, 04:08
tarihinde şunu yazdı:
>
> On Mon, Aug 27, 2018 at 6:49 PM, Cerem Cem ASLAN <ceremcem@ceremcem.net> wrote:
> > Thanks for your guidance, I'll get the device replaced first thing in
> > the morning.
> >
> > Here is balance results which I think resulted not too bad:
> >
> > sudo btrfs balance start /mnt/peynir/
> > WARNING:
> >
> >         Full balance without filters requested. This operation is very
> >         intense and takes potentially very long. It is recommended to
> >         use the balance filters to narrow down the balanced data.
> >         Use 'btrfs balance start --full-balance' option to skip this
> >         warning. The operation will start in 10 seconds.
> >         Use Ctrl-C to stop it.
> > 10 9 8 7 6 5 4 3 2 1
> > Starting balance without any filters.
> > Done, had to relocate 18 out of 18 chunks
> >
> > I suppose this means I've not lost any data, but I'm very prone to due
> > to previous `smartctl ...` results.
>
>
> OK so nothing fatal anyway. We'd have to see any kernel messages that
> appeared during the balance to see if there were read or write errors,
> but presumably any failure means the balance fails so... might get you
> by for a while actually.
>
>
>
>
>
>
>
> --
> Chris Murphy
