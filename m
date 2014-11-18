Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:13556 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752963AbaKRBRS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Nov 2014 20:17:18 -0500
Message-ID: <546A9E0F.4070108@ubuntu.com>
Date: Mon, 17 Nov 2014 20:17:03 -0500
From: Phillip Susi <psusi@ubuntu.com>
MIME-Version: 1.0
To: Fennec Fox <fennectech@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: Btrfs on a failing drive
References: <CAD1x5BB5uevNP4wUsp+2tgVhofGr53QTURunsiM-4ico95R9vQ@mail.gmail.com>
In-Reply-To: <CAD1x5BB5uevNP4wUsp+2tgVhofGr53QTURunsiM-4ico95R9vQ@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

On 11/17/2014 05:55 PM, Fennec Fox wrote:
> well i am an arch linux user and machine owner using a failing
> drive its still relyable enough for me but btrfs seems not to mark
> bad blocks as unusable and continues to try to write to them. 
> /bbs.archlinux.org/viewtopic.php?pid=1476540#p1476540  this forum
> post has a few more details regarding the problem  i really need a
> bit of help  thank you

If indeed writes are failing then the drive is only suitable for a
door stop.  Drives remap bad sectors to a spare pool on write so if it
is now failing writes, it has already exhausted its spare pool and you
should have replaced it long ago.  Have a look at its SMART stats and
it will probably confirm the drive is fubar.


> [   83.050733] BTRFS info (device sda1): csum failed ino 3048916
> off 33030144 csum 1217419445 expected csum 510562246 [   83.052317]
> BTRFS info (device sda1): csum failed ino 3048916 off 33030144 csum
> 1217419445 expected csum 510562246

That's not saying writes are failing; it is saying that your data has
been silently corrupted, which means the drive is the worst kind of
broken and should be thrown in a fire at once.


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBCgAGBQJUap4OAAoJENRVrw2cjl5RwBAH/1ceBd4i7WD7679x3bshYYTi
Lv63xLRMjbo+T0md3ptcndyxFbZlRdWQiJbIKT40yn9xnqOWeXWTkSmODqGyEOdC
M9HSlfZg8fOAha4kb7k1tzzqxdR1J3iAj03/G0B4+YKY0I7AaGdzhGLRAY8EVtRW
UVG99451wwRyUpg3YLk+n12MMSlq8Sy9XSjMU5/ECDzemH5GF6pPNi39nCy6JFti
oaTOwnAROfb7L3Y9ZBiIJ52Y7p4UIdS1jaSkLw0U2g0Gz+5V1/fb1hOhK5J/loYy
bC4JyoJsxn9GyJGwM93s64aWE5X+N+i7RzmysQVBI/3wepGXpG0Tsq37NnKB3iU=
=BctV
-----END PGP SIGNATURE-----
