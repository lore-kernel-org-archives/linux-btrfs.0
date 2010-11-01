From: Giangiacomo Mariotti <gg.mariotti@gmail.com>
Subject: btrfs debug messages useless?
Date: Mon, 1 Nov 2010 22:45:33 +0100
Message-ID: <AANLkTinhT-g4-Fe6PvqDhy-KpNtROaBY2KdvoF_01Axd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I have some partitions on my pc formatted with btrfs and every time I
get errors about one of them I can never identify it. I mean, today I
got this:

[58817.942531] btrfs bad tree block start 4294967297 23652478976
[58817.942899] btrfs bad tree block start 4294967297 23652478976

What am I supposed to get from this? How do I identify the partition
that has this problem?

All the other fs, while reporting problems, print the partition
they're talking about. btrfs doesn't. Why?

I didn't want to report this because I thought it was just a matter of
time before this would have been solved, but in the end I decided to
post here, at least to try to understand if it's just me who's unable
to understand how to solve this.

-- 
Giangiacomo
