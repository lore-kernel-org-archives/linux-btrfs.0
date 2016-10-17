Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:42652 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S933931AbcJQRlF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Oct 2016 13:41:05 -0400
Date: Mon, 17 Oct 2016 13:41:03 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Stefan Malte Schumacher <stefan.m.schumacher@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Monitoring Btrfs
Message-ID: <20161017174103.GC21290@hungrycats.org>
References: <CAA3ktqmhhasyk8L+W3jz9ifYw7UMoL4ueg1HQp7Co3L39xYe9Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="wl4gXchqb9PBRcq/"
In-Reply-To: <CAA3ktqmhhasyk8L+W3jz9ifYw7UMoL4ueg1HQp7Co3L39xYe9Q@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--wl4gXchqb9PBRcq/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 17, 2016 at 06:44:14PM +0200, Stefan Malte Schumacher wrote:
> Hello
>=20
> I would like to monitor my btrfs-filesystem for missing drives. On
> Debian mdadm uses a script in /etc/cron.daily, which calls mdadm and
> sends an email if anything is wrong with the array. I would like to do
> the same with btrfs. In my first attempt I grepped and cut the
> information from "btrfs fi show" and let the script send an email if
> the number of devices was not equal to the preselected number.
>=20
> Then I saw this:
>=20
> ubuntu@ubuntu:~$ sudo btrfs filesystem show
> Label: none  uuid: 67b4821f-16e0-436d-b521-e4ab2c7d3ab7
>     Total devices 6 FS bytes used 5.47TiB
>     devid    1 size 1.81TiB used 1.71TiB path /dev/sda3
>     devid    2 size 1.81TiB used 1.71TiB path /dev/sdb3
>     devid    3 size 1.82TiB used 1.72TiB path /dev/sdc1
>     devid    4 size 1.82TiB used 1.72TiB path /dev/sdd1
>     devid    5 size 2.73TiB used 2.62TiB path /dev/sde1
>     *** Some devices missing
>=20
> on this page: https://btrfs.wiki.kernel.org/index.php/Using_Btrfs_with_Mu=
ltiple_Devices
> The number of devices is still at 6, despite the fact that one of the
> drives is missing, which means that my first idea doesnt work.=20

Using fi show for this isn't a good idea.  By the time btrfs fi show
tells you something is different from the norm, you've probably already
crashed at least once and are now mounting with the 'degraded' option.

> I have
> two questions:
> 1) Has anybody already written a script like this? After all, there is
> no need to reinvent the wheel a second time.
> 2) What should I best grep for? In this case I would just go for the
> "missing". Does this cover all possible outputs of btrfs fi show in
> case of a damaged array? What other outputs do I need to consider for
> my script.

I monitor the device error counters, i.e. the output of

	for fs in /fs1 /fs2 /fs3... ; do
		btrfs dev stat "$fs" | grep -v " 0$"
	done

and send an email when it isn't empty.

When there are errors I investigate in more detail (is it a failing disk?
failed disk?  bad cables?  bad RAM?  One-off UNC sector that can be
ignored?), fix any problems (i.e. replace hardware, run scrub), and
reset the counters to zero with 'btrfs dev stat -z'.

> Yours sincerely
> Stefan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--wl4gXchqb9PBRcq/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlgFDS8ACgkQgfmLGlazG5zkdQCfYy+IcezPwRoKA25O8J+Y+Jqh
mIwAnjzmjmkPXwsSGgRwHfL/hDY+O/WS
=Qr/N
-----END PGP SIGNATURE-----

--wl4gXchqb9PBRcq/--
