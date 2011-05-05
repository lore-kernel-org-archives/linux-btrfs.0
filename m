From: CACook@quantum-sci.com
Subject: Re: Cannot Deinstall a Debian Package
Date: Thu, 5 May 2011 14:48:25 -0700
Message-ID: <201105051448.25771.CACook@quantum-sci.com>
References: <201105031227.43619.CACook@quantum-sci.com> <201105051357.07209.CACook@quantum-sci.com> <1304629163.11048.7.camel@havelock.liw.fi>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
To: "linux-btrfs" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1304629163.11048.7.camel@havelock.liw.fi>
List-ID: <linux-btrfs.vger.kernel.org>

On Thursday 5 May, 2011 13:59:23 Lars Wirzenius wrote:
> dpkg --fsys-tarfile foo.deb | tar -C / -tf -

I was expecting this to extract into the local directory, although it seems to have extracted into the final destinations.  Can't be sure.  grub-setup -V gives the new version.

 
> change -t to -x to actually extract

I don't see the distinction.  It does seem to have extracted.


