From: "Fajar A. Nugraha" <list@fajar.net>
Subject: Compression: per filesystem, or per subvolume?
Date: Sun, 8 May 2011 20:35:37 +0700
Message-ID: <BANLkTimwMnmS4jw=uwimm8b18662jO-Myw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Currently using Ubuntu Natty, kernel 2.6.38-9-generic, I have these
mount points using btrs subvolumes

$ mount -t btrfs
/dev/sda2 on / type btrfs (rw,noatime,subvolid=256,compress-force=zlib)
/dev/sda2 on /home type btrfs (rw,noatime,subvolid=258,compress=lzo)

Yet dmesg seems to show only zlib compression enabled
$ dmesg | grep btrfs
[   11.097908] btrfs: force zlib compression

Is this by design, or a bug?

-- 
Fajar
