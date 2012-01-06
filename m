From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [3.2-rc7] slowdown, warning + oops creating lots of files
Date: Thu, 5 Jan 2012 20:22:44 -0500
Message-ID: <20120106012244.GO30372@shiny>
References: <20120104214445.GE17026@dastard>
 <20120104221105.GF17026@dastard>
 <4F04D178.2070006@csamuel.org>
 <20120104230122.GA24466@dastard>
 <20120105184657.GC30372@shiny>
 <20120105194500.GD30372@shiny>
 <20120105201216.GG24466@dastard>
 <20120105210255.GE30372@shiny>
 <1325798672.17974.2.camel@Nokia-N900>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: Dave Chinner <david@fromorbit.com>, linux-btrfs@vger.kernel.org
To: Chris Samuel <chris@csamuel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1325798672.17974.2.camel@Nokia-N900>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 06, 2012 at 08:24:32AM +1100, Chris Samuel wrote:
> On Fri,=A0  6 Jan 2012, 08:02:55 EST, Chris Mason <chris.mason@oracle=
=2Ecom> wrote:
>=20
> > Yeah, same thing here.=A0  I'm testing a fix now, it's pretty dumb.=
=A0  We're
> > not allocating more metadata chunks from the drive because of where=
 the
> > allocation is happening, so it is just a check for "do we need a ne=
w
> > chunk" in the right place.
> >=20
> > I'll make sure it can fill my ssd and then send to you.
>=20
> *If* the fix works would this be a candidate for a
> stable 3.2.1 release rather than having to wait for
> 3.3?

Yes, it's pretty safe.

-chris

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
