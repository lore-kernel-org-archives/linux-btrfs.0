Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:45200 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750735AbbHDFKP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 4 Aug 2015 01:10:15 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZMUUO-00023t-QB
	for linux-btrfs@vger.kernel.org; Tue, 04 Aug 2015 07:10:12 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 04 Aug 2015 07:10:12 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 04 Aug 2015 07:10:12 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: BTRFS disaster (of my own making). Is this recoverable?
Date: Tue, 4 Aug 2015 05:10:06 +0000 (UTC)
Message-ID: <pan$f64e$1c059550$ef240e25$d6d81c77@cox.net>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sonic posted on Mon, 03 Aug 2015 22:20:38 -0400 as excerpted:

> I'm thinking this is a lost cause. Also thinking I need to provide for
> some redundancy in the future :-)
> 
> Any other suggestions before I give up the ghost on this?

I don't remember you saying anything about trying btrfs restore.  I'm not 
sure it can do anything for this case, and it definitely requires enough 
additional space on some other filesystem to store the data it restores, 
but if you had stuff on there you'd really like to get back, it's worth a 
shot, and if you're going to be backing up in the future, you'll need the 
additional devices for the backup in any case, so might as well get 'em 
now, mkfs them to whatever (doesn't have to be btrfs since all you're 
doing is using it as a place to store the files, it's the one you're 
restoring /from/ that's btrfs), mount 'em, and try restoring to them.

Worst-case, it doesn't work and you have your set of backup devices 
already prepped and ready to go.  Best-case, it recovers pretty much 
everything.

But I am guessing restore won't be able to do anything on it's own, 
you'll need to try btrfs-find-root, and feed the bytenr from roots it 
finds into restore until you get something useful.  Take a look at the 
link and brief instructions I posted in my first reply.

Of course, if btrfs-find-root doesn't show you any roots (these are the 
filesystem master roots), or if fed those roots using -t <bytenr>, btrfs 
restore --list-roots (these are the various subtree roots) doesn't give 
you anything worthwhile, then it /would/ appear you're looking at a lost-
cause... unless anyone else has a bright idea at this point.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

