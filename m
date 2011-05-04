From: Sander <sander@humilis.net>
Subject: Re: Cannot Deinstall a Debian Package
Date: Wed, 4 May 2011 11:51:54 +0200
Message-ID: <20110504095153.GA6914@attic.humilis.net>
References: <201105031227.43619.CACook@quantum-sci.com>
 <BANLkTinPUPM6+iNUvYfx0_C-Wt32eb_1jQ@mail.gmail.com>
 <201105031520.49993.CACook@quantum-sci.com>
Reply-To: sander@humilis.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: CACook@quantum-sci.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201105031520.49993.CACook@quantum-sci.com>
List-ID: <linux-btrfs.vger.kernel.org>

CACook@quantum-sci.com wrote (ao):
> I would be happy to upgrade grub, but the package management system is
> jammed because of this.

Put an exit on top of /etc/kernel/postrm.d/zz-update-grub and try again.

Install grub-pc 1.99~rc1-13 from Sid.

http://packages.debian.org/changelogs/pool/main/g/grub2/grub2_1.99~rc1-13/changelog

	Sander

-- 
Humilis IT Services and Solutions
http://www.humilis.net
