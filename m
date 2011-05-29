From: Jeff Putney <jeffrey.putney@gmail.com>
Subject: Reboot during rebalance, now unmountable
Date: Sat, 28 May 2011 20:30:00 -0500
Message-ID: <BANLkTinufzVhpF5jEA+mQz=uC+RFh4BJ3Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I've read the entire thread "Oops while rebalancing, now unmountable."
and it ended without any information about repairing the fs.  (the web
page wouldn't let me post a reply to that thread tho.)

Has there been any info?  The fs was working fine until I rebooted.

thanks for any info!

--jeff

root@aurora:~/btrfs-progs-unstable# uname -a
Linux aurora 2.6.38-8-generic-pae #42-Ubuntu SMP Mon Apr 11 05:17:09
UTC 2011 i686 i686 i386 GNU/Linux

root@aurora:~/btrfs-progs-unstable# mount -t btrfs -r -o
defaults,relatime,compress,space_cache /dev/dm-0 /mnt
mount: wrong fs type, bad option, bad superblock on /dev/mapper/put--vg-put,
       missing codepage or helper program, or other error
       In some cases useful info is found in syslog - try
       dmesg | tail  or so

root@aurora:~/btrfs-progs-unstable# dmesg |tail -6
[33472.371273] device label putBtrfs devid 1 transid 519691
/dev/mapper/put--vg-put
[33472.373079] btrfs: use zlib compression
[33472.373083] btrfs: enabling disk space caching
[33478.399721] btrfs: dm-0 checksum verify failed on 12883853500416
wanted 9E7E27F5 found CC775767 level 0
[33478.399733] Failed to read block groups: -5
[33478.420497] btrfs: open_ctree failed

root@aurora:~/btrfs-progs-unstable# ./btrfsck -s 0 /dev/dm-0
using SB copy 0, bytenr 65536
checksum verify failed on 12883853500416 wanted CC775767 found FFFFFFF5
Segmentation fault
root@aurora:~/btrfs-progs-unstable# ./btrfsck -s 1 /dev/dm-0
using SB copy 1, bytenr 67108864
checksum verify failed on 12883853500416 wanted CC775767 found FFFFFFF5
Segmentation fault
root@aurora:~/btrfs-progs-unstable# ./btrfsck -s 2 /dev/dm-0
using SB copy 2, bytenr 274877906944
checksum verify failed on 12883853500416 wanted CC775767 found FFFFFFF5
Segmentation fault
root@aurora:~/btrfs-progs-unstable# ./btrfsck -s 3 /dev/dm-0
using SB copy 3, bytenr 1125899906842624
No valid Btrfs found on /dev/dm-0
