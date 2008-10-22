From: Eric Anopolsky <erpo41@gmail.com>
Subject: Re: Some very basic questions
Date: Tue, 21 Oct 2008 20:29:04 -0600
Message-ID: <1224642544.7189.17.camel@telesto>
References: <20081021132322.271ad728.skraw@ithnet.com>
	 <1224597580.27474.93.camel@think.oraclecorp.com>
	 <1224622451.7412.1.camel@telesto>  <48FE553D.80501@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-mSlXcqXgUEXEAgvzxMGL"
Cc: Chris Mason <chris.mason@oracle.com>,
	Stephan von Krawczynski <skraw@ithnet.com>,
	linux-btrfs@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <48FE553D.80501@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>


--=-mSlXcqXgUEXEAgvzxMGL
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-10-21 at 18:18 -0400, Ric Wheeler wrote:
> Eric Anopolsky wrote:
> > On Tue, 2008-10-21 at 09:59 -0400, Chris Mason wrote:
> >  =20
> >>>     - power loss at any time must not corrupt the fs (atomic fs modif=
ication)
> >>>       (new-data loss is acceptable)
> >>>      =20
> >> Done.  Btrfs already uses barriers as required for sata drives.
> >>    =20
> >
> > Aren't there situations in which write barriers don't do what they're
> > supposed to do?
> >
> > Cheers,
> > Eric
> >
> >  =20
> If the drive effectively "lies" to you about flushing the write cache,=20
> you might have an issue. I have not seen that first hand with recent=20
> disk drives (and I have seen a lot :-))

That does not match the understanding I get from reading the
notes/caveats section of Documentation/block/barrier.txt:

"Note that block drivers must not requeue preceding requests while
completing latter requests in an ordered sequence.  Currently, no
error checking is done against this."

and perhaps more importantly:

"[a technical scenario involving disk writes]
The problem here is that the barrier request is *supposed* to indicate
that filesystem update requests [2] and [3] made it safely to the
physical medium and, if the machine crashes after the barrier is
written, filesystem recovery code can depend on that.  Sadly, that
isn't true in this case anymore.  IOW, the success of a I/O barrier
should also be dependent on success of some of the preceding requests,
where only upper layer (filesystem) knows what 'some' is.

This can be solved by implementing a way to tell the block layer which
requests affect the success of the following barrier request and
making lower lever drivers to resume operation on error only after
block layer tells it to do so.

As the probability of this happening is very low and the drive should
be faulty, implementing the fix is probably an overkill.  But, still,
it's there."

Cheers,
Eric



--=-mSlXcqXgUEXEAgvzxMGL
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iQEVAwUASP6P8AanbLzqVaVfAQJ3WAgAngXIJZ9PmiDT6+45wNcQzzCacgJMNZzI
dLPAj62i/SgINrchUNuRI+eQvzEcWkRMY7pAAsQAAdleb+G8STUCQ/oGmhMiElz3
iDcTQqT3NR+2t0438AA9xOgOqgOXdyMH4jcJeohG4RlSv9GsRWoG1dONUZVsEu/v
Iu1ruEoGRkjg/NLuob2hD3zS1NqokMdc9NEC1tTTEbkWAW/TWPSOlfwBvT+N0A3B
jt/0j9SrYRRGhDzr+r6YGFQQa7IeNiTuqL0LHKWBxc2LB7OqNBL0w2uKmSmKdM9D
rJK2wJm89ra5XR7DHXCEGAi11JI7X+/ES2EnFnTruB01K4wk49UBuA==
=dZu0
-----END PGP SIGNATURE-----

--=-mSlXcqXgUEXEAgvzxMGL--

