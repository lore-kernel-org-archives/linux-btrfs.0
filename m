Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:63837 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755847AbaHVHf5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Aug 2014 03:35:57 -0400
From: Marc Dietrich <marvin24@gmx.de>
To: Eric Sandeen <sandeen@redhat.com>
Cc: Gui Hecheng <guihc.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: init uninitialized output buf for btrfs-restore
Date: Fri, 22 Aug 2014 09:35:51 +0200
Message-ID: <2820069.ALay9nml0k@fb07-iapwap2>
In-Reply-To: <53F640F1.1010104@redhat.com>
References: <1408592136-7606-1-git-send-email-guihc.fnst@cn.fujitsu.com> <53F63D8F.2080400@redhat.com> <53F640F1.1010104@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart3356714.KWtt26RDXr"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--nextPart3356714.KWtt26RDXr
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="ISO-8859-1"

Hi Eric,

Am Donnerstag, 21. August 2014, 13:56:49 schrieb Eric Sandeen:
> On 8/21/14, 1:42 PM, Eric Sandeen wrote:
> > On 8/20/14, 10:35 PM, Gui Hecheng wrote:
> >> A memory problem reported by valgrind as follows:
> >> 	=== Syscall param pwrite64(buf) points to uninitialised byte(s)
> >> 
> >> When running:
> >> 	# valgrind --leak-check=yes btrfs restore /dev/sda9 /mnt/backup
> >> 
> >> Because the output buf size is alloced with malloc, but the length of
> >> output data is shorter than the sizeof(buf), so valgrind report
> >> uninitialised byte(s).
> >> We could use calloc to repalce malloc and clear this WARNING away.
> > 
> > It clears the valgrind error away, but does it hide a real bug?
> 
> Maybe the relevant question for Marc is - did you get decompression
> errors during restore?  if so then I guess it all makes sense, and
> the proposed patch seems sane after all, sorry.

I use lzo and yes, I got decompression errors.

Marc

--nextPart3356714.KWtt26RDXr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQEcBAABAgAGBQJT9vLXAAoJEKyeR39HFBtoxG0H/3ITX0CIhewwtqqZQVBDwV7L
NIF3h9fzBa9UMs898KGtkTguOxYciDfB8dTnkq3PFG5U9UyhZGq2B87qFUutnSp9
ln4UEqZspXISeB4mIlU+FkuDUuhMuN9ZyqWu5OqUgGNJhVuQYAQmoU6TA4yFzq4q
DVoHFxkhFH8ykcGeHMCYurUC1OxNTEB/Zpy65q8NSVGSQYwls99Y+7DIr8DgZX/d
ibMw1oyOUWGiQeHcSZ8jhshzNyX/Kz/q0Pzay2yX7fElLUH+X0kiWbrNfhD06O94
6vZ4pcmPqina4bqQ1i+/Eviga6FAr1iR8ShMAVMXyRUycKmSArCs2Zfg0dqxthk=
=5fny
-----END PGP SIGNATURE-----

--nextPart3356714.KWtt26RDXr--

