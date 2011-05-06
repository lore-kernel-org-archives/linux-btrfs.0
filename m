From: Sander <sander@humilis.net>
Subject: Re: Cannot Deinstall a Debian Package
Date: Fri, 6 May 2011 15:21:58 +0200
Message-ID: <20110506132158.GA20200@attic.humilis.net>
References: <201105031227.43619.CACook@quantum-sci.com>
 <201105060509.31652.CACook@quantum-sci.com>
 <20110506122028.GA3735@attic.humilis.net>
 <201105060558.00314.CACook@quantum-sci.com>
Reply-To: sander@humilis.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: CACook@quantum-sci.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201105060558.00314.CACook@quantum-sci.com>
List-ID: <linux-btrfs.vger.kernel.org>

CACook@quantum-sci.com wrote (ao):
> On Friday 6 May, 2011 05:20:28 Sander wrote:
> > Can you post the error?

> Do you want to continue [Y/n]? 
> Setting up linux-image-2.6.38-2-amd64 (2.6.38-3) ...

> /usr/sbin/grub-probe: error: cannot stat `/dev/root'.
> run-parts: /etc/kernel/postinst.d/zz-update-grub exited with return code 1
> Failed to process /etc/kernel/postinst.d at /var/lib/dpkg/info/linux-image-2.6.38-2-amd64.postinst line 801, <STDIN> line 7.
> dpkg: error processing linux-image-2.6.38-2-amd64 (--configure):
>  subprocess installed post-installation script returned error exit status 9
> configured to not write apport reports
>                                       Setting up grub-pc (1.99~rc1-13) ...
> grub-probe: error: cannot stat `/dev/root'.
> Installation finished. No error reported.
> /usr/sbin/grub-probe: error: cannot stat `/dev/root'.

Can you try:

dpkg -i /var/cache/apt/archives/grub-pc_1.99~rc1-13_amd64.deb
apt-get dist-upgrade

If that (second step) doesn't work:

echo "true" > /var/lib/dpkg/info/grub-installer.postinst
apt-get dist-upgrade

grub-install /dev/sda
update-grub

	Sander

-- 
Humilis IT Services and Solutions
http://www.humilis.net
