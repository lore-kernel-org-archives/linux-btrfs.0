Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:51564 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608AbbAWJsA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 23 Jan 2015 04:48:00 -0500
Date: Fri, 23 Jan 2015 09:47:56 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Brett King <brett.king@commandict.com.au>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Recovery Operation With Multiple Devices
Message-ID: <20150123094756.GB1654@carfax.org.uk>
References: <zarafa.54c1fe06.4689.28909bac67ef9272@mascot.commandict.com.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VrqPEDrXMn8OVzN4"
In-Reply-To: <zarafa.54c1fe06.4689.28909bac67ef9272@mascot.commandict.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--VrqPEDrXMn8OVzN4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 23, 2015 at 06:53:42PM +1100, Brett King wrote:
> Hi All,
> Just wondering how 'btrfs recovery' operates, when the source device given is one of many in an MD array - I can't find anything documentation beyond a single device use case.
> 
> Does it automatically include all devices in the relevant MD array as occurs when mounting, or does it only restore the data which happened to be written to the specific, single device given ?

   Neither. :)

   It automatically includes all devices as occurs when running
btrfsck. OK, it's a relatively pointless distinction, but the
mechanisms are slightly different.

> From an inverse perspective, how can I restore all data including snapshots, which are spread across a damaged MD FS to a new (MD) FS ?

   btrfs restore -l will show you the list of tree roots, which (for
trees numbered 256 and up) correspond to subvolumes and snapshots. You
can then use -r to select the tree to restore.

> Can send / receive do this perhaps ?

   Yes, but only if you can mount the FS.

   Hugo.

-- 
Hugo Mills             | I know of three kinds: hot, cool, and
hugo@... carfax.org.uk | what-time-does-the-tune-start?
http://carfax.org.uk/  |
PGP: 65E74AC0          |                                          Chris Dollin

--VrqPEDrXMn8OVzN4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUwhjMAAoJEFheFHXiqx3kpUMQAJb965nbvhNjNb+GQXLng3fv
YLI9cXjXU6+4aaOOeYUiYCSf/Y+K3EycRcRC0xHxGYuTmfFLPmyFzeT8WXD8dsU6
02Poms5jic8t2ickrFMdN9rPRj/1JfGq6MMzfihJMbQrbK0WvwBk9a3geSX+Awc3
yC32kIaNrQikxfmyMfW8eSJMAXZnD07kavPuoZNAZrmL8ZM+DHbyIMQnMUTwNh6l
OwNcKBKPTgNUDPSowxfTfvsuDb9nOenGYEF9NR8/YoDBMv2TjVgzsZjRtDt80X+D
Hi3H+bnyRlYqGjpZEJPRBlZrT1dDonDuCIH4JzJRCt7dlNNEm3ebZ6YlXBBrW46A
SP1IHfKSzYAdQIQA5pVKROjpwX+aqu1qo4Wc05PJUPpUz3VuiqehdJOpJQ8i0LyA
2Gj+8ZsYUBY2SF5zpnEf/wASO9eJYDzXZIWlubqxO2lhYAaSMuFU/6XIAodD6ioj
+hLJ89r1IPmQBkphYAqdmOM036xDZrJ37YIXu31m7+MfxMP+rDumV6bnvdZ7tFit
lLQ4RZWD1DnCK8RuGqwUDHpzKdt/irX27waRUhb32VVJsEEW93aM2bJwpPqs6WXl
h6A2Pi1PxthzH1uJgzAqZkKKKVeClN32hZKD7qz7buECqLB2ahGYt3rN2tZVX2CP
DoJaBVhze+9CbjodEq0X
=R8Rh
-----END PGP SIGNATURE-----

--VrqPEDrXMn8OVzN4--
