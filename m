Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f43.google.com ([209.85.214.43]:35629 "EHLO
        mail-it0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751417AbdD1N4L (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Apr 2017 09:56:11 -0400
Received: by mail-it0-f43.google.com with SMTP id 70so38058181ita.0
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Apr 2017 06:56:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTN2GyzebfC5JR_jZuF9_XVi9N0iHJutX2GuuvAPzVhAQ@mail.gmail.com>
References: <CAPsdh32v36LAbDLujVW-yiLiEvY_cNnqPtVXdKzdfADHUhB2JQ@mail.gmail.com>
 <20170427190751.2dc0e7ac@natsu> <CAPsdh33mN-QuL+-Z5UmO7Tmn4rEQs7_6X3a0D2T0APYkm5YR2A@mail.gmail.com>
 <CAPsdh33+2gA2EBswSrA-jV5H6ZtrK2tQ_W6j8rKtMUTYE2S76g@mail.gmail.com> <CAJCQCtTN2GyzebfC5JR_jZuF9_XVi9N0iHJutX2GuuvAPzVhAQ@mail.gmail.com>
From: Gerard Saraber <gsaraber@rarcoa.com>
Date: Fri, 28 Apr 2017 08:56:07 -0500
Message-ID: <CAPsdh31Djmz5p+1+XGmfN+Ropp3CdhNjU6CpnJhKhPx+fsG71w@mail.gmail.com>
Subject: Re: No space left on device when doing "mkdir"
To: Chris Murphy <lists@colorremedies.com>
Cc: Roman Mamedov <rm@romanrm.net>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dmarc is off, here's the output of the allocations: it's working
correctly right now, I'll update when it does it again.

/sys/fs/btrfs/7af2e65c-3935-4e0d-aa63-9ef6be991cb9/allocation/system/flags:2
/sys/fs/btrfs/7af2e65c-3935-4e0d-aa63-9ef6be991cb9/allocation/system/raid1/used_bytes:3948544
/sys/fs/btrfs/7af2e65c-3935-4e0d-aa63-9ef6be991cb9/allocation/system/raid1/total_bytes:33554432
/sys/fs/btrfs/7af2e65c-3935-4e0d-aa63-9ef6be991cb9/allocation/system/bytes_pinned:0
/sys/fs/btrfs/7af2e65c-3935-4e0d-aa63-9ef6be991cb9/allocation/system/disk_total:67108864
/sys/fs/btrfs/7af2e65c-3935-4e0d-aa63-9ef6be991cb9/allocation/system/bytes_may_use:0
/sys/fs/btrfs/7af2e65c-3935-4e0d-aa63-9ef6be991cb9/allocation/system/bytes_readonly:0
/sys/fs/btrfs/7af2e65c-3935-4e0d-aa63-9ef6be991cb9/allocation/system/bytes_used:3948544
/sys/fs/btrfs/7af2e65c-3935-4e0d-aa63-9ef6be991cb9/allocation/system/bytes_reserved:0
/sys/fs/btrfs/7af2e65c-3935-4e0d-aa63-9ef6be991cb9/allocation/system/disk_used:7897088
/sys/fs/btrfs/7af2e65c-3935-4e0d-aa63-9ef6be991cb9/allocation/system/total_bytes_pinned:0
/sys/fs/btrfs/7af2e65c-3935-4e0d-aa63-9ef6be991cb9/allocation/system/total_bytes:33554432
/sys/fs/btrfs/7af2e65c-3935-4e0d-aa63-9ef6be991cb9/allocation/metadata/flags:4
/sys/fs/btrfs/7af2e65c-3935-4e0d-aa63-9ef6be991cb9/allocation/metadata/raid1/used_bytes:65864957952
/sys/fs/btrfs/7af2e65c-3935-4e0d-aa63-9ef6be991cb9/allocation/metadata/raid1/total_bytes:83751862272
/sys/fs/btrfs/7af2e65c-3935-4e0d-aa63-9ef6be991cb9/allocation/metadata/bytes_pinned:0
/sys/fs/btrfs/7af2e65c-3935-4e0d-aa63-9ef6be991cb9/allocation/metadata/disk_total:167503724544
/sys/fs/btrfs/7af2e65c-3935-4e0d-aa63-9ef6be991cb9/allocation/metadata/bytes_may_use:739508224
/sys/fs/btrfs/7af2e65c-3935-4e0d-aa63-9ef6be991cb9/allocation/metadata/bytes_readonly:0
/sys/fs/btrfs/7af2e65c-3935-4e0d-aa63-9ef6be991cb9/allocation/metadata/bytes_used:65864957952
/sys/fs/btrfs/7af2e65c-3935-4e0d-aa63-9ef6be991cb9/allocation/metadata/bytes_reserved:1835008
/sys/fs/btrfs/7af2e65c-3935-4e0d-aa63-9ef6be991cb9/allocation/metadata/disk_used:131729915904
/sys/fs/btrfs/7af2e65c-3935-4e0d-aa63-9ef6be991cb9/allocation/metadata/total_bytes_pinned:1884160
/sys/fs/btrfs/7af2e65c-3935-4e0d-aa63-9ef6be991cb9/allocation/metadata/total_bytes:83751862272
/sys/fs/btrfs/7af2e65c-3935-4e0d-aa63-9ef6be991cb9/allocation/global_rsv_size:536870912
/sys/fs/btrfs/7af2e65c-3935-4e0d-aa63-9ef6be991cb9/allocation/data/flags:1
/sys/fs/btrfs/7af2e65c-3935-4e0d-aa63-9ef6be991cb9/allocation/data/raid1/used_bytes:23029876707328
/sys/fs/btrfs/7af2e65c-3935-4e0d-aa63-9ef6be991cb9/allocation/data/raid1/total_bytes:23175643529216
/sys/fs/btrfs/7af2e65c-3935-4e0d-aa63-9ef6be991cb9/allocation/data/bytes_pinned:0
/sys/fs/btrfs/7af2e65c-3935-4e0d-aa63-9ef6be991cb9/allocation/data/disk_total:46351287058432
/sys/fs/btrfs/7af2e65c-3935-4e0d-aa63-9ef6be991cb9/allocation/data/bytes_may_use:36474880
/sys/fs/btrfs/7af2e65c-3935-4e0d-aa63-9ef6be991cb9/allocation/data/bytes_readonly:1703936
/sys/fs/btrfs/7af2e65c-3935-4e0d-aa63-9ef6be991cb9/allocation/data/bytes_used:23029876707328
/sys/fs/btrfs/7af2e65c-3935-4e0d-aa63-9ef6be991cb9/allocation/data/bytes_reserved:15003648
/sys/fs/btrfs/7af2e65c-3935-4e0d-aa63-9ef6be991cb9/allocation/data/disk_used:46059753414656
/sys/fs/btrfs/7af2e65c-3935-4e0d-aa63-9ef6be991cb9/allocation/data/total_bytes_pinned:0
/sys/fs/btrfs/7af2e65c-3935-4e0d-aa63-9ef6be991cb9/allocation/data/total_bytes:23175643529216
/sys/fs/btrfs/7af2e65c-3935-4e0d-aa63-9ef6be991cb9/allocation/global_rsv_reserved:536870912


On Thu, Apr 27, 2017 at 6:35 PM, Chris Murphy <lists@colorremedies.com> wrote:
> On Thu, Apr 27, 2017 at 10:46 AM, Gerard Saraber <gsaraber@rarcoa.com> wrote:
>> After a reboot, I found this in the logs:
>> [  322.510152] BTRFS info (device sdm): The free space cache file
>> (36114966511616) is invalid. skip it
>> [  488.702570] btrfs_printk: 847 callbacks suppressed
>>
>>
>>
>> On Thu, Apr 27, 2017 at 10:18 AM, Gerard Saraber <gsaraber@rarcoa.com> wrote:
>>> no snapshots and no qgroups, just a straight up large volume.
>>>
>>> shrapnel gerard-store # btrfs fi df /home/exports
>>> Data, RAID1: total=20.93TiB, used=20.86TiB
>>> System, RAID1: total=32.00MiB, used=3.73MiB
>>> Metadata, RAID1: total=79.00GiB, used=61.10GiB
>>> GlobalReserve, single: total=512.00MiB, used=544.00KiB
>>>
>>> shrapnel gerard-store # btrfs filesystem usage /home/exports
>>> Overall:
>>>     Device size:                  69.13TiB
>>>     Device allocated:             42.01TiB
>>>     Device unallocated:           27.13TiB
>>>     Device missing:                  0.00B
>>>     Used:                         41.84TiB
>>>     Free (estimated):             13.63TiB      (min: 13.63TiB)
>>>     Data ratio:                       2.00
>>>     Metadata ratio:                   2.00
>>>     Global reserve:              512.00MiB      (used: 1.52MiB)
>>>
>>> On Thu, Apr 27, 2017 at 9:07 AM, Roman Mamedov <rm@romanrm.net> wrote:
>>>> On Thu, 27 Apr 2017 08:52:30 -0500
>>>> Gerard Saraber <gsaraber@rarcoa.com> wrote:
>>>>
>>>>> I could just reboot the system and be fine for a week or so, but is
>>>>> there any way to diagnose this?
>>>>
>>>> `btrfs fi df` for a start.
>>>>
>>>> Also obligatory questions: do you have a lot of snapshots, and do you use
>>>> qgroups?
>>>>
>
> A dev might find this helpful
> $ grep -IR . /sys/fs/btrfs/usevolumeUUIDhere/allocation/
>
>
> Also note that a lot of people on Btrfs aren't getting Gerard's
> emails, because anyone using gmail and some other agents see it as
> spam because of DMARC failure. Basically rarcoa.com is configured to
> tell mail senders to fail to (re)send emails, they can only be sent
> from raroa.com. Anyway, I think this is supposed to be fixed in
> mailing list servers, they need to strip these headers and insert
> their own rather than leaving them intact only later to get rejected
> due to honoring the header's stated policy.
>
> --
> Chris Murphy
