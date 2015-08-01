Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f47.google.com ([209.85.213.47]:33466 "EHLO
	mail-vk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413AbbHAUY7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 1 Aug 2015 16:24:59 -0400
Received: by vkgc186 with SMTP id c186so31344924vkg.0
        for <linux-btrfs@vger.kernel.org>; Sat, 01 Aug 2015 13:24:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55BD277F.2040201@friedels.name>
References: <55BD277F.2040201@friedels.name>
Date: Sat, 1 Aug 2015 14:24:58 -0600
Message-ID: <CAJCQCtQjn-3dAw8mcmbtcSHZa1k-Dvg6T6V5AcRKBm84HNuZzg@mail.gmail.com>
Subject: Re: Data single *and* raid?
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Aug 1, 2015 at 2:09 PM, Hendrik Friedel <hendrik@friedels.name> wrote:
> Hello,
>
> I converted an array to raid5 by
> btrfs device add /dev/sdd /mnt/new_storage
> btrfs device add /dev/sdc /mnt/new_storage
> btrfs balance start -dconvert=raid5 -mconvert=raid5 /mnt/new_storage/
>
> The Balance went through. But now:
> Label: none  uuid: a8af3832-48c7-4568-861f-e80380dd7e0b
>         Total devices 3 FS bytes used 5.28TiB
>         devid    1 size 2.73TiB used 2.57TiB path /dev/sde
>         devid    2 size 2.73TiB used 2.73TiB path /dev/sdc
>         devid    3 size 2.73TiB used 2.73TiB path /dev/sdd
> btrfs-progs v4.1.1
>
> Already the 2.57TiB is a bit surprising:
> root@homeserver:/mnt# btrfs fi df /mnt/new_storage/
> Data, single: total=2.55TiB, used=2.55TiB
> Data, RAID5: total=2.73TiB, used=2.72TiB
> System, RAID5: total=32.00MiB, used=736.00KiB
> Metadata, RAID1: total=6.00GiB, used=5.33GiB
> Metadata, RAID5: total=3.00GiB, used=2.99GiB
>
> Why is there Data single and Raid?
> Why is Metadata RAID1 and Raid5?


What kernel version?

-- 
Chris Murphy
