From: Sander <sander@humilis.net>
Subject: Re: Cannot Deinstall a Debian Package
Date: Fri, 6 May 2011 16:17:00 +0200
Message-ID: <20110506141659.GA1804@attic.humilis.net>
References: <201105031227.43619.CACook@quantum-sci.com>
 <201105060558.00314.CACook@quantum-sci.com>
 <20110506132158.GA20200@attic.humilis.net>
 <201105060656.12544.CACook@quantum-sci.com>
Reply-To: sander@humilis.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: CACook@quantum-sci.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201105060656.12544.CACook@quantum-sci.com>
List-ID: <linux-btrfs.vger.kernel.org>

CACook@quantum-sci.com wrote (ao):
> # dpkg -i /var/cache/apt/archives/grub-pc_1.99~rc1-13_amd64.deb
> (Reading database ... 135273 files and directories currently installed.)
> Preparing to replace grub-pc 1.99~rc1-13 (using .../grub-pc_1.99~rc1-13_amd64.deb) ...
> Unpacking replacement grub-pc ...
> Setting up grub-pc (1.99~rc1-13) ...
> grub-probe: error: cannot stat `/dev/root'.

Hm. Just do cp /bin/true /usr/sbin/grub-probe

	Sander

-- 
Humilis IT Services and Solutions
http://www.humilis.net
