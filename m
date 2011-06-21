From: Jan Stilow <jstilow@mobileobjects.de>
Subject: Re: Applications using fsync cause hangs for several seconds every
 few minutes
Date: Tue, 21 Jun 2011 13:15:30 +0200
Message-ID: <4E007D52.4000509@mobileobjects.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

Nirbheek Chauhan <nirbheek <at> gentoo.org> writes:
> However, recently, perhaps with 2.6.39, or after I quickly started
> filling up my disk again, it has become impossible for me to work for
> long periods on my machine.
>
> Every few minutes, (I guess) when applications do fsync (firefox,
> xchat, vim, etc), all applications that use fsync() hang for several
> seconds, and applications that use general IO suffer extreme
> slowdowns. iotop shows various combinations of the processes listed
> below doing writes, and the total write as 2-3MB/s.
>
> [btrfs-dealloc-]
> [btrfs-submit-0]
> [btrfs-transacti]
> [btrfs-endio-wri]
> [flush-btrfs-1]

I'm using btrfs under a 2.6.39-ARCH kernel and run into the same issue.

In my case the [btrfs-submit-0] and [btrfs-transacti] shows up in iotop
and produce 99% of IO at the time a application is frozen. For something
like 10 to 30 seconds.

After a fresh boot everything runs quiet acceptable and goes worse over
the day. If I reboot the unmount process takes a lot of time something
up to 8 minutes. After the reboot everything is back to normal. At least
for a while.

I use snapshots on a daily base and have 20 active snapshots all the
time. Maybe this is the reason for the performance impact?

> What can I do to debug this issue? What other information should I
> supply? Could someone guide me on how to figure out why my machine is
> unusable now?

I have no solution for this problem. In fact a reboot helps me even if
only temporary. I also changed the IO scheduler, switched to laptop mode
and remounted the device. Neither of these helped.

Maybe someone else has any suggestion?

Thanks.

Jan Stilow
