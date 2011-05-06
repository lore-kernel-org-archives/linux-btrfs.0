From: Sander <sander@humilis.net>
Subject: Re: Cannot Deinstall a Debian Package
Date: Fri, 6 May 2011 08:43:50 +0200
Message-ID: <20110506064350.GB27068@attic.humilis.net>
References: <201105031227.43619.CACook@quantum-sci.com>
 <201105050749.09690.CACook@quantum-sci.com>
 <BANLkTi=_mucea2-nPE54dgkuR3B9mU0o7g@mail.gmail.com>
 <201105051250.03335.CACook@quantum-sci.com>
Reply-To: sander@humilis.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: CACook@quantum-sci.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201105051250.03335.CACook@quantum-sci.com>
List-ID: <linux-btrfs.vger.kernel.org>

CACook@quantum-sci.com wrote (ao):
> It's starting to look like BTRFS is just busted in Debian, and I'll
> have to reinstall everything over a different filesystem.  I hate to
> give up btrfs raid and snapshotting, but these failures are just
> unlivable.  Is Oracle aware of this?  I'll have to warn others in the
> various forums that BTRFS breaks Debian, because no one warned me.
> This is unlivable, not to mention unbelievable.

Btrfs in Debian is just fine. I run btrfs on all my x86 systems with
only /, no separate /boot. On ARM one needs a /boot as u-boot only
understands ext2.

If you start over, you need to install Debian Sid (unstable), which
contains the latest grub and newest kernel. After installation, just
edit your sources.list and replace 'sid' with 'squeeze' (current
stable).

But for now, lets just fix your system. See my other post.

Btw, just found out the hard way that grub doesn't support btrfs lzo
compression :-)

	Sander

-- 
Humilis IT Services and Solutions
http://www.humilis.net
