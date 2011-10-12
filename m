From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: Number of hard links limit
Date: Wed, 12 Oct 2011 19:34:06 +0200
Message-ID: <201110121934.07105.Martin@lichtvoll.de>
References: <20100802114046.GA29926@lh.kyla.fi> <20100806113039.GA18858@lh.kyla.fi> <20100806134607.GB19942@think> (sfid-20100806_210500_470409_276ADFAF)
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Cc: 642603@bugs.debian.org
To: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org,
	sliedes@cc.hut.fi
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100806134607.GB19942@think>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

Am Freitag, 6. August 2010 schrieb Chris Mason:
> On Fri, Aug 06, 2010 at 02:30:39PM +0300, Sami Liedes wrote:
> > On Tue, Aug 03, 2010 at 12:22:14AM +0200, Oystein Viggen wrote:
> > > IIRC, the limit on hard links is per directory.  That is, if you
> > > put each hard link into its own directory, there's basically no
> > > limit to the amount of hard links you can make to one file.
> > 
> > Yes, that's always pointed out in these threads. Still, it seems to
> > be breaking real use cases also beyond backuppc (someone mentioned
> > installing some Gentoo package).
> 
> Right, this will get fixed in a future btrfs update.  We're focusing on
> stability with what we have right now, but I do agree we should have
> done this link back reference design differently.

What is the status of fixing the limits of hardlinks in BTRFS?

It is now easy to hit on Debian systems that have git package installed:

Preparing to replace git 1:1.7.6.3-1 (using .../git_1%3a1.7.7-1_amd64.deb) 
...
Unpacking replacement git ...
dpkg: error processing /var/cache/apt/archives/git_1%3a1.7.7-1_amd64.deb 
(--unpack):
 unable to make backup link of `./usr/lib/git-core/git-send-pack' before 
installing new version: Too many links
configured to not write apport reports
                                      dpkg-deb: error: subprocess paste 
was killed by signal (Broken pipe)
Errors were encountered while processing:
 /var/cache/apt/archives/git_1%3a1.7.7-1_amd64.deb


also see:

git - too many hardlinks in /usr/lib/git-core
http://bugs.debian.org/642603


While above bug might be fixed by using symlinks or by some other 
workaround, I think this limit will be hit more likely as BTRFS matures. I 
think it should be fixed, before the experimental flag of BTRFS is removed.

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
