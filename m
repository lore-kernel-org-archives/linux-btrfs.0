From: Sander <sander@humilis.net>
Subject: Re: Cannot Deinstall a Debian Package
Date: Fri, 6 May 2011 14:20:28 +0200
Message-ID: <20110506122028.GA3735@attic.humilis.net>
References: <201105031227.43619.CACook@quantum-sci.com>
 <201105050749.09690.CACook@quantum-sci.com>
 <20110506063333.GA27068@attic.humilis.net>
 <201105060509.31652.CACook@quantum-sci.com>
Reply-To: sander@humilis.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: CACook@quantum-sci.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201105060509.31652.CACook@quantum-sci.com>
List-ID: <linux-btrfs.vger.kernel.org>

CACook@quantum-sci.com wrote (ao):
> On Thursday 5 May, 2011 23:33:33 Sander wrote:
> > Can you do:
> > 
> > echo "true" > /var/lib/dpkg/info/grub-installer.postinst
> > 
> > and try again?
> 
> At some point somehow grup-pc apparently got installed, even with the
> script failure.  So I tried my dist-upgrade again, and seems to have
> completed almost 400 packages, but three still fail: Errors were
> encountered while processing:
>  linux-image-2.6.38-2-amd64
>  grub-pc
>  linux-image-2.6-amd64
> E: Sub-process /usr/bin/dpkg returned an error code (1)

Can you post the error?

	Sander

-- 
Humilis IT Services and Solutions
http://www.humilis.net
