Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:52728 "EHLO
        mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751274AbdKAG2U (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Nov 2017 02:28:20 -0400
Received: by mail-wm0-f46.google.com with SMTP id t139so2926304wmt.1
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Oct 2017 23:28:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20171101101510.218eeead@natsu>
References: <CAH=dxU5mGQ5ws11fFKC+X3F810MceMxNBwnCR=g=Rau9DLDRng@mail.gmail.com>
 <20171101101510.218eeead@natsu>
From: Dave <davestechshop@gmail.com>
Date: Wed, 1 Nov 2017 02:27:58 -0400
Message-ID: <CAH=dxU6ULJ7DmXMLyABHhCjHgbzhp5rAc1aC9oBKeivbdjH==w@mail.gmail.com>
Subject: Re: Need help with incremental backup strategy (snapshots,
 defragmentingt & performance)
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Cc: Roman Mamedov <rm@romanrm.net>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 1, 2017 at 1:15 AM, Roman Mamedov <rm@romanrm.net> wrote:
> On Wed, 1 Nov 2017 01:00:08 -0400
> Dave <davestechshop@gmail.com> wrote:
>
>> To reconcile those conflicting goals, the only idea I have come up
>> with so far is to use btrfs send-receive to perform incremental
>> backups as described here:
>> https://btrfs.wiki.kernel.org/index.php/Incremental_Backup .
>
> Another option is to just use the regular rsync to a designated destination
> subvolume on the backup host, AND snapshot that subvolume on that host from
> time to time (or on backup completions, if you can synchronize that).
>
> rsync --inplace will keep space usage low as it will not reupload entire files
> in case of changes/additions to them.
>

This seems like a brilliant idea, something that has a lot of potential...

On a system where the root filesystem is on an SSD and the backup
volume on an HDD, I could rsync hourly, and then run Snapper on the
backup volume hourly, as well as using Snapper's timeline cleanup on
the backup volume. The live filesystem would have zero snapshots and
could be optimized for performance. The backup volume could retain a
large number of snapshots (even more than several hundred) because
performance would not be very important (as far as I can guess). This
seems to resolve our conflict.

How about on a system (such as a laptop) with only a single SSD? Would
this same idea work where the backup volume is on the same block
device? I know that is not technically a backup, but what it does
accomplish is separation of the live filesystem from the snapshotted
backup volume for performance reasons -- yet the hourly snapshot
history is still available. That would seem to meet our use case too.
(An external backup disk would be connected to the laptop
periodically, of course, too.)

Currently, for most btrfs volumes, I have three volumes: the main
volume, a snapshot subvolume which contains all the individual
snapshots, and a backup volume* (on a different block device but on
the same machine).

With this new idea, I would have a main volume without any snapshots
and a backup volume which contains all the snapshots. It simplifies
things on that level and it also simplifies performance tuning on the
main volume. In fact it simplifies backup snapshot management too.

My initial impression is that this simplifies everything as well as
optimizing everything. So surely it must have some disadvantages
compared to btrfs send-receive incremental backups
(https://btrfs.wiki.kernel.org/index.php/Incremental_Backup). What
would those disadvantages be?

The first one that comes to mind is that I would lose the
functionality of pre- and post- upgrade snapshots on the root
filesystem. But I think that's minor. I could either keep those two
snapshots for a few hours or days after major upgrades or maybe I
could find a pacman hook that uses rsync to make pre- and post-
upgrade copies...

* Footnote: on some workstation computers, we have 2 or 3 separate
backup block devices (e..g, external USB hard drives, etc.). Laptops,
however, generally only have a single block device and are not always
connected to an external USB hard drive for backup as often as would
be ideal. But we also don't keep any critical data on laptops.
