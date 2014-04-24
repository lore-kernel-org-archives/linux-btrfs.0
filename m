Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from SD88.btc-net.bg ([212.39.90.88]:44618 "HELO sd88.btc-net.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753690AbaDXRTn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Apr 2014 13:19:43 -0400
From: =?UTF-8?B?0J/Qu9Cw0LzQtdC9INCf0LXRgtGA0L7Qsg==?=
	<plamen@petrovi.no-ip.info>
To: "'Marc MERLIN'" <marc@merlins.org>
Cc: <linux-btrfs@vger.kernel.org>
References: <000001cf5f19$ac92b2b0$05b81810$@petrovi.no-ip.info> <20140423185413.GF26949@merlins.org> <001401cf5f27$17cae590$4760b0b0$@petrovi.no-ip.info> <20140423191546.GG26949@merlins.org> 
In-Reply-To: 
Subject: RE: Can anyone boot a system using btrfs root with linux 3.14 or newer?
Date: Thu, 24 Apr 2014 20:19:21 +0300
Message-ID: <000501cf5fe1$55198590$ff4c90b0$@petrovi.no-ip.info>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> -----Original Message-----
> From: Пламен Петров [mailto:plamen@petrovi.no-ip.info]
> Sent: Wednesday, April 23, 2014 10:38 PM
> To: 'Marc MERLIN'
> Cc: 'linux-btrfs@vger.kernel.org'
> Subject: RE: Can anyone boot a system using btrfs root with linux 3.14 or
> newer?
> 
> > -----Original Message-----
> > From: Marc MERLIN [mailto:marc@merlins.org]
> > Sent: Wednesday, April 23, 2014 10:16 PM
> > To: Пламен Петров
> > Cc: linux-btrfs@vger.kernel.org
> > Subject: Re: Can anyone boot a system using btrfs root with linux 3.14
> > or newer?
> >
> > On Wed, Apr 23, 2014 at 10:06:12PM +0300, Пламен Петров wrote:
> > > Just to clarify - I am using a monolithic kernel built from source,
> > > and it has all
> > the stuff it needs to support built-in, and then some. And no modules.
> > > The sources I'm using are the vanilla kernels from Linus and Greg KH
> > downloaded from kernel.org.
> >
> > Ok.
> >
> > > Check out the attached config I am using - it’s a kernel I'm running
> > > on one
> > server and a couple of virtual machines.
> >
> > That's the working .config.
> > I suggest you diff that one with the new one you have for 3.14
> >
> > > Until now - copying said config and doing a "make oldconfig" or
> > > "make
> > olddefconfig" and compiling-then-booting worked fine.
> >
> > This should indeed work, this is what I do too.
> >
> > So now, we're kind of guessing. To save us all time, could you capture
> > a serial console boot from the running 3.13 and then the failing 3.14.
> 
> Well, for the details - see for example here:
> https://bugzilla.kernel.org/attachment.cgi?id=133111
> how does a 3.14.1 built the way described earlier fails.
> 
> And for that matter - see the whole bugzilla bug entry - I went on and
> bisected this, using the linux-stable git tree, and after that landed me on the
> commit that introduces some "shiny new btrfs feature" for 3.14 - I decided
> my git bisection has gone wrong. And because I reported it on April 17-th and
> since then there has been no activity on the bugzilla entry besides me
> updating it - I posted my problem here, for more eyes to see.
> 

I just realized that the l gave no way for identifying the particular bugzilla entry. Here it is:
https://bugzilla.kernel.org/show_bug.cgi?id=74261

Sorry about that!
---------------------------------
Plamen Petrov


