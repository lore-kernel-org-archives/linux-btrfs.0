Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36755 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751287AbaLCS1C (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 3 Dec 2014 13:27:02 -0500
Date: Wed, 3 Dec 2014 19:26:33 +0100
From: David Sterba <dsterba@suse.cz>
To: Hugo Mills <hugo@carfax.org.uk>,
        Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
        Shriramana Sharma <samjnaa@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Possible to undo subvol delete?
Message-ID: <20141203182633.GV12140@suse.cz>
Reply-To: dsterba@suse.cz
References: <CAH-HCWW+C9VSV0vb5D1SfU+5md8=zfrZiAbK4cqFiGFW4bKR4w@mail.gmail.com>
 <20141130042306.GE8916@merlins.org>
 <547C6922.6030206@gmail.com>
 <CAH-HCWW4vUXzM6S1fCzwxdPiWHBZaf5ZNZexjRmND2WkzNK-qg@mail.gmail.com>
 <20141201184621.5dd7fcd9@natsu>
 <CAH-HCWV7mAz0cqO9r910aNa+wzufauvc_nOOpoB9ogDPdf7RsA@mail.gmail.com>
 <20141202031403.GZ17395@hungrycats.org>
 <20141202125252.GR12140@twin.jikos.cz>
 <20141202140945.GM32735@carfax.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20141202140945.GM32735@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 02, 2014 at 02:09:45PM +0000, Hugo Mills wrote:
> On Tue, Dec 02, 2014 at 01:52:52PM +0100, David Sterba wrote:
> > On Mon, Dec 01, 2014 at 10:14:03PM -0500, Zygo Blaxell wrote:
> > > > export BTRFS_SUBVOLUME_DELETE_CONFIRM=1
> > > > 
> > > > Ideas?
> > > 
> > > Never rely on aliasing or environment variables for defaults, and never
> > > change default behavior if your releases are old enough that someone
> > > has built scripts on top of them.  ;)
> > 
> > Exactly.
> > 
> > > If I had to pick the least evil, I'd go for interactive prompting by
> > > default (do nothing if the interaction fails, e.g. no TTY) and add a
> > > '-f'/'--force' flag to bypass the prompt.
> > 
> > This sounds acceptable.
> > 
> > > This is consistent with the
> > > way lvm2 and mdadm work when presented with data-losing or otherwise
> > > questionable commands and parameters.  It will break scripts, but btrfs
> > > users should still be expecting that for a while as undesirable default
> > > behaviors are identified.
> > 
> > How is this going to break scripts?
> 
>    Any script which relies on being able to delete subvolumes in
> unattended operation will now require modification to use -f.

Even with the tty/interactive shell detection in place? Maybe I
understood the reference to lvm/mdadm tools wrong. My idea is that the
scripts would work as now, no prompts there.
