Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf1-f45.google.com ([209.85.167.45]:39097 "EHLO
        mail-lf1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728230AbeIPXhS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 16 Sep 2018 19:37:18 -0400
Received: by mail-lf1-f45.google.com with SMTP id v77-v6so11661769lfa.6
        for <linux-btrfs@vger.kernel.org>; Sun, 16 Sep 2018 11:13:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180916180325.c6jkusse76gsuf52@campbell-lange.net>
References: <20180916111445.lqwjqvq4aeiwglmm@campbell-lange.net>
 <b6d821fb-334f-8145-27e3-28a8cfa99940@mendix.com> <7fade1e9-7eb2-d416-6a3d-452cbca3bbe5@mendix.com>
 <20180916180325.c6jkusse76gsuf52@campbell-lange.net>
From: Chris Murphy <lists@colorremedies.com>
Date: Sun, 16 Sep 2018 12:13:31 -0600
Message-ID: <CAJCQCtQYznC83N9bj7TKNcrJpS9Omp3goULwro3TCihk85PvmQ@mail.gmail.com>
Subject: Re: Move data and mount point to subvolume
To: Rory Campbell-Lange <rory@campbell-lange.net>
Cc: Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> So I did this:
>
>     btrfs subvol snapshot /bkp /bkp/backup-subvol
>
> strangely while /bkp/backup has lots of files in it,
> /bkp/backup-subvol/backup has none.
>
> # btrfs subvol list /bkp
> ID 258 gen 313585 top level 5 path backup
> ID 4782 gen 313590 top level 5 path backup-subvol

OK so previously you said "/bkp which is a top level subvolume. There
are no other subvolumes."

But in fact backup is already a subvolume. So now it's confusing what
you were asking for in the first place, maybe you didn't realize
backup is not a dir but it is a subvolume.

If you snapshot a subvolume, which itself contains subvolumes, the
nested subvolumes are not snapshot. In the snapshot, the nested
subvolumes are empty directories.


>
> # btrfs fi du -s /bkp/backup-subvol/backup
>      Total   Exclusive  Set shared  Filename
> ERROR: cannot check space of '/bkp/backup-subvol/backup': Inappropriate
> ioctl for device

That's a bug in older btrfs-progs. It's been fixed, but I'm not sure
what version, maybe by 4.14?


>
> Any ideas about what could be going on?
>
> In the mean time I'm trying:
>
>     btrfs subvol create /bkp/backup-subvol
>     cp -prv --reflink=always /bkp/backup/* /bkp/backup-subvol/

Yeah that will take a lot of writes that are not necessary, now that
you see backup is a subvolume already. If you want a copy of it, just
snapshot it.

-- 
Chris Murphy
