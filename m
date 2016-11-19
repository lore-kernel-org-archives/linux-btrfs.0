Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:41946 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751919AbcKSI1F (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 19 Nov 2016 03:27:05 -0500
Date: Sat, 19 Nov 2016 03:27:02 -0500
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Chris Mason <clm@fb.com>
Cc: dsterba@suse.cz, Qu Wenruo <quwenruo@cn.fujitsu.com>, bo.li.liu@oracle.com,
        Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [RFC] btrfs: make max inline data can be equal to sectorsize
Message-ID: <20161119082702.GV21290@hungrycats.org>
References: <20161011064742.17364-1-wangxg.fnst@cn.fujitsu.com>
 <20161111202210.GB30930@dhcp-whq-twvpn-1-vpnpool-10-159-131-21.vpn.oracle.com>
 <1bbc9b5f-9bdb-d8b6-bbd5-7718ea33dcef@cn.fujitsu.com>
 <20161116161023.GU12522@twin.jikos.cz>
 <147397a2-0401-82c2-069b-ce21e2d07484@fb.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="PDzrc2MStrmgSXgo"
In-Reply-To: <147397a2-0401-82c2-069b-ce21e2d07484@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--PDzrc2MStrmgSXgo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 18, 2016 at 03:58:06PM -0500, Chris Mason wrote:
>=20
>=20
> On 11/16/2016 11:10 AM, David Sterba wrote:
> >On Mon, Nov 14, 2016 at 09:55:34AM +0800, Qu Wenruo wrote:
> >>At 11/12/2016 04:22 AM, Liu Bo wrote:
> >>>On Tue, Oct 11, 2016 at 02:47:42PM +0800, Wang Xiaoguang wrote:
> >>>>If we use mount option "-o max_inline=3Dsectorsize", say 4096, indeed
> >>>>even for a fresh fs, say nodesize is 16k, we can not make the first
> >>>>4k data completely inline, I found this conditon causing this issue:
> >>>>  !compressed_size && (actual_end & (root->sectorsize - 1)) =3D=3D 0
> >>>>
> >>>>If it retuns true, we'll not make data inline. For 4k sectorsize,
> >>>>0~4094 dara range, we can make it inline, but 0~4095, it can not.
> >>>>I don't think this limition is useful, so here remove it which will
> >>>>make max inline data can be equal to sectorsize.
> >>>
> >>>It's difficult to tell whether we need this, I'm not a big fan of using
> >>>max_inline size more than the default size 2048, given that most repor=
ts
> >>>about ENOSPC is due to metadata and inline may make it worse.
> >>
> >>IMHO if we can use inline data extents to trigger ENOSPC more easily,
> >>then we should allow it to dig the problem further.
> >>
> >>Just ignoring it because it may cause more bug will not solve the real
> >>problem anyway.
> >
> >Not allowing the full 4k value as max_inline looks artificial to me.
> >We've removed other similar limitation in the past so I'd tend to agree
> >to do the same here. There's no significant use for it as far as I can
> >tell, if you want to exhaust metadata, the difference to max_inline=3D40=
95
> >would be really tiny in the end. So, I'm okay with merging it. If
> >anybody feels like adding his reviewed-by, please do so.
>=20
> The check is there because in practice it doesn't make sense to inline an
> extent if it fits perfectly in a data block.  You could argue its saving
> seeks, but we're also adding seeks by spreading out the metadata in gener=
al.
> So, I'd want to see benchmarks before deciding.

Does that limit kick in before or after compression?  A compressed extent
could easily have 4096 bytes of data in 200 bytes.  If a filesystem
contained a whole lot of exactly-4096-byte compressible files that extra
byte might be worth something.

> If we're using it for debugging, I'd rather stick with max_inline=3D4095.
>=20
> -chris
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--PDzrc2MStrmgSXgo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlgwDNYACgkQgfmLGlazG5ysqACg2zjkWaVoFyk4wOm/qr8iSove
aDMAoJ3t2oVPuJGhSuZB32Mge0qZ8z4b
=p35K
-----END PGP SIGNATURE-----

--PDzrc2MStrmgSXgo--
