Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:44726 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751167AbaGGWVk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 7 Jul 2014 18:21:40 -0400
Received: from compute5.internal (compute5.nyi.mail.srv.osa [10.202.2.45])
	by gateway1.nyi.mail.srv.osa (Postfix) with ESMTP id 04BB721BB4
	for <linux-btrfs@vger.kernel.org>; Mon,  7 Jul 2014 18:21:40 -0400 (EDT)
Date: Mon, 7 Jul 2014 15:26:02 -0700
From: Greg KH <greg@kroah.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Joseph Salisbury <joseph.salisbury@canonical.com>,
        kamal.mostafa@canonical.com, luis.henriques@canonical.com,
        jslaby@suse.cz, clm@fb.com, jbacik@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [v3.10.y][v3.11.y][v3.12.y][v3.13.y][v3.14.y][PATCH 1/1][V2]
 ALSA: usb-audio: Prevent printk ratelimiting from spamming kernel log while
 DEBUG not defined
Message-ID: <20140707222602.GB11171@kroah.com>
References: <cover.1403113867.git.joseph.salisbury@canonical.com>
 <a377cdb51b1a98e9fa6bffaa124502fc15c47903.1403113867.git.joseph.salisbury@canonical.com>
 <1403142759.23472.28.camel@deadeye.wl.decadent.org.uk>
 <53A4515C.8090103@canonical.com>
 <53A47BC4.8040406@canonical.com>
 <1403352353.23472.67.camel@deadeye.wl.decadent.org.uk>
 <20140621194827.GA5128@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140621194827.GA5128@kroah.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jun 21, 2014 at 12:48:27PM -0700, Greg KH wrote:
> On Sat, Jun 21, 2014 at 01:05:53PM +0100, Ben Hutchings wrote:
> > On Fri, 2014-06-20 at 14:21 -0400, Joseph Salisbury wrote:
> > [...]
> > > I looked at this some more.   It seems like my v2 backport may be the
> > > most suitable for the releases mentioned in the subject line, but I'd
> > > like to get additional feedback.
> > > 
> > > The lines added by commit a5065eb just get removed by commit b7a77235. 
> > > Also, if I apply commit a5065eb, it will also require a backport to pull
> > > in just a piece of code(Remove snd_printk() and add dev_dbg()) from
> > > another prior commit(0ba41d9).  No backport would be needed at all if I
> > > cherry-pick 0ba41d9, but that commit seems to have too may changes for a
> > > stable release.
> > 
> > Keep the changes squashed together if you like, but do include both
> > commit hashes and commit messages.
> 
> No, I don't want to see "squashed together" patches, please keep them as
> close to the original patch as possible.  It saves time in the long run,
> trust me...

And since no one did this work for me, I had to do it myself...

{grumble}
