Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:34622 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753179AbdECL0z (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 May 2017 07:26:55 -0400
Received: by mail-io0-f196.google.com with SMTP id h41so34783304ioi.1
        for <linux-btrfs@vger.kernel.org>; Wed, 03 May 2017 04:26:55 -0700 (PDT)
Subject: Re: Can I see what device was used to mount btrfs?
To: kreijack@inwind.it, Adam Borowski <kilobyte@angband.pl>,
        Andrei Borzenkov <arvidjaar@gmail.com>
References: <1e2e2e5c-5ee8-85c1-1db4-74293d8c9c1e@gmail.com>
 <20170502135820.2ft7bsoceeqhnbqf@angband.pl>
 <CAA91j0V97dCb+j_thg0oi7B4D29VVKcqtRcpCWbgQyzi+FScKA@mail.gmail.com>
 <20170502184923.jdpfx3pwkl5avdph@angband.pl>
 <c7f3c9fe-2f28-e102-9df7-273dc5a6ca8e@inwind.it>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <dd909c77-5014-3ec8-a976-7290145ad46d@gmail.com>
Date: Wed, 3 May 2017 07:26:51 -0400
MIME-Version: 1.0
In-Reply-To: <c7f3c9fe-2f28-e102-9df7-273dc5a6ca8e@inwind.it>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-05-02 15:50, Goffredo Baroncelli wrote:
> On 2017-05-02 20:49, Adam Borowski wrote:
>>> It could be some daemon that waits for btrfs to become complete.  Do we
>>> have something?
>> Such a daemon would also have to read the chunk tree.
>
> I don't think that a daemon is necessary. As proof of concept, in the past I developed a mount helper [1] which handled the mount of a btrfs filesystem:
> this handler first checks if the filesystem is a multivolume devices, if so it waits that all the devices are appeared. Finally mount the filesystem.
>
>> It's not so simple -- such a btrfs device would have THREE states:
>>
>> 1. not mountable yet (multi-device with not enough disks present)
>> 2. mountable ro / rw-degraded
>> 3. healthy
>
> My mount.btrfs could be "programmed" to wait a timeout, then it mounts the filesystem as degraded if not all devices are present. This is a very simple strategy, but this could be expanded.
>
> I am inclined to think that the current approach doesn't fit well the btrfs requirements.  The roles and responsibilities are spread to too much layer (udev, systemd, mount)... I hoped that my helper could be adopted in order to concentrate all the responsibility to only one binary; this would reduce the interface number with the other subsystem (eg systemd, udev).
The primary problem is that systemd treats BTRFS like a block-layer 
instead of a filesystem (so it assumes all devices need to be present), 
and that it doesn't trust the kernel's mount function to work correctly. 
  As a result, it assumes that the mount operation will fail if it 
doesn't see all the devices instead of just trying it like it should.
>
> For example, it would be possible to implement a sane check that prevent to mount a btrfs filesystem if two devices exposes the same UUID...
>
>
> BR
> G.Baroncelli
>
> [1] See "[RFC][PATCH v2] mount.btrfs helper" thread ( https://marc.info/?l=linux-btrfs&m=141736989508243&w=2 )
>

