Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-out15.tpgi.com.au ([220.244.226.125]:33771 "EHLO
	mail15.tpgi.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751305AbbHFBFQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 5 Aug 2015 21:05:16 -0400
From: Paul Jones <paul@pauljones.id.au>
To: Chris Murphy <lists@colorremedies.com>, Sonic <sonicsmith@gmail.com>
CC: Btrfs BTRFS <linux-btrfs@vger.kernel.org>, Hugo Mills <hugo@carfax.org.uk>
Subject: RE: BTRFS disaster (of my own making). Is this recoverable?
Date: Thu, 6 Aug 2015 00:45:08 +0000
Message-ID: <B7F2379062E32745A8651FBDB20F64596115AB1F@Server.waterlogic.com.au>
References: <CAP5+4qewgAhZ=1qKyDMMAsHC39CH36VmuaEuyaaaTAWHeqzmYw@mail.gmail.com>
	<pan$73c92$81fb65b9$3c60e540$cb422e6a@cox.net>
	<CAP5+4qfi4UdfMmNdC2XizTG0au-btnKBqSmg1rUaW=EJApZkmA@mail.gmail.com>
	<CAP5+4qdmjkniaoY6+FCL4OTAYQjpU=DOWBRv-3FkEvFN=TAeRw@mail.gmail.com>
	<20150803152835.GF14352@carfax.org.uk>
	<CAP5+4qfmXdMvBaVK1KqUfBRfM447ASJ4U0OqRxhsOw2r4WE1fQ@mail.gmail.com>
	<CAP5+4qd2-kKEG5y2gEphQ=5A4+B+=2teMxiZJc-vDHZ1_-t8OQ@mail.gmail.com>
	<CAP5+4qceVW2JbAteuRQUK+5mdwWcp8fF0QUk6Q87nqCw5P5wRw@mail.gmail.com>
	<CAP5+4qfLEqvGQhCkzQWPLy-dtAS7GjSfDy5Oo=6OXL1zohrc=Q@mail.gmail.com>
	<CAP5+4qcdn9eeHk=EgpUjNC2T+fxwimRit+BRsxQDv6k1Bb=Gqg@mail.gmail.com>
	<pan$f64e$1c059550$ef240e25$d6d81c77@cox.net>
	<CAP5+4qcfn_nPwD0eeMGJGuB5nEkSg0rbjnV6AUnCmEnJ5qu20w@mail.gmail.com>
	<CAP5+4qePXJuxv4FRdNSy-wsHTSr=iuJYrqdOwfYw4tOESiCCug@mail.gmail.com>
 <CAJCQCtSFcXhC9xBLia0uns64PdLPQXwEPin=sxSOsdhW+tD2Yg@mail.gmail.com>
In-Reply-To: <CAJCQCtSFcXhC9xBLia0uns64PdLPQXwEPin=sxSOsdhW+tD2Yg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> -----Original Message-----
> From: linux-btrfs-owner@vger.kernel.org [mailto:linux-btrfs-
> owner@vger.kernel.org] On Behalf Of Chris Murphy
> Sent: Thursday, 6 August 2015 2:54 AM
> To: Sonic <sonicsmith@gmail.com>
> Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>; Hugo Mills
> <hugo@carfax.org.uk>
> Subject: Re: BTRFS disaster (of my own making). Is this recoverable?
> 
> On Wed, Aug 5, 2015 at 6:31 AM, Sonic <sonicsmith@gmail.com> wrote:
> > On Tue, Aug 4, 2015 at 4:23 PM, Sonic <sonicsmith@gmail.com> wrote:
> >> Seems that if there was someway to edit something in those first
> >> overwritten 32MB of disc 2 to say "hey, I'm really here, just a bit
> >> screwed up" maybe some of the recovery tools could actually work.
> >
> > Just want to reiterate this thought.
> >
> > The basic error in most cases with the tools at hand is that Disc 2 is
> > missing so there's little the tools can do. Somewhere in those first
> > 32MB should be something to properly identify the disc as part of the
> > array.
> 
> Yes but it was probably  uniquely only on that disk, because there's no
> redundancy for metadata or system chunks. Therefore there's no copy on
> the other disk to use as a model. The btrfs check command has an option to
> use other superblocks, so you could try that switch and see if it makes a
> difference but it sounds like it's finding backup superblocks automatically.
> That's the one thing that is pretty much always duplicated on the same disk;
> for sure the first superblock is munged and would need repair. But there's
> still other chunks missing... so I don't think it'll help.

Would it be possible to store this type of critical information twice on each disk, at the beginning and end? I thought BTRFS already did that, but I might be thinking of some other filesystem. I've had my share of these types of oops! moments as well.
 


Paul.

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
