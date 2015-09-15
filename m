Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:43286 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289AbbIOPzs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Sep 2015 11:55:48 -0400
Date: Tue, 15 Sep 2015 15:55:47 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: service@automatix.de
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Recovery possible on asynchronous transid ?
Message-ID: <20150915155547.GB28645@carfax.org.uk>
References: <55F82990.5050403@automatix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Y7xTucakfITjPcLV"
In-Reply-To: <55F82990.5050403@automatix.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Y7xTucakfITjPcLV
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 15, 2015 at 04:22:08PM +0200, Juergen Sauer wrote:
> Hi!
>=20
> Due an hibernation event my BTRFS Raid56 failed and is not mountable
> anymore. :(
>=20
> For Debugging I moved the Devices to an test-hardware and booted this
> system from an Arch Linux ISO, which I created for this purpose.
>=20
> The Problem is:
> [ 1086.714109] BTRFS (device sdd1): parent transid verify failed on
> 209362944 wanted 293924 found 293922

   Try mounting with -o recovery, and see if that helps.

   Hugo.

> Is there any posibility to recover any files from this desaster?
> Is there any posibiolity to set the superblock to transid #293922 ?
>=20
> See my tries to recover here as konsole log below.
>=20
>=20
>=20
>=20
> ---------x----------x-----------x------------------x--------------
> BTRFS Tools Version: btrfs-progs v4.2
>=20
> Kernel: Linux archiso 4.1.6-1-ARCH #1 SMP PREEMPT Mon Aug 17 08:52:28
> CEST 2015 x86_64 GNU/Linux
>=20
> btrfs show
> Label: 'archiv'  uuid: 48f71e09-6898-4665-bc61-bd7ca4ba4a24
> 	Total devices 4 FS bytes used 3.35TiB
> 	devid    1 size 1.70TiB used 726.69GiB path /dev/sdc3
> 	devid    2 size 1.82TiB used 1.35TiB path /dev/sdb1
> 	devid    3 size 1.82TiB used 1.35TiB path /dev/sda1
> 	devid    4 size 1.82TiB used 1.35TiB path /dev/sdd1
>=20
> mount LABEL=3Darchiv /mnt -o degraded,ro
> # dmesg
> [ 1086.691246] BTRFS info (device sdd1): allowing degraded mounts
> [ 1086.691251] BTRFS info (device sdd1): disk space caching is enabled
> [ 1086.714109] BTRFS (device sdd1): parent transid verify failed on
> 209362944 wanted 293924 found 293922
> [ 1086.752227] BTRFS (device sdd1): parent transid verify failed on
> 244719616 wanted 293924 found 293922
> [ 1086.754377] BTRFS: bdev /dev/sdb1 errs: wr 3, rd 0, flush 1, corrupt
> 0, gen 0
> [ 1086.754676] BTRFS (device sdd1): parent transid verify failed on
> 209375232 wanted 293924 found 293914
> [ 1086.770626] BTRFS (device sdd1): parent transid verify failed on
> 245538816 wanted 293924 found 293922
> [ 1086.912646] BTRFS (device sdd1): parent transid verify failed on
> 253378560 wanted 293924 found 293914
> [ 1086.942088] BTRFS (device sdd1): parent transid verify failed on
> 253390848 wanted 293924 found 293914
> [ 1086.944003] BTRFS (device sdd1): parent transid verify failed on
> 253403136 wanted 293924 found 293914
> [ 1087.262500] BTRFS (device sdd1): parent transid verify failed on
> 253911040 wanted 293924 found 293914
> [ 1087.264800] BTRFS (device sdd1): bad tree block start 0 253911040
> [ 1087.266442] BTRFS: Failed to read block groups: -5
> [ 1087.315127] BTRFS: open_ctree failed
>=20
> # btrfs-find-root /dev/sda1
> Superblock thinks the generation is 293924
> Superblock thinks the level is 2
> Found tree root at 244273152 gen 293924 level 2
> Well block 238604288(gen: 293923 level: 2) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 199577600(gen: 293922 level: 2) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 199786496(gen: 293921 level: 2) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 199925760(gen: 293919 level: 0) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 209240064(gen: 293914 level: 0) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 182116352(gen: 293913 level: 2) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 179388416(gen: 293912 level: 2) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 238559232(gen: 293911 level: 0) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 237764608(gen: 293911 level: 0) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 175108096(gen: 293910 level: 2) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 74981376(gen: 293909 level: 2) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 156815360(gen: 293908 level: 0) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 156807168(gen: 293908 level: 0) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 156803072(gen: 293908 level: 0) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 156688384(gen: 293908 level: 0) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 153407488(gen: 293908 level: 0) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 149504000(gen: 293908 level: 0) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 149499904(gen: 293908 level: 0) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 149078016(gen: 293908 level: 0) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 149073920(gen: 293908 level: 0) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 147288064(gen: 293908 level: 0) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 107081728(gen: 293907 level: 0) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 61517824(gen: 293906 level: 2) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 63414272(gen: 293905 level: 0) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 100290560(gen: 293904 level: 0) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 61906944(gen: 293904 level: 0) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 99393536(gen: 293903 level: 0) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 79740928(gen: 293903 level: 0) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 47403008(gen: 293901 level: 2) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 42622976(gen: 293899 level: 2) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 40329216(gen: 293898 level: 2) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 38137856(gen: 293897 level: 2) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 36515840(gen: 293896 level: 2) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> parent transid verify failed on 209362944 wanted 293924 found 293922
> parent transid verify failed on 209362944 wanted 293924 found 293922
> parent transid verify failed on 209362944 wanted 293924 found 293922
>=20
> # btrfs-find-root /dev/sdb1
> Ignoring transid failure
> Superblock thinks the generation is 293924
> Superblock thinks the level is 2
> Found tree root at 244273152 gen 293924 level 2
> Well block 238604288(gen: 293923 level: 2) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 199577600(gen: 293922 level: 2) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 199786496(gen: 293921 level: 2) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 199925760(gen: 293919 level: 0) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 209240064(gen: 293914 level: 0) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 182116352(gen: 293913 level: 2) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 179388416(gen: 293912 level: 2) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 238559232(gen: 293911 level: 0) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 237764608(gen: 293911 level: 0) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 175108096(gen: 293910 level: 2) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 74981376(gen: 293909 level: 2) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 156815360(gen: 293908 level: 0) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 156807168(gen: 293908 level: 0) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 156803072(gen: 293908 level: 0) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 156688384(gen: 293908 level: 0) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 153407488(gen: 293908 level: 0) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 149504000(gen: 293908 level: 0) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 149499904(gen: 293908 level: 0) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 149078016(gen: 293908 level: 0) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 149073920(gen: 293908 level: 0) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 147288064(gen: 293908 level: 0) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 107081728(gen: 293907 level: 0) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 61517824(gen: 293906 level: 2) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 63414272(gen: 293905 level: 0) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 100290560(gen: 293904 level: 0) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 61906944(gen: 293904 level: 0) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 99393536(gen: 293903 level: 0) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 79740928(gen: 293903 level: 0) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 47403008(gen: 293901 level: 2) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 42622976(gen: 293899 level: 2) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 40329216(gen: 293898 level: 2) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 38137856(gen: 293897 level: 2) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 36515840(gen: 293896 level: 2) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> parent transid verify failed on 209362944 wanted 293924 found 293922
> parent transid verify failed on 209362944 wanted 293924 found 293922
> parent transid verify failed on 209362944 wanted 293924 found 293922
>=20
> # btrfs-find-root /dev/sdc3
> Ignoring transid failure
> Superblock thinks the generation is 293924
> Superblock thinks the level is 2
> Found tree root at 244273152 gen 293924 level 2
> Well block 238604288(gen: 293923 level: 2) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 199577600(gen: 293922 level: 2) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 199786496(gen: 293921 level: 2) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 199925760(gen: 293919 level: 0) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 209240064(gen: 293914 level: 0) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 182116352(gen: 293913 level: 2) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 179388416(gen: 293912 level: 2) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 238559232(gen: 293911 level: 0) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 237764608(gen: 293911 level: 0) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 175108096(gen: 293910 level: 2) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 74981376(gen: 293909 level: 2) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 156815360(gen: 293908 level: 0) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 156807168(gen: 293908 level: 0) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 156803072(gen: 293908 level: 0) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 156688384(gen: 293908 level: 0) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 153407488(gen: 293908 level: 0) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 149504000(gen: 293908 level: 0) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 149499904(gen: 293908 level: 0) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 149078016(gen: 293908 level: 0) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 149073920(gen: 293908 level: 0) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 147288064(gen: 293908 level: 0) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 107081728(gen: 293907 level: 0) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 61517824(gen: 293906 level: 2) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 63414272(gen: 293905 level: 0) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 100290560(gen: 293904 level: 0) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 61906944(gen: 293904 level: 0) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 99393536(gen: 293903 level: 0) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 79740928(gen: 293903 level: 0) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 47403008(gen: 293901 level: 2) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 42622976(gen: 293899 level: 2) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 40329216(gen: 293898 level: 2) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 38137856(gen: 293897 level: 2) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 36515840(gen: 293896 level: 2) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> parent transid verify failed on 209362944 wanted 293924 found 293922
> parent transid verify failed on 209362944 wanted 293924 found 293922
> parent transid verify failed on 209362944 wanted 293924 found 293922
> Ignoring transid failure
>=20
> # btrfs-find-root /dev/sdd1
> Superblock thinks the generation is 293924
> Superblock thinks the level is 2
> Found tree root at 244273152 gen 293924 level 2
> Well block 238604288(gen: 293923 level: 2) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 199577600(gen: 293922 level: 2) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 199786496(gen: 293921 level: 2) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 199925760(gen: 293919 level: 0) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 209240064(gen: 293914 level: 0) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 182116352(gen: 293913 level: 2) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 179388416(gen: 293912 level: 2) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 238559232(gen: 293911 level: 0) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 237764608(gen: 293911 level: 0) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 175108096(gen: 293910 level: 2) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 74981376(gen: 293909 level: 2) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 156815360(gen: 293908 level: 0) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 156807168(gen: 293908 level: 0) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 156803072(gen: 293908 level: 0) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 156688384(gen: 293908 level: 0) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 153407488(gen: 293908 level: 0) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 149504000(gen: 293908 level: 0) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 149499904(gen: 293908 level: 0) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 149078016(gen: 293908 level: 0) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 149073920(gen: 293908 level: 0) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 147288064(gen: 293908 level: 0) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 107081728(gen: 293907 level: 0) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 61517824(gen: 293906 level: 2) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 63414272(gen: 293905 level: 0) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 100290560(gen: 293904 level: 0) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 61906944(gen: 293904 level: 0) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 99393536(gen: 293903 level: 0) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 79740928(gen: 293903 level: 0) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 47403008(gen: 293901 level: 2) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 42622976(gen: 293899 level: 2) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 40329216(gen: 293898 level: 2) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 38137856(gen: 293897 level: 2) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 36515840(gen: 293896 level: 2) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> parent transid verify failed on 209362944 wanted 293924 found 293922
> parent transid verify failed on 209362944 wanted 293924 found 293922
> parent transid verify failed on 209362944 wanted 293924 found 293922
> Ignoring transid failure
> Superblock thinks the generation is 293924
> Superblock thinks the level is 2
> Found tree root at 244273152 gen 293924 level 2
> Well block 238604288(gen: 293923 level: 2) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 199577600(gen: 293922 level: 2) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 199786496(gen: 293921 level: 2) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 199925760(gen: 293919 level: 0) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 209240064(gen: 293914 level: 0) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 182116352(gen: 293913 level: 2) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 179388416(gen: 293912 level: 2) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 238559232(gen: 293911 level: 0) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 237764608(gen: 293911 level: 0) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 175108096(gen: 293910 level: 2) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 74981376(gen: 293909 level: 2) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 156815360(gen: 293908 level: 0) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 156807168(gen: 293908 level: 0) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 156803072(gen: 293908 level: 0) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 156688384(gen: 293908 level: 0) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 153407488(gen: 293908 level: 0) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 149504000(gen: 293908 level: 0) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 149499904(gen: 293908 level: 0) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 149078016(gen: 293908 level: 0) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 149073920(gen: 293908 level: 0) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 147288064(gen: 293908 level: 0) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 107081728(gen: 293907 level: 0) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 61517824(gen: 293906 level: 2) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 63414272(gen: 293905 level: 0) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 100290560(gen: 293904 level: 0) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 61906944(gen: 293904 level: 0) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 99393536(gen: 293903 level: 0) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 79740928(gen: 293903 level: 0) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 47403008(gen: 293901 level: 2) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 42622976(gen: 293899 level: 2) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 40329216(gen: 293898 level: 2) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 38137856(gen: 293897 level: 2) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> Well block 36515840(gen: 293896 level: 2) seems good, but
> generation/level doesn't match, want gen: 293924 level: 2
> ---------x----------x-----------x------------------x--------------
>=20
> Thanks in advance
>=20
>=20
> mit freundlichen Gr=FC=DFen
> J=FCrgen Sauer

--=20
Hugo Mills             | vi: The core of evil.
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--Y7xTucakfITjPcLV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJV+D+CAAoJEFheFHXiqx3kzgkQAJOfQsVQmE2jdgMTOYV85hh9
/RojizmFNP7X5y1gFv33lZJmvmXXqZcnx8n5CyjU3FXiW/oPmQ06zoHhVv8fLTmo
aQftmQXnFne830deXBJ0R8X8z2nHcnvxUkxQ1nYNL3gH7ONeZqpqF8mMK7dPjZVs
2tI3pDx76mVML+LdPOwOP76t1pwVUhQEXdSQE2ikVMisXzWYDXJYe4zPZm7MdqVf
7d4h4KtEt9CQiAqLHx1lWH+ZDvG7IWMNNhdIxCh6wuvWqB5LYDSKhaycePEcx752
fjVawCcclM4RAnlkrxKU8PQIPvLnkVoxesQSxsMTU2HL39fvIGwX13fKUeILM5eU
2cx4NyIPmmZOOc3nWvWoa0z3v0sdKTBOnzCtWUuaBK2PiEeC9WmooulTu9/FqvRQ
L1HumtifV+r/NPbvOPBNWVSn+8ShJoHHcnPcb/e9Fe0RaWXhcUGrJBXrpkfmJf8r
fc4R+f9ViDbMlOLPmEnpo710yitmQZQFq8B3IfR7ukjn+4162XEyFfh8c5zpRKE5
Xk9ZIfmrwRMb8hqevXC8qbrssQCEoDMnR3jMnCZ7G/AbxUj+u8mVQYuV9amLkLhg
By7y3n7XJi5VC7lXLDWngwX6euJG2yk+98hRRIC9H+BQA2up3xCj8JtPP5y2/baL
goCackEw4z4bhBC8LUV9
=5/75
-----END PGP SIGNATURE-----

--Y7xTucakfITjPcLV--
