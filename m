From: Marcin Kuk <marcin.kuk@gmail.com>
Subject: compress-force option problem
Date: Fri, 10 Dec 2010 18:05:08 +0100
Message-ID: <AANLkTinTWFt=yD8u_w-Ex20BMDXQs+kVZjXs4FJmZmOY@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I have problem with options passed during mounting btrfs filesystem.

Distro: Debian Squeeze with XEN
# uname -a
Linux terminator 2.6.32-5-xen-686 #1 SMP Thu Nov 25 23:23:08 UTC 2010
i686 GNU/Linux

If I am trying mount with -o compress - it work perfectly:

# mount -o compress /dev/vg0_terminator/test /mnt/backup/

# dmesg |tail
[509543.214592] btrfs: use compression
[509619.841842] device fsid d44c18f154fc7778-4f5d69fd40c5a1ba devid 1
transid 450 /dev/mapper/vg0_terminator-test

But -o compress-force or -o compress=lzo or -o compress-zlib didn't work:

# mount -o compress-force /dev/vg0_terminator/test /mnt/backup/
mount: wrong fs type, bad option, bad superblock on
/dev/mapper/vg0_terminator-test,
       missing codepage or helper program, or other error
       In some cases useful info is found in syslog - try
       dmesg | tail  or so

# dmesg |tail

[509234.944346] btrfs: unrecognized mount option 'compress=zlib'
[509234.944762] btrfs: open_ctree failed
[509295.321244] device fsid d44c18f154fc7778-4f5d69fd40c5a1ba devid 1
transid 446 /dev/mapper/vg0_terminator-test
[509295.322282] btrfs: unrecognized mount option 'compress=lzo'
[509295.322681] btrfs: open_ctree failed
[509543.213575] device fsid d44c18f154fc7778-4f5d69fd40c5a1ba devid 1
transid 446 /dev/mapper/vg0_terminator-test
[509619.842888] btrfs: unrecognized mount option 'compress-force'
[509619.843280] btrfs: open_ctree failed

The same is on my laptop with Ubuntu 10.10 without XEN installed.

Any suggestion?

Best regards,
Marcin Kuk
