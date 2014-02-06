Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from luka.romanrm.net ([213.163.64.74]:46487 "EHLO luka.romanrm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756204AbaBFMpG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 6 Feb 2014 07:45:06 -0500
Date: Thu, 6 Feb 2014 18:45:02 +0600
From: Roman Mamedov <rm@romanrm.net>
To: Brendan Hide <brendan@swiftspirit.co.za>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Provide a better free space estimate on RAID1
Message-ID: <20140206184502.128b7dbe@natsu>
In-Reply-To: <52F33BE7.4020708@swiftspirit.co.za>
References: <20140206021516.304732cd@natsu>
	<52F33BE7.4020708@swiftspirit.co.za>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/d_Q=M9YDJNUtsy8T9EqDzln"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/d_Q=M9YDJNUtsy8T9EqDzln
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 06 Feb 2014 09:38:15 +0200
Brendan Hide <brendan@swiftspirit.co.za> wrote:

> This is a known issue:=20
> https://btrfs.wiki.kernel.org/index.php/FAQ#Why_does_df_show_incorrect_fr=
ee_space_for_my_RAID_volume.3F
> Btrfs is still considered experimental=20

It's long overdue to start tackling these snags and 'stop hiding behind the
experimental flag' [1], which is also no longer present as of 3.13.

[1] http://www.spinics.net/lists/linux-btrfs/msg30396.html

> this is just one of those caveats we've learned to adjust to.

Sure, but it's hard to argue this particular behavior is clearly broken from
the user perspective, even if it's "broken by design", and there are a numb=
er
of very "smart" and "future-proof" reasons to keep it broken today.

Personally I tired of trying to keep in mind which partitions are btrfs rai=
d1,
and mentally divide the displayed free space by two for those. That's what
computers are for, to keep track of such things.

> The change could work well for now and I'm sure it has been considered.=20
> I guess the biggest end-user issue is that you can, at a whim, change=20
> the model for new blocks - raid0/5/6,single etc and your value from 5=20
> minutes ago is far out from your new value without having written=20
> anything or taken up any space. Not a show-stopper problem, really.

Changing the allocation profile for new blocks is a serious change you don'=
t do
accidentally, it's about the same importance level as e.g. resizing the
filesystem. And no one is really surprised when the 'df' result changes aft=
er
an FS resize.

> The biggest dev issue is that future features will break this behaviour,=
=20

That could be years away.

> such as the "per-subvolume RAID profiles" you mentioned. It is difficult=
=20
> to motivate including code (for which there's a known workaround) where=20
> we know it will be obsoleted.

There's not a lot of code to include (as my 3-line patch demonstrates), it
could just as easily be removed when it's obsolete. But I did not have any
high hopes of defeating the "broken by design" philosophy, that's why I did=
n't
submit it as a real patch for inclusion but rather just as a helpful hint f=
or
people to add to their own kernels if they want this change to happen.

--=20
With respect,
Roman

--Sig_/d_Q=M9YDJNUtsy8T9EqDzln
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlLzg84ACgkQTLKSvz+PZwhfFgCgggq1TTCkx0clXnB9/5ifaoFU
DMAAn0rpRl+AgU274WbIsJC9Zq3IUqqn
=bTfY
-----END PGP SIGNATURE-----

--Sig_/d_Q=M9YDJNUtsy8T9EqDzln--
