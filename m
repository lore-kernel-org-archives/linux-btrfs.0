From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: btrfs csum failed on git .pack file
Date: Thu, 17 Sep 2009 11:05:49 +0200
Message-ID: <20090917090549.GE23126@kernel.dk>
References: <20090907203531.GA1889@phenom2.trippelsdorf.de> <20090908200041.GF18599@kernel.dk> <20090917050512.GB1916@phenom2.trippelsdorf.de> <20090917064456.GZ23126@kernel.dk> <20090917090428.GA1877@phenom2.trippelsdorf.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090917090428.GA1877@phenom2.trippelsdorf.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 17 2009, Markus Trippelsdorf wrote:
> On Thu, Sep 17, 2009 at 08:44:56AM +0200, Jens Axboe wrote:
> > On Thu, Sep 17 2009, Markus Trippelsdorf wrote:
> > > On Tue, Sep 08, 2009 at 10:00:42PM +0200, Jens Axboe wrote:
> > > > On Mon, Sep 07 2009, Markus Trippelsdorf wrote:
> > > > > Just got this error today in my dmesg:
> > > > > btrfs csum failed ino 1483065 off 158482432 csum 4283543305 private 43905798
> > > > > 
> > > > > linux % find . -inum 1483065
> > > > > ./.git/objects/pack/pack-f9251bcc6a8afe3c92193e14d1d742f2f0182ce5.pack
> > > > > 
> > > > > It's the main pack file from my git linux kernel tree:
> > > > > 
> > > > 
> > > > Hmm, I ran into something very similar. Care to check what the corrupted
> > > > block of data looks like (and how big it is)?
> > > 
> > > I've hit the same problem again today:
> > > 
> > > btrfs csum failed ino 1826333 off 150208512 csum 4148434891 private 1660028275
> > > 
> > > The file in question is:
> > > ./.git/objects/pack/pack-a2330b703d5a7fd62626b39a5fdfb6eecf739d0d.pack
> > > 
> > > I can't read the file directly, because of the csum mismatch:
> > 
> > Chris, is there a way to force reading the file? Seems like that would
> > be a very handy feature.
> > 
> > Markus, not sure if that works, but you could always try and remount
> > with data checksumming disabled.
> > 
> > mount /dev/fooX -o remount,rw,nodatasum
> > 
> > should do the trick.
> 
> That doesn't work unfortunately, btrfs still calculates and compares the
> checksums (it won't write new ones I guess).

Ah ok, as mentioned I wasn't sure whether that would work or not. I'll
defer to Chris :-)

-- 
Jens Axboe

