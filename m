Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:34149 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932688AbbENRf4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 May 2015 13:35:56 -0400
Date: Thu, 14 May 2015 17:35:55 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: lauri <lauri.vosandi@gmail.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dave@jikos.cz>
Subject: Re: [PATCH] btrfs-progs: receive explicit parent support
Message-ID: <20150514173555.GB18480@carfax.org.uk>
References: <1430043165-20641-1-git-send-email-lauri.vosandi@gmail.com>
 <20150426111943.GZ18187@carfax.org.uk>
 <CAJ1pDqR6Q_cfLiKoNKReC1Rx76BkNXj3pY6_CqHeyL3J_hSf6g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LCbsoPZWBRMqE7TI"
In-Reply-To: <CAJ1pDqR6Q_cfLiKoNKReC1Rx76BkNXj3pY6_CqHeyL3J_hSf6g@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--LCbsoPZWBRMqE7TI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Apr 26, 2015 at 02:37:58PM +0300, lauri wrote:
> > Subvol A on source side: (A, -)
> > Send this to A' on target side: (A', A)
> > Send this back to A'' on source side: (A'', A) <-- Note the A here, not=
 A'
>=20
> I also think your approach is the real solution to the problem, but as
> some pointed out on IRC this changes the behaviour of btrfs receive
> and will break things for someone. When I asked whose obscure workflow
> does it break nobody could come up with any reasonable example whereas
> sending snapshots back and forth seems to be the major usecase for
> btrfs receive and it's impossible to for example restore snapshots
> with current implementation.
>=20
> I know that -p may fail horribly but the idea was to have *option* to
> replace parent lookup logic and instead of relying on UUID-s simply
> have it specified by userspace application.

   My argument is that having this option present will mean that
people will use it. Getting send/receive right is hard enough as it is
without giving someone an option which can completely screw things up
in *most* cases. If you want an analogy, it's a bit like giving
someone a drum of nerve toxin to get rid of the fly in their kitchen,
rather than a fly swatter. (Yes, a bad analogy is like a leaky
screwdriver, and this one's engaging in a bit of hyperbole, but I hope
it gets my point across.)

> >    More later, when I've had a little time to play with things and
> > think through the semantics properly.
>=20
> You want to give it a try?

   Finally, I managed to spend some time with it. What follows is long
and detailed, but I hope it's clear, and rigorous. I'd like someone
with a mathematical turn of mind to give this a good kicking, because
there may be some errors in it, but I think it's right.

   A subvolume may be described by the tuple (u, r, p), where u is the
UUID of the subvolume itself, r is the "received UUID" set to indicate
the original send source of the subvolume, and p is the UUID of the
parent subvolume, set when a snapshot is taken. We indicate a
read-only snapshot with a * suffix. The location of a subvolume is
shown with the filesystem prefixed to it: m(u, r, p).

   We use capital letters (A, B, C, ...) to indicate subvolumes, and
S, T to indicate the "source" and "target" filesystems. Note that send
operations will sometimes go from T to S in the examples that follow.

   There are four functions we need to consider: two for snapshots and
two for send operations. The current definitions of the functions are:

Ordinary snapshot:
   Snap(m(u1, #, #))  -> m(u2, -, u1)

Read-only snapshot:
   SnapR(m(u1, #, #))  -> m(u2, -, u1)*

Full send:
   Send(m1(u1, #, #)*, m2) -> m2(u2, u1, -)*

Incremental send:
   SendP(m1(u2, #, p1)*, m1(u1, r1, p1)*, m2) -> m2(u3, u2, p2)*
            precondition: m2(p2, u1, #)* exists for some p2.

where # means "don't care" in all cases.

   This latter function sends m1(u2, #, p1)* to m2, using m1(u1, r1,
p1)* as the parameter to the -p command option (e.g. the reference
point for the incremental stream). The precondition is necessary to
ensure that the reference subvolumes on each side are identical. The
m1(u1, r1, p1)* is the same subvolume data as m2(p2, u1, #)* because
the only way that the second field of a subvolume can be set is via
one of the Send functions, which don't modify the subvolume data (or,
through the read-only property, allow it to be modified).

   Now, there are two use cases we want to support: 1) restore from
backups and continue with incrementals; 2) bidirectional
synchronisation, where incremental sends are used to shift the state
of a subvolume from one machine to another and back again. These are
very similar cases -- the former case simply uses a full send from T
to S, rather than the incremental send used in the latter case.

First use case: restore from backups
------------------------------------

The first use case goes something like this:

1) Create a subvolume, S(A, -, -) as the working subvol.
2) Make a backup to T:
 a  SnapR(S(A, -, -))                   ->  S(B, -, A)*
 b  Send(S(B, -, A)*, T)                ->               T(C, B, -)*
3) Subvol A is modified
4) Make an incremental backup to T
 a  SnapR(S(A, -, -))                   ->  S(D, -, A)*
 b  SendP(S(D, -, A)*, S(B, -, A)*, T)  ->               T(E, D, C)*
 (repeat 3, 4 ad libitum)
5) A meteorite strike destroys S, and it is replaced with a blank machine
6) Restore the backup, making a new working subvol G
 a  Send(T(E, D, C)*, S)                ->  S(F, E, -)*
 b  Snap(S(F, E, -)*)                   ->  S(G, -, F)
7) The new working subvol S(G, -, F) is modifed
8) Make an incremental backup to T
 a  SnapR(S(G, -, F))                   ->  S(H, -, G)*
 b  SendP(S(H, -, G)*, S(F, E, -)*, T)  ->               T(I, H, E)*

Now, with the current implementation, 8b will fail for two reasons:

 - We can't immediately tell that S(H, -, G)* and S(F, E, -)* are
   related, and
 - T(#, F, #)* doesn't exist.

However, it should be allowed to succeed, because there's a chain
of snapshots connecting S(F, E, -)* to S(H, -, G)*, so one is a direct
ancestor of the other. Further, a subvolume equivalent to E exists on
both S and T after step 7 -- E and F respectively. The subvolume S(F,
E, -)* has enough metadata to be able to correctly identify that it's
equivalent to T(E, D, C)*, but the precondition on the SendP function
doesn't support it.

Second use case: bidirectional synchronisation
----------------------------------------------

   Let's leave that there for the moment and look at the second
use-case:

1) Create a subvolume, S(A, -, -) as the working subvol.
2) Make a backup to T:
 a  SnapR(S(A, -, -))                   ->  S(B, -, A)*
 b  Send(S(B, -, A)*, T)                ->               T(C, B, -)*
3) Subvol A is modified
4) Make an incremental backup to T
 a  SnapR(S(A, -, -))                   ->  S(D, -, A)*
 b  SendP(S(D, -, A)*, S(B, -, A)*, T)  ->               T(E, D, C)*
 (repeat 3, 4 ad libitum)
5) Make a working copy on T
    Snap(T(E, D, C))                    ->               T(F, -, E)
6) Subvol F is modified
7) Send the changes back to S
 a  SnapR(T(F, -, E))                   ->               T(G, F, -)*
 b  SendP(T(G, F, -)*, T(E, D, C)*, S)  ->  S(H, G, D)*

Again, with the current implementation, this will fail -- at step 7b
this time. As before, there's two reasons why:

 - We can't immediately tell that T(G, F, -)* and T(E, D, C)* are
   related, and
 - T(#, E, #)* doesn't exist.

As before, it should be allowed, because there's a chain of snapshots
connecting T(E, D, C)* to T(G, F, -)*, so the former is a direct
ancestor of the latter, and because S(D, -, A)* is a duplicate of the
reference subvolume T(E, D, C)*.

   Now, in the first case we've got S(F, E, -)* on the source side,
and T(E, D, C)* on the target side. In the second case, we have T(E,
D, C)* on the source and S(D, -, A)* on the target. In both cases,
we're looking for a subvolume on the target whose UUID matches the
Received UUID of the source side's reference subvolume. This contrasts
with the original algorithm, where we only look for a subvolume on the
target whose Received UUID matches the UUID of the source side's
reference.

What to do about it
-------------------

   So, to support these two use-cases, our SendP function needs to
look like this:

   SendP(m1(u2, #, p1)*, m1(u1, r1, p1)*, m2) -> m2(u3, u2, p2)*
            precondition: m2(p2, u1, #)* exists for some p2,
   or
   SendP(m1(u2, #, p1)*, m1(u1, r1, #)*, m2) -> m2(u3, u2, r1)*
            precondition: m2(r1, #, #)* exists,
	              and m1(p1, -, u1)# exists.

or, in other words, the first form is where the reference subvolume
has been sent to the target machine; the second form is where the
reference subvolume has come *from* the target machine. The other term
in the precondition simply verifies that there has been a chain of
snapshots on the local machine that connects the subject of the send
back to the reference subvolume. So, finally, we end up with the final
form of the function as:

   SendP(m1(u2, #, p1)*, m1(u1, r1, p2)*, m2) -> m2(u3, u2, p3)*
          preconditions:
              (chain rule)     m1(p1, -, u1)# exists or p1 =3D=3D p2
          and (reference rule) m2(p2, u1, #)* exists or m2(r1, #, #)* exists

The chain rule can (must) be done on the send side. The reference rule
means that we need both r1 and u1 to be available on the receiving
side. I haven't checked, but this will probably involve a change to
the stream format to send r1.

Other things
------------

   As mentioned above, there's a use-case where we do something like
this:

1) S(A, -, -)
2) Send a backup
 a  SnapR(S(A, -, -))               ->  S(B, -, A)*
 b  Send(S(B, -, A)*, T)            ->               T(C, B, -)*
3) Roll back to the state of B
    Snap(S(B, -, A))                ->  S(D, -, B)
4) S(D, -, B) is used for a while
5) Send a backup
 a  SnapR(S(D, -, B))               ->  S(E, -, D)*
 b  SendP(S(E, -, D)*, S(B, -, A)*  ->               T(F, E, C)*

This is supported with the above infrastructure, but it's not going to
work if there's more snapshots in between stages 3 and 4 (because the
"parent" UUID is rotated out each time). We would need a
generalisation of the "chain rule", so that we look for a chain of
snapshots of _any_ length from the reference to the subject. However,
this would either require us to keep a full history of all ancestors
with each snapshot, or to find such a path in the tree of snapshot
history when we run the send (and to require that all snapshots in
that sequence still exist). Neither of these is a particularly
attractive proposition, and I would suggest not trying to support that
use case right now.

   The other thing that we don't support at all is merging changes
=66rom divergent snapshots. i.e. snapshot A to B and C, modify both B
and C, and then later try to merge B and C into D. (Possibly with
additional sends between all of those stages). This gets into issues
of semantic merging. I feel entirely justified in telling anyone who
wants to implement that kind of workflow that it's out of scope for
send/receive, and referring them to a distributed revision control
system like git.

   Finally, there's an interesting use case of trying to rotate the
bidirectional sync through several machines in turn (S, T, Q, R and
back to S). I haven't had time to look at that one in detail, and I
probably won't do so, but at least the analysis of it should be
tractable with the above notation, if anyone does feel moved to look
into it.

   Hugo.

--=20
Hugo Mills             | Once is happenstance; twice is coincidence; three
hugo@... carfax.org.uk | times is enemy action.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--LCbsoPZWBRMqE7TI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJVVNz6AAoJEFheFHXiqx3kWiEQAIgqax6KfYJ5l8fnYYcxBG4u
amVlSds93AJ2x2w7q1FqYfNG+GZoO7niiJMfEP996WeuBIX50Hs+aJZrf6LdRAp7
+flkbfLNV4NLq7GdF51uPjL7f2jyd+/ae5cUK+PIyCg8yWQFN6AjCzpl2AWsun/g
eAuxjR9qZeWMr/hHEjKmLCvELRJECG0nebI+MFQkHNIiDt9GMg3Mci1F3f0fZQkx
4Geat4OZ9S0EMZ1hucAowH46WymsAJHlfyQ8bvGrHgH6XCo2FqKSVj4e+hb2uzQs
pvO9Nt0FUIuWha++zBfSslDbtsnbLONs1dapST1MsNtgPAIUyqdktwRvonPndm+X
fWsP1e2/71WOLQxMS8ANpF5wCDtsgJKrNPi9q0AoltVw3IwgyfwqK8lPj6/CehzB
PrAvKR/gwOC9eaUAhBliTRBMZurCBknlnsXLKvwn71MOzXxDt4QeA/nD1x/zNIa6
KWNbJRqwF8sPQT+NsmLkvGZ2Y2jMj2KkFJ/8g9U8ZJuF8QFheasX7WEs3tlbMiRX
kA4y6B5NiGDqiv+WH4uS0PHPAJDUJY5X1tdntmsj3a/Vq9ZLWsguQJJ+aawucuB5
/Jyme0wB1YiTT47pTKYbo9QR7RKmjBbVxNx1M+FrPylkHmOX6JzNK1YR/Ua6uE+w
rcAoGfI+0XBY8APs5i+/
=OeqN
-----END PGP SIGNATURE-----

--LCbsoPZWBRMqE7TI--
