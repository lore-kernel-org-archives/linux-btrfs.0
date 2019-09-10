Return-Path: <SRS0=dUzf=XF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87A62C3A5A2
	for <linux-btrfs@archiver.kernel.org>; Tue, 10 Sep 2019 04:16:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4D2AE20872
	for <linux-btrfs@archiver.kernel.org>; Tue, 10 Sep 2019 04:16:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gofYfGy0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732418AbfIJEQQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 10 Sep 2019 00:16:16 -0400
Received: from mail-yb1-f171.google.com ([209.85.219.171]:39111 "EHLO
        mail-yb1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729294AbfIJEQP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Sep 2019 00:16:15 -0400
Received: by mail-yb1-f171.google.com with SMTP id o80so2816683ybc.6
        for <linux-btrfs@vger.kernel.org>; Mon, 09 Sep 2019 21:16:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=tNr8raXSt7YpmhUyACalCZOw3le5r4R36kcLA03618g=;
        b=gofYfGy0wKnNW2P4rPqCo76sV200PWEQQvAs+RVkFMIz/m1klA5awE5Z2BC8G6ZAtn
         yuSewecGMeT8Cxbydc91HaVgsIvAe5n6wHnX3r65Hw758WVxi5ZHiQ2nfXNMB9d1E1eL
         M7Lg9XbKFm4US3fHHgcrAYajZ32AF0RAigw+zGy79fjQ6s4lKYc8qJQLIZ2kGw1KOZaG
         rV4wp3K7ucmSn9IejIjhFxEnlS3cEzolciPDw57E66JWDIyeA7tqyoWTfHRuavhqSIri
         j0+UpKh1tRq5yVhTLsw1dZsW6X6L2XbSpSVk7Qv+5OALFVjK2/C7U0+SbGhWYEJrxWMG
         gF3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=tNr8raXSt7YpmhUyACalCZOw3le5r4R36kcLA03618g=;
        b=QS6evlZhu6SD2O7eZF3iXKxcNrI6bcIJtXxgtXHG6WClS1wROQ7jBjGBgWkPbpIFzB
         YUObSZVw9o2dzuSOJerN+T0pw6KuwIZ7Dsao183rAs39bsxTRnWJGa4q3bwMaOlc9vsx
         j4KzPHsKtrY0JRy5iZP2Yc6NaOj6DHlWH1egwjQ4eMvSWyUVKwBGNuDKzmbxGszzPLci
         CS9u1wAzy2vKGYwW7FpkjOF625Kn79kbBBWnM0MSPGf/RQVzDyqLE6gRL+dWwCRGegDP
         iNt/rIv1fgZzNf3/TdvrJP3M/6DLM1OSQobx70nzxrCoe3gv71xZDPqzWwy9Zxsr6rk2
         JU7g==
X-Gm-Message-State: APjAAAX9wZTSabRi5lkIEd+bSl4sLbBn6lytGA3voCsPZnqqzYJY9OOn
        wSFrqHiP2kq8RYRG0644sg3XgTE+C0f8D/6Bc4QMc8Y=
X-Google-Smtp-Source: APXvYqxZmR3iJbSjvd5uzhPGs1EYHuEd3EBu9e1Uyp+ruJd1zMB7pzOBujNxTMiTsSlLpfEpT2Y/BKis/8AyRoSx5Qw=
X-Received: by 2002:a25:3844:: with SMTP id f65mr17990871yba.220.1568088973364;
 Mon, 09 Sep 2019 21:16:13 -0700 (PDT)
MIME-Version: 1.0
From:   Daniel Martinez <danielsmartinez@gmail.com>
Date:   Tue, 10 Sep 2019 01:15:36 -0300
Message-ID: <CAMmfObZuWx0HR48VNnN2M1jguBsfUmyXTQ-KN5J9iCySxRapHw@mail.gmail.com>
Subject: btrfs reported used space doesn't correspond with space occupied by
 the files themselves
To:     linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hello,

I've recently converted my root 32GB ext4 partition to btrfs (using
btrfs-progs 5.2). After that was done, I made a snapshot and tried to
update the system. Unfortunately I didn't have enough free space to
fit the whole update on that small partition, so it failed. I then
realized my mistake and deleted not only that newly made snapshot, but
also ext2_saved and some random files on the filesystem, totaling
about 5GB. For my surprise, the update still failed due to ENOSPC.

At this point, I tried running a balance, but it also failed with
ENOSPC. I tried the balance -dusage X with X increasing from zero, but
to my surprise again, it also failed.

Data, single: total=28.54GiB, used=28.34GiB
System, single: total=32.00MiB, used=16.00KiB
Metadata, single: total=1.00GiB, used=807.45MiB
GlobalReserve, single: total=41.44MiB, used=0.00B

Looking at btrfs filesystem df, it looks like those 5GB of data I
deleted are still occupying space. In fact, ncdu claims all the files
on that drive sum up to only 19GB.

I tried adding a second 2GB drive but that still wasn't enough to run
a full data balance (metadata runs fine).

This is what filesystem usage looks like:

Overall:
    Device size:                  31.59GiB
    Device allocated:             29.57GiB
    Device unallocated:            2.03GiB
    Device missing:                  0.00B
    Used:                         29.13GiB
    Free (estimated):              2.22GiB      (min: 2.22GiB)
    Data ratio:                       1.00
    Metadata ratio:                   1.00
    Global reserve:               41.44MiB      (used: 0.00B)

Data,single: Size:28.54GiB, Used:28.34GiB
   /dev/sda7     768.00MiB
   /dev/sdb1      27.79GiB

Metadata,single: Size:1.00GiB, Used:807.45MiB
   /dev/sdb1       1.00GiB

System,single: Size:32.00MiB, Used:16.00KiB
   /dev/sdb1      32.00MiB

Unallocated:
   /dev/sda7       1.03GiB
   /dev/sdb1       1.00GiB


I then made a read-only snapshot of the root filesystem and used btrfs
send/receive to transfer it to another btrfs filesystem, and when it
got there its also only occupying 19GB.

So there seems 10GB got lost somewhere in the process and I can't find
a way to get them back (other thank mkfs'ing and restoring a backup),
which in this case is about 30% of the available disk space.

What may be causing this?

Thanks,
Daniel.
