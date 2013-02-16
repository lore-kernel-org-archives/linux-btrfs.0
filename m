Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:55885 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754701Ab3BPXNb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 16 Feb 2013 18:13:31 -0500
Date: Sat, 16 Feb 2013 23:13:28 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Adam Ryczkowski <adam.ryczkowski@statystyka.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: How to clone btrfs partition?
Message-ID: <20130216231328.GL28997@carfax.org.uk>
References: <510E6714.7040206@statystyka.net>
 <510F0AE4.4070608@cn.fujitsu.com>
 <51200320.4010205@statystyka.net>
 <20130216221709.GK28997@carfax.org.uk>
 <512012D6.7010403@statystyka.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="O8/n5iBOhiUtMkxf"
In-Reply-To: <512012D6.7010403@statystyka.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--O8/n5iBOhiUtMkxf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Feb 17, 2013 at 12:14:30AM +0100, Adam Ryczkowski wrote:
> Welcome,
> 
> I need to clone btrfs partition. Not a single snapshot, but the
> whole lot of snapshots.
> 
> I thought that send & receive can help me. Can it? When I try to use
> 
>   btrfs send /mnt/btrfs-root >/dev/null
>
> I get "ERROR: /mnt/adama-docs is not read-only.", and I was
> explained that I need to use snaphot (created with the "-r" switch).
>
> So does it mean that I need to make a recursive search for each
> read&write subvolume on the file system in order to make a read-only
> snapshot, so I can clone the whole partition? Or is there a more
> simple approach?

   Right now, yes, that's what you'll have to do. Note that the set of
snapshots won't be atomic, although each snapshot itself is atomic.
Recursive snapshots aren't implemented yet, but are on the list of
things to do.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
                   --- I know of three kinds: hot, ---                   
                cool,  and what-time-does-the-tune-start?                

--O8/n5iBOhiUtMkxf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUSASmL9z9OVl50rAAQKG8Q/5AXbQo7Xu5wM6q+URXjbyLr4XOTloyMU7
oU4YzuLPDiw40IOio9acXzvOGPEPluqzz7f3pDIWcyll+3vaL0GhlAnLrhkJgfrL
bocGxSdJ2xzaCXToNxAbPDERkbUR6XbgHpy0CmwzDnNnhX+b4ivnlJXyqqlcEdQR
jPwLKHr7DjmMYVvq1aeki3UBQj9LAcP2Uiwzt0L9JsrV0xBS6makHCTV8srozfEM
/EhOXbNLKOREZ+O43jywFN6zraPqafX/g0yyPpBkEkVWiPzXle283/97ZD8jkuEh
sShiChFfqVsSeWTj323X8WNFjhUE0RNsbacFJcnrovbJ8FLvQn6nsEGqq+zawhOI
3UBgzO7/75vlyx2pPgOU2NtmmY1QrLmGNRzE7MPywjjhDuBGg6OKqlUBbumAqK2q
RDCRHMgQQhM5owqNyK0GC5T5fnKMVSip3LXI3jHHIcc7tjAlRLAKHIKei1DUCyFD
wwyLUjbKskBvs/QUjin7F9L14fnTaVxim/B3fwO0i2Qyetf8GeqGgnax0XF+QQ1g
l7N78q+cwI8wOl7A8qzp5jMDWmymWeumG/0qO+5MIqmur5aE7M9eysOY2mEQcY3Q
xqR9V9zc/S7rDLb3k4G3Yt9SndldEl+g65H4VLZ4Oyt4OowqY8e9MjPuapq8+IHe
TRscM9YwixI=
=NxYB
-----END PGP SIGNATURE-----

--O8/n5iBOhiUtMkxf--
