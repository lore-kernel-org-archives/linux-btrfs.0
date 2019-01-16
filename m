Return-Path: <SRS0=HC3m=PY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C29FEC43387
	for <linux-btrfs@archiver.kernel.org>; Wed, 16 Jan 2019 13:07:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 96D4B206C2
	for <linux-btrfs@archiver.kernel.org>; Wed, 16 Jan 2019 13:07:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392952AbfAPNHr (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 16 Jan 2019 08:07:47 -0500
Received: from frost.carfax.org.uk ([85.119.82.111]:38644 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390247AbfAPNHr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 Jan 2019 08:07:47 -0500
Received: from hrm by frost.carfax.org.uk with local (Exim 4.80)
        (envelope-from <hrm@carfax.org.uk>)
        id 1gjkv0-0008TM-Dq; Wed, 16 Jan 2019 13:07:42 +0000
Date:   Wed, 16 Jan 2019 13:07:42 +0000
From:   Hugo Mills <hugo@carfax.org.uk>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
        Leonard Lausen <leonard@lausen.nl>
Subject: Re: [PATCH] btrfs: Do mandatory tree block check before submitting
 bio
Message-ID: <20190116130742.GH5134@carfax.org.uk>
Mail-Followup-To: Hugo Mills <hugo@carfax.org.uk>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org, Leonard Lausen <leonard@lausen.nl>
References: <20190116115308.8687-1-wqu@suse.com>
 <20190116120113.GG5134@carfax.org.uk>
 <702957e0-b7c9-bc5f-2409-bdc5ff8d39b6@gmx.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="tT3UgwmDxwvOMqfu"
Content-Disposition: inline
In-Reply-To: <702957e0-b7c9-bc5f-2409-bdc5ff8d39b6@gmx.com>
X-GPG-Fingerprint: DD84 D558 9D81 DDEE 930D  2054 585E 1475 E2AB 1DE4
X-GPG-Key: E2AB1DE4
X-Parrot: It is no more. It has joined the choir invisible.
X-IRC-Nicks: darksatanic darkersatanic darkling darkthing
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


--tT3UgwmDxwvOMqfu
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 16, 2019 at 08:26:35PM +0800, Qu Wenruo wrote:
>=20
>=20
> On 2019/1/16 =E4=B8=8B=E5=8D=888:01, Hugo Mills wrote:
> >    Hi, Qu,
> >=20
> > On Wed, Jan 16, 2019 at 07:53:08PM +0800, Qu Wenruo wrote:
> >> There are at least 2 reports about memory bit flip sneaking into on-di=
sk
> >> data.
> >>
> >> Currently we only have a relaxed check triggered at
> >> btrfs_mark_buffer_dirty() time, as it's not mandatory, only for
> >> CONFIG_BTRFS_FS_CHECK_INTEGRITY enabled build.
> >>
> >> This patch will address the hole by triggering comprehensive check on
> >> tree blocks before writing it back to disk.
> >>
> >> The timing is set to csum_tree_block() where @verify =3D=3D 0.
> >> At that timing, we're generation csum for tree blocks before submitting
> >> the metadata bio, so we could avoid all the unnecessary calls at
> >> btrfs_mark_buffer_dirty(), but still catch enough error.
> >=20
> >    I agree wholeheartedly with the idea of this change. Just one
> > question:
> >=20
> >    How does this get reported to the user/administrator? As I
> > understand it, a detectably corrupt metadata page will generate an I/O
> > error from the filesystem before it's written to disk? How will this
> > show up in kernel logs?
>=20
> Well, you caught me.
>=20
> I haven't try the error case, and in fact if it fails, it fails by
> triggering kernel BUG_ON(), thus you may not have a chance to see the
> error message from btrfs module.
>=20
> > Is it distinguishable in any way from a
> > similar error that was generated on reading such a corrupt metadata
> > node from the disk?
>=20
> Kind of distinguishable for this patch, when you hit kernel BUG_ON() at
> fs/btrfs/extent_io.c:4016 then it's definitely from this patch. :P

   Haha. :)

> >    Basically, I want to be able to distinguish this case (error
> > detected when writing) from the existing case (error detected when
> > reading) when someone shows up on IRC with a "broken filesystem".
>=20
> Definitely, I'll address this and the BUG_ON() in next version.

   The error-on-read case gives us a pretty good report on what's
wrong and where. Typically something like "bad key order" or "wrong
item size", plus the logical address of the metadata chunk so we can
dump it with debug-tree -b.

   Having the same messages from this call-site to indicate the kind
of error found, and also something to indicate that it was detected
before hitting disk (i.e. which call-site for the checks triggered the
error) would be, I think, the minimal information needed. If we could
also have the human-readable dump of the full metadata page logged as
well, that would be ideal -- we won't be able to use debug-tree to
diagnose the issue afterwards, as it won't have reached the disk.

   Thanks,
   Hugo.

> Thanks,
> Qu
>=20
> >=20
> >    Hugo.
> >=20
> >> Reported-by: Leonard Lausen <leonard@lausen.nl>
> >> Signed-off-by: Qu Wenruo <wqu@suse.com>
> >> ---
> >>  fs/btrfs/disk-io.c | 10 ++++++++++
> >>  1 file changed, 10 insertions(+)
> >>
> >> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> >> index 8da2f380d3c0..45bf6be9e751 100644
> >> --- a/fs/btrfs/disk-io.c
> >> +++ b/fs/btrfs/disk-io.c
> >> @@ -313,6 +313,16 @@ static int csum_tree_block(struct btrfs_fs_info *=
fs_info,
> >>  			return -EUCLEAN;
> >>  		}
> >>  	} else {
> >> +		/*
> >> +		 * Here we're calculating csum before writing it to disk,
> >> +		 * do comprenhensive check here to catch memory corruption
> >> +		 */
> >> +		if (btrfs_header_level(buf))
> >> +			err =3D btrfs_check_node(fs_info, buf);
> >> +		else
> >> +			err =3D btrfs_check_leaf_full(fs_info, buf);
> >> +		if (err < 0)
> >> +			return err;
> >>  		write_extent_buffer(buf, result, 0, csum_size);
> >>  	}
> >> =20
> >=20
>=20




--=20
Hugo Mills             | Friends: people who know you well, but like you
hugo@... carfax.org.uk | anyway.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--tT3UgwmDxwvOMqfu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJcPyyeAAoJEFheFHXiqx3kmhIP/3aFQWNaacVqxJR4+hGEBIvF
rLDUF5oiAJbOTtrjGqmUcmaIA9el0qxnsdZEaeoEqm6pcnJqovaKx8ebknuVfVgR
OH3h5n5sLTtDEgMYo3Zrw4NxHQgPW5AvxN5ukQ6mzn/JfHcZbEUjq8ZqhtwLQigX
cnIyJf2YIwiRirMK31FihfsEenlKNiEN8HC58H/7hJ2A7VTu6ZM0zH7MKvX1+oTm
9NVfk0QdEUlU5Y9WcGM+j7tuktFqKBC1DZIyNf2mEd49zphHBj55vKXKi0Yu/AWV
BQmllUWvDNyfDUoTkfN9U27eaiCDGlbCQmoXkC9+t0Mk7IR6SvDUueC64bngJruV
DaccR+cgAVQLol8ZDy8DkLztFymHedGqG66rVrRxG7IsYABYLZqk1X0A94hb5vKL
TCwCA6qHEv4Ycgils1Qxo8J/bZRDhd32HRxT6itLy+d4d9+Kwy8bA/sphmVNL6sL
/jN3T4PRFZ41QR3cEbDc1jGfp8fqqISnhUXE0JPduyKnME3CsHHA4kcV5f2Am8C9
VD6bpM0mYgfasC090h6nBKBdKnfT/iSHHugoWKsojLj/EzhMikecBGLyCDJO2SBo
dhCqq0PPrWWRzX/G3VgDUf060eoNZxls+k9zMIFcUAavpbj8Ck6RSF4L41B0A6Hx
BcoGt7TYGcH5FFK8ukaW
=mzEs
-----END PGP SIGNATURE-----

--tT3UgwmDxwvOMqfu--
