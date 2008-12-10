From: Ray Van Dolson <rayvd@bludgeon.org>
Subject: Re: Data De-duplication
Date: Wed, 10 Dec 2008 13:19:03 -0800
Message-ID: <20081210211903.GA29002@bludgeon.org>
References: <1228862899.8130.1.camel@mattos-laptop> <1228915802.11900.8.camel@think.oraclecorp.com> <32809.2001:470:e828:1::2:2.1228939660.squirrel@avalon.arbitraryconstant.com> <1228943437.7571.1.camel@mattos-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: btrfs-devel@arbitraryconstant.com,
	Chris Mason <chris.mason@oracle.com>,
	linux-btrfs@vger.kernel.org
To: Oliver Mattos <oliver.mattos08@imperial.ac.uk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1228943437.7571.1.camel@mattos-laptop>
List-ID: <linux-btrfs.vger.kernel.org>

I lost the original post so I'm jumping in at the wrong thread-point :)
Someone mentioned that the primary usage of de-dup is in the backup
realm.  True perhaps currently, but de-dup IMO is *the* killer app in
the world of virtualization and is a huge reason why we're picking
NetApp at work to back our NFS VMware DataStores.  We easily see 50%
savings in space.

I know of only one other production filesystem implementation of
data-dedup -- GreenBytes has it in their ZFS-based storage product.

I'm not sure why this hasn't caught on, but as soon as a solid and fast
implementation of it exists in the Linux world I really think it can
catch on for VM datastores.... I know we've hollered at Sun as to why
they haven't rolled it out for ZFS yet!

Anyways, I know it's on the roadmap, just like throwing my $0.02 once
in a while on how big a feature I think this could be......

Great job all :)
Ray
