Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f181.google.com ([209.85.161.181]:34705 "EHLO
        mail-yw0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S937048AbdD0PS3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Apr 2017 11:18:29 -0400
Received: by mail-yw0-f181.google.com with SMTP id k11so17212027ywb.1
        for <linux-btrfs@vger.kernel.org>; Thu, 27 Apr 2017 08:18:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170427190751.2dc0e7ac@natsu>
References: <CAPsdh32v36LAbDLujVW-yiLiEvY_cNnqPtVXdKzdfADHUhB2JQ@mail.gmail.com>
 <20170427190751.2dc0e7ac@natsu>
From: Gerard Saraber <gsaraber@rarcoa.com>
Date: Thu, 27 Apr 2017 10:18:22 -0500
Message-ID: <CAPsdh33mN-QuL+-Z5UmO7Tmn4rEQs7_6X3a0D2T0APYkm5YR2A@mail.gmail.com>
Subject: Re: No space left on device when doing "mkdir"
To: Roman Mamedov <rm@romanrm.net>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

no snapshots and no qgroups, just a straight up large volume.

shrapnel gerard-store # btrfs fi df /home/exports
Data, RAID1: total=20.93TiB, used=20.86TiB
System, RAID1: total=32.00MiB, used=3.73MiB
Metadata, RAID1: total=79.00GiB, used=61.10GiB
GlobalReserve, single: total=512.00MiB, used=544.00KiB

shrapnel gerard-store # btrfs filesystem usage /home/exports
Overall:
    Device size:                  69.13TiB
    Device allocated:             42.01TiB
    Device unallocated:           27.13TiB
    Device missing:                  0.00B
    Used:                         41.84TiB
    Free (estimated):             13.63TiB      (min: 13.63TiB)
    Data ratio:                       2.00
    Metadata ratio:                   2.00
    Global reserve:              512.00MiB      (used: 1.52MiB)

On Thu, Apr 27, 2017 at 9:07 AM, Roman Mamedov <rm@romanrm.net> wrote:
> On Thu, 27 Apr 2017 08:52:30 -0500
> Gerard Saraber <gsaraber@rarcoa.com> wrote:
>
>> I could just reboot the system and be fine for a week or so, but is
>> there any way to diagnose this?
>
> `btrfs fi df` for a start.
>
> Also obligatory questions: do you have a lot of snapshots, and do you use
> qgroups?
>
> --
> With respect,
> Roman
