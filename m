From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: btrfs and load (sys)
Date: Wed, 23 Nov 2011 20:56:16 +0600
Message-ID: <20111123205616.73b4d0a7@natsu>
References: <CAJ1PRSnhqo3yU4b0sbcYLfByb_pTDuAOL2xo4fryiEoacr8iYg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/rFPorEK=z423ZgDqDk/kov2"; protocol="application/pgp-signature"
Cc: linux-btrfs@vger.kernel.org
To: "krzf83@gmail.com " <krzf83@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAJ1PRSnhqo3yU4b0sbcYLfByb_pTDuAOL2xo4fryiEoacr8iYg@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/rFPorEK=z423ZgDqDk/kov2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 23 Nov 2011 15:43:14 +0100
"krzf83@gmail.com " <krzf83@gmail.com> wrote:

> I've been using btrfs for two months now. Every day between 02:00 and
> 08:00 I rsync some 300GB data (milions of files) to btrfs device and
> then make snapshot. Next day i rsync again 300GG little changed (rsync
> "in place"). First days it worked perfectly. Then loadavg (sys load)
> started to rise. Now, after 60 days of rsync+shapshots sys load is so
> high that whole server becames quite unresponsive betweend 02:00 and
> 08:00. I never deleted any shapshot (yet) to its not rebalancing
> thing.

Hello,

I employ the same scenario, except that my rsync-(actually mirrordir-) dest=
ination btrfs device is only mounted briefly for the copy-then-snapshot ope=
ration, and unmounted during the rest of the time. Haven't noticed any perf=
ormance problems yet, but even though I have about 2 TB of data there, it's=
 probably not millions of files.

Have you tried unmounting the FS and then mounting it again, to see if it s=
olves the performance problem (at least for a while)? Or just keeping it mo=
stly unmounted, I suppose what you have is a partition with backups, so kee=
ping it mostly offline is better reliability-wise.


--=20
With respect,
Roman

~~~~~~~~~~~~~~~~~~~~~~~~~~~
"Stallman had a printer,
with code he could not see.
So he began to tinker,
and set the software free."

--Sig_/rFPorEK=z423ZgDqDk/kov2
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk7NCZAACgkQTLKSvz+PZwirbgCgmTLLcjMiPaqzqBLx6TTQwROu
eR4Anj2L3N/h9vwlJvHGI1l0MqW/Aslr
=tsjX
-----END PGP SIGNATURE-----

--Sig_/rFPorEK=z423ZgDqDk/kov2--
