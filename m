Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f177.google.com ([209.85.223.177]:33789 "EHLO
        mail-io0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966758AbdD0QqV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Apr 2017 12:46:21 -0400
Received: by mail-io0-f177.google.com with SMTP id k87so27879788ioi.0
        for <linux-btrfs@vger.kernel.org>; Thu, 27 Apr 2017 09:46:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPsdh33mN-QuL+-Z5UmO7Tmn4rEQs7_6X3a0D2T0APYkm5YR2A@mail.gmail.com>
References: <CAPsdh32v36LAbDLujVW-yiLiEvY_cNnqPtVXdKzdfADHUhB2JQ@mail.gmail.com>
 <20170427190751.2dc0e7ac@natsu> <CAPsdh33mN-QuL+-Z5UmO7Tmn4rEQs7_6X3a0D2T0APYkm5YR2A@mail.gmail.com>
From: Gerard Saraber <gsaraber@rarcoa.com>
Date: Thu, 27 Apr 2017 11:46:19 -0500
Message-ID: <CAPsdh33+2gA2EBswSrA-jV5H6ZtrK2tQ_W6j8rKtMUTYE2S76g@mail.gmail.com>
Subject: Re: No space left on device when doing "mkdir"
To: Roman Mamedov <rm@romanrm.net>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

After a reboot, I found this in the logs:
[  322.510152] BTRFS info (device sdm): The free space cache file
(36114966511616) is invalid. skip it
[  488.702570] btrfs_printk: 847 callbacks suppressed



On Thu, Apr 27, 2017 at 10:18 AM, Gerard Saraber <gsaraber@rarcoa.com> wrote:
> no snapshots and no qgroups, just a straight up large volume.
>
> shrapnel gerard-store # btrfs fi df /home/exports
> Data, RAID1: total=20.93TiB, used=20.86TiB
> System, RAID1: total=32.00MiB, used=3.73MiB
> Metadata, RAID1: total=79.00GiB, used=61.10GiB
> GlobalReserve, single: total=512.00MiB, used=544.00KiB
>
> shrapnel gerard-store # btrfs filesystem usage /home/exports
> Overall:
>     Device size:                  69.13TiB
>     Device allocated:             42.01TiB
>     Device unallocated:           27.13TiB
>     Device missing:                  0.00B
>     Used:                         41.84TiB
>     Free (estimated):             13.63TiB      (min: 13.63TiB)
>     Data ratio:                       2.00
>     Metadata ratio:                   2.00
>     Global reserve:              512.00MiB      (used: 1.52MiB)
>
> On Thu, Apr 27, 2017 at 9:07 AM, Roman Mamedov <rm@romanrm.net> wrote:
>> On Thu, 27 Apr 2017 08:52:30 -0500
>> Gerard Saraber <gsaraber@rarcoa.com> wrote:
>>
>>> I could just reboot the system and be fine for a week or so, but is
>>> there any way to diagnose this?
>>
>> `btrfs fi df` for a start.
>>
>> Also obligatory questions: do you have a lot of snapshots, and do you use
>> qgroups?
>>
>> --
>> With respect,
>> Roman
