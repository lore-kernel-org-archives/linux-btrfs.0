Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yh0-f50.google.com ([209.85.213.50]:38926 "EHLO
	mail-yh0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756179AbbBIAbU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 8 Feb 2015 19:31:20 -0500
Received: by mail-yh0-f50.google.com with SMTP id a41so6193148yho.9
        for <linux-btrfs@vger.kernel.org>; Sun, 08 Feb 2015 16:31:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CANcfdL0stL-8T2AGsJ_GcVKFDedSy38u9ESUUZ9Jk=ee0njJNQ@mail.gmail.com>
References: <CANcfdL0x_LTSnyL1FP8vVV4=MaFrewT4pd0MZgu3qzxOviXDgg@mail.gmail.com>
	<CAJCQCtT+8+02KkYOcRUOhscj3AP0av8PpNmsK526hvJY=3ucRw@mail.gmail.com>
	<CANcfdL0twe-pi4f1ZVNG=m82gQTKc5QL3pcodY6diJ6uLj2Q9A@mail.gmail.com>
	<CAJCQCtSJ+kgxKb-gGnuOCFEVBsr2UP0aUWg_M60Ts_OQaSL8oQ@mail.gmail.com>
	<CANcfdL2aSfE5uwgwt1KYGRsucF_wTGSyEVT=LfX+COd2gywJ+A@mail.gmail.com>
	<CANcfdL3qEG8HPDzRE8z8rEuuBpkcbMF4ZjV0oQrH9sZ8FSpxXg@mail.gmail.com>
	<CAJCQCtRy=Duyd9T5_rnPF06=a-fuqjhR=0yos0UtA1vm1r2v2A@mail.gmail.com>
	<CANcfdL0stL-8T2AGsJ_GcVKFDedSy38u9ESUUZ9Jk=ee0njJNQ@mail.gmail.com>
Date: Sun, 8 Feb 2015 17:31:19 -0700
Message-ID: <CAJCQCtSBBY0q5oQwOwtBG8m9w5zinnNn_aPYQPL2bUCtU2++TA@mail.gmail.com>
Subject: Re: Replacing a (or two?) failed drive(s) in RAID-1 btrfs filesystem
From: Chris Murphy <lists@colorremedies.com>
To: constantine <costas.magnuse@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Feb 8, 2015 at 4:53 PM, constantine <costas.magnuse@gmail.com> wrote:
> I understood my mistake on using consumer drives and this is why I
> bought the RED versions some days ago. I would have done this earlier
> if I had the money.

You need to raise the SCSI command timer value for the drives that
don't support SCT ERC. That way the kernel won't reset the link when
the drive hangs on a read error; this will allow the drive to report
the read error and allow Btrfs to fix the problem. If you don't do
this, long recover problems on these drives simply get worse until
there'd data loss. And as far as I know, Btrfs doesn't create another
copy in such a case.


> So to sum up.
>
> I have upgraded my btrfs-progs and I have mounted the filesystem with
> # mount -o degraded /dev/sdi1 /mnt/mountpoint
>
>
> I want to minimize my risk.

Backup the fking volume first. And whatever files don't backup, you
have to use btrfs restore on them if you ever want to retrieve them.

>
> Now I should do
> # btrfs device delete /dev/sdc1 ?
> or
> # btrfs check --repair --init-csum-tree ?

Try the first one. Just realize that any data that's on both the
failed drive and sdc1 will be lost, which is why you must have a
backup or use btrfs restore to start out. There is no way to re-add
sdc1 once you remove it.

-- 
Chris Murphy
