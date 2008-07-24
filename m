From: Chris Mason <chris.mason@oracle.com>
Subject: Re: kernel BUG at extent_map.c:275!
Date: Thu, 24 Jul 2008 10:34:40 -0400
Message-ID: <1216910080.6932.174.camel@think.oraclecorp.com>
References: <1216697528.18980.34.camel@shinybook.infradead.org>
	 <1216697801.18980.40.camel@shinybook.infradead.org>
	 <1216722065.6932.125.camel@think.oraclecorp.com>
	 <1216737343.18980.98.camel@shinybook.infradead.org>
	 <1216746235.6932.129.camel@think.oraclecorp.com>
	 <1216748498.3019.9.camel@shinybook.infradead.org>
	 <48861C07.3040103@oracle.com>
	 <1216749897.3019.18.camel@shinybook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Zach Brown <zach.brown@oracle.com>, linux-btrfs@vger.kernel.org
To: David Woodhouse <dwmw2@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1216749897.3019.18.camel@shinybook.infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2008-07-22 at 14:04 -0400, David Woodhouse wrote:
> On Tue, 2008-07-22 at 10:42 -0700, Zach Brown wrote:
> > David Woodhouse wrote:
> > > On Tue, 2008-07-22 at 13:03 -0400, Chris Mason wrote:
> > >> Well, the test is there to make sure the caller is doing the right
> > >> thing.  Before we remove it, I'd like to understand why it is failing.
> > > 
> > > Because this is a uniprocessor kernel. So spin_lock() and spin_unlock()
> > > both do absolutely nothing, and spin_trylock() _always_ returns 1.
> > 
> > How about using assert_spin_locked()?
> 
> Yeah, that should work if we still need these checks.
> 

This one is applied now and pushed out.

-chris


