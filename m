From: Tomasz Torcz <tomek@pipebreaker.pl>
Subject: Re: btrfs csum failed on git .pack file
Date: Thu, 17 Sep 2009 19:50:01 +0200
Message-ID: <20090917175001.GA23973@mother.pipebreaker.pl>
References: <20090907203531.GA1889@phenom2.trippelsdorf.de> <20090908200041.GF18599@kernel.dk> <20090917050512.GB1916@phenom2.trippelsdorf.de> <20090917064456.GZ23126@kernel.dk> <20090917090428.GA1877@phenom2.trippelsdorf.de> <20090917090549.GE23126@kernel.dk> <20090917121501.GB1877@phenom2.trippelsdorf.de> <4AB26B2C.9030703@oracle.com> <20090917171006.GA1935@phenom2.trippelsdorf.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090917171006.GA1935@phenom2.trippelsdorf.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 17, 2009 at 07:10:06PM +0200, Markus Trippelsdorf wrote:
> > > 06CD DFC0: 0D 86 2B B2 57 A4 5A CD  78 4B 08 94 C0 65 17 3A
> > > 06CD DFC0: 0D 86 2B B2 57 A4 5A CD  78 0B 08 94 C0 65 17 3A
> > 
> > 4B = 01001011
> > 0B = 00001011
> > 
> > And so on.
> > 
> > It looks like a few bits are getting flipped at the same byte offset.
> > One can imagine software bugs that would do this, certainly, but upset
> > hardware seems awfully likely too.
> 
> I'm afraid you're right. I did some further tests and now I'm pretty
> sure that a bad RAM module was the root cause of it all...
> Oh well.

  On the other hand, that what's so great in checksumming filesystems.
You found bad module thanks to btrfs, otherwise you wouldn't suspect
anything wrong. If you have had raid-1 for data, this corruption would
have been fixed by btrfs.

-- 
Tomasz Torcz                                                       72->|   80->|
xmpp: zdzichubg@chrome.pl                                          72->|   80->|

