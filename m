Return-Path: <SRS0=tjhn=M5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C820ECDE30
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Oct 2018 10:48:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1139A214C3
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Oct 2018 10:48:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TnqJcYus"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1139A214C3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726958AbeJQSna (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 17 Oct 2018 14:43:30 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:44099 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726868AbeJQSna (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 Oct 2018 14:43:30 -0400
Received: by mail-ot1-f66.google.com with SMTP id p23so25655373otf.11
        for <linux-btrfs@vger.kernel.org>; Wed, 17 Oct 2018 03:48:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=JFOfcf6BfT2HfbxdLKWTVUlzWyo17VgX85rz3Q1qVrM=;
        b=TnqJcYusSJ6e3SbOx5q3y8VpGgE8269JfpS+8y7j/vVTLGzvTdmI55iJI7xW9Zm070
         p9mnNvr5ABUSY3yM72COqfUFohmNLE0OufgUsBfW3XIc/ihRBprOD0Jfz36R7YWlHltW
         V701MvHmo12nEf6dOkG5C1xAYrTKkPTCh5WNLUMaF3LQrNuGwWRROU2y37oqk5rdF7ui
         wERdHsch7g+ABJsVq/CaD8+jKO5OiMWz6JOxYv10oDqVyC0bIAhbR3BnQpGZDSyXOYzk
         9MkjZF0P6nHZE1OPa+UUPn9EAohGlM67VdCVGORxPVqpi2lMDepjA+pgT2cJ94VHvK+F
         NMgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=JFOfcf6BfT2HfbxdLKWTVUlzWyo17VgX85rz3Q1qVrM=;
        b=YsZj5tmNI1dBjfz0y6RbiChAsQ5Rdnosxac8PwOGJKRUEWvZlb7UjcDqc/IJvePJRp
         ZzNz1TBjd1qW9u2onlDLhTIBfzJBeIvuKyHmhCJziqdqM66bCMs+P0Ad2k80/MhxjfsN
         kkePKnkNW8E0XNpmsu2zmwr5wx2nNCnvNxWkRHIGRmI1mGqNR7laQBwwK5HoMm9Dt+/R
         aeO0fLVyQj9VrVddpecxEmAfl7BGqo113wX/xZdgetzHK3qIlysso1ll+AYhYN5+zh4P
         FmEbIPkEllCbC1TbkAwBFNMGTQ+MtE9pLnlNC1/Tye0TR8hrQJJPEBEqytcvLx7gFCk3
         gnjA==
X-Gm-Message-State: ABuFfoje973jL1rEGyQ9o/Ko3vaIEoJJScewULAVktuBly06QMjSciOV
        9Mg52/F9oTm+P2hYnkHckx2f0nvnEHl7IqxXyQr8P3Oo0FU=
X-Google-Smtp-Source: ACcGV60pdgdVa0/QnXH4fuDZf6Vz4iUtcLTovC//4fEI/W4VOuesMaVVHkvpSCfUfFtnNUOGfpas3KEwr4jx5WIv/fM=
X-Received: by 2002:a9d:429a:: with SMTP id r26mr16990735ote.337.1539773302082;
 Wed, 17 Oct 2018 03:48:22 -0700 (PDT)
MIME-Version: 1.0
References: <3074900.XK8U9Revzq@libor-nb>
In-Reply-To: <3074900.XK8U9Revzq@libor-nb>
From:   Henk Slager <eye1tm@gmail.com>
Date:   Wed, 17 Oct 2018 12:48:11 +0200
Message-ID: <CAPmG0jZw4ezvGUvWM2wqtWWVcc+pQPN_HM_gFSU-+oqp83drkA@mail.gmail.com>
Subject: Re: btrfs send receive: No space left on device
To:     =?UTF-8?B?TGlib3IgS2xlcMOhxI0=?= <libor.klepac@bcom.cz>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Oct 17, 2018 at 10:29 AM Libor Klep=C3=A1=C4=8D <libor.klepac@bcom.=
cz> wrote:
>
> Hello,
> i have new 32GB SSD in my intel nuc, installed debian9 on it, using btrfs=
 as a rootfs.
> Then i created subvolumes /system and /home and moved system there.
>
> System was installed using kernel 4.9.x and filesystem created using btrf=
s-progs 4.7.x
> Details follow:
> main filesystem
>
> # btrfs filesystem usage /mnt/btrfs/ssd/
> Overall:
>     Device size:                  29.08GiB
>     Device allocated:              4.28GiB
>     Device unallocated:           24.80GiB
>     Device missing:                  0.00B
>     Used:                          2.54GiB
>     Free (estimated):             26.32GiB      (min: 26.32GiB)
>     Data ratio:                       1.00
>     Metadata ratio:                   1.00
>     Global reserve:               16.00MiB      (used: 0.00B)
>
> Data,single: Size:4.00GiB, Used:2.48GiB
>    /dev/sda3       4.00GiB
>
> Metadata,single: Size:256.00MiB, Used:61.05MiB
>    /dev/sda3     256.00MiB
>
> System,single: Size:32.00MiB, Used:16.00KiB
>    /dev/sda3      32.00MiB
>
> Unallocated:
>    /dev/sda3      24.80GiB
>
> #/etc/fstab
> UUID=3Dd801da52-813d-49da-bdda-87fc6363e0ac       /mnt/btrfs/ssd         =
 btrfs noatime,space_cache=3Dv2,compress=3Dlzo,commit=3D300,subvolid=3D5   =
      0       0
> UUID=3Dd801da52-813d-49da-bdda-87fc6363e0ac       /                      =
 btrfs   noatime,space_cache=3Dv2,compress=3Dlzo,commit=3D300,subvol=3D/sys=
tem         0       0
> UUID=3Dd801da52-813d-49da-bdda-87fc6363e0ac       /home                  =
 btrfs   noatime,space_cache=3Dv2,compress=3Dlzo,commit=3D300,subvol=3D/hom=
e         0       0
>
> -----
> Then i installed kernel from backports:
> 4.18.0-0.bpo.1-amd64 #1 SMP Debian 4.18.6-1~bpo9+1
> and btrfs-progs 4.17
>
> For backups , i have created 16GB iscsi device on my qnap and mounted it,=
 created filesystem, mounted like this:
> LABEL=3Dbackup                                    /mnt/btrfs/backup      =
 btrfs   noatime,space_cache=3Dv2,compress=3Dlzo,subvolid=3D5,nofail,noauto=
         0       0
>
> After send-receive operation on /home subvolume, usage looks like this:
>
> # btrfs filesystem usage /mnt/btrfs/backup/
> Overall:
>     Device size:                  16.00GiB
>     Device allocated:              1.27GiB
>     Device unallocated:           14.73GiB
>     Device missing:                  0.00B
>     Used:                        844.18MiB
>     Free (estimated):             14.92GiB      (min: 14.92GiB)
>     Data ratio:                       1.00
>     Metadata ratio:                   1.00
>     Global reserve:               16.00MiB      (used: 0.00B)
>
> Data,single: Size:1.01GiB, Used:833.36MiB
>    /dev/sdb        1.01GiB
>
> Metadata,single: Size:264.00MiB, Used:10.80MiB
>    /dev/sdb      264.00MiB
>
> System,single: Size:4.00MiB, Used:16.00KiB
>    /dev/sdb        4.00MiB
>
> Unallocated:
>    /dev/sdb       14.73GiB
>
>
> Problem is, during send-receive of system subvolume, it runs out of space=
:
>
> # btrbk run /mnt/btrfs/ssd/system/ -v
> btrbk command line client, version 0.26.1  (Wed Oct 17 09:51:20 2018)
> Using configuration: /etc/btrbk/btrbk.conf
> Using transaction log: /var/log/btrbk.log
> Creating subvolume snapshot for: /mnt/btrfs/ssd/system
> [snapshot] source: /mnt/btrfs/ssd/system
> [snapshot] target: /mnt/btrfs/ssd/_snapshots/system.20181017T0951
> Checking for missing backups of subvolume "/mnt/btrfs/ssd/system" in "/mn=
t/btrfs/backup/"
> Creating subvolume backup (send-receive) for: /mnt/btrfs/ssd/_snapshots/s=
ystem.20181016T2034
> No common parent subvolume present, creating full backup...
> [send/receive] source: /mnt/btrfs/ssd/_snapshots/system.20181016T2034
> [send/receive] target: /mnt/btrfs/backup/system.20181016T2034
> mbuffer: error: outputThread: error writing to <stdout> at offset 0x4b5bd=
000: Broken pipe
> mbuffer: warning: error during output to <stdout>: Broken pipe
> WARNING: [send/receive] (send=3D/mnt/btrfs/ssd/_snapshots/system.20181016=
T2034, receive=3D/mnt/btrfs/backup) At subvol /mnt/btrfs/ssd/_snapshots/sys=
tem.20181016T2034
> WARNING: [send/receive] (send=3D/mnt/btrfs/ssd/_snapshots/system.20181016=
T2034, receive=3D/mnt/btrfs/backup) At subvol system.20181016T2034
> ERROR: rename o77417-5519-0 -> lib/modules/4.18.0-0.bpo.1-amd64/kernel/dr=
ivers/watchdog/pcwd_pci.ko failed: No space left on device
> ERROR: Failed to send/receive btrfs subvolume: /mnt/btrfs/ssd/_snapshots/=
system.20181016T2034  -> /mnt/btrfs/backup
> [delete] options: commit-after
> [delete] target: /mnt/btrfs/backup/system.20181016T2034
> WARNING: Deleted partially received (garbled) subvolume: /mnt/btrfs/backu=
p/system.20181016T2034
> ERROR: Error while resuming backups, aborting
> Created 0/2 missing backups
> WARNING: Skipping cleanup of snapshots for subvolume "/mnt/btrfs/ssd/syst=
em", as at least one target aborted earlier
> Completed within: 116s  (Wed Oct 17 09:53:16 2018)
> -------------------------------------------------------------------------=
-------
> Backup Summary (btrbk command line client, version 0.26.1)
>
>     Date:   Wed Oct 17 09:51:20 2018
>     Config: /etc/btrbk/btrbk.conf
>     Filter: subvolume=3D/mnt/btrfs/ssd/system
>
> Legend:
>     =3D=3D=3D  up-to-date subvolume (source snapshot)
>     +++  created subvolume (source snapshot)
>     ---  deleted subvolume
>     ***  received subvolume (non-incremental)
>     >>>  received subvolume (incremental)
> -------------------------------------------------------------------------=
-------
> /mnt/btrfs/ssd/system
> +++ /mnt/btrfs/ssd/_snapshots/system.20181017T0951
> !!! /mnt/btrfs/backup/system.20181016T2034
> !!! Target "/mnt/btrfs/backup" aborted: Failed to send/receive subvolume
>
> NOTE: Some errors occurred, which may result in missing backups!
> Please check warning and error messages above.
> -----------------------------
>
> With compression=3Dnone or compression=3Dzlib , send-receive runs ok
I have seen similar behavior when doing a btrfs receive onto an
compression=3Dlzo or compression=3Dzstd mounted filesystem on an SD-card.
(I was cloning the rootfilesystem from an older SBC to a newly bought
one.) With multiple tries, I noticed that the receive process failed
at about the same point (a folder with .h-files), but not always the
same file. I think that some pipeline or queue overflow/failure at the
lower levels (maybe even below btrfs) causes this, but I have not
futher looked at it.

The workaround was to have the receiving filesystem first as a
loop-mounted sparse image on the laptop that I used for the cloning.
And then writing the image to the designated partition on the SD-card
with dd_rescue.

The laptop ran Opensuse Tumbleweed (about 2 weeks ago) with a snapshot
not older than 1 month. If needed, I can figure out in more detail
what kernel etc, but it was kernel 4.18.x and progs 4.17.x series.
