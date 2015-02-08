Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f51.google.com ([209.85.215.51]:41302 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756634AbbBHXx1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 8 Feb 2015 18:53:27 -0500
Received: by labgf13 with SMTP id gf13so10286027lab.8
        for <linux-btrfs@vger.kernel.org>; Sun, 08 Feb 2015 15:53:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRy=Duyd9T5_rnPF06=a-fuqjhR=0yos0UtA1vm1r2v2A@mail.gmail.com>
References: <CANcfdL0x_LTSnyL1FP8vVV4=MaFrewT4pd0MZgu3qzxOviXDgg@mail.gmail.com>
 <CAJCQCtT+8+02KkYOcRUOhscj3AP0av8PpNmsK526hvJY=3ucRw@mail.gmail.com>
 <CANcfdL0twe-pi4f1ZVNG=m82gQTKc5QL3pcodY6diJ6uLj2Q9A@mail.gmail.com>
 <CAJCQCtSJ+kgxKb-gGnuOCFEVBsr2UP0aUWg_M60Ts_OQaSL8oQ@mail.gmail.com>
 <CANcfdL2aSfE5uwgwt1KYGRsucF_wTGSyEVT=LfX+COd2gywJ+A@mail.gmail.com>
 <CANcfdL3qEG8HPDzRE8z8rEuuBpkcbMF4ZjV0oQrH9sZ8FSpxXg@mail.gmail.com> <CAJCQCtRy=Duyd9T5_rnPF06=a-fuqjhR=0yos0UtA1vm1r2v2A@mail.gmail.com>
From: constantine <costas.magnuse@gmail.com>
Date: Sun, 8 Feb 2015 23:53:04 +0000
Message-ID: <CANcfdL0stL-8T2AGsJ_GcVKFDedSy38u9ESUUZ9Jk=ee0njJNQ@mail.gmail.com>
Subject: Re: Replacing a (or two?) failed drive(s) in RAID-1 btrfs filesystem
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I understood my mistake on using consumer drives and this is why I
bought the RED versions some days ago. I would have done this earlier
if I had the money.

So to sum up.

I have upgraded my btrfs-progs and I have mounted the filesystem with
# mount -o degraded /dev/sdi1 /mnt/mountpoint


I want to minimize my risk.

Now I should do
# btrfs device delete /dev/sdc1 ?
or
# btrfs check --repair --init-csum-tree ?


constantine


On Sun, Feb 8, 2015 at 11:34 PM, Chris Murphy <lists@colorremedies.com> wrote:
> On Sun, Feb 8, 2015 at 4:09 PM, constantine <costas.magnuse@gmail.com> wrote:
>> By the way, /dev/sdc just completed the extended offline test without
>> any error... I feel so confused,....
>
> First, we know from a number of studies, including the famous (and now
> kinda old) Google study that  a huge percent of drive failures come
> with no SMART errors.
>
> Second, SMART is only saying its internal test is good. The errors are
> related to data transfer, so that implicates the enclosure (bridge
> chipset or electronics), the cable, or the controller interface.
> Actually it could also be a flaky controller or RAM on the drive
> itself too which I don't think get checked with SMART tests.
>
> --
> Chris Murphy
