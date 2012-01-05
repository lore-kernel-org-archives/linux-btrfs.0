From: Chris Samuel <chris@csamuel.org>
Subject: Re: [3.2-rc7] slowdown, warning + oops creating lots of files
Date: Fri, 06 Jan 2012 08:24:32 +1100
Message-ID: <1325798672.17974.2.camel@Nokia-N900>
References: <20120104214445.GE17026@dastard>
	 <20120104221105.GF17026@dastard> <4F04D178.2070006@csamuel.org>
	 <20120104230122.GA24466@dastard> <20120105184657.GC30372@shiny>
	 <20120105194500.GD30372@shiny> <20120105201216.GG24466@dastard>
	  <20120105210255.GE30372@shiny>
Reply-To: Chris Samuel <chris@csamuel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>,
	Dave Chinner <david@fromorbit.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120105210255.GE30372@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri,=C2=A0  6 Jan 2012, 08:02:55 EST, Chris Mason <chris.mason@oracl=
e.com> wrote:

> Yeah, same thing here.=C2=A0  I'm testing a fix now, it's pretty dumb=
=2E=C2=A0  We're
> not allocating more metadata chunks from the drive because of where t=
he
> allocation is happening, so it is just a check for "do we need a new
> chunk" in the right place.
>=20
> I'll make sure it can fill my ssd and then send to you.

*If* the fix works would this be a candidate for a
stable 3.2.1 release rather than having to wait for
3.3?

cheers,
Chris
--=20
Chris Samuel - http://www.csamuel.org/ - on mobile
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
