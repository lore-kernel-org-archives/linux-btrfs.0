Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from meiko.romanrm.net ([195.154.92.155]:53017 "EHLO
	meiko.romanrm.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409AbbH1Jqq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 28 Aug 2015 05:46:46 -0400
Date: Fri, 28 Aug 2015 14:46:43 +0500
From: Roman Mamedov <rm@romanrm.net>
To: George Duffield <forumscollective@gmail.com>
Cc: Austin S Hemmelgarn <ahferroin7@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: Understanding BTRFS storage
Message-ID: <20150828144643.7074ed9e@natsu>
In-Reply-To: <CAG__1a4x_bv2DURyT0ZW0p+udh43ifcn=bHjUKM4NF1Tk=cYDw@mail.gmail.com>
References: <CAG__1a4T=d_O49CnOw+0gtKr56xtrmcjRcmujtUff_s_-oL0Jw@mail.gmail.com>
	<20150826165024.05af044f@natsu>
	<55DDAB1C.90406@gmail.com>
	<CAG__1a4x_bv2DURyT0ZW0p+udh43ifcn=bHjUKM4NF1Tk=cYDw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/nS+_tfognonzWnAFq6hfWPb"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/nS+_tfognonzWnAFq6hfWPb
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 28 Aug 2015 10:50:12 +0200
George Duffield <forumscollective@gmail.com> wrote:

> Running a traditional raid5 array of that size is statistically
> guaranteed to fail in the event of a rebuild.

Yeah I consider RAID5 to be safe up to about 4 devices. As you already have=
 5
and looking to expand, I'd recommend going RAID6. The "fail on rebuild" iss=
ue
is almost completely mitigated by it, perhaps up to a dozen of drives or mo=
re.

Don't know about your usage scenarios, but as for me the loss of storage
efficiency in RAID10 compared to RAID6 in unacceptable, and I also don't ne=
ed
the performance benefits of RAID10 at all.

So both from the efficiency and stability standpoints my personal choice
currently is Btrfs single device mode on top of MD RAID5 (in a 4 drive arra=
y)
and RAID6 (with 7 drives).

--=20
With respect,
Roman

--Sig_/nS+_tfognonzWnAFq6hfWPb
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlXgLgMACgkQTLKSvz+PZwjcQQCfXHfgH2dh7UTRSSN791e0Pn0b
vTgAoIrXX9DL4o6MyuOq+vzEFxXmu5H1
=hLrk
-----END PGP SIGNATURE-----

--Sig_/nS+_tfognonzWnAFq6hfWPb--
