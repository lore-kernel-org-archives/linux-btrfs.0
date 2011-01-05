From: Josef Bacik <josef@redhat.com>
Subject: Re: Offline Deduplication for Btrfs
Date: Wed, 5 Jan 2011 15:28:54 -0500
Message-ID: <20110105202854.GE2562@localhost.localdomain>
References: <1294245410-4739-1-git-send-email-josef@redhat.com> <4D24AD92.4070107@bobich.net> <201101051941.13268.diegocg@gmail.com> <20110105190139.GA32671@bludgeon.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: Diego Calleja <diegocg@gmail.com>,
	Gordan Bobic <gordan@bobich.net>,
	BTRFS MAILING LIST <linux-btrfs@vger.kernel.org>
To: Ray Van Dolson <rayvd@bludgeon.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110105190139.GA32671@bludgeon.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 05, 2011 at 11:01:41AM -0800, Ray Van Dolson wrote:
> On Wed, Jan 05, 2011 at 07:41:13PM +0100, Diego Calleja wrote:
> > On Mi=E9rcoles, 5 de Enero de 2011 18:42:42 Gordan Bobic escribi=F3=
:
> > > So by doing the hash indexing offline, the total amount of disk I=
/O=20
> > > required effectively doubles, and the amount of CPU spent on doin=
g the=20
> > > hashing is in no way reduced.
> >=20
> > But there are people who might want to avoid temporally the extra c=
ost
> > of online dedup, and do it offline when the server load is smaller.
> >=20
> > In my opinion, both online and offline dedup have valid use cases, =
and
> > the best choice is probably implement both.
>=20
> Question from an end-user.  When we say "offline" deduplication, are =
we
> talking about post-process deduplication (a la what Data ONTAP does
> with their SIS implementation) during which the underlying file syste=
m
> data continues to be available, or a process that needs exclusive
> access ot the blocks to do its job?
>=20

Yeah its just a post-process thing, you run it when you care to run it =
and it
doesn't make anything unavailable.  Thanks,

Josef
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
