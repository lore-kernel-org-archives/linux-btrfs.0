From: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Subject: Re: btrfs and 1 billion small files
Date: Mon, 7 May 2012 14:19:32 +0200
Message-ID: <20120507141932.673709f8@fem.tu-ilmenau.de>
References: <20120507105552.GC8938@carfax.org.uk>
	<1429905255.3406.1336389326378.JavaMail.root@zimbra.interconnessioni.it>
	<20120507113928.GE8938@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: Alessio Focardi <alessiof@gmail.com>, linux-btrfs@vger.kernel.org
To: Hugo Mills <hugo@carfax.org.uk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120507113928.GE8938@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

Am Mon, 7 May 2012 12:39:28 +0100
schrieb Hugo Mills <hugo@carfax.org.uk>:

> On Mon, May 07, 2012 at 01:15:26PM +0200, Alessio Focardi wrote:
...
> > That's a very clever suggestion, I'm preparing a test server right
> > now: going to use the -m single option. Any other suggestion
> > regarding format options?
> > 
> > pagesize? leafsize?
> 
>    I'm not sure about these -- some values of them definitely break
> things. I think they are required to be the same, and that you could
> take them up to 64k with no major problems, but do check that first
> with someone who actually knows.

First, if you have this filesystem as rootfs, a separate /boot
partition is needed. Grub is unable to boot from btrfs with different
node-/leafsize. Second a very recent kernel is needed (linux-3.4-rc1 at
least).

regards,
  Johannes
