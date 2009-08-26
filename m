From: Joel Reed <joelwreed@gmail.com>
Subject: btrfsctl -a doesn't find my btrfs
Date: Wed, 26 Aug 2009 15:11:20 -0400
Message-ID: <4A9588D8.7020208@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

If I scan I device with a btrfs with -A, it finds it:

(~/btrfs-progs-unstable) sudo ./btrfsctl -A /dev/sda5
operation complete
Btrfs v0.19-1-g4f89b6e-dirty

But when I do a "scan all devices", it can't find my btrfs on /dev/sda5:

(~/btrfs-progs-unstable) sudo ./btrfsctl -a
Scanning for Btrfs filesystems
failed to read /dev/sr0

I'm using btrfs-progs-unstable version 
4f89b6eb0718ade63152791db32794da78fbba70. Am I doing something wrong or 
misinterpreting how btrfsctl works?

I notice that "-a" does a:

     ret = btrfs_scan_one_device(fd, fullpath, &tmp_devices,
&num_devices,
               BTRFS_SUPER_INFO_OFFSET);

Whereas "-A" does a:

     fd = open("/dev/btrfs-control", O_RDWR);
     if (fd < 0) {
       perror("failed to open /dev/btrfs-control");
       exit(1);
     }

Followed by a:

  ret = ioctl(fd, BTRFS_IOC_SCAN_DEV, &args);

Should "-a" be taught to follow "-A"? I could make a patch if so...

jr
