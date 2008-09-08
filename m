From: Steve Long <slong@rathaus.eclipse.co.uk>
Subject: Re: btrfs_tree_lock & trylock
Date: Tue, 9 Sep 2008 00:28:01 +0100
Message-ID: <200809090028.01980.slong@rathaus.eclipse.co.uk>
References: <20080908135414.GG26079@one.firstfloor.org> <20080908171742.GB19117@infradead.org> <48C5619E.9010505@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <48C5619E.9010505@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Monday 08 September 2008 18:32:14 Ric Wheeler wrote:
> Christoph Hellwig wrote:
> > On Mon, Sep 08, 2008 at 09:49:42AM -0700, Stephen Hemminger wrote:
> >> Not to mention the problem that developers seem to have faster machines
> >> than average user, but slower than the enterprise and future generation
> >> CPU's. So any tuning value seems to get out of date fast.
> >
> > So where do my fellow developers get these fast systems from? :)
>
> Actually, my experience is that most linux file system developers have
> really poking, aged hardware with little to no cutting edge storage (or
> even cutting edge commercial class storage). Testing file systems on lap
> tops and desktops with old CPUs, no DRAM and 40GB drives does not even
> reflect a typical home user these days :-)
>
Yeah but it means they really notice when the algorithm has been improved. 
It's character-building, or summat. ;-)
