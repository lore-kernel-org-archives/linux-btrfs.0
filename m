From: David Woodhouse <dwmw2@infradead.org>
Subject: Re: kernel BUG at extent_map.c:275!
Date: Tue, 22 Jul 2008 13:41:38 -0400
Message-ID: <1216748498.3019.9.camel@shinybook.infradead.org>
References: <1216697528.18980.34.camel@shinybook.infradead.org>
	 <1216697801.18980.40.camel@shinybook.infradead.org>
	 <1216722065.6932.125.camel@think.oraclecorp.com>
	 <1216737343.18980.98.camel@shinybook.infradead.org>
	 <1216746235.6932.129.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1216746235.6932.129.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2008-07-22 at 13:03 -0400, Chris Mason wrote:
> Well, the test is there to make sure the caller is doing the right
> thing.  Before we remove it, I'd like to understand why it is failing.

Because this is a uniprocessor kernel. So spin_lock() and spin_unlock()
both do absolutely nothing, and spin_trylock() _always_ returns 1.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation


