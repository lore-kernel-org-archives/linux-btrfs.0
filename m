Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:37900 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708AbaBYGvo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Feb 2014 01:51:44 -0500
Date: Mon, 24 Feb 2014 22:51:34 -0800
From: Marc MERLIN <marc@merlins.org>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <20140225065134.GE3521@merlins.org>
References: <20140224055103.GA15937@merlins.org>
 <pan$78eb$fa967f30$1d30da9e$2510275d@cox.net>
 <20140224082938.GF23877@carfax.org.uk>
 <pan$3f644$bd8e6a71$2603a9b4$2382ccea@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <pan$3f644$bd8e6a71$2603a9b4$2382ccea@cox.net>
Subject: Re: btrfs userland interface isn't 32/64bit clean (breaks lsattr and
 btrfs send)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 24, 2014 at 08:43:44AM +0000, Duncan wrote:
> Hugo Mills posted on Mon, 24 Feb 2014 08:29:38 +0000 as excerpted:
> 
> > On Mon, Feb 24, 2014 at 06:32:14AM +0000, Duncan wrote:
> >> 
> >> This is a known issue.  There's patches in the pipeline for 32-bit
> >> userspace on a 64-bit kernel, already.
> > 
> >    If you mean my recent patch, that's only for receive. I've not
> > noticed any other issues on my 32/64 system, but I've not done much with
> > it either (with btrfs, it's only really used for btrfs receive --
> > everything else is ext4).
> 
> Thanks.  Yes, I believe that's what I had in mind.  So apparently there's 
> more needed.  (I /think/ I might have seen at least one additional patch 
> float by for 32/64, but as it's out of my usage domain I'm not paying 
> /that/ much attention to it, so perhaps not.)

In the meantime, if that helps someone, on debian it's trivial to get
64bit for some packages. All I had to do was this:
gargamel:/usr/src# dpkg --add-architecture amd64
gargamel:/usr/src# dpkg --print-foreign-architectures
amd64
gargamel:/usr/src# apt-get install e2fsprogs:amd64 btrfs-tools:amd64

And that's it.
Now I'm back in business with a 64bit kernel.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
