Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:42007 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085AbaLBFuF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Dec 2014 00:50:05 -0500
Date: Mon, 1 Dec 2014 21:50:02 -0800
From: Marc MERLIN <marc@merlins.org>
To: MegaBrutal <megabrutal@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
        Shriramana Sharma <samjnaa@gmail.com>
Message-ID: <20141202055002.GD8916@merlins.org>
References: <CAH-HCWW+C9VSV0vb5D1SfU+5md8=zfrZiAbK4cqFiGFW4bKR4w@mail.gmail.com>
 <20141130042306.GE8916@merlins.org>
 <547C6922.6030206@gmail.com>
 <CAH-HCWW4vUXzM6S1fCzwxdPiWHBZaf5ZNZexjRmND2WkzNK-qg@mail.gmail.com>
 <20141201184621.5dd7fcd9@natsu>
 <CAH-HCWV7mAz0cqO9r910aNa+wzufauvc_nOOpoB9ogDPdf7RsA@mail.gmail.com>
 <CAE8gLhkiv0YnFArrzwLfnrGcqm1pRsuYBgakwrMs2W61xuothw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAE8gLhkiv0YnFArrzwLfnrGcqm1pRsuYBgakwrMs2W61xuothw@mail.gmail.com>
Subject: Re: Possible to undo subvol delete?
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 02, 2014 at 06:33:38AM +0100, MegaBrutal wrote:
> 2014-12-01 17:39 GMT+01:00 Shriramana Sharma <samjnaa@gmail.com>:
> >
> > When btrfs has so many features (esp snapshots) to prevent user
> > accidentally deleting data (I liked especially
> > http://www.youtube.com/v/9H7e6BcI5Fo?start=209) I think there has to
> > be *some* modicum of support for warning against deleting a subvolume
> > (and it seems others agree too).
> >
> 
> WOW, this is pretty neat? How can I do the same actions from the
> command-line? E.g. I would be curious whether a file changed since the
> last snapshot. Today I have to use traditional methods like plain "ls

It's not trivial. See
http://marc.merlins.org/perso/btrfs/2014-05.html#Btrfs-diff-Between-Snapshots

>From what I understand, the only way to do this better is to use
btrfs-send and parse the output, but that's not trivial either since
btrfs-send has lots of intermediate renames.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
