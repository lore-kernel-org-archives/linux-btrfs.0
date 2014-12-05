Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49598 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751378AbaLERzF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 5 Dec 2014 12:55:05 -0500
Date: Fri, 5 Dec 2014 18:55:04 +0100
From: David Sterba <dsterba@suse.cz>
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Cc: dsterba@suse.cz, Hugo Mills <hugo@carfax.org.uk>,
        Shriramana Sharma <samjnaa@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Possible to undo subvol delete?
Message-ID: <20141205175504.GN9754@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20141130042306.GE8916@merlins.org>
 <547C6922.6030206@gmail.com>
 <CAH-HCWW4vUXzM6S1fCzwxdPiWHBZaf5ZNZexjRmND2WkzNK-qg@mail.gmail.com>
 <20141201184621.5dd7fcd9@natsu>
 <CAH-HCWV7mAz0cqO9r910aNa+wzufauvc_nOOpoB9ogDPdf7RsA@mail.gmail.com>
 <20141202031403.GZ17395@hungrycats.org>
 <20141202125252.GR12140@twin.jikos.cz>
 <20141202140945.GM32735@carfax.org.uk>
 <20141203182633.GV12140@suse.cz>
 <20141203195408.GY17380@hungrycats.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20141203195408.GY17380@hungrycats.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 03, 2014 at 02:54:14PM -0500, Zygo Blaxell wrote:
> > Even with the tty/interactive shell detection in place? Maybe I
> > understood the reference to lvm/mdadm tools wrong. My idea is that the
> > scripts would work as now, no prompts there.
> 
> How do we reliably distinguish between
> "running in a script interactively",
> "running in a script non-interactively",
> and "running interactively"?

The first choice is to use isatty() function, but this would not be
enough to detect #1, which would require an extra option to force the
itneractive mode.

> I could easily run a script from the command line that creates and
> destroys subvols and runs for days or weeks (in fact, I quite often do).
> It would be a significant productivity hit if an upgrade made it stop
> every night waiting for confirmation from a user who went home hours
> ago and won't be back for hours more.

Yeah, we want to avoid such surprises. Besides isatty, there could be
more shell magic to detect the interactive mode reliably, I don't know.
