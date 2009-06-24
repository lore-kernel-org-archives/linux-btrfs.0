From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Phoronix article slaming BTRFS
Date: Wed, 24 Jun 2009 10:31:16 +0200
Message-ID: <20090624083116.GI31415@kernel.dk>
References: <loom.20090623T024010-331@post.gmane.org> <20090623144123.GB19276@think> <20090623181935.2b01c17d.skraw@ithnet.com> <loom.20090624T021752-858@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Mike Ramsey <MikeJRamsey@comcast.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <loom.20090624T021752-858@post.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 24 2009, Mike Ramsey wrote:
> Stephan von Krawczynski <skraw <at> ithnet.com> writes:
> 
> [snip]
> > 
> > Can someone explain to a quite naive person like me why one should be
> > interested in SSDs that perform worse than Intel? Why shouldn't I just buy the
> > best-performing product? This is a moving market, and it is obvious that the
> > bad performers will be left behind...
> > If you really care to fiddle with ssd options then use a real bad hw for
> > testing the performance - take an ide interface and connect a CF card.
> > This is a common setup for embedded usage and frequently used. Everything in
> > between CF and Intel will just be dead before your fs options will become
> > really stable. So why loose time with it?
> > 
> 
> Depends on who you talk to.
> 
> http://www.tomshardware.com/news/ocz-ssd-vertex-intel-solid-state,7127.html
> 
> "OCZ Says Its New Vertex SSD Beats Intel's X25-E"

Heh, the Vertex beating the X25-E? I think such a statement could only
come from OCZ. No amount of magic will suddenly make MLC beat SLC, let
alone a well tuned firmware like the X25-E's. I'm sure they concocted
some synthetic benchmark where the Vertex has some slight edge. In the
real world, the X25-E wipes the floor with the Vertex.

The Vertex is indeed a good performer, in its price range it's currently
the one to beat. I have doubts about the maturity of the product though,
looks mostly like a live beta being tested in the field. So I'd just be
careful with what kind of use they are put to. But just running tests on
the drive does show that it performs well for most things.

-- 
Jens Axboe

