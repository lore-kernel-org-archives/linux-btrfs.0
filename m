From: "Sebastian 'gonX' Jensen" <gonx@overclocked.net>
Subject: Regarding full drives
Date: Tue, 13 Apr 2010 02:21:52 +0200
Message-ID: <s2q8a48dc7a1004121721xb76d004et6d5d84abd7c9f86b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I'm by no means a Linux guru... but btrfs-show shows me as not being
entirely full (about 100gb free, so 90% full), and so does df.

Yet I still got this in dmesg:

[45219.275507] no space left, need 4096, 0 delalloc bytes,
886547939328 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0
bytes_readonly, 0 may use 886547939328 total

Obviously the drive is full, but with compress enabled I'm surprised
it did it already when it was about 90% full, even though I had heard
about this before.
I've cleaned a bit up on the drives now, but I just want to know
whether this is a bug that has to be filed, or if this still isn't
completely fixed.

I'm running RAID-0 on metadata and data over 5 drives. I rebalanced
the array a couple of days ago, but I'm not sure if it finished
entirely when I rebooted the computer the next day (perhaps this could
have something to do with it?)

My latest commit is 9f680ce04ea19dabbbafe01b57b61930a9b70741 - so it
_is_ up to date.

Regards,
Sebastian J.
