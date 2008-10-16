From: Valerie Aurora Henson <vaurora@redhat.com>
Subject: Re: Data-deduplication?
Date: Thu, 16 Oct 2008 15:25:01 -0400
Message-ID: <20081016192501.GE16946@shell>
References: <20081012020629.GA14615@bludgeon.org> <1223895734.7032.1.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ray Van Dolson <rayvd@bludgeon.org>, linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1223895734.7032.1.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 13, 2008 at 07:02:14AM -0400, Chris Mason wrote:
> On Sat, 2008-10-11 at 19:06 -0700, Ray Van Dolson wrote:
> > I recall their being a thread here a number of months back regarding
> > data-deduplication support for bttfs.
> > 
> > Did anyone end up picking that up and giving a go at it?  Block level
> > data dedup would be *awesome* in a Linux filesystem.  It does wonders
> > for storing virtual machines w/ NetApp and WAFL, and even ZFS doesn't
> > have this feature yet (although I've read discussions on them looking
> > to add it).
> > 
> 
> So far nobody has grabbed this one, but I've had more requests (no
> shocker there, the kvm people are interested in it too).  It probably
> won't make 1.0 but the disk format will be able to support it.

Both deduplication and compression have an interesting side effect in
which a write to a previously "allocated" block can return ENOSPC.
This is even more exciting when you factor in mmap.  Any thoughts on
how to handle this?

-VAL
