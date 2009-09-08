From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: btrfs csum failed on git .pack file
Date: Tue, 8 Sep 2009 22:32:14 +0200
Message-ID: <20090908203214.GH18599@kernel.dk>
References: <20090907203531.GA1889@phenom2.trippelsdorf.de> <20090908200041.GF18599@kernel.dk> <20090908202211.GA1901@phenom2.trippelsdorf.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090908202211.GA1901@phenom2.trippelsdorf.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 08 2009, Markus Trippelsdorf wrote:
> On Tue, Sep 08, 2009 at 10:00:42PM +0200, Jens Axboe wrote:
> > On Mon, Sep 07 2009, Markus Trippelsdorf wrote:
> > > Just got this error today in my dmesg:
> > > btrfs csum failed ino 1483065 off 158482432 csum 4283543305 private 43905798
> > > 
> > > linux % find . -inum 1483065
> > > ./.git/objects/pack/pack-f9251bcc6a8afe3c92193e14d1d742f2f0182ce5.pack
> > > 
> > > It's the main pack file from my git linux kernel tree:
> > > 
> > > linux % ls -l ./.git/objects/pack/
> > > total 562848
> > > -rw-r--r-- 1 markus markus   1891324 2008-11-29 19:49 pack-011b43fa6956667db5e67fba859e40cb4b154226.idx
> > > -rw-r--r-- 1 markus markus  44002938 2008-11-29 19:54 pack-011b43fa6956667db5e67fba859e40cb4b154226.pack.temp
> > > -rw-r--r-- 1 markus markus    730332 2008-11-29 19:49 pack-67be92b3fab3dab175683582dab0b719517e55a5.idx
> > > -r--r--r-- 1 markus markus  36061684 2009-09-06 21:48 pack-f9251bcc6a8afe3c92193e14d1d742f2f0182ce5.idx
> > > -r--r--r-- 1 markus markus 335202742 2009-09-06 21:48 pack-f9251bcc6a8afe3c92193e14d1d742f2f0182ce5.pack
> > > -rw------- 1 markus markus 158457856 2009-09-07 22:15 tmp_pack_OUdxER
> > > 
> > > I'm running the latest git kernel and I've been using btrfs as my root
> > > fs for the last few weeks without problems so far.
> > 
> > Hmm, I ran into something very similar. Care to check what the corrupted
> > block of data looks like (and how big it is)?
> 
> I've already deleted the file in question unfortunately.
> On IRC Chris decided that either bad RAM or a harddrive error was the
> most likely reason for this chechsum mismatch.

Darn, that's too bad. The corruption issue I had was also in a git pack
file. It was fine one day, bad the next. Turned out to be 16kb of 0xff
in the file, and I blamed it on the (cheap) SSD drive that hosted the
local git repo. It's still the most likely explanation given the nature
of the problem, however it would have been really interesting to see
what corruption you had.

-- 
Jens Axboe

