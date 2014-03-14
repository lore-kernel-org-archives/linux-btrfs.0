Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:50345 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756416AbaCNWoK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Mar 2014 18:44:10 -0400
Date: Fri, 14 Mar 2014 22:44:04 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: remove transaction from send
Message-ID: <20140314224404.GJ6151@carfax.org.uk>
References: <1394739733-500-1-git-send-email-jbacik@fb.com>
 <20140313221628.GF6151@carfax.org.uk>
 <53234FAA.5060204@fb.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6J7GEvtanOfV9oXA"
In-Reply-To: <53234FAA.5060204@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--6J7GEvtanOfV9oXA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Mar 14, 2014 at 02:51:22PM -0400, Josef Bacik wrote:
> On 03/13/2014 06:16 PM, Hugo Mills wrote:
> >On Thu, Mar 13, 2014 at 03:42:13PM -0400, Josef Bacik wrote:
> >>Lets try this again.  We can deadlock the box if we send on a box and try to
> >>write onto the same fs with the app that is trying to listen to the send pipe.
> >>This is because the writer could get stuck waiting for a transaction commit
> >>which is being blocked by the send.  So fix this by making sure looking at the
> >>commit roots is always going to be consistent.  We do this by keeping track of
> >>which roots need to have their commit roots swapped during commit, and then
> >>taking the commit_root_sem and swapping them all at once.  Then make sure we
> >>take a read lock on the commit_root_sem in cases where we search the commit root
> >>to make sure we're always looking at a consistent view of the commit roots.
> >>Previously we had problems with this because we would swap a fs tree commit root
> >>and then swap the extent tree commit root independently which would cause the
> >>backref walking code to screw up sometimes.  With this patch we no longer
> >>deadlock and pass all the weird send/receive corner cases.  Thanks,
> >
> >    There's something still going on here. I managed to get about twice
> >as far through my test as I had before, but I again got an "unexpected
> >EOF in stream", with btrfs send returning 1. As before, I have this in
> >syslog:
> >
> >Mar 13 22:09:12 s_src@amelia kernel: BTRFS error (device sda2): did not find backref in send_root. inode=1786631, offset=825257984, disk_byte=36504023040 found extent=36504023040\x0a
> >
> 
> I just noticed that the offset you have there is freaking gigantic,
> like 700mb, which is way larger than what an extent should be.  Here
> is a newer debug patch, just chuck the old on and put this instead
> and re-run
> 
> http://paste.fedoraproject.org/85486/39482301

   That last run, with the above patch, failed again, at approximately
the same place again. The only output in dmesg is:

[ 6488.168469] BTRFS error (device sda2): did not find backref in send_root. inode=1786631, offset=825257984, disk_byte=36504023040 found extent=36504023040, len=1294336

as before. Definitely no kernel WARN, no backtraces.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
            --- You're never alone with a rubber duck... ---             

--6J7GEvtanOfV9oXA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBUyOGNFheFHXiqx3kAQJsSQ//RhaRQWUAqiIIms2JlKZFF5wC0wRb52pj
K1JzTHATw7VoxRln1Hghu+fAjQiETTccBWEkyR5w1uThynVXxZvBQBfCiZY4frlt
RFOex/A720qObCDIZybgkyYxECcfJzMHeWunMk0VGZGYjO7tTTDi8D4xY1m8s7Bd
NSaFQ90FSE5HhTyxFnGI+Bz4IbAhOMGfCWiy6HqPlx7/I2GeBiYzcLdMNUC3Rwjy
SWhNxiaYeujBemtjk1rj64ImYcbE32ebK6j5oCfaxmoHT/VbU1Ikmr1q3qKCfb/H
LfAQ3B9M+lW++UWcxjzJdfjkJOWRbyehz2ScK6+24kHuHxL75sOxf+ei3TsWdDQ6
LMRDBcfPEMG9hVqq7JJ5736ArO4cVJ8fzJEFt2+9pYy4T+yfilMtewoZUa7Jv28/
XUDDyjf0WPYw0QOIYxkAz0hs1+HdYj0kuf4fIeiYAJZoG7o1uhx2AmFSaPXgb7Sm
DE5OipfHIPn5y30dePyl62Pij7Ics2nTAme87mmatBHtCi6B2/86kN8RD6dNtqfk
MCC2PXgv9lxLM38yu6ZdI3B8RwLkwCWc5DiwN/KrS8ZQBMx7DK7LIrmjHXdT+GRJ
Uo8+8673Ef2M0cV3PgOUtAFE3kVGG+/5aCfA0c1TmsJUachheTJyjBW50z2lR+HG
ochvE/3JaNg=
=uXwZ
-----END PGP SIGNATURE-----

--6J7GEvtanOfV9oXA--
