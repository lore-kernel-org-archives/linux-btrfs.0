From: miyamoto moesasji <miyamoto.31b@gmail.com>
Subject: Unexpected ENOSPC on a SSD-drive after day of uptime, kernel
	2.6.32-rc5
Date: Thu, 5 Nov 2009 20:38:18 +0000
Message-ID: <fe72f2c80911051238y299bab12g5f4b878851a25f13@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I've just finished installing onto an OCZ Agilent v2 SSD with btrfs as
filesystem. However to my surprise I've hit an ENOSPC condition one
one of the partitions within less than a day of uptime, while the
filesystem on that partition only reported 50% to be in use, which is
far from the 75% limit people mention on the ML.

Note that this occurs using a vanilla 2.6.32-rc5 kernel on a 64-bit
gentoo system.

Error-message from logs:

2009-11-05T07:55:57.586574+00:00 PulsarX4 kernel: [  136.095961] no
space left, need 4096, 4440064 delalloc bytes, 10704142336 bytes_used,
0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use
10708582400 total
2009-11-05T07:55:57.645314+00:00 PulsarX4 kernel: [  136.154217] no
space left, need 4096, 4448256 delalloc bytes, 10704134144 bytes_used,
0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use
10708582400 total

Further details:

0) The partition that reports ENOSPC is mounted as:
/dev/sda3		/usr			btrfs		defaults,rw,nodev,noatime					

1) df -h reports : /dev/sda3              21G   11G  9.5G  53% /usr

2) btrfs-show :
Label: none  uuid: 0a89100d-096d-4c67-b3c7-745c9b7c3dc5
	Total devices 1 FS bytes used 10.60GB
	devid    1 size 20.00GB used 20.00GB path /dev/sda3

3) The other partitions using btrfs show a similar relatively large
difference between the space reported by df -h and the size being
taken up according to btrfs-show.

Although this potentially is a problem between screen and chair I
don't see what I am doing wrong. Note that the ENOSPC issue occurs on
a partition that still allows me to boot, so it is possible to run
tests if needed when this indeed turns out to be a bug.

Please let me know in case I need to provide further details from the logs.
