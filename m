From: jlcenter@comcast.net
Subject: Re: btrfs open_ctree failed (after recent Ubuntu update)
Date: Sun, 19 Feb 2012 19:31:51 +0000 (UTC)
Message-ID: <1323199538.1070187.1329679911124.JavaMail.root@sz0019a.westchester.pa.mail.comcast.net>
References: <20120219192605.GA5350@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120219192605.GA5350@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

Thanks, Hugo.  I'll check this out.  -John

----- Original Message -----
From: "Hugo Mills" <hugo@carfax.org.uk>
To: jlcenter@comcast.net
Cc: linux-btrfs@vger.kernel.org
Sent: Sunday, February 19, 2012 2:26:05 PM
Subject: Re: btrfs open_ctree failed (after recent Ubuntu update)

On Sun, Feb 19, 2012 at 07:03:28PM +0000, jlcenter@comcast.net wrote:
> I was curious, if one goes the route of upgrading the kernel, how
> does one upgrade the btrfs tools?

   The tools are pretty much independent of the kernel -- you can
upgrade the kernel and keep the tools the same. The only thing is that
you would miss out on any new kernel features that the tools didn't
support.

   For new tools, it's actually pretty simple to compile your own (you
don't even have to install them -- the btrfs tool runs perfectly
happily from the build directory). Instructions are on the wiki:

http://btrfs.ipv5.de/index.php?title=Btrfs_source_repositories#Official_repository

   Hugo.

> Thanks.
> 
>     -John
> 
> ----- Original Message -----
> From: "Chris Samuel" <chris@csamuel.org>
> To: linux-btrfs@vger.kernel.org
> Cc: "Curtis Jones" <curtis.jones@gmail.com>
> Sent: Saturday, February 18, 2012 6:00:27 PM
> Subject: Re: btrfs open_ctree failed (after recent Ubuntu update)
> 
> On Sunday 19 February 2012 07:34:22 Curtis Jones wrote:
> 
> > Any help would be appreciated. Thank you. Please CC me on any
> > replies.
> >
> > Linux veriton 3.0.0-16-generic-pae #28-Ubuntu SMP Fri Jan 27
> > 19:24:01 UTC 2012 i686 i686 i386 GNU/Linux
> 
> That's a fairly old kernel in btrfs terms, you may want to try the 
> latest 3.2.x kernel from the Ubuntu Mainline Kernel PPA here:
> 
> http://kernel.ubuntu.com/~kernel-ppa/mainline/
> 
> If that doesn't work out you can try the latest 3.3 RC there too.
> 
> I'm running the 64-bit 3.2.5 kernel from there on Kubuntu 11.10 and it 
> is fine (modulo boot time complaints about the apparmour stuff).
> 
> cheers,
> Chris

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
            --- There isn't a noun that can't be verbed. ---             
