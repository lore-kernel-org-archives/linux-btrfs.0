From: Oliver Mattos <oliver.mattos08@imperial.ac.uk>
Subject: Re: Data De-duplication
Date: Wed, 10 Dec 2008 22:06:18 +0000
Message-ID: <1228946778.7571.28.camel@mattos-laptop>
References: <1228862899.8130.1.camel@mattos-laptop>
	 <1228915802.11900.8.camel@think.oraclecorp.com>
	 <32809.2001:470:e828:1::2:2.1228939660.squirrel@avalon.arbitraryconstant.com>
	 <1228943437.7571.1.camel@mattos-laptop>
	 <20081210211903.GA29002@bludgeon.org>
	 <1228945336.7571.26.camel@mattos-laptop>
	 <20081210215754.GT23979@tracyreed.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Ray Van Dolson <rayvd@bludgeon.org>,
	<btrfs-devel@arbitraryconstant.com>,
	Chris Mason <chris.mason@oracle.com>,
	<linux-btrfs@vger.kernel.org>
To: Tracy Reed <treed@tracyreed.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20081210215754.GT23979@tracyreed.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2008-12-10 at 13:57 -0800, Tracy Reed wrote:
> On Wed, Dec 10, 2008 at 09:42:16PM +0000, Oliver Mattos spake thusly:
> > I'm considering writing that script to test on my ext3 disk just to see
> > how much duplicate wasted data I really have.
> 
> Check out the fdupes command. In Fedora 8 it is in the yum repo as
> fdupes-1.40-10.fc8
> 
FDupes is good for whole file matches, but btrfs supports partial-file
duplication elimination (eg. where two big files share some parts in
common but other parts have changed).  Fdupes would be a good start
though.

