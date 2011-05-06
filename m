From: Sander <sander@humilis.net>
Subject: Re: Cannot Deinstall a Debian Package
Date: Fri, 6 May 2011 08:33:33 +0200
Message-ID: <20110506063333.GA27068@attic.humilis.net>
References: <201105031227.43619.CACook@quantum-sci.com>
 <201105031520.49993.CACook@quantum-sci.com>
 <20110504095153.GA6914@attic.humilis.net>
 <201105050749.09690.CACook@quantum-sci.com>
Reply-To: sander@humilis.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: CACook@quantum-sci.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201105050749.09690.CACook@quantum-sci.com>
List-ID: <linux-btrfs.vger.kernel.org>

CACook@quantum-sci.com wrote (ao):
> On Wednesday 4 May, 2011 02:51:54 Sander wrote:
> > Put an exit on top of /etc/kernel/postrm.d/zz-update-grub and try again.
> > 
> > Install grub-pc 1.99~rc1-13 from Sid.
> 
> First I put an exit right after #! /bin/sh  and it failed.  Then I
> moved /etc/kernel/postrm.d/zz-update-grub to / and it still failed.


> # dpkg -i /var/cache/apt/archives/grub-pc_1.99~rc1-13_amd64.deb 
> (Reading database ... 136703 files and directories currently installed.)
> Preparing to replace grub-pc 1.99~rc1-13 (using .../grub-pc_1.99~rc1-13_amd64.deb) ...
> Unpacking replacement grub-pc ...
> Setting up grub-pc (1.99~rc1-13) ...
> grub-probe: error: cannot stat `/dev/root'.
> Installation finished. No error reported.
> /usr/sbin/grub-probe: error: cannot stat `/dev/root'.

Can you do:

echo "true" > /var/lib/dpkg/info/grub-installer.postinst

and try again?

	Sander

-- 
Humilis IT Services and Solutions
http://www.humilis.net
