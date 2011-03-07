From: Maria =?ISO-8859-1?Q?Wikstr=F6m?= <maria@ponstudios.se>
Subject: Re: [PATCH] btrfs file write debugging patch
Date: Mon, 07 Mar 2011 20:56:50 +0100
Message-ID: <1299527810.11172.8.camel@mainframe>
References: <BAY156-w43472A651462DCADA1F9FAD2C10@phx.gbl>
	 <AANLkTi=6G2A1Lb6aWwtFeLgJvV2k_syss4rRfokbFG56@mail.gmail.com>
	 <1865303E0DED764181A9D882DEF65FB68662CD02C8@shsmsx502.ccr.corp.intel.com>
	 <1299203447-sup-9359@think> <1299241124-sup-3502@think>
	 <BAY156-w4980F081E2593ACCC07B2AD2C20@phx.gbl>
	 <AANLkTikFVd3kG4J99BQvVUwb05DRQXLyabsHieeTZCBW@mail.gmail.com>
	 <AANLkTinjtx37eJ+v6WS=Y8z_Brkb9YGq5cZdFP1bVWGB@mail.gmail.com>
	 <BAY156-w342CF81501D00C36A69EABD2C50@phx.gbl>
	 <AANLkTimDvTraBapv18iOf8wmUh8nSnUay2etXvjEv77P@mail.gmail.com>
	 <AANLkTi=gqurEsoMZv+10Np4duOKq4kZf77mTgu6BfkSC@mail.gmail.com>
	 <1299434330-sup-8189@think> <1299459296-sup-3057@think>
	 <AANLkTikP0wWvRpGis+-mmuu_CvRnq9j0AdGuHrb9Y5WF@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Chris Mason <chris.mason@oracle.com>,
	Xin Zhong <thierryzhong@hotmail.com>,
	"xin.zhong" <xin.zhong@intel.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Mitch Harder <mitch.harder@sabayonlinux.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTikP0wWvRpGis+-mmuu_CvRnq9j0AdGuHrb9Y5WF@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

m=C3=A5n 2011-03-07 klockan 00:07 -0600 skrev Mitch Harder:
> On Sun, Mar 6, 2011 at 6:58 PM, Chris Mason <chris.mason@oracle.com> =
wrote:
> > Excerpts from Chris Mason's message of 2011-03-06 13:00:27 -0500:
> >> Excerpts from Mitch Harder's message of 2011-03-05 11:50:14 -0500:
> >> > I've constructed a test patch that is currently addressing all t=
he
> >> > issues on my system.
> >> >
> >> > The portion of Openmotif that was having issues with page faults=
 works
> >> > correctly with this patch, and gcc-4.4.5 builds without issue.
> >> >
> >> > I extracted only the portion of the first patch that corrects th=
e
> >> > handling of dirty_pages when copied=3D=3D0, and incorporated the=
 second
> >> > patch that falls back to one-page-at-a-time if there are trouble=
s with
> >> > page faults.
> >>
> >> Just to make sure I understand, could you please post the full com=
bined
> >> path that was giving you trouble with gcc?  We do need to make sur=
e the
> >> pages are properly up to date if we fall back to partial writes.
> >
> > Ok, I was able to reproduce this easily with fsx.  The problem is t=
hat I
> > wasn't making sure the last partial page in the write was up to dat=
e
> > when it was also the first page in the write.
> >
> > Here is the updated patch, it has all the fixes we've found so far:
> >
>=20
> This latest patch that Chris has sent out fixes the issues I've been
> encountering.
>=20
> I can build gcc-4.4.5 without problems.
>=20
> Also, the portion of Openmotif that was having issues with page fault=
s
> is working correctly.
>=20
> Let me know if you still would like to see the path names for the
> portions of the gcc-4.4.5 build that were giving me issues.  I didn't
> save that information, but I can regenerate it.  But it sounds like
> it's irrelevant now.

With the patch I can compile libgcrypt without any problem, so it solve=
s
my problems to.

// Maria



--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
