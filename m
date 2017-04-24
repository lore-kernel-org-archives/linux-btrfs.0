Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f171.google.com ([209.85.161.171]:34356 "EHLO
        mail-yw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S975264AbdDXRCJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Apr 2017 13:02:09 -0400
Received: by mail-yw0-f171.google.com with SMTP id k11so37636026ywb.1
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Apr 2017 10:02:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJyZh6S4f=6W+oA6DT1zu2FRuCgO7w8TfRzC96rPWNzUszvRmg@mail.gmail.com>
References: <CAJyZh6S4f=6W+oA6DT1zu2FRuCgO7w8TfRzC96rPWNzUszvRmg@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 24 Apr 2017 11:02:02 -0600
Message-ID: <CAJCQCtQ2d1c6OOGnJkKQ269kR526Y=krOcnJgy9cJHGQiw4aQQ@mail.gmail.com>
Subject: Re: Problem with file system
To: Fred Van Andel <vanandel@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 24, 2017 at 9:27 AM, Fred Van Andel <vanandel@gmail.com> wrote:
> I have a btrfs file system with a few thousand snapshots.  When I
> attempted to delete 20 or so of them the problems started.
>
> The disks are being read but except for the first few minutes there
> are no writes.
>
> Memory usage keeps growing until all the memory (24 Gb) is used in a
> few hours. Eventually the system will crash with out of memory errors.

Boot with these boot parameters
log_buf_len=1M

I find it easier to remotely login with another computer to capture
problems in case of a crash and I can't save things locally. So on the
remote computer use 'journalctl -kf -o short-monotonic'

Either on the 1st computer, or from an additional ssh connection from the 2nd:

echo 1 >/proc/sys/kernel/sysrq
btrfs fi show   #you need the UUID for the volume you're going to
mount, best to have it in advance

mount the file system normally, and once it's starting to have the
problem (I guess it happens pretty quickly?)

echo t > /proc/sysrq-trigger
grep . -IR /sys/fs/btrfs/UUID/allocation/

Paste in the UUID from fi show. If the computer is hanging due to
running out of memory, each of these commands can take a while to
complete. So it's best to have them all ready to go before you mount
the file system, and the problem starts happening. Best if you can
issue the commands more than once as the problem gets worse, if you
can keep them all organized and labeled.

Then attach them (rather than pasting them into the message).


> I tried to zero the log hoping it wouldn't restart after a reboot but
> that didn't work

Yeah don't just start randomly hitting the fs with a hammer like
zeroing the log tree. That's for a specific problem and this isn't it.


> I am assuming that the attempt to remove the snapshots caused this
> problem.  How do I interrupt the process so I can access the
> filesystem again?

Snapshot creation is essentially free. Snapshot removal is expensive.
There's no way to answer your questions because your email doesn't
even include a call trace. So a developer will need at least the call
trace, but there might be some other useful information in a sysrq +
t, as well as the allocation states.



> # btrfs fi df /pubroot
> Data, RAID1: total=5.58TiB, used=5.58TiB
> System, RAID1: total=32.00MiB, used=828.00KiB
> System, single: total=4.00MiB, used=0.00B
> Metadata, RAID1: total=104.00GiB, used=70.64GiB
> GlobalReserve, single: total=512.00MiB, used=28.51MiB

Later, after this problem is solved, you'll want to get rid of that
single system chunk that isn't being used, but might cause a problem
in a device failure.

sudo btrfs balance start -mconvert=raid1,soft <mp>


-- 
Chris Murphy
