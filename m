From: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Subject: Re: [PATCH] btrfs file write debugging patch
Date: Mon, 7 Mar 2011 23:12:07 +0100
Message-ID: <201103072312.08371.johannes.hirte@fem.tu-ilmenau.de>
References: <BAY156-w43472A651462DCADA1F9FAD2C10@phx.gbl> <AANLkTikP0wWvRpGis+-mmuu_CvRnq9j0AdGuHrb9Y5WF@mail.gmail.com> <1299527810.11172.8.camel@mainframe>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Cc: Mitch Harder <mitch.harder@sabayonlinux.org>,
	Chris Mason <chris.mason@oracle.com>,
	Xin Zhong <thierryzhong@hotmail.com>,
	"xin.zhong" <xin.zhong@intel.com>,
	"linux-btrfs" <linux-btrfs@vger.kernel.org>
To: Maria =?utf-8?q?Wikstr=C3=B6m?= <maria@ponstudios.se>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1299527810.11172.8.camel@mainframe>
List-ID: <linux-btrfs.vger.kernel.org>

On Monday 07 March 2011 20:56:50 Maria Wikstr=C3=B6m wrote:
> m=C3=A5n 2011-03-07 klockan 00:07 -0600 skrev Mitch Harder:
> > On Sun, Mar 6, 2011 at 6:58 PM, Chris Mason <chris.mason@oracle.com=
>=20
wrote:
> > > Excerpts from Chris Mason's message of 2011-03-06 13:00:27 -0500:
> > >> Excerpts from Mitch Harder's message of 2011-03-05 11:50:14 -050=
0:
> > >> > I've constructed a test patch that is currently addressing all=
 the
> > >> > issues on my system.
> > >> >=20
> > >> > The portion of Openmotif that was having issues with page faul=
ts
> > >> > works correctly with this patch, and gcc-4.4.5 builds without
> > >> > issue.
> > >> >=20
> > >> > I extracted only the portion of the first patch that corrects =
the
> > >> > handling of dirty_pages when copied=3D=3D0, and incorporated t=
he second
> > >> > patch that falls back to one-page-at-a-time if there are troub=
les
> > >> > with page faults.
> > >>=20
> > >> Just to make sure I understand, could you please post the full
> > >> combined path that was giving you trouble with gcc?  We do need =
to
> > >> make sure the pages are properly up to date if we fall back to
> > >> partial writes.
> > >=20
> > > Ok, I was able to reproduce this easily with fsx.  The problem is=
 that
> > > I wasn't making sure the last partial page in the write was up to=
 date
> > > when it was also the first page in the write.
> >=20
> > > Here is the updated patch, it has all the fixes we've found so fa=
r:
> > This latest patch that Chris has sent out fixes the issues I've bee=
n
> > encountering.
> >=20
> > I can build gcc-4.4.5 without problems.
> >=20
> > Also, the portion of Openmotif that was having issues with page fau=
lts
> > is working correctly.
> >=20
> > Let me know if you still would like to see the path names for the
> > portions of the gcc-4.4.5 build that were giving me issues.  I didn=
't
> > save that information, but I can regenerate it.  But it sounds like
> > it's irrelevant now.
>=20
> With the patch I can compile libgcrypt without any problem, so it sol=
ves
> my problems to.

Can confirm this. And the bug seems to be hardware-related. On my Penti=
um4=20
system it was 100% reproducible, on my Atom-based system I couldn't tri=
gger=20
it.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
