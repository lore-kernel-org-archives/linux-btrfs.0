From: Bron Gondwana <brong@fastmail.fm>
Subject: Re: Data Deduplication with the help of an online filesystem check
Date: Wed, 29 Apr 2009 10:06:17 +1000
Message-ID: <20090429000617.GA14794@brong.net>
References: <20090427033331.GC17677@cip.informatik.uni-erlangen.de> <200904281945.10274.hjclaes@web.de> <20090428201619.GK7217@cip.informatik.uni-erlangen.de> <200904282236.07428.hjclaes@web.de> <20090428205242.GA13112@cip.informatik.uni-erlangen.de> <1240952295.15136.73.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Thomas Glanzmann <thomas@glanzmann.de>,
	Heinz-Josef Claes <hjclaes@web.de>,
	Edward Shishkin <edward.shishkin@gmail.com>,
	Tomasz Chmielewski <mangoo@wpkg.org>,
	linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1240952295.15136.73.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 28, 2009 at 04:58:15PM -0400, Chris Mason wrote:
> >         Assuming a 4 kbyte block size that would mean for a 1 Tbyte
> >         filesystem:
> > 
> >         1Tbyte / 4096 / 8 = 32 Mbyte of memory (this should of course
> >         be saved to disk from time to time and be restored on startup).
> > 
> 
> Sorry, a 1TB drive is teeny, I don't think a bitmap is practical across
> the whole FS.

32Mbyte of memory is teeny too.  You can pick up a server with 32Gb for
about $5k these days.  Using 10% of that gives you room for 100Tb of
storage, which is getting to be a reasonable size.  More than that and
you would be thinking of bigger machines anyway to have enough memory
for a decent cache.

(32Gb seems to be the nice price point, because 4Gb dimms are cheap as
chips, and 8Gb are way expensive.  We're buying 32Gb machines at the
moment)

Bron ( ok, so I don't work with giant enterprise systems.  I can see
       that there are cases where this might suck, but memory seems
       to be growing as fast as disk in the low end )
