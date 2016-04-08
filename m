Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f41.google.com ([209.85.215.41]:35129 "EHLO
	mail-lf0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758594AbcDHQTs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Apr 2016 12:19:48 -0400
Received: by mail-lf0-f41.google.com with SMTP id c126so83101568lfb.2
        for <linux-btrfs@vger.kernel.org>; Fri, 08 Apr 2016 09:19:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <7303236.im7zcVY3uK@merkaba>
References: <7303236.im7zcVY3uK@merkaba>
Date: Fri, 8 Apr 2016 18:19:41 +0200
Message-ID: <CAPmG0jYakN3vpHf-nHAtYxojim4jcy-sQguzcEJJyYppojZgAw@mail.gmail.com>
Subject: Re: btrfs send/receive using generation number as source
From: Henk Slager <eye1tm@gmail.com>
To: Martin Steigerwald <martin@lichtvoll.de>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 8, 2016 at 1:01 PM, Martin Steigerwald <martin@lichtvoll.de> wrote:
> Hello!
>
> As far as I understood, for differential btrfs send/receive – I didn´t use it
> yet – I need to keep a snapshot on the source device to then tell btrfs send
> to send the differences between the snapshot and the current state.

During the incremental send operation you need 2 ro snapshots
available (a parent and a current snapshot) and after that, you just
need to keep the current one and promote that to parent snapshot and
keep it around until the next incremental send. So indeed that locks
space and you might run out of free space if there is a long time
before the next incremental send|receive and changes in the filesystem
are large in volume.

Alternatively, you could do non-incremental send, if the fs is
relatively small and you have some method to dedupe on the receiving
filesystem. But the rsync method is by far preferred in this case I
would say.

> Now the BTRFS filesystems on my SSDs are often quite full, thus I do not keep
> any snapshots except for one during rsync or borgbackup script run-time.
>
> Is it possible to tell btrfs send to use generation number xyz to calculate
> the difference? This way, I wouldn´t have to keep a snapshot around, I
> believe.
>
> I bet not, at the time cause -c wants a snapshot. Ah and it wants a snapshot
> of the same state on the destination as well. Well on the destination I let
> the script make a snapshot after the backup so… what I would need is to

You can use -p for incremental send and you can also send back (new)
increments from backup to master.

> remember the generation number of the source snapshot that the script creates
> to backup from and then tell btrfs send that generation number + the
> destination snapshots.
>
> Well, or get larger SSDs or get rid of some data on them.

I switched from ext4 to btrfs rootfs on an old netbook which has only
4G soldered flash and no option for extension  (except via USB/SDcard
which turned out to be not reliable enough over a longer period of
time).
Basically compress=lzo mount option extents the lifetime of this
netbook while still using a modern full-sized linux distro. But I
guess you have already compressed/compacted what is possible.
