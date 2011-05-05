From: Lars Wirzenius <liw@liw.fi>
Subject: Re: Cannot Deinstall a Debian Package
Date: Thu, 05 May 2011 21:59:23 +0100
Message-ID: <1304629163.11048.7.camel@havelock.liw.fi>
References: <201105031227.43619.CACook@quantum-sci.com>
	 <201105051250.03335.CACook@quantum-sci.com>
	 <BANLkTinkhtYYFx+eKQzdrRDSvpgEiPHzpQ@mail.gmail.com>
	 <201105051357.07209.CACook@quantum-sci.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: CACook@quantum-sci.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201105051357.07209.CACook@quantum-sci.com>
List-ID: <linux-btrfs.vger.kernel.org>

On to, 2011-05-05 at 13:57 -0700, CACook@quantum-sci.com wrote:
> On Thursday 5 May, 2011 13:31:17 cwillu wrote:
> > I took the liberty of asking #debian, and they've requested that you
> > file a bug in their bug tracker.  They've also suggested that you
> > might be able to short-circuit the faulty script in their kernel
> > package via an "exit 0", or even replace the faulty grub-probe by
> > manually extracting the newer version of the package.
> 
> I tried to install Debian's reportbug, but of course I can't.  And assembling the info they need for email reporting will take me a half day of analysis.  Part of the problem here is I am trying desperately to make a living in another line of business, and I don't have time for any of these problems.
> 
> I don't know how to manually extract a package.  I guess it's done with dpkg, but that will take more time for me to figure out.  I've lost half of today already on this problem.

dpkg --fsys-tarfile foo.deb | tar -C / -tf -

change -t to -x to actually extract


