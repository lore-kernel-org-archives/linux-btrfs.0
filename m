Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:54787 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932927Ab2GYOAm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Jul 2012 10:00:42 -0400
Date: Wed, 25 Jul 2012 15:00:36 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Alexander Block <ablock84@googlemail.com>
Cc: Arne Jansen <sensille@gmx.net>, linux-btrfs@vger.kernel.org
Subject: Re: [RFC PATCH 0/6] Experimental btrfs send/receive (btrfs-progs)
Message-ID: <20120725140036.GE30007@carfax.org.uk>
References: <1341409174-13619-1-git-send-email-ablock84@googlemail.com>
 <500D43A7.1010801@gmx.net>
 <CAB9VWqAGTOttaz722LnMiufPNUZaLQU7epAdGFejK9gssuHnRg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CGDBiGfvSTbxKZlW"
In-Reply-To: <CAB9VWqAGTOttaz722LnMiufPNUZaLQU7epAdGFejK9gssuHnRg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--CGDBiGfvSTbxKZlW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 25, 2012 at 12:41:56PM +0200, Alexander Block wrote:
> On Mon, Jul 23, 2012 at 2:29 PM, Arne Jansen <sensille@gmx.net> wrote:
> > On 04.07.2012 15:39, Alexander Block wrote:
> >> Hello all,
> >>
> >> This is the user space side of btrfs send/receive.
> >>
> >> You can apply them manually or use my git repo:
> >>
> >> git://github.com/ablock84/btrfs-progs.git (branch send)
> >>
> >> The branch is based on Hugo's integration-20120605 branch. I had to add a temporary
> >> commit to fix a bug introduced in one of the strncpy/overflow patches that got into
> >> btrfs-progs. This fix is not part of the btrfs send/receive patchset, but you'll
> >> probably need it if you want to base on the integration branch. I hope this is not
> >> required in the future when a new integration branch comes out.
> >>
> >> Example usage:
> >>
> >> Multiple snapshots at once:
> >> btrfs send /mnt/snap[123] > snap123.btrfs
> >
> > a) Do we really want a single token command here, not
> > btrfs filesystem send or subvol send?
> In my opinion the single token is easier to type and remember. But if
> enough speaks for normal subcommands this can be changed (but by
> someone else as I'm running out of time).

   Since everything else is two commands, yes, I think we need it for
consistency. (And, since it's a publically-visible interface, for
acceptance of the patches -- we don't want to be changing the way the
commands work after the fact).

> > b) zfs makes sure stdout is not a tty, to prevent flooding
> > your console. This kinda makes sense.
> This makes sense. But again, this has to be done by someone else.

   Can you keep a brief list of such cleanups/features and dump it on
the wiki as a proposed project when your time does run out, please.
That way the details don't get lost, and they can be found by other
people and dealt with independently.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
    --- Turning,  pages turning in the widening bath, / The spine ---    
        cannot bear the humidity. / Books fall apart; the binding        
            cannot hold. / Page 129 is loosed upon the world.            

--CGDBiGfvSTbxKZlW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iD8DBQFQD/wDIKyzvlFcI40RAs8oAJwLvTlZ3faGHrrGZWZ44lCha3qehQCcD/vy
lPcy/OhweOpX+hb1s0M0ATw=
=Hmb9
-----END PGP SIGNATURE-----

--CGDBiGfvSTbxKZlW--
