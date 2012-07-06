Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-2.hut.fi ([130.233.228.92]:59110 "EHLO smtp-2.hut.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756005Ab2GFVqi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 6 Jul 2012 17:46:38 -0400
Date: Sat, 7 Jul 2012 00:41:29 +0300
From: Sami Liedes <sami.liedes@iki.fi>
To: Jan Schmidt <list.btrfs@jan-o-sch.net>, linux-btrfs@vger.kernel.org
Subject: Re: btrfs GPF in read_extent_buffer() while scrubbing with kernel
 3.4.2
Message-ID: <20120706214129.GA8933@sli.dy.fi>
References: <4FF42876.8010309@jan-o-sch.net>
 <20120704160340.GA9770@sli.dy.fi>
 <4FF47168.9010405@jan-o-sch.net>
 <20120704202452.GA8996@sli.dy.fi>
 <4FF5998D.8020205@jan-o-sch.net>
 <20120705234739.GA9736@sli.dy.fi>
 <4FF6C12A.10305@jan-o-sch.net>
 <20120706143350.GA10427@sli.dy.fi>
 <4FF6FF8C.4010007@jan-o-sch.net>
 <20120706195923.GA10687@sli.dy.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="+QahgC5+KEYLbs62"
In-Reply-To: <20120706195923.GA10687@sli.dy.fi>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--+QahgC5+KEYLbs62
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 06, 2012 at 10:59:24PM +0300, Sami Liedes wrote:
> I think I might try running it overnight with KMEMCHECK to see if it
> reports something. But for now, what there's in the log:

My KMEMCHECK kernel didn't even boot (due to some weird KMEMCHECK/ACPI
interaction), so I won't pursue this idea further at the moment...

> * lots of checksum mismatch [234], no 1s

One thing to notice from the logs, too, is that the device seems to
always be dm-6, the second device of the filesystem. This never seems
to happen to dm-5. There are 1583 lines of "btrfs: dm-6 checksum
verify failed".

	Sami

--+QahgC5+KEYLbs62
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCgAGBQJP91uJAAoJEKLT589SE0a0HvAQAMTlvqbRuxOOVbZGTMCyQvyp
x5L21SXm9pK5GoqUftAEdU3WdkfSd6VuA+Xb0qaMMGitByBY8+T9UqI9LyxwN58C
ixChQlpb8kk++wTjAYkeU+WoETFWWNf1jibrBDetl0xKNuZ1sO4df6FhN6Zyg3si
fg+G+HCVvswXTlJEddwlXt7mcjOf2sQxw1agI6oInToOuxa3EWGBzX449rtxMKVk
YE/bmSN7KSrPFMl6fMUva/qpuWy6jI0msOlWy+n9G0AfNNvw+V8kfNbpbJAp6j7n
hZQ8Rv0pKaroIiQw/lmBA3QoptjdSZKkBwCR6ktNTcugqci9jfmpNZGIqIvEjMPC
jmYNLZMXKjUPvDCR1UGx/aaRcSOCTjfYRbei2I8x5Br/+DW/cM7w6saiYNBxluyk
xi2V6s1tWXOEvPImwi6UkAsbTyBfOD8EKM6nrmYR4qjgwYFurD2tTSuKQMeLH98h
+Tf2B1Xt7Q+5pOJoARPacJL1SWAwJDx8VehH2F5fvmZNqyT0qNTcEWxqqhDa/EHI
9ikGy9+g8X8ZQNZvTQ144c8hLz7uQEown21ir/1p30RR+1HsvIkhaNHwbaLYGpiV
oKRsVVLSvlKPSzupD7cFP6EFNLj8DTmms1ewJJdIQJRNP9FgAAUFLJqdlUeFC06E
6w8508D34f7tudI5a+Wk
=9hDe
-----END PGP SIGNATURE-----

--+QahgC5+KEYLbs62--
