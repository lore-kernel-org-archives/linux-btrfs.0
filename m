Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:36099 "EHLO
        mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752107AbcKJG5i (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 Nov 2016 01:57:38 -0500
Received: by mail-wm0-f43.google.com with SMTP id g23so22115631wme.1
        for <linux-btrfs@vger.kernel.org>; Wed, 09 Nov 2016 22:57:38 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1478714157.5823632d5829d@webmail.adria.it>
References: <1478714157.5823632d5829d@webmail.adria.it>
From: Alex Powell <alexj.powellalt@googlemail.com>
Date: Thu, 10 Nov 2016 17:27:36 +1030
Message-ID: <CAKGv6Coc4vzsJsJ8=AEP1-vcdDzCcNeeGAoerkMwaukAowOzwA@mail.gmail.com>
Subject: Re:
To: bepi@adria.it
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
It would be good but perhaps each task should be created via cronjobs
instead of having a script running all the time or one script via one
cronjob

Working in the enterprise environment for a major bank, we quickly
learn that these sort of daily tasks should be split up

Kind Regards,
Alex

On Thu, Nov 10, 2016 at 4:25 AM,  <bepi@adria.it> wrote:
> Hi.
>
> I'm making a script for managing btrfs.
>
> To perform the scrub, to create and send (even to a remote system) of the backup
> snapshot (or for one copy of the current state of the data).
>
> The script is designed to:
> - Be easy to use:
>   - The preparation is carried out automatically.
>   - Autodetect of the subvolume mounted.
> - Be safe and robust:
>   - Check that not exist a another btrfs managing already started.
>   - Subvolume for created and received snapshot are mounted and accessible only
>     for the time necessary to perform the requested operation.
>   - Verify that the snapshot and sending snapshot are been executed completely.
>   - Progressive numbering of the snapshots for identify with certainty
>     the latest snapshot.
>
> Are also available command for view the list of snaphost present, command for
> delete the snapshots.
>
> For example:
>
> btrsfManage SCRUB /
> btrsfManage SNAPSHOT /
> btrsfManage SEND / /dev/sda1
> btrsfManage SEND / root@gdb.exnet.it/dev/sda1
> btrsfManage SNAPLIST /dev/sda1
> btrsfManage SNAPDEL /dev/sda1 "root-2016-11*"
>
> You are interested?
>
> Gdb
>
>
> ----------------------------------------------------
> This mail has been sent using Alpikom webmail system
> http://www.alpikom.it
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
