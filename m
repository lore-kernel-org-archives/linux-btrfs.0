Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:44518 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992525AbbHHTF2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 8 Aug 2015 15:05:28 -0400
Date: Sat, 8 Aug 2015 19:05:25 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Martin Tippmann <martin.tippmann@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: fs unreadable after powercycle: BTRFS (device sda): parent
 transid verify failed on 427084513280 wanted 390924 found 390922
Message-ID: <20150808190525.GM14352@carfax.org.uk>
References: <CABL_Pd-Z6-raB3ngEDbj=-d+QVMohGQ9DHXqv0fVvVNy-HVxUA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Kc9HNjpzOXVc7FFU"
In-Reply-To: <CABL_Pd-Z6-raB3ngEDbj=-d+QVMohGQ9DHXqv0fVvVNy-HVxUA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Kc9HNjpzOXVc7FFU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Aug 08, 2015 at 08:43:34PM +0200, Martin Tippmann wrote:
> Hi, after a hard reboot (powercycle) a btrfs volume did not come up again:
> 
> It's a single 4TB disk - only btrfs with lzo - data=single,metadata=dup
> 
> [  121.831814] BTRFS info (device sda): disk space caching is enabled
> [  121.857820] BTRFS (device sda): parent transid verify failed on
> 427084513280 wanted 390924 found 390922
> [  121.861607] BTRFS (device sda): parent transid verify failed on
> 427084513280 wanted 390924 found 390922
> [  121.861715] BTRFS: failed to read tree root on sda
> [  121.878111] BTRFS: open_ctree failed
> 
> btrfs-progs v4.0
> Kernel: 4.1.4
> 
> I'm quite sure that the HDD is fine (no SMART Problems, Disk Errorlog
> is empty, It's a new Enterprise-Drive that worked well in the past
> days/weeks).
> 
> So I'm kind at loss what to do:
> 
> How can I recover from that problem? I've found just a note in the
> FAQ[1] but no solution to the problem.
> 
> Maybe someone can give some clues why does this happen in the first
> place? Is it unfortunate timing due to the abrupt power cycle?
> Shouldn't CoW protect against this somewhat?

   Not "somewhat": it should protect it completely. There are two ways
that this can happen: it's a bug in btrfs, or there's something
stopping barriers from working. That latter case can be either a bug
in the kernel's block layer (pretty unlikely), or the hardware is
behaving badly and ignoring the barriers (more likely, particularly if
it's on a USB/SATA converter).

   I don't think there's a good solution to transid failures, I'm
afraid. The best that I'm aware of is to use btrfs restore to grab the
pieces of your FS that aren't up to date in your backups, and then
restore from them.

> Thanks for any hints!
> 
> Additional info:
> 
> # btrfs check /dev/sda
> parent transid verify failed on 427084513280 wanted 390924 found 390922
> parent transid verify failed on 427084513280 wanted 390924 found 390922
> parent transid verify failed on 427084513280 wanted 390924 found 390922
> parent transid verify failed on 427084513280 wanted 390924 found 390922
> Ignoring transid failure
> Couldn't setup extent tree
> Couldn't open file system
> 
> Not sure what it does but it looks not too good:

   Actually, it's pretty good, other than the transid failure, which
is a real problem.

   Hugo.

> # btrfs-find-root /dev/sda
> parent transid verify failed on 427084513280 wanted 390924 found 390922
> parent transid verify failed on 427084513280 wanted 390924 found 390922
> parent transid verify failed on 427084513280 wanted 390924 found 390922
> parent transid verify failed on 427084513280 wanted 390924 found 390922
> Ignoring transid failure
> Couldn't setup extent tree
> Couldn't setup device tree
> Superblock thinks the generation is 390924
> Superblock thinks the level is 1
>   Well block 427084988416(gen: 390923 level: 1) seems good, but
> generation/level doesn't match, want gen: 390924 level: 1
> Well block 427084021760(gen: 390923 level: 1) seems good, but
> generation/level doesn't match, want gen: 390924 level: 1
> Well block 427084431360(gen: 390915 level: 0) seems good, but
> generation/level doesn't match, want gen: 390924 level: 1
> Well block 427084398592(gen: 390915 level: 0) seems good, but
> generation/level doesn't match, want gen: 390924 level: 1
> Well block 427083988992(gen: 390915 level: 0) seems good, but
> generation/level doesn't match, want gen: 390924 level: 1
> Well block 427038621696(gen: 390914 level: 1) seems good, but
> generation/level doesn't match, want gen: 390924 level: 1
> Well block 427031035904(gen: 390913 level: 1) seems good, but
> generation/level doesn't match, want gen: 390924 level: 1
> Well block 427285069824(gen: 390912 level: 1) seems good, but
> generation/level doesn't match, want gen: 390924 level: 1
> Well block 427060887552(gen: 390912 level: 1) seems good, but
> generation/level doesn't match, want gen: 390924 level: 1
> Well block 427013128192(gen: 390912 level: 1) seems good, but
> generation/level doesn't match, want gen: 390924 level: 1
> Well block 427001872384(gen: 390909 level: 0) seems good, but
> generation/level doesn't match, want gen: 390924 level: 1
> Well block 426965237760(gen: 390906 level: 0) seems good, but
> generation/level doesn't match, want gen: 390924 level: 1
> Well block 426965221376(gen: 390906 level: 0) seems good, but
> generation/level doesn't match, want gen: 390924 level: 1
> Well block 426965188608(gen: 390906 level: 0) seems good, but
> generation/level doesn't match, want gen: 390924 level: 1
> Well block 426965172224(gen: 390906 level: 0) seems good, but
> generation/level doesn't match, want gen: 390924 level: 1
> Well block 426965155840(gen: 390906 level: 0) seems good, but
> generation/level doesn't match, want gen: 390924 level: 1
> Well block 426964271104(gen: 390906 level: 0) seems good, but
> generation/level doesn't match, want gen: 390924 level: 1
> Well block 426964156416(gen: 390906 level: 0) seems good, but
> generation/level doesn't match, want gen: 390924 level: 1
> Well block 426950377472(gen: 390905 level: 0) seems good, but
> generation/level doesn't match, want gen: 390924 level: 1
> Well block 426944512000(gen: 390905 level: 0) seems good, but
> generation/level doesn't match, want gen: 390924 level: 1
> Well block 426940841984(gen: 390905 level: 0) seems good, but
> generation/level doesn't match, want gen: 390924 level: 1
> Well block 426940612608(gen: 390905 level: 0) seems good, but
> generation/level doesn't match, want gen: 390924 level: 1
> Well block 426940465152(gen: 390905 level: 0) seems good, but
> generation/level doesn't match, want gen: 390924 level: 1
> Well block 426940153856(gen: 390905 level: 0) seems good, but
> generation/level doesn't match, want gen: 390924 level: 1
> Well block 426939809792(gen: 390905 level: 0) seems good, but
> generation/level doesn't match, want gen: 390924 level: 1
> Well block 426939711488(gen: 390905 level: 0) seems good, but
> generation/level doesn't match, want gen: 390924 level: 1
> Well block 426939465728(gen: 390905 level: 0) seems good, but
> generation/level doesn't match, want gen: 390924 level: 1
> Well block 426939351040(gen: 390905 level: 0) seems good, but
> generation/level doesn't match, want gen: 390924 level: 1
> Well block 426939006976(gen: 390905 level: 0) seems good, but
> generation/level doesn't match, want gen: 390924 level: 1
> Well block 426938564608(gen: 390905 level: 0) seems good, but
> generation/level doesn't match, want gen: 390924 level: 1
> Well block 426938351616(gen: 390905 level: 0) seems good, but
> generation/level doesn't match, want gen: 390924 level: 1
> Well block 426347577344(gen: 390904 level: 1) seems good, but
> generation/level doesn't match, want gen: 390924 level: 1
> Well block 168491106304(gen: 390903 level: 1) seems good, but
> generation/level doesn't match, want gen: 390924 level: 1
> Well block 1340608053248(gen: 390902 level: 1) seems good, but
> generation/level doesn't match, want gen: 390924 level: 1
> Well block 1340295020544(gen: 390902 level: 1) seems good, but
> generation/level doesn't match, want gen: 390924 level: 1
> Well block 1264696688640(gen: 390902 level: 1) seems good, but
> generation/level doesn't match, want gen: 390924 level: 1
> Well block 1136507092992(gen: 390902 level: 1) seems good, but
> generation/level doesn't match, want gen: 390924 level: 1
> Well block 1136226516992(gen: 390902 level: 1) seems good, but
> generation/level doesn't match, want gen: 390924 level: 1
> Well block 998473711616(gen: 390902 level: 1) seems good, but
> generation/level doesn't match, want gen: 390924 level: 1
> Well block 998114721792(gen: 390902 level: 1) seems good, but
> generation/level doesn't match, want gen: 390924 level: 1
> Well block 667127316480(gen: 390902 level: 1) seems good, but
> generation/level doesn't match, want gen: 390924 level: 1
> Well block 667048116224(gen: 390902 level: 1) seems good, but
> generation/level doesn't match, want gen: 390924 level: 1
> Well block 667041382400(gen: 390902 level: 1) seems good, but
> generation/level doesn't match, want gen: 390924 level: 1
> Well block 667034255360(gen: 390902 level: 1) seems good, but
> generation/level doesn't match, want gen: 390924 level: 1
> Well block 667028701184(gen: 390902 level: 1) seems good, but
> generation/level doesn't match, want gen: 390924 level: 1
> Well block 667018526720(gen: 390902 level: 1) seems good, but
> generation/level doesn't match, want gen: 390924 level: 1
> Well block 666950320128(gen: 390902 level: 1) seems good, but
> generation/level doesn't match, want gen: 390924 level: 1
> Well block 23074570240(gen: 390902 level: 1) seems good, but
> generation/level doesn't match, want gen: 390924 level: 1
> Well block 22614048768(gen: 390813 level: 1) seems good, but
> generation/level doesn't match, want gen: 390924 level: 1
> Well block 22605398016(gen: 390812 level: 1) seems good, but
> generation/level doesn't match, want gen: 390924 level: 1
> Well block 22599712768(gen: 390811 level: 1) seems good, but
> generation/level doesn't match, want gen: 390924 level: 1
> Well block 22586949632(gen: 390809 level: 1) seems good, but
> generation/level doesn't match, want gen: 390924 level: 1
> Well block 1340463906816(gen: 390808 level: 1) seems good, but
> generation/level doesn't match, want gen: 390924 level: 1
> Well block 1340435660800(gen: 390808 level: 1) seems good, but
> generation/level doesn't match, want gen: 390924 level: 1
> Well block 1340394799104(gen: 390808 level: 1) seems good, but
> generation/level doesn't match, want gen: 390924 level: 1
> Well block 1264894115840(gen: 390808 level: 1) seems good, but
> generation/level doesn't match, want gen: 390924 level: 1
> Well block 1136142614528(gen: 390808 level: 1) seems good, but
> generation/level doesn't match, want gen: 390924 level: 1
> Well block 666915078144(gen: 390808 level: 1) seems good, but
> generation/level doesn't match, want gen: 390924 level: 1
> Well block 666902560768(gen: 390808 level: 1) seems good, but
> generation/level doesn't match, want gen: 390924 level: 1
> 
> 
> regards
> Martin
> 
> 
> 1: https://btrfs.wiki.kernel.org/index.php/Problem_FAQ#parent_transid_verify_failed

-- 
Hugo Mills             | This chap Anon is writing some perfectly lovely
hugo@... carfax.org.uk | stuff at the moment.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--Kc9HNjpzOXVc7FFU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJVxlL0AAoJEFheFHXiqx3kWcUP/joWZxJAuBMVKyN6yR4Tirxl
5+4xVcIUoW26BfKNOeHgussCiF01DlIvJDZLXwAV1QxqMamR4/sFN1p7BoSIVB9i
Wlyo8ZfxWMwwokvW2cMusIagP964ZfL31q4wQ6GH6Vmo3QlhowIswm5XbJO+igSl
7qCmiEpYVro/KUmYC+CcIKNPDdBRDVT1X4AtI9f7j3+/EzKH106i+x/KaletlRiV
ay9ip9EZtx+olrHmtEZtFUadNwCl0ELo/Cej7061ih20W27G1rehITpTZN/GnfR1
MJPgtFeJk/ydDCxX9ai+dmMWPGm5gJ/zuHZWuf9SYFmQ2frAV1wJC0D4kuqhefxT
DaynCXTn4J59wuly6HbfftnK+dy7/aSlGnulPig6aYW+j8OOFDL0JiIc/Fei7Nwc
Sf0OOthijZNtAAAnltpJLOGQ0ONsCcD7LdMwSU0J6eU7gFcwaFGVLYSGYaOqb6fv
D4gcJsz6pBizwJKroYdz0GRPBCz2OnHa33VrKjS3wBYr/96Bzk5yqF3TNQfx1SCX
pl+iyTycN5LsGYvqvGNcRp7iUxHckTQ1UKWlQ6PubLQDIiNl38ijw+pqpXjc6O0D
7g583rsdnZLHGaCrZ1KImUp8SgGS/KtqyzRXD5Qt1G+DhnT/kX1ygrCHElRXFZp7
bPdxpam/pXf3zsqNCw3Z
=iJJf
-----END PGP SIGNATURE-----

--Kc9HNjpzOXVc7FFU--
