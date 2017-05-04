Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f48.google.com ([209.85.215.48]:33106 "EHLO
        mail-lf0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752129AbdEDDtA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 May 2017 23:49:00 -0400
Received: by mail-lf0-f48.google.com with SMTP id r17so986625lfg.0
        for <linux-btrfs@vger.kernel.org>; Wed, 03 May 2017 20:48:59 -0700 (PDT)
Subject: Re: Can I see what device was used to mount btrfs?
To: Chris Murphy <lists@colorremedies.com>,
        Goffredo Baroncelli <kreijack@inwind.it>
References: <1e2e2e5c-5ee8-85c1-1db4-74293d8c9c1e@gmail.com>
 <20170502135820.2ft7bsoceeqhnbqf@angband.pl>
 <CAA91j0V97dCb+j_thg0oi7B4D29VVKcqtRcpCWbgQyzi+FScKA@mail.gmail.com>
 <20170502184923.jdpfx3pwkl5avdph@angband.pl>
 <c7f3c9fe-2f28-e102-9df7-273dc5a6ca8e@inwind.it>
 <20170502221506.3dfe125e@jupiter.sol.kaishome.de>
 <cdf96959-94e8-4932-465f-ea5c72187892@inwind.it>
 <CAJCQCtQwCohHJBKihg5fMC2Wc6+jz=Zc-a5MAOBaV4Pt-YzN6w@mail.gmail.com>
Cc: Kai Krakow <hurikhan77@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <1763c852-d8dd-a3f1-bdac-c8534659c682@gmail.com>
Date: Thu, 4 May 2017 06:48:55 +0300
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQwCohHJBKihg5fMC2Wc6+jz=Zc-a5MAOBaV4Pt-YzN6w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

03.05.2017 21:43, Chris Murphy пишет:
> If I understand the bug report correctly, the user specifies mounting
> by label which then systemd is converting into /dev/dm-0 (because it's
> a two LUKS devices Btrfs volume).
> 

No, that's not the problem.

The actual reason for report is that systemd shows device, which is
apparently (as shown in "systemctl status foo.mount" and in
/proc/self/mountinfo for /foo) used to mount /foo, as non-existent.
"Tentative" state is used by systemd to represent devices that do exist
but were not announced to it (or announced with SYSTEMD_READY=0).

To understand why it happens you need to know how systemd handles btrfs
mounts. udev rule calls "btrfs device ready" and if it says that
filesystem is not yet ready to be mounted, it sets SYSTEMD_READY=0. When
final device that makes btrfs complete appears, it is announced to
systemd. Usually this last device also "wins" when creating device
aliases, so LABEL/UUID is resolved to it. When systemd sees this device
it proceeds with mount.

Now as we have seen device that is shown in /proc/self/mountinfo is
*not* the same device that was used to actually mount filesystem. So in
case of bug report all links point to /dev/dm-1 but /proc/self/mountinfo
show /dev/dm-0. But /dev/dm-0 "does not esist" (when it was scanned
btrfs was not ready yet) hence the confusion.

Now related problem (which was "helpfully" closed as duplicate without
understanding the real issue) is that creation of those links itself is
not deterministic.

> Why not convert the fstab mount by label request, into a /dev/by-uuid/
> path; and then systemd calls mount with -u,--uuid mount option rather
> than the block device?

It absolutely does not matter. Internally util-linux will convert it to
/dev/disk/by-xxx anyway. And currently systemd needs device name to wait
for so it needs to resolve it.

> I'd think this is better no matter what the
> file system is, but certainly with Btrfs and possibly ZFS. That makes
> the device discovery problem not systemd's problem to hassle with.
> 
> 
> 
> Chris Murphy
> 
> 
> 
> 
> On Wed, May 3, 2017 at 11:05 AM, Goffredo Baroncelli <kreijack@inwind.it> wrote:
>> On 2017-05-02 22:15, Kai Krakow wrote:
>>>> For example, it would be possible to implement a sane check that
>>>> prevent to mount a btrfs filesystem if two devices exposes the same
>>>> UUID...
>>> Ideally, the btrfs wouldn't even appear in /dev until it was assembled
>>> by udev. But apparently that's not the case, and I think this is where
>>> the problems come from. I wish, btrfs would not show up as device nodes
>>> in /dev that the mount command identified as btrfs. Instead, btrfs
>>> would expose (probably through udev) a device node
>>> in /dev/btrfs/fs_identifier when it is ready.
>>
>>
>> And what if udev fails to assemble the devices (for example because not all the disks are available or because there are two disks with the same uuid) ?
>> And if the user can't access the disks, how he could solve the issues (i.e. two disk with the same uuid)
>>
>> I think that udev should be put out of the game of assembling the disks. For the following reasons:
>> 1) udev is not developed by the BTRFS community where the btrfs knowledges are; there are a lot of corner cases which are not clear to the btrfs developers; how these case could be more clearer to the udev developers (who indeed are very smart guys) ?
>> 2) I don't think that udev is flexible enough to handle all the cases (e.g.: two disks with the same uuid,  missing devices)
>> 3) udev works quite well at handling the device appearing; why it should be involved in the filesystem assembling ?
>>
>>
>> BR
>> G.Baroncelli
>>
>>
>> --
>> gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
>> Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 

