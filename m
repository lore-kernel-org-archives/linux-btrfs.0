From: Goffredo Baroncelli <kreijack@gmail.com>
Subject: Re: severe hardlink bug
Date: Sun, 24 Jan 2010 09:09:44 +0100
Message-ID: <201001240909.44753.kreijack@libero.it>
References: <20100124015138.092c4959@simplux>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100124015138.092c4959@simplux>
List-ID: <linux-btrfs.vger.kernel.org>

On Sunday 24 January 2010, Michael Niederle wrote:
> I'm using btrfs with a kernel 2.6.32.2 (builtin) as the root file system of 
a
> Gentoo Linux installation.
> 
> While attempting to install the plt-scheme package a strange error about 
link
> counts occurred ([Error 31] Too many Links).

See this thread:

Mass-Hardlinking Oops - http://thread.gmane.org/gmane.comp.file-
systems.btrfs/3427

There is a limit of the number of hardlink for a file. The maximum number of 
the link depends by  name length.

BR
Goffredo


-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijackATinwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
