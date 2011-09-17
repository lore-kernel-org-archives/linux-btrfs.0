From: Mansour <mansour@oxplot.com>
Subject: Data consistency for un-opened files at crash time
Date: Sat, 17 Sep 2011 13:00:07 +1000
Message-ID: <CAPV0TS6Ynsir885CMC7mz7u6gm3BB5P9ctCJKX6c1uFLome67A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Due to a recent crash of my PC which subsequently resulted in corruption
of my btrfs partition, I set out to research about file system
reliablity in general and btrfs in specific. I came across the numurous
accounts of corruption due to the use of btrfs with dm-crypt. I also
found Chris Mason's barrier test
http://oss.oracle.com/~mason/barrier-test. Having tested ext4 FS with
it, I could consistently corrupt it when on dm-crypt *with* barrier
mount option on.

As sad as it was finding about this issue, I decided to instead put a
plain btrfs for my home directory and mount ecryptfs at the top of it
for the time being. As for my backup btrfs partition which already has a
lot of COW trees - about a year worth of backup, this isn't a
possibility. I therefore devised a different plan, however, I need to
ensure a certain characteristic of btrfs before going ahead with it:

Let's assume we have a physical partition formatted as btrfs with no dm
layers in play - so we know write-barriers work ok. We then put a large
file (>500GB) on it called "apple".  Using COW cp, we copy it to a new
file called "orange". Now if we open orange and start writing randomly
in it and while writing, pull the power plug, is it gauranteed that
when we mount the fs next time, *apple* is intact - both in terms of
metadata and actual data?

Cheers,
Mansour
