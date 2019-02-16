Return-Path: <SRS0=6oD6=QX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FDFBC43381
	for <linux-btrfs@archiver.kernel.org>; Sat, 16 Feb 2019 00:03:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4FE7620818
	for <linux-btrfs@archiver.kernel.org>; Sat, 16 Feb 2019 00:03:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="dRAPELeu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389938AbfBPAD5 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 15 Feb 2019 19:03:57 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:40770 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387546AbfBPAD5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Feb 2019 19:03:57 -0500
Received: by mail-lf1-f68.google.com with SMTP id t14so8436838lfk.7
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Feb 2019 16:03:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ESx9dgIekB5P5nQv5TGBk4laWTHflNQJqtVFSQ+ypgk=;
        b=dRAPELeuKwyObpndLB5lAceBZjjel7FgbTDeMrHgVOvRR2K77lMwmIds/GA8uh2Dff
         stVhQ4iDqeyuR1c2yguDmX6H2gpW6TFT1MatAZV/vR+ub9nXKpYcZZS0CtddsMPItK0p
         IZeJbobNZteV5gDqul8tsOigCYmMVTvp2oM5NYChOBaPj/BLGDLh8/Wi3o8QC6RcYJ/l
         x3RzcOyOYCveZeX/F3M3xeWzvOF/FO2GcJcaK2On/4yw8pS9UIgGbhE97VbsPQSXDDNO
         7IKKE3OoaCS38iLNT2nMi1qAeem7f3cg/jKIJqxx5z5kMc3hOuvXIxJ1ZGGeOZMLhtF6
         fLIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ESx9dgIekB5P5nQv5TGBk4laWTHflNQJqtVFSQ+ypgk=;
        b=DclHoHblWNABSCM5mcnfCMDGDrJQVt3o/a1cu08OGLd8NmNYStZPE5jFIdOS1qDKt6
         LOi9tB0SNaKafr36HimVPEqMrVt2wtlZQ0+2ZI9VZvWvL0Gr+M5s2Hr8S1hikbKqZFr0
         6J1YIUv9wymI/n64D39jCOlxAy/Kmz10pJ7m2gVF0jUp+XaOCVTt6SCV+CWTmwVUJo2w
         NoHyb8/moTPWRwiGqBC+v7PsDkhk03enMjEvbhdFAnwoS8ozDO+cwIJ56KF8r6AVuozo
         DO73vHdzTumrdph7mOu+NUC8NBePz3Lxul9MJoj3CB7lvRB7I2+lZVmu1jMqIrZDj2fR
         04Wg==
X-Gm-Message-State: AHQUAuYOb9uTtLfVykRCKcDY0N1zX+sIbmVC919ng8gzPVRrqOr59g/U
        3/+yAiMe6Pqqs57d+VJ1AN3W/bvw9z7rNqpM0jInnFtJGsM=
X-Google-Smtp-Source: AHgI3IYEs5HLd2fvTMQrJb53XJ0VJYBRHKKlFHDmhJv7PKmZs2EnkhceWqsCR2FP0zP0LXEz7LXMB8yi3WdHnQo/cyM=
X-Received: by 2002:ac2:4194:: with SMTP id z20mr6801947lfh.74.1550275434580;
 Fri, 15 Feb 2019 16:03:54 -0800 (PST)
MIME-Version: 1.0
References: <CAG245DUfS_cXvDZguyE76bPprY8Y1_f+FymHnGjYqkUq_qWbnQ@mail.gmail.com>
In-Reply-To: <CAG245DUfS_cXvDZguyE76bPprY8Y1_f+FymHnGjYqkUq_qWbnQ@mail.gmail.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Fri, 15 Feb 2019 17:03:42 -0700
Message-ID: <CAJCQCtTz6tYmW1GaYmdoyPDB+F6bL_RxKsxbNh9MafkOe-2F=w@mail.gmail.com>
Subject: Re: Btrfs corruption: Cannot mount partition
To:     =?UTF-8?Q?Martin_P=C3=B6hlmann?= <mpdeimos@gmail.com>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Feb 15, 2019 at 2:31 PM Martin P=C3=B6hlmann <mpdeimos@gmail.com> w=
rote:
>
> Hello,
>
> After a reboot I am lost with an unmountable BTRFS partition. Before
> reboot I had first compile problems with freezing IntelliJ. These
> persisted after a first reboot, after a second reboot I am faced with
> the following error after entering the dm-crypt password (also after
> manual mount with -o ro,recovery, see attached dmesg):
>
> [ 6098.921985] BTRFS error (device dm-0): unable to find ref byte nr
> 390335463424 parent 0 root 2
> [ 6098.922473] BTRFS: error (device dm-0) in __btrfs_free_extent:6828:
> errno=3D-2 No such entry
> [ 6098.922526] BTRFS: error (device dm-0) in
> btrfs_run_delayed_refs:2978: errno=3D-2 No such entry
> [ 6098.922601] BTRFS: error (device dm-0) in btrfs_replay_log:2267:
> errno=3D-2 No such entry (Failed to recover log tree)
> [ 6098.972326] BTRFS error (device dm-0): open_ctree failed

This suggests a crash or power failure, as there's a log that needs to
be replayed to mount the file system, but that log replay has failed.
Try:

mount -o ro,nologreplay <dev> <mp>

If that works without additional errors, go ahead an unmount. If
you're willing to take a small risk of the last, maybe minute or so of
transactions being lost, and you need to get up and running sooner
than later, you can zero the log.

btrfs rescue zero-log <dev>

However, it might be useful to try and provide more information first
because log replay should not fail.

btrfs insp dump-s -f <dev>

From that you will see an item log_root and a number after it. Copy
that number and paste it in here:

btrfs insp dump-t -b <logtreeaddr> --follow <dev>

I'm not sure how much information btrfs dump tree can provide about
log trees, but worth a shot I guess.



> I've searched for a solution on the web, but most articles tell to do
> nothing, but write to this mailing list. So my hopes are that you can
> shed some light into what I can do.
>
> I've found a quite recent thread here
> (https://lore.kernel.org/linux-btrfs/5b0d2e94-6e4e-aecd-3eda-459c4a96bb13=
@mokrynskyi.com/)
> but this just mentions a fix for 'Fix missing reference aborts when
> resuming snapshot delete' and is not further specific.
>
> Setup of my SSD looks like:
>
> * efi
> * dm-crypt plain. Contains BTRFS (w/o lvm or similar). Several
> subvolumes (/, /home, ...)
> * swap
>
> I've already run btrfs restore on volid 258 (home) and gathered lots
> of data from the disk (>200GB). I also have a dd backup of the
> cryptroot after the failure happened (in case something goes wrong).
> Besides I did not do any fix attempts yet. If there is anything I can
> do to get the system working again, I'm happy to hear.
>
> Thanks!
>
> My Linux system is Arch Linux (up to date), logs below come from the
> Arch install medium .
>
> # uname -a
> Linux archiso 4.20.6-arch1-1-ARCH #1 SMP PREEMPT Thu Jan 31 08:22:01
> UTC 2019 x86_64 GNU/Linux
>
> # btrfs --version
> btrfs-progs v4.19.1
>
> # btrfs fi show
> Label: 'root'  uuid: bbd941a4-5525-4ba6-a4d8-3ead02b8aae1
>         Total devices 1 FS bytes used 381.56GiB
>         devid    1 size 460.39GiB used 393.01GiB path /dev/mapper/cryptro=
ot
>
> # btrfs check --readonly /dev/mapper/cryptroot
> [1/7] checking root items
> [2/7] checking extents
> [3/7] checking free space cache
> [4/7] checking fs roots
> root 258 inode 776 errors 200, dir isize wrong
> root 258 inode 1131031 errors 1, no inode item
>         unresolved ref dir 776 index 87215 namelen 17 name
> TransportSecurity filetype 1 errors 5, no dir item, no inode ref
> root 258 inode 2911226 errors 1, no inode item
>         unresolved ref dir 776 index 160611 namelen 17 name
> TransportSecurity filetype 1 errors 5, no dir item, no inode ref


Hmm, that's possibly getting tripped up on the log. I'm not sure. So
I'm still curious if it can mount ro without log replay. That's a safe
command, it doesn't make any changes on disk. If it works, you can
back up some files while you have the chance in case repair attempts
don't work or things get worse.

Obviously the less you change the system (zero log, and check --repair
both write to the file system and change it) the better off you are
until a developer can give advice. But it's also Friday and it might
be a few days before one gets to reply. So, if you can wait, do that.



--=20
Chris Murphy
