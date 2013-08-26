Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:55538 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590Ab3HZTbW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 26 Aug 2013 15:31:22 -0400
Date: Mon, 26 Aug 2013 20:31:10 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Chris Murphy <lists@colorremedies.com>
Cc: Nick Lee <email@nickle.es>, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Question: How can I recover this partition? (unable to find
 logical $hugenum len 4096)
Message-ID: <20130826193110.GO3115@carfax.org.uk>
References: <CAKcLGm_QXTjN3e-HtogM+XXygymG+1kjhuOAMNfj=ngSHx5T5Q@mail.gmail.com>
 <5EB2ECAC-9A8C-4403-8630-944B646DE3B8@nickle.es>
 <DD09B4EA-9F87-4D18-8B7A-EEF2FFD6A7FE@nickle.es>
 <EC688346-BA9C-4077-A301-12FFE5463121@colorremedies.com>
 <A19C7607-0BF4-4C40-B9A3-F94144034B72@colorremedies.com>
 <6A12FF1B-5E1A-4F6F-92DA-41E52152E6F2@nickle.es>
 <EA37CDC0-8D44-45ED-8266-0E1CDECBE3EE@nickle.es>
 <CA17D410-C4E1-4F82-A0FF-CFA6D725E5D2@colorremedies.com>
 <CAGURm2FS=YTuBpbrg7BV=Un8ZCp9xYZae-WuqhjV29xXA7e0jw@mail.gmail.com>
 <E76A410A-0CEF-47D7-A501-E2DDF0230735@colorremedies.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OAiy6VLsECigG9dy"
In-Reply-To: <E76A410A-0CEF-47D7-A501-E2DDF0230735@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--OAiy6VLsECigG9dy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 26, 2013 at 01:10:54PM -0600, Chris Murphy wrote:
> 
> On Aug 26, 2013, at 11:41 AM, Nick Lee <email@nickle.es> wrote:
> 
> > There was a discussion on IRC a few days ago that the problem with the tree root's bloco was likely the result of either an issue with the disk itself, or the chunk tree/logical mappings. I ran the chunk recover, looked over the errors it found, and hit write. (If it failed, I was going to run something photorec, loss of organization as a side effect.)
> > 
> > I can write something more clear after my flight lands tomorrow if you want.

> I'm just curious about when to use various techniques: -o recovery,
> btrfsck, chunk-recover, zero log.

   Let's assume that you don't have a physical device failure (which
is a different set of tools -- mount -odegraded, btrfs dev del
missing).

   First thing to do is to take a btrfs-image -c9 -t4 of the
filesystem, and keep a copy of the output to show josef. :)

   Then start with -orecovery and -oro,recovery for pretty much
anything.

   If those fail, then look in dmesg for errors relating to the log
tree -- if that's corrupt and can't be read (or causes a crash), use
btrfs-zero-log.

   If there's problems with the chunk tree -- the only one I've seen
recently was reporting something like "can't map address" -- then
chunk-recover may be of use.

   After that, btrfsck is probably the next thing to try. If options
-s1, -s2, -s3 have any success, then btrfs-select-super will help by
replacing the superblock with one that works. If that's not going to
be useful, fall back to btrfsck --repair.

   Finally, btrfsck --repair --init-extent-tree may be necessary if
there's a damaged extent tree. Finally, if you've got corruption in
the checksums, there's --init-csum-tree.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
      --- Try everything once,  except incest and folk-dancing. ---      

--OAiy6VLsECigG9dy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUhus/lheFHXiqx3kAQKZHw/+IoQ819N0eUXhZURlTgcBLolqWWP+qfl5
BCrR2oOOGTTqTOTNutSzIDV3bpE6j8vZxjlxI+rLLOT5cfegj0jqOzD/Dj9m99kp
+rgMaEg0jgw8UsNn2qKw3nW9Bz5UMA1/BMUDObWDa/4+QpcLXBFab2T0RCqPbyLz
rVL2Run0uZIWnO4csHFV7Oh+IOnbj2BxWOPnjocrSketlzvuYrGdO0UdRhyA5VW0
sPQjbSvULgOYZa93KXrrHSX6dhIA2ODS4rrdTmJbEMB5zXiwJyfkI34Reg1wRhE+
p3xMUw3GJd3+jnY69qlWhmZL9SNDzkNO/qFVw1l2yixXuuZoZgWs8kl96ugWec2w
wycFjofHdF+fEzvkXfvmyDkocy+MQzW6u+8h9+gPT1MqGJnY4TRWuQUcSWuW2efM
1ksbvAakuAJNCt5v+PnHF8YjSRW0/Kdetf5UkfNKvmVnOCaSaUENBKuLLY+blt4f
ODZPHpMYzGwweZ+NtOhiUEhhknmUmHmxjYLk5gDMhEvZtIHKS1dRB2mlVdLwoBE2
khyNdvYm0oWSIJKrbAW/CdRgz0bqDNrutR+TLuau1EQ+vARIUMQlnoP4hF16zdha
HWsrk61It3VQhfLRVk5qyf98z5+Dd2sQrieKTiyiL/Ov0LMOUBjB+rcZ7GIMrg0y
8Z85tNuquxY=
=B/8w
-----END PGP SIGNATURE-----

--OAiy6VLsECigG9dy--
