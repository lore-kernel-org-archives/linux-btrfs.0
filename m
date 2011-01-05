From: Ray Van Dolson <rayvd@bludgeon.org>
Subject: Re: Offline Deduplication for Btrfs
Date: Wed, 5 Jan 2011 11:01:41 -0800
Message-ID: <20110105190139.GA32671@bludgeon.org>
References: <1294245410-4739-1-git-send-email-josef@redhat.com>
 <4D24AD92.4070107@bobich.net>
 <201101051941.13268.diegocg@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: Gordan Bobic <gordan@bobich.net>,
	BTRFS MAILING LIST <linux-btrfs@vger.kernel.org>
To: Diego Calleja <diegocg@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201101051941.13268.diegocg@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 05, 2011 at 07:41:13PM +0100, Diego Calleja wrote:
> On Mi=E9rcoles, 5 de Enero de 2011 18:42:42 Gordan Bobic escribi=F3:
> > So by doing the hash indexing offline, the total amount of disk I/O=
=20
> > required effectively doubles, and the amount of CPU spent on doing =
the=20
> > hashing is in no way reduced.
>=20
> But there are people who might want to avoid temporally the extra cos=
t
> of online dedup, and do it offline when the server load is smaller.
>=20
> In my opinion, both online and offline dedup have valid use cases, an=
d
> the best choice is probably implement both.

Question from an end-user.  When we say "offline" deduplication, are we
talking about post-process deduplication (a la what Data ONTAP does
with their SIS implementation) during which the underlying file system
data continues to be available, or a process that needs exclusive
access ot the blocks to do its job?

Ray
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
