Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f42.google.com ([209.85.215.42]:35558 "EHLO
        mail-lf0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932856AbdHVNo6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Aug 2017 09:44:58 -0400
Received: by mail-lf0-f42.google.com with SMTP id k186so23813954lfe.2
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Aug 2017 06:44:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170822132208.GD14804@rus.uni-stuttgart.de>
References: <20170822132208.GD14804@rus.uni-stuttgart.de>
From: Peter Becker <floyd.net@gmail.com>
Date: Tue, 22 Aug 2017 15:44:56 +0200
Message-ID: <CAEtw4r1cDuE0F_MXe6mHDUr03BhEueBWeq7YaRYjNhhf=UD6KQ@mail.gmail.com>
Subject: Re: netapp-alike snapshots?
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Is use: https://github.com/jf647/btrfs-snap

2017-08-22 15:22 GMT+02:00 Ulli Horlacher <framstag@rus.uni-stuttgart.de>:
> With Netapp/waffle you have automatic hourly/daily/weekly snapshots.
> You can find these snapshots in every local directory (readonly).
> Example:
>
> framstag@fex:/sw/share: ll .snapshot/
> drwxr-xr-x  framstag root - 2017-08-14 10:21:47 .snapshot/daily.2017-08-15_0010
> drwxr-xr-x  framstag root - 2017-08-14 10:21:47 .snapshot/daily.2017-08-16_0010
> drwxr-xr-x  framstag root - 2017-08-14 10:21:47 .snapshot/daily.2017-08-17_0010
> drwxr-xr-x  framstag root - 2017-08-14 10:21:47 .snapshot/daily.2017-08-18_0010
> drwxr-xr-x  framstag root - 2017-08-18 23:59:29 .snapshot/daily.2017-08-19_0010
> drwxr-xr-x  framstag root - 2017-08-19 21:01:25 .snapshot/daily.2017-08-20_0010
> drwxr-xr-x  framstag root - 2017-08-20 19:48:40 .snapshot/daily.2017-08-21_0010
> drwxr-xr-x  framstag root - 2017-08-20 02:50:18 .snapshot/hourly.2017-08-20_1210
> drwxr-xr-x  framstag root - 2017-08-20 02:50:18 .snapshot/hourly.2017-08-20_1610
> drwxr-xr-x  framstag root - 2017-08-20 19:48:40 .snapshot/hourly.2017-08-20_2010
> drwxr-xr-x  framstag root - 2017-08-21 00:42:28 .snapshot/hourly.2017-08-21_0810
> drwxr-xr-x  framstag root - 2017-08-21 00:42:28 .snapshot/hourly.2017-08-21_1210
> drwxr-xr-x  framstag root - 2017-08-21 13:05:28 .snapshot/hourly.2017-08-21_1610
>
> I would like to have something similar with btrfs.
> Programming such a feature is not a general problem for me, but I think I
> am not the first one who wants this kind of auto-snapshooting.
> Is there (where?) such a tool?
>
> I know snapper, but it has a totally different approach.
>
> --
> Ullrich Horlacher              Server und Virtualisierung
> Rechenzentrum TIK
> Universitaet Stuttgart         E-Mail: horlacher@tik.uni-stuttgart.de
> Allmandring 30a                Tel:    ++49-711-68565868
> 70569 Stuttgart (Germany)      WWW:    http://www.tik.uni-stuttgart.de/
> REF:<20170822132208.GD14804@rus.uni-stuttgart.de>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
