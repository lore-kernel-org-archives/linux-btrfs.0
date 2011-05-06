From: CACook@quantum-sci.com
Subject: Re: Cannot Deinstall a Debian Package
Date: Fri, 6 May 2011 05:09:31 -0700
Message-ID: <201105060509.31652.CACook@quantum-sci.com>
References: <201105031227.43619.CACook@quantum-sci.com> <201105050749.09690.CACook@quantum-sci.com> <20110506063333.GA27068@attic.humilis.net>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
To: "linux-btrfs" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110506063333.GA27068@attic.humilis.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Thursday 5 May, 2011 23:33:33 Sander wrote:
> Can you do:
> 
> echo "true" > /var/lib/dpkg/info/grub-installer.postinst
> 
> and try again?

At some point somehow grup-pc apparently got installed, even with the script failure.  So I tried my dist-upgrade again, and seems to have completed almost 400 packages, but three still fail:
Errors were encountered while processing:
 linux-image-2.6.38-2-amd64
 grub-pc
 linux-image-2.6-amd64
E: Sub-process /usr/bin/dpkg returned an error code (1)

I can't reboot at this point, as on this machine I started a 'balance' through ssh on another machine, and it's been running for over 12 hours.  It does not respond to ^C and I'm afraid to reboot with it running.


