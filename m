From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [GIT PULL] scrub updates for 3.1
Date: Tue, 5 Jul 2011 18:52:48 -0700 (PDT)
Message-ID: <1309917127-sup-8901@shiny>
References: <4E130AD7.2010300@gmx.net> <4E13B4FA.8050008@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Arne Jansen <sensille@gmx.net>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E13B4FA.8050008@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Li Zefan's message of 2011-07-05 21:06:02 -0400:
> 21:00, Arne Jansen worte:
> > Hi Chris,
> > 
> > since rc-6 seems to be the last rc for 3.0 and in case you're already
> > preparing your pull request for 3.1, can you please pull the following
> > updates for scrub, based on your for-linus tree (2f7e33d432)?
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/arne/btrfs-unstable-arne.git
> > for-chris
> > 
> > It just contains the readahead patch, which gives a significant
> > performance improvement for scrub. Currently scrub is the only
> > consumer.
> > 
> > Thanks,
> > Arne
> > 
> > Arne Jansen (7):
> >       btrfs: add an extra wait mode to read_extent_buffer_pages
> >       btrfs: add READAHEAD extent buffer flag
> >       btrfs: state information for readahead
> >       btrfs: initial readahead code and prototypes
> >       btrfs: hooks for readahead
> >       btrfs: test ioctl for readahead
> 
> Do we really want this ioctl that is merely for testing some kernel
> APIs in our upstream kernel?

I'd like to avoid the ioctl for now, since once it is there we're stuck
with it forever.  At least for the 3.1 pull lets keep it out please.

-chris
