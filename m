Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mari.romanrm.net ([157.7.203.202]:43516 "EHLO mari.romanrm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751818AbaFFSxZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 6 Jun 2014 14:53:25 -0400
Date: Sat, 7 Jun 2014 00:53:17 +0600
From: Roman Mamedov <rm@romanrm.net>
To: WorMzy Tykashi <wormzy.tykashi@gmail.com>
Cc: Filipe Manana <fdmanana@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs module dependencies broken in 3.14?
Message-ID: <20140607005317.077071e0@natsu>
In-Reply-To: <CALOYprW2R7iN0j=M6py0pbOkibbyob5L7KXHtmT92-32wVYMdw@mail.gmail.com>
References: <20140606204009.261e8ec3@natsu>
	<CAL3q7H7TD8FvFwVEx+A9ABEXhQW-C2yuNr6mga+XH9uMyMt+Qw@mail.gmail.com>
	<CALOYprW2R7iN0j=M6py0pbOkibbyob5L7KXHtmT92-32wVYMdw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/i6yWROv/KjWEvEp_1_AGDF2"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/i6yWROv/KjWEvEp_1_AGDF2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 6 Jun 2014 19:31:37 +0100
WorMzy Tykashi <wormzy.tykashi@gmail.com> wrote:

> My solution was to write a patch for mkinitcpio (Arch initrd creation
> tool) [1] so that it explicitly adds the crc32c module to the initrd
> if btrfs is needed. I imagine it wouldn't be difficult to add the same
> logic to debian's initrd creation tool. IIRC it already does something
> similar in other cases where there's an invisible dependency like
> this.

It was "visible" in 3.13, see the Debian bug link, there are modinfo of the
3.13 and 3.14 modules compared side by side. I wonder is there really no wa=
y to
make it show up in the actual module dependencies as before?

To me patching initrd creation tools to special-case "if btrfs then add crc=
32"
seems to be a really bizarre way of dealing with the issue.

--=20
With respect,
Roman

--Sig_/i6yWROv/KjWEvEp_1_AGDF2
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlOSDh4ACgkQTLKSvz+PZwi+8gCgjhP4MnX+2VNaAXDSuKx5KWCs
JHEAnj8yCzan4+y1oZ7/pkPFBfcHRXFO
=Vr7/
-----END PGP SIGNATURE-----

--Sig_/i6yWROv/KjWEvEp_1_AGDF2--
