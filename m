Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:57668 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1947017Ab3BHUs3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Feb 2013 15:48:29 -0500
Date: Fri, 8 Feb 2013 20:48:23 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Ilya Dryomov <idryomov@gmail.com>
Cc: Ian Kumlien <pomac@demius.net>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 6/6] Btrfs-progs: add the rescue section to btrfs
Message-ID: <20130208204823.GC28997@carfax.org.uk>
References: <1360283822-23452-1-git-send-email-pomac@demius.net>
 <1360283822-23452-7-git-send-email-pomac@demius.net>
 <20130208195717.GA2477@zambezi.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5G06lTa6Jq83wMTw"
In-Reply-To: <20130208195717.GA2477@zambezi.lan>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--5G06lTa6Jq83wMTw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 08, 2013 at 09:57:17PM +0200, Ilya Dryomov wrote:
> On Fri, Feb 08, 2013 at 01:37:02AM +0100, Ian Kumlien wrote:
> > the btrfs command now lists:
> >     btrfs rescue select-super -s <number> <device>
> >         Select a superblock
> >     btrfs rescue dump-super <device>
> >         Dump a superblock to disk
> >     btrfs rescue debug-tree [options] <device>
> >         Debug the filesystem
> > 
> > btrfs-dump-super.c was imported in to cmds-rescue-super-ops.c
> > 
> > This patch integrates all the functionality...
> > 
> > cmds-rescue.c is used to glue cmds-rescue-debug-tree.c,
> > cmds-rescue-restore.c and cmds-rescue-super-ops.c together to
> > make the source files more managable.
> 
> I think btrfs-debug-tree should go under debug -- btrfs debug dump-tree.
> Same goes for btrfs-dump-super -- btrfs debug dump-super.  These
> commands won't help an average user to rescue a single byte, they are
> there to help developers.  I suppose you can also import btrfs-image
> under btrfs debug dump-image.

   Can I put in a suggestion of using inspect-internal instead? Since
we've already got that one already? (But I'm not bothered about debug;
either is good).

   Hugo.

> This leaves the question of whether we want select-super under rescue.
> Given that it can easily do more harm than good, it might not be the
> best place for it..
> 
> Thanks,
> 
> 		Ilya

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
       --- The early bird gets the worm,  but the second mouse ---       
                            gets the cheese.                             

--5G06lTa6Jq83wMTw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBURVkl79z9OVl50rAAQIWQw//Serf+825vsGUPokOipJrUP45j1tJTa5k
GPHH7U8O8syZOC3GhYjj3y6XdM6IrhhPi/OSsY7PmBzXDxuQT/k8YSzLCL0oRRsY
jK64TZ5CrA4ouNjs4DQVs9mmVAwR5sshgzOS0RfwXSua+mS/2JiQNRlG1jsk1B3x
mRijb4fRsOtDYNPquTzVSbu7OJZvPY9QUIKMI9jsLEPs0imMIUVuFRjZPxTNAwlu
pfqJ+UQ4OcqTkoFD8Gi13ZNmYuGLz4MPiCz3wdu+m7hWwg/0syVukGN90jPey5h+
VsmOmM+K4MbecN2lkPDoVSYU0T8gSUSSy8f8eIHkGvjQytAw9hcewuy1EewFbhdO
//ZM1UO0IOaXvGxwkZQs9Ul0+kaDPTL0+AkrFwEUWRpaptgcQUwC1YUaN89VMHTl
CrjuAwnaaU6XqK3oCS6MEROVquHnjMhuFTXwHGrNsSbgiT/+mBE6sEJVS2DyAnIZ
+23hY5XNY++RlYeb5U0hXlpF0FZMdjQZW2PcFKrJFXI1zP9BOLpFpyT/6gVt4vsN
riPxZ4DeCEgJCkmR8+O8eSOlWepg3IDhXYGJZQtYIrMPrffnc4eCZor66D6SwW3q
NvKrnfFIOUkeLQWIFE5wSdfeGTDGdyZmSGJDBgZY6eiJ4SsEKBTIft8lGHRytQFE
l1OMRyhHPVo=
=boJ+
-----END PGP SIGNATURE-----

--5G06lTa6Jq83wMTw--
