From: Chris Mason <chris.mason@oracle.com>
Subject: Re: btrfs subvol find-modified
Date: Fri, 26 Mar 2010 17:11:24 -0400
Message-ID: <20100326211124.GK13680@think>
References: <20100326111807.24dcc2f0@simplux>
 <20100326212207.424db8af@simplux>
 <20100326202646.GG13680@think>
 <201003262136.32330.kreijack@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Dipl.-Ing. Michael Niederle" <mniederle@gmx.at>,
	linux-btrfs@vger.kernel.org
To: kreijack@libero.it
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201003262136.32330.kreijack@libero.it>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 26, 2010 at 09:36:31PM +0100, Goffredo Baroncelli wrote:
> On Friday 26 March 2010, Chris Mason wrote:
> > On Fri, Mar 26, 2010 at 09:22:07PM +0100, Dipl.-Ing. Michael Niederle wrote:
> > > Hi, Chris!
> > > 
> > > > Add an optional timestamp field to filter
> > > > files that have changed since a given timestamp.
> > > 
> > > Is there a possibility to derive the timestamp directly from the 
> generation
> > > number?
> > 
> > I'm afraid not.
> > 
> > > 
> > > If we have a "-e"-switch for printing extent-information we could also 
> have
> > > another switch to decide whether to print directory-information or not and
> > > combine find-new and find-modified into a single command.
> > 
> > Yes, that's the direction I'd like to see.
> > 
> > > 
> > > Meanwhile I have implemented the (very simple) command
> > > 
> > > btrfs subvolume max-gen <path>
> > > 	Print the highest generation number in a filesystem.
> > > 
> 
> It is possible to combine the commands max-gen and find-new ? Something like:
> 
> 	$ btrfs subvol find-new subvol1 snap1
> 
> I think that the generation number is useful only from a developer point of 
> view. But from an user point of view a command which is able to compare two 
> snapshot if more useful.

In general, the end goal is backing up a snapshot the changes from a
point in time to right now.  We don't actually need a snapshot to do
this, we just need the generation number and (optionally) a timestamp.

So, we could store these things into a state file that gets fed into the
next backup, but I'd like to keep a command that can print them as well.

-chris

