Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from SD88.btc-net.bg ([212.39.90.88]:44536 "HELO sd88.btc-net.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932410AbaDXRIv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Apr 2014 13:08:51 -0400
From: =?UTF-8?B?0J/Qu9Cw0LzQtdC9INCf0LXRgtGA0L7Qsg==?=
	<plamen@petrovi.no-ip.info>
To: "'Chris Mason'" <clm@fb.com>, "'Marc MERLIN'" <marc@merlins.org>
Cc: <linux-btrfs@vger.kernel.org>
References: <000001cf5f19$ac92b2b0$05b81810$@petrovi.no-ip.info> <20140423185413.GF26949@merlins.org> <001401cf5f27$17cae590$4760b0b0$@petrovi.no-ip.info> <20140423191546.GG26949@merlins.org> <002401cf5f2b$7f8d41b0$7ea7c510$@petrovi.no-ip.info> <20140423205819.GH26949@merlins.org> <535904BB.1090307@fb.com> <53590548.5000301@fb.com>
In-Reply-To: <53590548.5000301@fb.com>
Subject: RE: Can anyone boot a system using btrfs root with linux 3.14 or newer?
Date: Thu, 24 Apr 2014 20:08:32 +0300
Message-ID: <000301cf5fdf$d264a270$772de750$@petrovi.no-ip.info>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> -----Original Message-----
> From: Chris Mason [mailto:clm@fb.com]
> Sent: Thursday, April 24, 2014 3:36 PM
> To: Marc MERLIN; Пламен Петров
> Cc: linux-btrfs@vger.kernel.org
> Subject: Re: Can anyone boot a system using btrfs root with linux 3.14 or
> newer?
> 
> 
> 
> On 04/24/2014 08:34 AM, Chris Mason wrote:
> >
> >
> > On 04/23/2014 04:58 PM, Marc MERLIN wrote:
> >> On Wed, Apr 23, 2014 at 10:37:44PM +0300, Пламен Петров wrote:
> >>>> So now, we're kind of guessing. To save us all time, could you
> >>>> capture a serial console boot from the running 3.13 and then the
> >>>> failing 3.14.
> >>>
> >>> Well, for the details - see for example here:
> >>> https://bugzilla.kernel.org/attachment.cgi?id=133111
> >>> how does a 3.14.1 built the way described earlier fails.
> >>
> >> Thanks, that helps.
> >> Except, now I'm perplexed.
> >>
> >> It indeed shows btrfs loaded and your block device being detected.
> >> However it does not show a btrfs mount error.
> >
> > The mount error is popping up after the printk about not being able to
> > find root.  Add rootwait to the command line.
> 
> Sorry, that's almost but not quite what I meant to say.  The device detection
> message is popping up after the printk about not being able to find root.  Add
> rootwait to the command line.
> 
> In other words, the mount is failing before the root device is detected.
>   rootwait will make us wait (forever) instead of failing.
> 
> -chris

Today I managed to try adding rootwait to the kernel commandline - the kernel panic with it in place, too.
---------------------------------
Plamen Petrov


