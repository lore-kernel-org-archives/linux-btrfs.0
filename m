Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:55266 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752122Ab3HZSeX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 26 Aug 2013 14:34:23 -0400
Date: Mon, 26 Aug 2013 19:34:19 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Tomasz Chmielewski <tch@virtall.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: failed to read log tree, open_ctree failed
Message-ID: <20130826183419.GM3115@carfax.org.uk>
References: <20130827022509.57de1ab2@virtall.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uwB7x3tnyrZQfZJI"
In-Reply-To: <20130827022509.57de1ab2@virtall.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--uwB7x3tnyrZQfZJI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 27, 2013 at 02:25:09AM +0800, Tomasz Chmielewski wrote:
> I had a RAID-1 btrfs filesystem with Linux 3.10.
> 
> After hard reset, I'm no longer able to mount it:
> 
> [   35.254122] Btrfs loaded
> [   35.254577] device label test-btrfs devid 1 transid 97966 /dev/sda4
> [   35.254819] device label test-btrfs devid 3 transid 97966 /dev/sdb4
> [   35.255032] device label test-btrfs devid 3 transid 97966 /dev/sdb4
> [   35.255552] btrfs: force zlib compression
> [   35.255645] btrfs: disk space caching is enabled
> [   35.379806] btrfs: bdev /dev/sda4 errs: wr 0, rd 2, flush 0, corrupt 0, gen 0
> [   56.209412] parent transid verify failed on 3321036099584 wanted 97967 found 97966
> [   56.225990] parent transid verify failed on 3321036099584 wanted 97967 found 97966
> [   56.226128] btrfs: failed to read log tree
> [   56.344483] btrfs: open_ctree failed
> 
> 
> I've tried with 3.11-rc7, but it gives the same result.
> 
> Any hints how to recover from that?
> I have backups, but it would be nice if the filesystem just mounted.

   Try mounting with both -orecovery and -oro,recovery.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
              --- Python is executable pseudocode; perl ---              
                        is executable line-noise.                        

--uwB7x3tnyrZQfZJI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUhufq1heFHXiqx3kAQKAaA/+MKhqby2egHLYIfgIuKHMHMsIr5aGVdau
YEfsifUjAOKL3+RuWZbEWFdSjjy773tTVeL/GwXD7U5TkjvK3JCUUgJ7EGuAcTSt
ESzDtDFjCZBiwImroiC5oobsMLdLCJUpfstPQ+x8rKpv7fUEXc2RA+qCAxuofQtI
/1WJfXLTPM8FuRDm0TIqQwkj7Bz8oB6t+WCY0ZkTeLA3RW3sj+vxlrSJwOIZ5azX
B/IHITeBs4Ym5MuKcKAj7oBCBrwtWHeeOFVUvdro0ctowAtccjyWuRnrgp5hsLxK
v8unw4v7bCK/vQyeOxfbsEp8fYl9zZVtyXiy/CabRdB1gGI4kSZHHpq0I/EWwf7+
MrgxdWHFxNKHk9thqyZYJKOq4d4bRahDF5Of7M2qpPiGAvCL96nVAKN2HE+SJodC
RflG71g9//evvKmn55XEArCiMef9+uzC2YDkJ81YM8tHCIJaalVYgErMmhdUgPK5
E+vVNN6a2SgMeXxTzVBJi/t26VcEK7H4dP3SRAxb87dQzTfEBAs69ue3LdLu6jTo
rq2wd9NWqXtIfNHxfbkspscinxCiNnQoqeuq3FrOaFY9QWRUMpBNhq80+dlXtqOO
I4AL5jAqOkd+2D6PqeOtTCy2e/HO6dwGH0quo3Zg7roF9nKRkwG3ZygijWOMufpG
e+jNDZQFc/0=
=Y1ga
-----END PGP SIGNATURE-----

--uwB7x3tnyrZQfZJI--
