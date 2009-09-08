From: Tomasz Torcz <tomek@pipebreaker.pl>
Subject: Re: btrfs csum failed on git .pack file
Date: Tue, 8 Sep 2009 22:55:41 +0200
Message-ID: <20090908205541.GC4247@mother.pipebreaker.pl>
References: <20090907203531.GA1889@phenom2.trippelsdorf.de> <20090908200041.GF18599@kernel.dk> <20090908202211.GA1901@phenom2.trippelsdorf.de> <20090908203214.GH18599@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Jens Axboe <jens.axboe@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090908203214.GH18599@kernel.dk>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 08, 2009 at 10:32:14PM +0200, Jens Axboe wrote:
> On Tue, Sep 08 2009, Markus Trippelsdorf wrote:
> > On Tue, Sep 08, 2009 at 10:00:42PM +0200, Jens Axboe wrote:
> > > On Mon, Sep 07 2009, Markus Trippelsdorf wrote:
> > > > Just got this error today in my dmesg:
> > > > btrfs csum failed ino 1483065 off 158482432 csum 4283543305 private 43905798
> > 
> > I've already deleted the file in question unfortunately.
> > On IRC Chris decided that either bad RAM or a harddrive error was the
> > most likely reason for this chechsum mismatch.
> 
> Darn, that's too bad. The corruption issue I had was also in a git pack
> file. It was fine one day, bad the next. Turned out to be 16kb of 0xff
> in the file, and I blamed it on the (cheap) SSD drive that hosted the
> local git repo. It's still the most likely explanation given the nature
> of the problem, however it would have been really interesting to see
> what corruption you had.

  BTW, I had some similar issue. One file on btrfs had csum failed.
I've copied it using dd_rescue and, suprise, reading new file yields
this error also. How to retrieve block failing csum check from btrfs volume?

-- 
Tomasz Torcz                                                       72->|   80->|
xmpp: zdzichubg@chrome.pl                                          72->|   80->|

