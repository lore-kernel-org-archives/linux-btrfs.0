Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:50383 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754828AbcARMpg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Jan 2016 07:45:36 -0500
Date: Mon, 18 Jan 2016 12:45:33 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Marc MERLIN <marc@merlins.org>
Cc: Btrfs mailing list <linux-btrfs@vger.kernel.org>
Subject: Re: BTRFS: bdev /dev/mapper/dshelf1 errs: wr 2970, rd 848, flush 0,
 corrupt 189, gen 0
Message-ID: <20160118124533.GU422@carfax.org.uk>
References: <20160118002748.GE12045@merlins.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="p8mP+8RrBGerSNjm"
In-Reply-To: <20160118002748.GE12045@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--p8mP+8RrBGerSNjm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jan 17, 2016 at 04:27:48PM -0800, Marc MERLIN wrote:
> So, I had an FS with a few issues, I ran btrfs check --repair to completion
> 
> Then, after mounting, I still get this warning.
> Shouldn't those error counters be reset after check --repair?
> 
> Kernel: 4.2.5
> Btrfs-tools: 4.3-1
> 
> If that matters, here's the output of check --repair (captured with script
> -f, so the output is a bit wrong):
> gargamel:~# btrfs check --repair -p /dev/mapper/dshelf1
> enabling repair mode
> Checking filesystem on /dev/mapper/dshelf1
> UUID: 6358304a-2234-4243-b02d-4944c9af47d7
> badcextentx[29368320, 29372416), type mismatch with chunk
> bad extent [29372416, 29376512), type mismatch with chunk
> 
> (2856970 lines deleted)
> 
> bad extent [8697338122240, 8697338126336), type mismatch with chunk
> bad extent [8697338126336, 8697338130432), type mismatch with chunk
> bad extent [8697338130432, 8697338134528), type mismatch with chunk

   This is, I think, a symptom of an FS created with a broken
mkfs.btrfs, and it needs to be re-created. Take a look for that error
message in the mailing list archives -- there's been a few posts about
it in the last couple of months.

   Hugo.

> checking extents [.]
> 
> repaired damaged extent references
> 
> Fixed 0 roots.
> cache and super generation don't match, space cache will be invalidated
> Fixedidiscountofileoextents for inode: 204450 in root: 45851
> FixedidiscountofileOextents for inode: 204452 in root: 45851
> root 45851 inode 204452 errors 40, bad file extent
> Fixedidiscountofileoextents for inode: 204452 in root: 45851
> root 45851 inode 204452 errors 40, bad file extent
> rootk45851sinodes204452 errors 40, bad file extent
> FixedidiscountofileOextents for inode: 204450 in root: 45852
> FixedidiscountofileOextents for inode: 204452 in root: 45852
> checking fs roots [o]
> rootk45851sinodes204452 errors 40, bad file extent
> Fixedidiscountofile.extents for inode: 204450 in root: 45856
> Fixed discount file extents for inode: 204452 in root: 45856
> rootk45851sinodes204452 errors 40, bad file extent
> warninggliner3653 [o]
> 
> checking csums
> checking root refs
> found 9826147025859 bytes used err is 0
> total csum bytes: 9584068648
> total tree bytes: 12200706048
> total fs tree bytes: 330457088
> total extent tree bytes: 498716672
> btree space waste bytes: 1372963760
> file data blocks allocated: 9976766078976
>  referenced 9987816431616
> btrfs-progs v4.3
> 
> Thanks,
> Marc

-- 
Hugo Mills             | In my day, we didn't have fancy high numbers. We had
hugo@... carfax.org.uk | "nowt", "one", "twain" and "multitudes".
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--p8mP+8RrBGerSNjm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWnN5tAAoJEFheFHXiqx3kmRwP/2ZeMT35hADvwQ8Gx8df6FFR
k+RHnuSfl0fkowZjExZHIGrVLRzp0codp9S8D5e9o46qsHy2RCfnT/n/vOu8ZNUd
Y+xroihW0l8XRuVi+wzJobwCHaBfOMDvLudRGE5h5+knP2TC6rF4w26cqxliu2HL
lGv8/dAjwo0/YiXqYl/McenbXQuTdxR8/tQ3YR+vK1r9n1cawqRESDjVyKEEtRpZ
vVV1toj2Y/RCqVaxZ2ZPVkNOP9C5PutOYEK7H3098xy4kU033F844s1xI8VLY0go
+8hPT+1s6CXllW2z93GfoVKW33IGmuLThFi4oULGIgOvnFU9UWEjAxUBJ60BozRa
fWCtSFmk6qJQ3iaILWhLnDkROPGejWn4gSfn85O0HMTwLUw615tHsIt7nPcjw9uc
yQIlS5iNkrggPlwgso50MClKVtmBNh4vJMMCs9RX/7HnA4YN4EGyHOfoh0eaSon8
weIUITlrbRgpL5R0aQ01wKyddiKUxFV1TNXwcEEVYfVU4bpU9WGGaSMiV33W0sn+
TBnd9AfZ6FDCIAdR59A87FMCYczcFsAtoYw8EHVKEV85iGsca76GPdwYsMaESMYm
rkuIJ7CpQrCm1o0Wsa7bEtNM8FhZYspSBo4bGDEkSRT8vFzL44BOb/hjnXkev8ct
YJDesfPftN6DwIbhApwA
=1rhJ
-----END PGP SIGNATURE-----

--p8mP+8RrBGerSNjm--
