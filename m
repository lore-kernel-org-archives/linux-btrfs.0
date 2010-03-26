From: Goffredo Baroncelli <kreijack@gmail.com>
Subject: Re: btrfs subvol find-modified
Date: Fri, 26 Mar 2010 21:36:31 +0100
Message-ID: <201003262136.32330.kreijack@libero.it>
References: <20100326111807.24dcc2f0@simplux> <20100326212207.424db8af@simplux> <20100326202646.GG13680@think>
Reply-To: kreijack@libero.it
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
To: Chris Mason <chris.mason@oracle.com>,
	"Dipl.-Ing. Michael Niederle" <mniederle@gmx.at>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100326202646.GG13680@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Friday 26 March 2010, Chris Mason wrote:
> On Fri, Mar 26, 2010 at 09:22:07PM +0100, Dipl.-Ing. Michael Niederle wrote:
> > Hi, Chris!
> > 
> > > Add an optional timestamp field to filter
> > > files that have changed since a given timestamp.
> > 
> > Is there a possibility to derive the timestamp directly from the 
generation
> > number?
> 
> I'm afraid not.
> 
> > 
> > If we have a "-e"-switch for printing extent-information we could also 
have
> > another switch to decide whether to print directory-information or not and
> > combine find-new and find-modified into a single command.
> 
> Yes, that's the direction I'd like to see.
> 
> > 
> > Meanwhile I have implemented the (very simple) command
> > 
> > btrfs subvolume max-gen <path>
> > 	Print the highest generation number in a filesystem.
> > 

It is possible to combine the commands max-gen and find-new ? Something like:

	$ btrfs subvol find-new subvol1 snap1

I think that the generation number is useful only from a developer point of 
view. But from an user point of view a command which is able to compare two 
snapshot if more useful.

> 
> Great.
> 
> -chris
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijackATinwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
