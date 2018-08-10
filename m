Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f43.google.com ([209.85.218.43]:37531 "EHLO
        mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727038AbeHKArP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 10 Aug 2018 20:47:15 -0400
Received: by mail-oi0-f43.google.com with SMTP id j205-v6so18368556oib.4
        for <linux-btrfs@vger.kernel.org>; Fri, 10 Aug 2018 15:15:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <7e1b4883-0095-3d7d-553d-ccb551d37a29@gmx.com>
References: <CAAMvbhED_WrVH5VHL9ND4dpMdS+C5erVnXJQcpwbKU2YnoMu6A@mail.gmail.com>
 <fa1bac3c-76d6-eb0a-459b-5b931375f1a9@gmx.com> <CAAMvbhGJdGobexGS0QEGDexNeZpZkJY3o_s9N4izZeEJ7-HWtA@mail.gmail.com>
 <7e1b4883-0095-3d7d-553d-ccb551d37a29@gmx.com>
From: James Courtier-Dutton <james.dutton@gmail.com>
Date: Fri, 10 Aug 2018 23:14:48 +0100
Message-ID: <CAAMvbhGK7QZnLg+4O4B-Pk4XdfgS6N6Gv41ggPn151TPxOPA-g@mail.gmail.com>
Subject: Re: BUG: scheduling while atomic
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 6 August 2018 at 07:26, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>
>
>> WARNING: CPU: 3 PID: 803 at
>> /build/linux-hwe-SYRsgd/linux-hwe-4.15.0/fs/btrfs/extent_map.c:77
>> free_extent_map+0x78/0x90 [btrfs]
>
> Then it makes sense, as it's a WARN_ON() line, showing one extent map is
> still used.
>
> If it get freed, it will definitely cause some rbtree corruption.
>
>
> It's should be the only free_extent_map() call in __do_readpage() function.
> However a first glance into this function shows nothing wrong, nor new
> modification in this function.
> (Maybe it's the get_extent() hook?)
>
> Is there any reproducer? Or special workload?
The workload is fairly simple.
1) The server is receiving 1Gbyte files from across the network, in 10
minute intervals, and storing them on the HDD.
2) A process reads the files, scanning them for certain patterns.
3) A cron job deletes the old files.



>
> And, have you tried "btrfs check --readonly <device>"? If there is any
> error it would help a lot to locate the problem.
>
root@sandisk:~# btrfs check --readonly /dev/sda3
Checking filesystem on /dev/sda3
UUID: 8c9063b9-a4bb-48d1-92ba-6adf49af6fb5
checking extents
checking free space cache
block group 6874953940992 has wrong amount of free space
failed to load free space cache for block group 6874953940992
checking fs roots
checking csums
checking root refs
found 1488143566396 bytes used err is 0
total csum bytes: 1448276084
total tree bytes: 5079711744
total fs tree bytes: 3280207872
total extent tree bytes: 146997248
btree space waste bytes: 1100557047
file data blocks allocated: 2266345996288
 referenced 2235075653632
root@sandisk:~#


So, not much to see there.
Any more ideas?
