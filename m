From: CACook@quantum-sci.com
Subject: Cannot Deinstall a Debian Package
Date: Tue, 3 May 2011 12:27:43 -0700
Message-ID: <201105031227.43619.CACook@quantum-sci.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
To: "linux-btrfs" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


Having a failure that may be because grub2 doesn't BTRFS.  /boot is ext3 and / is BTRFS.

# dpkg -r linux-image-2.6.32-5-amd64
(Reading database ... 136673 files and directories currently installed.)
Removing linux-image-2.6.32-5-amd64 ...
Examining /etc/kernel/postrm.d .
run-parts: executing /etc/kernel/postrm.d/initramfs-tools 2.6.32-5-amd64 /boot/vmlinuz-2.6.32-5-amd64
run-parts: executing /etc/kernel/postrm.d/zz-update-grub 2.6.32-5-amd64 /boot/vmlinuz-2.6.32-5-amd64
/usr/sbin/grub-probe: error: cannot find a device for / (is /dev mounted?).
run-parts: /etc/kernel/postrm.d/zz-update-grub exited with return code 1
Failed to process /etc/kernel/postrm.d at /var/lib/dpkg/info/linux-image-2.6.32-5-amd64.postrm line 234.
dpkg: error processing linux-image-2.6.32-5-amd64 (--remove):
 subprocess installed post-removal script returned error exit status 1
Errors were encountered while processing:
 linux-image-2.6.32-5-amd64

I can't install or remove packages, of do my dist-upgrades.  What gives?

