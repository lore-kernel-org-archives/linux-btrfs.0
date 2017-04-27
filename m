Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f176.google.com ([209.85.161.176]:36556 "EHLO
        mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S937913AbdD0Xfj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Apr 2017 19:35:39 -0400
Received: by mail-yw0-f176.google.com with SMTP id l18so23624310ywh.3
        for <linux-btrfs@vger.kernel.org>; Thu, 27 Apr 2017 16:35:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPsdh33+2gA2EBswSrA-jV5H6ZtrK2tQ_W6j8rKtMUTYE2S76g@mail.gmail.com>
References: <CAPsdh32v36LAbDLujVW-yiLiEvY_cNnqPtVXdKzdfADHUhB2JQ@mail.gmail.com>
 <20170427190751.2dc0e7ac@natsu> <CAPsdh33mN-QuL+-Z5UmO7Tmn4rEQs7_6X3a0D2T0APYkm5YR2A@mail.gmail.com>
 <CAPsdh33+2gA2EBswSrA-jV5H6ZtrK2tQ_W6j8rKtMUTYE2S76g@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Thu, 27 Apr 2017 17:35:38 -0600
Message-ID: <CAJCQCtTN2GyzebfC5JR_jZuF9_XVi9N0iHJutX2GuuvAPzVhAQ@mail.gmail.com>
Subject: Re: No space left on device when doing "mkdir"
To: Gerard Saraber <gsaraber@rarcoa.com>
Cc: Roman Mamedov <rm@romanrm.net>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 27, 2017 at 10:46 AM, Gerard Saraber <gsaraber@rarcoa.com> wrote:
> After a reboot, I found this in the logs:
> [  322.510152] BTRFS info (device sdm): The free space cache file
> (36114966511616) is invalid. skip it
> [  488.702570] btrfs_printk: 847 callbacks suppressed
>
>
>
> On Thu, Apr 27, 2017 at 10:18 AM, Gerard Saraber <gsaraber@rarcoa.com> wrote:
>> no snapshots and no qgroups, just a straight up large volume.
>>
>> shrapnel gerard-store # btrfs fi df /home/exports
>> Data, RAID1: total=20.93TiB, used=20.86TiB
>> System, RAID1: total=32.00MiB, used=3.73MiB
>> Metadata, RAID1: total=79.00GiB, used=61.10GiB
>> GlobalReserve, single: total=512.00MiB, used=544.00KiB
>>
>> shrapnel gerard-store # btrfs filesystem usage /home/exports
>> Overall:
>>     Device size:                  69.13TiB
>>     Device allocated:             42.01TiB
>>     Device unallocated:           27.13TiB
>>     Device missing:                  0.00B
>>     Used:                         41.84TiB
>>     Free (estimated):             13.63TiB      (min: 13.63TiB)
>>     Data ratio:                       2.00
>>     Metadata ratio:                   2.00
>>     Global reserve:              512.00MiB      (used: 1.52MiB)
>>
>> On Thu, Apr 27, 2017 at 9:07 AM, Roman Mamedov <rm@romanrm.net> wrote:
>>> On Thu, 27 Apr 2017 08:52:30 -0500
>>> Gerard Saraber <gsaraber@rarcoa.com> wrote:
>>>
>>>> I could just reboot the system and be fine for a week or so, but is
>>>> there any way to diagnose this?
>>>
>>> `btrfs fi df` for a start.
>>>
>>> Also obligatory questions: do you have a lot of snapshots, and do you use
>>> qgroups?
>>>

A dev might find this helpful
$ grep -IR . /sys/fs/btrfs/usevolumeUUIDhere/allocation/


Also note that a lot of people on Btrfs aren't getting Gerard's
emails, because anyone using gmail and some other agents see it as
spam because of DMARC failure. Basically rarcoa.com is configured to
tell mail senders to fail to (re)send emails, they can only be sent
from raroa.com. Anyway, I think this is supposed to be fixed in
mailing list servers, they need to strip these headers and insert
their own rather than leaving them intact only later to get rejected
due to honoring the header's stated policy.

-- 
Chris Murphy
