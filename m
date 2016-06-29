Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:33525 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218AbcF2TX7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 Jun 2016 15:23:59 -0400
Date: Wed, 29 Jun 2016 19:23:57 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Saint Germain <saintger@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Kernel bug during RAID1 replace
Message-ID: <20160629192357.GC10223@carfax.org.uk>
References: <CAJCQCtRSu0GwLRqgvzj9pv80gqoqb6vnjVMLwMmnWF-rvR0tcg@mail.gmail.com>
 <20160629005208.5e9addcf@system>
 <CAJCQCtQnNfpu6xoFy2W_hfikphhp_AbUDVmm4Lr2Rsncrx_EsA@mail.gmail.com>
 <20160629115055.29018e6a@system>
 <CAJCQCtS=kd31tOe_YCX96W1K85sH2_qTAsxggyyP5kWzZrauoQ@mail.gmail.com>
 <20160629201208.275b37ad@system>
 <16e65a07-03b6-2540-fc96-3538c5bc5c99@gmail.com>
 <20160629210217.0e4e4d1c@system>
 <CAJCQCtRyPyXA+4+D-J8940xiOMcEwQHgsk6uSpnPeLUduAJd2Q@mail.gmail.com>
 <20160629211613.125ce3f0@system>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jy6Sn24JjFx/iggw"
In-Reply-To: <20160629211613.125ce3f0@system>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--jy6Sn24JjFx/iggw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 29, 2016 at 09:16:13PM +0200, Saint Germain wrote:
> On Wed, 29 Jun 2016 13:08:30 -0600, Chris Murphy
> <lists@colorremedies.com> wrote :
> 
> > >> > Ok I will follow your advice and start over with a fresh BTRFS
> > >> > volume. As explained on another email, rsync doesn't support
> > >> > reflink, so do you think it is worth trying with BTRFS send
> > >> > instead ? Is it safe to copy this way or rsync is more reliable
> > >> > in case of faulty BTRFS volume ?
> > >> >
> > >> If you have the space, btrfs restore would probably be the best
> > >> option. It's not likely, but using send has a risk of contaminating
> > >> the new filesystem as well.
> > >>
> > >
> > > I have to copy through the network (I am running out of disks...) so
> > > btrfs restore is unfortunately not an option.
> > > I didn't know that btrfs send could contaminate the target disk as
> > > well ?
> > > Ok rsync it is then.
> > 
> > restore will let you extract files despite csum errors. I don't think
> > send will, and using cp or rsync Btrfs definitely won't hand over the
> > file.
> > 
> 
> That's Ok I'd prefer to avoid copying files with csum errors anyway (I
> can restore them from backups).
> However will btrfs send abort the whole operation as soon as it finds a
> csum error ?
> And will I have the risk to "contaminate" the target BTRFS volume by
> using BTRFS send ?

   A send stream is effectively just a sequence of filesystem commands
(mv, cp, cp --reflink, rm, dd). So any damage that it can do when
replayed by receive is limited to what you can do with the basic shell
commands (plus cloning extents). If you have metadata breakage in your
source filesystem, this won't cause the same metadata breakage to show
up in the target filesystem.

   Hugo.

-- 
Hugo Mills             | Quidquid latine dictum sit, altum videtur
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--jy6Sn24JjFx/iggw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJXdCBNAAoJEFheFHXiqx3koIUP/juAw9ATk62isCL+NtgYok54
HgRWhkFCjEJF7Wp8p3X7MT3oUf4n0zBEBN7IhR8XXP/+Nk+AfqR6peNnmgAGmr/4
hqJ152o3k8yizMpN8PcQQcQlmMhUS+3et5G8aR20Vm7JN43zSI4CV75yRm07+XE0
xI/ZevYuItIrTcun4pk6UxUAYF7PeMItrsK4r4/jiMBRS504qjkNatMvIZOVaM0p
pJuRQhmDM2UFSRSWKe2TZxtMxRHTJE1sGjDltYzRWe3xJ90FLX+5QVfUZjH+zbmG
rUetfaPpo2bvPEmPxSh54nIUT7FTg2uGH9TxWIwDPnq5+flmpofbcpsed3SmH1Td
0CQ2heRQOXqQCIfsCKURnNfBzt0AyWx2WZWeO/7ERHxTlvclM/xVMpw19pKcIISY
Vp9Wt0TsolmSlunWZdzGw2FumyNcb7DsSthnaJdDIDAOxg6n55ht43oBINKiVfvQ
lTQQk6rYCFHTQFce1VAgfBG4nhpd2s3YeAtokIZQb+JlNfNXglVBOkuepv7Md0GU
hG0trcPAYC7HRWAeB8+my/W+H3f8v24UFC+cDHwLAhxnm1s8+Rd8rbe7Rvkdm4yZ
HvfyMYJOAnanWNgyTxk5LE9RdowNjkbaD7VfzC8mNwgzYn6noEUhb2aJy8hisA2c
AydDWP7zfzeGxA4UST7O
=CtXA
-----END PGP SIGNATURE-----

--jy6Sn24JjFx/iggw--
