Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailer.moparscape.org ([144.76.72.168]:56414 "EHLO
	mailer.moparscape.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597AbaLER3C (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Dec 2014 12:29:02 -0500
Message-ID: <5481EB59.2020603@moparisthebest.com>
Date: Fri, 05 Dec 2014 12:28:57 -0500
From: moparisthebest <admin@moparisthebest.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: abort device removal?
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello all,

I had a 6-device array I added a 4tb device to last night and ran the
command to remove a previous 4tb device that still worked fine
overnight.  Unfortunately, one of the OTHER devices completely failed
while this was happening, and it *looks* like btrfs did the right thing
and stopped the move, except it's still marked as 0 space in btrfs fi
show.  The delete command is still running, though iotop shows it's not
actually reading or writing anything and no further moving messages in
dmesg/kern.log seems to indicate that too.

So what I think I *need* to do is re-add the drive it's currently trying
to remove so I can delete the now non-functioning other drive without
losing any data.  My fear is a reboot or unmount/remount will fail to
mount the currently-being-removed drive as well causing me to lose
everything.

Here is some relevant info from the system:
# uname -a
Linux mytorrentflux1 3.13.0-40-generic #69-Ubuntu SMP Thu Nov 13
17:53:56 UTC 2014 x86_64 x86_64 x86_64 GNU/Linux
# btrfs --version
Btrfs v3.17.3
# btrfs fi show
Label: 'completed'  uuid: 0d14bb0f-46cc-408e-9245-f06d50ec2da8
        Total devices 7 FS bytes used 7.60TiB
        devid    1 size 3.64TiB used 3.28TiB path /dev/mapper/fourtb1
        devid    2 size 3.64TiB used 3.29TiB path /dev/mapper/fourtb2
        devid    3 size 2.73TiB used 2.37TiB path /dev/mapper/threetb1
        devid    5 size 1.82TiB used 1.82TiB path /dev/mapper/twotb1
        devid    6 size 0.00B used 1.99TiB path /dev/mapper/fourtb3
        devid    7 size 2.73TiB used 2.22TiB path /dev/mapper/threetb2
        devid    8 size 3.64TiB used 240.29GiB path /dev/mapper/fourtb4

Btrfs v3.17.3
# btrfs fi df /mnt/completed/
Data, RAID10: total=6.26TiB, used=6.26TiB
Data, RAID1: total=1.33TiB, used=1.33TiB
System, RAID10: total=96.00MiB, used=852.00KiB
Metadata, RAID10: total=10.77GiB, used=9.90GiB
Metadata, RAID1: total=5.00GiB, used=4.37GiB

fourtb4 is the new drive I just added, fourtb3 is the functioning drive
I attempted to remove before threetb1 completely failed (smartctl can't
even read anything from it, well, from the underlying device)

dmesg/kern.log is too large too attach, here are some important-looking
excerpts (3 lines often repeated):
Dec  5 09:59:35 mytorrentflux1 kernel: [1549876.646751] btrfs: bdev
/dev/mapper/threetb1 errs: wr 17599, rd 973, flush 0, corrupt 0, gen 0
Dec  5 09:59:35 mytorrentflux1 kernel: [1549877.022291] lost page write
due to I/O error on /dev/mapper/threetb1
Dec  5 10:07:08 mytorrentflux1 kernel: [1550329.743294]
btrfs_dev_stat_print_on_error: 264 callbacks suppressed

I appreciate any help or guidance I can get on this issue so I don't
lose data, hopefully.

Thanks much!
