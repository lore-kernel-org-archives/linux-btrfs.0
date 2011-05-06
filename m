From: CACook@quantum-sci.com
Subject: Re: Cannot Deinstall a Debian Package
Date: Fri, 6 May 2011 05:57:59 -0700
Message-ID: <201105060558.00314.CACook@quantum-sci.com>
References: <201105031227.43619.CACook@quantum-sci.com> <201105060509.31652.CACook@quantum-sci.com> <20110506122028.GA3735@attic.humilis.net>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
To: "linux-btrfs" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110506122028.GA3735@attic.humilis.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Friday 6 May, 2011 05:20:28 Sander wrote:
> Can you post the error?

# apt-get dist-upgrade
Reading package lists... Done
Building dependency tree       
Reading state information... Done
Calculating upgrade... Done
0 upgraded, 0 newly installed, 0 to remove and 0 not upgraded.
3 not fully installed or removed.
After this operation, 0 B of additional disk space will be used.
Do you want to continue [Y/n]? 
Setting up linux-image-2.6.38-2-amd64 (2.6.38-3) ...
Running depmod.
Running update-initramfs.
update-initramfs: Generating /boot/initrd.img-2.6.38-2-amd64
initrd.img(/boot/initrd.img-2.6.38-2-amd64
) points to /boot/initrd.img-2.6.38-2-amd64
 (/boot/initrd.img-2.6.38-2-amd64) -- doing nothing at /var/lib/dpkg/info/linux-image-2.6.38-2-amd64.postinst line 348, <STDIN> line 7.
vmlinuz(/boot/vmlinuz-2.6.38-2-amd64
) points to /boot/vmlinuz-2.6.38-2-amd64
 (/boot/vmlinuz-2.6.38-2-amd64) -- doing nothing at /var/lib/dpkg/info/linux-image-2.6.38-2-amd64.postinst line 348, <STDIN> line 7.
Examining /etc/kernel/postinst.d.
run-parts: executing /etc/kernel/postinst.d/dkms 2.6.38-2-amd64 /boot/vmlinuz-2.6.38-2-amd64
dkms: running auto installation service for kernel 2.6.38-2-amd64:
      vboxhost (3.2.12)...failed.
run-parts: executing /etc/kernel/postinst.d/initramfs-tools 2.6.38-2-amd64 /boot/vmlinuz-2.6.38-2-amd64
run-parts: executing /etc/kernel/postinst.d/pm-utils 2.6.38-2-amd64 /boot/vmlinuz-2.6.38-2-amd64
run-parts: executing /etc/kernel/postinst.d/update-notifier 2.6.38-2-amd64 /boot/vmlinuz-2.6.38-2-amd64
run-parts: executing /etc/kernel/postinst.d/zz-update-grub 2.6.38-2-amd64 /boot/vmlinuz-2.6.38-2-amd64
/usr/sbin/grub-probe: error: cannot stat `/dev/root'.
run-parts: /etc/kernel/postinst.d/zz-update-grub exited with return code 1
Failed to process /etc/kernel/postinst.d at /var/lib/dpkg/info/linux-image-2.6.38-2-amd64.postinst line 801, <STDIN> line 7.
dpkg: error processing linux-image-2.6.38-2-amd64 (--configure):
 subprocess installed post-installation script returned error exit status 9
configured to not write apport reports
                                      Setting up grub-pc (1.99~rc1-13) ...
grub-probe: error: cannot stat `/dev/root'.
Installation finished. No error reported.
/usr/sbin/grub-probe: error: cannot stat `/dev/root'.
dpkg: error processing grub-pc (--configure):
 subprocess installed post-installation script returned error exit status 1
configured to not write apport reports
                                      dpkg: dependency problems prevent configuration of linux-image-2.6-amd64:
 linux-image-2.6-amd64 depends on linux-image-2.6.38-2-amd64; however:
  Package linux-image-2.6.38-2-amd64 is not configured yet.
dpkg: error processing linux-image-2.6-amd64 (--configure):
 dependency problems - leaving unconfigured
configured to not write apport reports
                                      Errors were encountered while processing:
 linux-image-2.6.38-2-amd64
 grub-pc
 linux-image-2.6-amd64
E: Sub-process /usr/bin/dpkg returned an error code (1)
