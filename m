Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:39724 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754598AbbEMVIO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 May 2015 17:08:14 -0400
Date: Wed, 13 May 2015 17:08:04 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Learner Study <learner.study@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs dedup - available or experimental? Or yet to be?
Message-ID: <20150513210804.GA12262@hungrycats.org>
References: <meq6hm$lbh$1@ger.gmane.org>
 <20150323232212.GL31762@carfax.org.uk>
 <CAP8+hKXZ5p80E_9dmVyzkdFGgc6NMSj2MDyp3DZ-dVi2RQ=EyA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3V7upXqbjpZ4EhLz"
In-Reply-To: <CAP8+hKXZ5p80E_9dmVyzkdFGgc6NMSj2MDyp3DZ-dVi2RQ=EyA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--3V7upXqbjpZ4EhLz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 13, 2015 at 09:23:25AM -0700, Learner Study wrote:
> I have been reading on de-duplication and how algorithms such as Bloom
> and Cuckoo filters are used for this purpose.
>=20
> Does BTRFS dedup use any of these, or are there plans to incorporate
> these in future?

btrfs dedup currently lives in user space, and there are multiple
dedup userspace projects in development.

Administrators can choose the dedup tool, and can use multiple dedup tools
on the same filesystem.  This is particularly handy if you know something
about your data that a naive hashing algorithm might not (e.g. you have
two large trees derived from a common base, so you can use a much more
efficient algorithm than you would if you knew nothing about the data).

The basic kernel interface for dedup is the extent-same ioctl.
A userspace program creates a list of (fd, length, offset) tuples
referencing identical content and passes them to the kernel.  The kernel
locks the file contents, compares them, and replaces identical data
copies with references to a single extent in an atomic operation.
The kernel also provides interfaces to efficiently discover recently
modified extents in a filesystem, enabling deduplicators to follow new
data without the need to block writes.

Most btrfs deduplicators are based on a block-level hash table built by
scanning files, but every other aspect of the tools (e.g. the mechanism by
which files are discovered, block sizes, scalability, use of prefiltering
algorithms such as Bloom filters, whether the hash table is persistent
or ephemeral, etc) is different from one tool to another, and changing
over time as the tools are developed.

Because the kernel interface implies a read of both copies of duplicate
data, it is not necessary to use a collision-free hash.  Optimizing the
number of bits in the hash function for the size of the filesystem and
exploiting the statistical tendency for identical blocks to be adjacent
to other identical blocks in files enables considerable space efficiency
in the hash table--possibly so much that the Bloom/Cuckoo-style
pre-filtering benefit becomes irrelevant.  I'm not aware of a released
btrfs deduplicator that currently exploits these optimizations.

> Thanks for your guidance!
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--3V7upXqbjpZ4EhLz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlVTvTQACgkQgfmLGlazG5w8sQCcC6xS0u5+wBL1qbRGlHJlfb8X
KLUAnAwbTMOO5OmJeosmgGPErz8Dyax7
=B9r6
-----END PGP SIGNATURE-----

--3V7upXqbjpZ4EhLz--
