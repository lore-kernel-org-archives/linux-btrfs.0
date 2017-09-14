Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:40559 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751316AbdINPcX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 14 Sep 2017 11:32:23 -0400
Received: from hrm by frost.carfax.org.uk with local (Exim 4.80)
        (envelope-from <hrm@carfax.org.uk>)
        id 1dsW7q-0005Z9-Sy
        for linux-btrfs@vger.kernel.org; Thu, 14 Sep 2017 15:32:22 +0000
Date: Thu, 14 Sep 2017 15:32:22 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: linux-btrfs@vger.kernel.org
Subject: Re: snapshots of encrypted directories?
Message-ID: <20170914153222.GC7067@carfax.org.uk>
References: <20170914145739.GA32347@rus.uni-stuttgart.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="ctP54qlpMx3WjD+/"
In-Reply-To: <20170914145739.GA32347@rus.uni-stuttgart.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--ctP54qlpMx3WjD+/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Sep 14, 2017 at 04:57:39PM +0200, Ulli Horlacher wrote:
> I use encfs on top of btrfs.
> I can create btrfs snapshots, but I have no suggestive access to the files
> in these snaspshots, because they look like:
> 
> drwx------  framstag users        - 2017-09-08 11:47:18 uHjprldmxo3-nSfLmcH54HMW
> drwxr-xr-x  framstag users        - 2017-09-08 11:47:18 wNEWaDCgyXTj0d-Myk8wXZfh
> -rw-r--r--  framstag users      377 2015-06-12 14:02:53 -zDmc7xfobKDkbl8z7oKOHxv
> -rw-r--r--  framstag users    2,367 2012-07-10 14:32:30 7pfKs27K9k5zANE4WOQEuFa2
> -rw-------  framstag users      692 2009-10-20 13:45:41 8SQElYCph85kDdcFasUHybVr
> -rw-------  framstag users    2,872 2017-08-31 16:21:52 bm,yNi1e4fsAClDv7lNxxSfJ
> lrwxrwxrwx  framstag users        - 2017-06-01 15:53:00 GZxNYI0Gy96R18fz40f7k5rl -> wvuQKHYzdFbar18fW6jjOerXk2IsS4OAA2fnHalBZjMQ,7Kw0j-zE3IJqxhmmGBN8G9
> -rw-r--r--  framstag users      182 2016-12-01 13:34:31 rqtNBbiYDym0hPMbBL-VLJZcFZu6nkNxlsjTX-sU88I4I1
> 
> I have to mount the snapshot with encfs, to have access to the (decrypted)
> files. 
> 
> Any better ideas?

   I'd say it's doing exactly what it should be doing. You're making a
copy of an encrypted data store, and the result is encrypted. In order
to read it, it needs to have the decrpytion layer applied to it with
the correct key (which is the need to mount the snapshot with encfs).

   Would you _really_ want a system where the encrypted contents of a
subvolume can be decrypted by simply snapshotting it?

   Hugo.

-- 
Hugo Mills             | Great films about cricket: Umpire of the Rising Sun
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--ctP54qlpMx3WjD+/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJZuqEGAAoJEFheFHXiqx3k91UP/11qVbq/r1jpX7pbmIhMcwsj
QrkG80N2ESTBMsJsp9+8TLN+yh5Y/AxWoheOTiyVzwCuzkaRuR2CBsS+xyY0KQWF
WOn+aUYxPfRgvuyqNaYKGOmejB4q5sk5heBB4ZAj2IZ+NiHKKNifDjfSQVjNlGxb
2khMIzoodPrsnm2jjZl4GSbzNCpgeENiP1iXOXeLnwatUlJVis6c5WnlD7M9jRvZ
8sixdGuroxH6fXjQlSGtYtrpsDmiM6tFUGXC8zuMwR/tegj+4ttzsZqgbe+pikSV
09hbz5lAgLPJdmNhBqsxwlcRf1jNxytYFF5U7pimy45qsrBF6PpDPAOEK91tntum
zDCszrk+xI+pmUMmYXnxon+AlTsGGYCa0C+kWwk/bx/hC6jYpWtijUvSxrAwPZKI
sFqyA7WVepsN7dn3WqhmwUKMMtQ4hIh1zlLAZf+9c4eMiCyeiLFZg332YHmkWKSi
n7PE+e0NrJQDwlSslU1ac2MA1dY1WA8lJqqrPTN485AeOsLYew7RkEidjhK3X2Ai
3nr1dqb5Q0OrAtWYemLsyT8+pQg3UJT+5h0TFkLyMC7VncuyNH8mcWaCB8WaoKPm
+soNCQ3YC5BNHKsDUts6EDH8xxrlEpJsRIuBpq9BjsRdwQow4uCsnjUpViH7C5Nq
R4Em7iK1FkFSRWXOqlC5
=0sVh
-----END PGP SIGNATURE-----

--ctP54qlpMx3WjD+/--
