Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:59442 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753902AbcJLXNe (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Oct 2016 19:13:34 -0400
Date: Wed, 12 Oct 2016 22:43:11 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Sean Greenslade <sean@seangreenslade.com>
Cc: Btrfs List <linux-btrfs@vger.kernel.org>
Subject: Re: Incremental send robustness question
Message-ID: <20161012224311.GK7683@carfax.org.uk>
References: <20161012222955.GB2412@fox.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="PEfPc/DjvCj+JzNg"
In-Reply-To: <20161012222955.GB2412@fox.home>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--PEfPc/DjvCj+JzNg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 12, 2016 at 06:29:55PM -0400, Sean Greenslade wrote:
> Hi, all. I have a question about a backup plan I have involving
> send/receive. As far as I can tell, there's no way to to resume a send
> that has been interrupted. In this case, my interruption comes from an
> overbearing firewall that doesn't like long-lived connections. I'm
> trying to do the initial (non-incremental) sync of the first snapshot
> from my main server to my backup endpoint. The snapshot is ~900 GiB, and
> the internet link is 25 Mbps, so this'll be going for quite a long time.
> 
> What I would like to do is "fake" the first snapshot transfer by
> rsync-ing the files over. So my question is this: if I rsync a subvolume
> (with the -a option to make all file times, permissions, ownerships,
> etc. the same), is that good enough to then be used as a parent for
> future incremental sends?

   No, it needs some additional subvol metadata to be set so that the
receiver can detect which subvol to snapshot when restoring an
incremental.

   Depending on how much local storage you have, you could do
something like write the send stream to disk (split into pieces), and
then copy each piece to the receiver, and cat those all together to
replay them. It'd be a bit hairy to get the timing right, though,
without emptying or filling the various pipes.

> And while we're at it, what are the failure modes for incremental sends?
> Will it throw an error if the parents don't match, or will there just be
> silent failures?

   It'll throw an error, as far as I know.

> I would imagine receive would barf if it was told to
> reference a file that didn't exist, but what if the referenced file is
> there but contains different data? Are there checks for this sort of
> thing, or is it always assumed that the parent subvols are identical and
> if they're not, you're in undefined behavior land?

   The parent subvols have UUIDs in them which should act as a
sufficient check for any accidental errors. (See the received-subvol
option for btrfs sub list). It's not robust against an attacker that
can control the UUIDs... but then, if they can do that, there's a
whole load more problems you've got.

   Hugo.

-- 
Hugo Mills             | Great oxymorons of the world, no. 8:
hugo@... carfax.org.uk | The Latest In Proven Technology
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--PEfPc/DjvCj+JzNg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJX/rx+AAoJEFheFHXiqx3kBMIQAIE4nl70ACKQkanRQRMYOR0t
2nbxKgxcyf1FvRbTBY5sK36hk+mLuwgKGoPuyqPlSMfkqp/MBVolQGInURZ3BU3S
qzxw8lYCBYx7hl/1AVXJI4FmHiKuY/gTrPMRHfZn0NsngNQoyogkONMLFYKYLm8q
54u/6bY5G2VqB2XUMgJtxC4GXQlA3f4BkCrWmYVxmL4Kr1yQDoFHgOCzzxMVGqsN
MEixLznGErSUqnmWJdza8kFS2q9nh7GgSPtXni1etvLmzahIp5lhoQOS0viMWbFA
jFJHe/ZMlxunuo6OqU3njpc/Azt5Bo3CQvLHMtO2FPWDJ0bjycKLay9NcR14Nict
c8cpvs32CdJgomrPQjhNPnL+ybCgyRfw9TY2U8CqVblHXBe3M6bDVASQc/zW9L6Y
ixfPZiOJKhC5MwZLNlhQwk/SvC7PGY9OapTbj+J8b7NB1adkc5FivTB/btBmUBd1
NPV2ru3k26CjaTPU8CfTbfQSP1b7AD/d3D6pR7MmdqBq47kzS6ULnEYkFfIfqQgt
1y3E+AbEmesguIAPaIwcTqBi9nuvpXzHEfMwiOS4Pel5iU2JIcNMlUPDg/9rCJ7j
YoG+qBgHZO6KEqGq2UuOaK6pS+77wyJ2+VK7jH6MEKyHheZ0CsMU2AZFv8M9Zzpb
L5P0KddGptH3mHlMlyDq
=ZXqd
-----END PGP SIGNATURE-----

--PEfPc/DjvCj+JzNg--
