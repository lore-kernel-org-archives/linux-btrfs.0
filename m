From: Sander <sander@humilis.net>
Subject: Re: Cannot Deinstall a Debian Package
Date: Fri, 6 May 2011 08:49:33 +0200
Message-ID: <20110506064933.GC27068@attic.humilis.net>
References: <201105031227.43619.CACook@quantum-sci.com>
 <201105050749.09690.CACook@quantum-sci.com>
 <BANLkTi=_mucea2-nPE54dgkuR3B9mU0o7g@mail.gmail.com>
 <201105051250.03335.CACook@quantum-sci.com>
 <1304625253-sup-3665@think>
Reply-To: sander@humilis.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: CACook <cacook@quantum-sci.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1304625253-sup-3665@think>
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason wrote (ao):
> I'm happy to patch up bugs in the FS (or point you to newer
> kernels that have them fixed) but at this point we don't have enough
> info to say if it is an FS problem or a debian package problem.
> 
> Perhaps if you ran it under strace?
> 
> Other distros don't have problems with btrfs on /, so somehow this is
> specific to debian's setup.

I believe this is fixed in Debian testing/unstable:
http://packages.debian.org/changelogs/pool/main/g/grub2/grub2_1.99~rc1-13/changelog

"grub2 (1.99~20110106-1) experimental; urgency=low

   * New Bazaar snapshot.
     - Check that named RAID array devices exist before using them
       (closes:
       #606035).
     - Clear terminfo output on initialisation (closes: #569678).
     - Fix grub-probe when btrfs is on / without a separate /boot.
"

	Sander

-- 
Humilis IT Services and Solutions
http://www.humilis.net
