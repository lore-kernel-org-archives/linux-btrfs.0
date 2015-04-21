Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54465 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753428AbbDUXHU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Apr 2015 19:07:20 -0400
Date: Wed, 22 Apr 2015 09:06:53 +1000
From: NeilBrown <neilb@suse.de>
To: Christoph Hellwig <hch@infradead.org>
Cc: David Howells <dhowells@redhat.com>, Chris Mason <clm@fb.com>,
        Al Viro <viro@ZenIV.linux.org.uk>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.cz>, linux-cachefs@vger.kernel.org,
        Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/3] fscache/cachefiles: optionally use SEEK_DATA
 instead of ->bmap.
Message-ID: <20150422090653.35ad074c@notabene.brown>
In-Reply-To: <20150420094539.GA12622@infradead.org>
References: <20150420052558.26554.97143.stgit@notabene.brown>
	<20150420052752.26554.52672.stgit@notabene.brown>
	<20150420060818.GA32675@infradead.org>
	<20150420162700.3e69c7db@notabene.brown>
	<20150420094539.GA12622@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/34Rpsa0blcVekf+q/NTN0l1"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/34Rpsa0blcVekf+q/NTN0l1
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 20 Apr 2015 02:45:39 -0700 Christoph Hellwig <hch@infradead.org>
wrote:

> On Mon, Apr 20, 2015 at 04:27:00PM +1000, NeilBrown wrote:
> > A worthwhile goal, but I certainly wouldn't consider pursuing it until =
what I
> > have submitted so far as been accepted - let's not reject "good" while
> > waiting for "perfect".
>=20
> It's still broken.  You add conditional flag for the almost right
> (almost because the flag in the filesystem type needs to go)

Why does it have to go?  I suspect you have a reason, but I can't read your
mind.

>  while
> leaving the broken option th default.=20

You say it is broken, and yet people are using it and are having a degree of
success.

Surely the appropriate process is:
 - introduce a "better" option
 - examine each relevant filesystem and transition over to use the new opti=
on.
 - remove the "not so good" option.

I'm still at step 1.

>   So what you propose here is not
> good, it's at best just as bad as the old version because you don't
> remove broken code but add a lot more clutter at the same time.

What I propose is measurably better because it works with BTRFS now, and
there seems to be a reasonable path towards making to generally better if
someone cares enough to examine each filesystem.

So I still claim you are pushing back against "good" because you want
"perfect".

NeilBrown

--Sig_/34Rpsa0blcVekf+q/NTN0l1
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVTbYEDnsnt1WYoG5AQIbuQ/+J75ySYqP83GzlIjavqUtdAuAUxF6f1k/
8tTK5UcaiiCIl4B3i1zt2yavV7g1iP186n9SizND29jESVVMVCYGVtlaV2N6xKWM
U3A86AljdUuY4zMIJsoXUdToaaIUBQuUKR5nh1GdL6TqWOwgjwvpaz/dDnDo934K
kvIhXx2HFHqAvyNmSJZOe+wmJF9N64C6H9//dUY2QQrUxdf82HAf8j3u5QObhGXt
COOIGSf/fDunj3qwaMcBcwOFaXP6BtpMofsPIsnyQ5FtsMrqoEbDLdh7lVoiv1KW
5/sadxbFaDHC2S4mNKyy+8v3jC3lf/l/Npu0bP608UiXHCPjpXRAOKhzbdSUOnNr
dHVmx6+4syQG16R+ysGOaVX/8mSQaT+uXaOYSaPwPjPYhU07RwQTRnOwK46I38SF
rND1PNbz/C3mC2WKRq1QLpt4uiK8X8z4bJCZrFdMQSwSITirSkjKexaxSlCOCFTf
H0gmjcM80dsXoaaGCo4bf+kC/Ac+JS1Ksoxi4rkQy/dy56Hp/VieHZ0ZtQzgryBf
Menj3NnLEn22R2WfHk+9oDZ7psKBY2919ZubsvEeqT3t9F2LEgJOrJEjydF94qMi
n2L6xClwf1oHmuxrGOgOpBDrNUzmAhrtXvz+huPEOwf3zH6iba6ekx32XxxRPDY4
p2SwDHYJq7E=
=1Y6T
-----END PGP SIGNATURE-----

--Sig_/34Rpsa0blcVekf+q/NTN0l1--
