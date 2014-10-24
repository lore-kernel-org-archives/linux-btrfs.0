Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:47390 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754560AbaJXDDa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Oct 2014 23:03:30 -0400
Date: Thu, 23 Oct 2014 23:03:29 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Eric Sandeen <sandeen@redhat.com>, Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        "dsterba@suse.cz Sterba" <dsterba@suse.cz>
Subject: Re: [bug] btrfs check --subvol-extents segfault
Message-ID: <20141024030329.GE17395@hungrycats.org>
References: <BB091951-5382-4788-901D-20E96546548A@colorremedies.com>
 <5418AD03.4090301@redhat.com>
 <5428CFE6.3060703@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4Epv4kl9IRBfg3rk"
In-Reply-To: <5428CFE6.3060703@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--4Epv4kl9IRBfg3rk
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I just stumbled across this bug a few hours ago.
It's still in btrfs-progs 3.17.

On Mon, Sep 29, 2014 at 11:20:06AM +0800, Qu Wenruo wrote:
> Ping.
>=20
> No response?
>=20
> Thanks,
> Qu
> -------- Original Message --------
> Subject: Re: [bug] btrfs check --subvol-extents segfault
> From: Eric Sandeen <sandeen@redhat.com>
> To: Chris Murphy <lists@colorremedies.com>, Btrfs BTRFS
> <linux-btrfs@vger.kernel.org>
> Date: 2014=E5=B9=B409=E6=9C=8817=E6=97=A5 05:34
> >On 9/16/14 4:33 PM, Chris Murphy wrote:
> >>https://bugzilla.redhat.com/show_bug.cgi?id=3D1142421
> >>
> >>kernel-3.17.0-0.rc5.git0.1.fc22.x86_64
> >>btrfs-progs-3.16-1.fc21.x86_64
> >>
> >>Steps to Reproduce:
> >>1. mkfs.btrfs /dev/sdc
> >>2. btrfs check --subvol-extents /dev/sdc
> >>
> >>Results:
> >>Segmentation fault (core dumped)
> >>
> >>[  632.749774] btrfs[692]: segfault at 0 ip 00007fc9963fdd77 sp 00007ff=
f93450880 error 4 in libc-2.19.90.so[7fc9963c2000+1bd000]
> >>
> >>Eric Sandeed writes in the bugzilla that this was broken by commit
> >>d34cbe76c723a05a14bbcfdc46e8ede789c3f1f9 which drops the requirement
> >>to specify a subvolid, but still does arg_strtou64(optarg) ->
> >>arg_strtou64(NULL) so it crashes.
> >Yeah, AFAICT (although it's not documented anywhere) the functionality is
> >*supposed* to take a subvolid as an argument.
> >
> >The commit lets it pass w/ no args, but still does arg_strtou64(optarg) =
to get
> >the subvolid, and boom.
> >
> >I think the commit just needs to be reverted, and then manpages updated &
> >testcases written...
> >
> >-Eric
> >--
> >To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> >the body of a message to majordomo@vger.kernel.org
> >More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--4Epv4kl9IRBfg3rk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlRJwYEACgkQgfmLGlazG5y00QCaAqbn/4WOsbqBmqTlb4gB5wWg
qrIAniTEMpTKNJNRvXRLVtj8NQGq9A9D
=leQX
-----END PGP SIGNATURE-----

--4Epv4kl9IRBfg3rk--
