From: CACook@quantum-sci.com
Subject: Re: Cannot Deinstall a Debian Package
Date: Fri, 6 May 2011 06:56:10 -0700
Message-ID: <201105060656.12544.CACook@quantum-sci.com>
References: <201105031227.43619.CACook@quantum-sci.com> <201105060558.00314.CACook@quantum-sci.com> <20110506132158.GA20200@attic.humilis.net>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
To: "linux-btrfs" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110506132158.GA20200@attic.humilis.net>
List-ID: <linux-btrfs.vger.kernel.org>


Same old problem.

On Friday 6 May, 2011 06:21:58 Sander wrote:
> Can you try:
> 
> dpkg -i /var/cache/apt/archives/grub-pc_1.99~rc1-13_amd64.deb
> apt-get dist-upgrade

# dpkg -i /var/cache/apt/archives/grub-pc_1.99~rc1-13_amd64.deb
(Reading database ... 135273 files and directories currently installed.)
Preparing to replace grub-pc 1.99~rc1-13 (using .../grub-pc_1.99~rc1-13_amd64.deb) ...
Unpacking replacement grub-pc ...
Setting up grub-pc (1.99~rc1-13) ...
grub-probe: error: cannot stat `/dev/root'.
Installation finished. No error reported.
/usr/sbin/grub-probe: error: cannot stat `/dev/root'.
dpkg: error processing grub-pc (--install):
 subprocess installed post-installation script returned error exit status 1
Processing triggers for man-db ...
Errors were encountered while processing:
 grub-pc
#

> If that (second step) doesn't work:
> 
> echo "true" > /var/lib/dpkg/info/grub-installer.postinst
> apt-get dist-upgrade

# echo "true" > /var/lib/dpkg/info/grub-installer.postinst
# dpkg -i /var/cache/apt/archives/grub-pc_1.99~rc1-13_amd64.deb
(Reading database ... 135273 files and directories currently installed.)
Preparing to replace grub-pc 1.99~rc1-13 (using .../grub-pc_1.99~rc1-13_amd64.deb) ...
Unpacking replacement grub-pc ...
Setting up grub-pc (1.99~rc1-13) ...
grub-probe: error: cannot stat `/dev/root'.
Installation finished. No error reported.
/usr/sbin/grub-probe: error: cannot stat `/dev/root'.
dpkg: error processing grub-pc (--install):
 subprocess installed post-installation script returned error exit status 1
Processing triggers for man-db ...
Errors were encountered while processing:
 grub-pc

# which update-grub
/usr/sbin/update-grub
# /usr/sbin/update-grub -v
grub-mkconfig (GRUB) 1.99~rc1-13

Apparently 1.99~rc1-13 is installed and synaptic confirms this, despite the script failure, although every .mod file in /usr/lib/grub is in the i386-pc directory.  I'm running 64bit Debian Testing with kernel 2.6.37-2.




