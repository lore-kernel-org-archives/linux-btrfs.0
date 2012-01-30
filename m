From: lutz.euler@freenet.de (Lutz Euler)
Subject: Spurious ENOSPC while filling a filesystem with rsync
Date: Mon, 30 Jan 2012 20:04:04 +0100
Message-ID: <20262.59812.23853.734233@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I was rsyncing some 54 GB onto a newly created btrfs filesystem,
both metadata and data in RAID1 and using lzo compression, when
after transferring less than half of the amount rsync stopped
with "no space left on device", while the destination filesystem
was less than half filled. I started rsync again shortly afterwards
and it finished the copy without further problems.

The filesystem is doing just fine now, there were no errors logged
to syslog, I don't know whether this is reproducible (didn't try),
but, as I am AFAIK using the newest version of the software involved,
I send this mail just to say: It is still possible to get an unwarrante=
d
ENOSPC with btrfs.

Please see below for the details.

Thanks for working on btrfs! Regards,

Lutz

Kernel: v3.3-rc1-383-g0a96265
uname -a: Linux test 3.3.0-rc1 #1 SMP PREEMPT Sun Jan 29 16:06:29 CET
  2012 x86_64 x86_64 x86_64 GNU/Linux
btrfs-progs: cloned on 2012-01-25 from
  git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git,
  latest commit is fdb6c0402337d9607c7a39155088eaf033742752.
OS: Ubuntu 11.04.

The source filesystem is ext4 on an SSD.
The destination is another SSD (sdb), partitioned into 2 x 40 GB.
The filesystem was created like so:
# mkfs.btrfs -d raid1 -m raid1 /dev/sdb1 /dev/sdb2
# btrfs device scan
I made an entry in /etc/fstab:
UUID=3D88af7576-3027-4a3b-a5ae-34bfd167982f /mnt btrfs compress=3Dlzo 0=
 0
# mount /mnt
# grep sdb /proc/mounts
/dev/sdb1 /mnt btrfs rw,relatime,compress=3Dlzo,ssd,space_cache 0 0

The rsync call was:
$ time rsync -ax --delete test /mnt

After 17 minutes rsync stopped with "No space left on device",
but there was still lots of space:

$ df -h /mnt
Dateisystem            Size  Used Avail Use% Eingeh=E4ngt auf
/dev/sdb1              75G   31G   42G  43% /mnt
# btrfs fi show /dev/sdb1
Label: none  uuid: 88af7576-3027-4a3b-a5ae-34bfd167982f
	Total devices 2 FS bytes used 15.47GB
	devid    2 size 37.26GB used 21.01GB path /dev/sdb2
	devid    1 size 37.26GB used 21.03GB path /dev/sdb1

I issued the same rsync call a few minutes later and after another
17 minutes it finished successfully. The filesystem is still not full:

$ df -h /mnt
Dateisystem            Size  Used Avail Use% Eingeh=E4ngt auf
/dev/sdb1              75G   62G   12G  85% /mnt
# btrfs fi show /dev/sdb1
Label: none  uuid: 88af7576-3027-4a3b-a5ae-34bfd167982f
	Total devices 2 FS bytes used 30.92GB
	devid    2 size 37.26GB used 37.25GB path /dev/sdb2
	devid    1 size 37.26GB used 37.26GB path /dev/sdb1
$ du -sh /mnt
54G	/mnt
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
