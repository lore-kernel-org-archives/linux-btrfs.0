From: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: Multiple btrfsck inode error 400 on Unclean Shutdowns
Date: Mon, 9 Jan 2012 13:27:59 -0600
Message-ID: <CAKcLGm-J=mhiZt8tOc_27gQYkSSkz2EpVDvgCVFgiDUZon_fow@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Lately, I've been running into a sharp increase in btrfsck inode 400
corruptions after an unclean shutdown.

The shutdowns have resulted from multiple sources (power outage, Xorg
keyboard misconfiguration, etc...).  I have not made any systematic
study of btrfs' robustness to corruption after an unclean shutdown,
but I've had at least 4 btrfs partitions report btrfsck inode 400
corruptions after unclean shutdowns.  That seems frequent enough for
me to develop concerns that a regression has slipped in somewhere.
Then again, maybe I'm just unlucky (I know you can't guarantee a
shutdown won't lead to a potential corruption).

So far, the impact of these corruptions has been minor.  I've been
able to pull the data from the partition without error for a reformat.
 However, I see numerous errors reported if I try to run a balance
once I get reports of btrfsck inode 400 corruptions.

Even though the impact of this corruption is minor, this frequency of
issues after an unclean shutdown seems much higher than I encounter
with competing file systems.

Has anybody else been encountering an increase in btrfsck inode 400
errors recently?
