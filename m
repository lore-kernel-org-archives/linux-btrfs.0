From: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Subject: Re: [patch 0/2] grub-0.97: btrfs support
Date: Fri, 11 Dec 2009 00:15:46 +0100
Message-ID: <200912110016.04548.johannes.hirte@fem.tu-ilmenau.de>
References: <4ABBED5F.6000008@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Cc: The development of BTRFS <linux-btrfs@vger.kernel.org>
To: Edward Shishkin <edward.shishkin@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4ABBED5F.6000008@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Am Freitag 25 September 2009 00:06:23 schrieb Edward Shishkin:
> Hello everyone.
... 
> The following patches are for Fedora 10(**).
> The distro-independent package will be put to kernel.org a bit later.
> 
> 
> All comments, bugreports, etc. are welcome as usual.

Ok, I have another comment/bugreport *g*.

I'm testing this patch with gentoo, so the grub sources are not identicaly the 
same. With this patches applied, grub is unable to detect JFS or XFS 
filesystems. XFS is reported as unknown, JFS is reported as btrfs. Reiserfs and 
ext2/3 are detected as expected.

regards,
  Johannes
