From: Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: btrfs csum failed on git .pack file
Date: Thu, 17 Sep 2009 19:10:06 +0200
Message-ID: <20090917171006.GA1935@phenom2.trippelsdorf.de>
References: <20090907203531.GA1889@phenom2.trippelsdorf.de>
 <20090908200041.GF18599@kernel.dk>
 <20090917050512.GB1916@phenom2.trippelsdorf.de>
 <20090917064456.GZ23126@kernel.dk>
 <20090917090428.GA1877@phenom2.trippelsdorf.de>
 <20090917090549.GE23126@kernel.dk>
 <20090917121501.GB1877@phenom2.trippelsdorf.de>
 <4AB26B2C.9030703@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-btrfs@vger.kernel.org
To: Zach Brown <zach.brown@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4AB26B2C.9030703@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 17, 2009 at 10:00:28AM -0700, Zach Brown wrote:
> 
> > 0130 9FA0: E2 3B 43 AA 63 BF 28 B3  87 B7 FD AB DA 74 2D 1C
> > 0130 9FA0: E2 3B 43 AA 63 BF 28 B3  87 33 FD AB DA 74 2D 1C
> 
> B7 = 10110111
> 33 = 00110011
> 
> > 06CD DF90: B0 22 6B 46 9F ED 6E 47  73 5E 7E EB DA 5F D6 11
> > 06CD DF90: B0 22 6B 46 9F ED 6E 47  73 1E 7E EB DA 5F D6 11
> 
> 5E = 01011110
> 1E = 00011110
> 
> > 06CD DFC0: 0D 86 2B B2 57 A4 5A CD  78 4B 08 94 C0 65 17 3A
> > 06CD DFC0: 0D 86 2B B2 57 A4 5A CD  78 0B 08 94 C0 65 17 3A
> 
> 4B = 01001011
> 0B = 00001011
> 
> And so on.
> 
> It looks like a few bits are getting flipped at the same byte offset.
> One can imagine software bugs that would do this, certainly, but upset
> hardware seems awfully likely too.

I'm afraid you're right. I did some further tests and now I'm pretty
sure that a bad RAM module was the root cause of it all...
Oh well.

-- 
Markus
