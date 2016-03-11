Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:48361 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932084AbcCKWRH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Mar 2016 17:17:07 -0500
Received: from hrm by frost.carfax.org.uk with local (Exim 4.80)
	(envelope-from <hrm@carfax.org.uk>)
	id 1aeVMl-0006ZW-TD
	for linux-btrfs@vger.kernel.org; Fri, 11 Mar 2016 22:17:03 +0000
Date: Fri, 11 Mar 2016 22:17:03 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Btrfs mailing list <linux-btrfs@vger.kernel.org>
Subject: The *right* algorithm for determining the amount of free space
Message-ID: <20160311221703.GJ17196@carfax.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nhAUiXSLan16V5i8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--nhAUiXSLan16V5i8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

   I know I promised this a while ago and didn't get round to it, but
Henk's tinkering reminded me of it. I note specifically that the
algorithm used to give the free space to plain old df gives incorrect
results -- probably because it's not using the algorithm below.

   There is an algorithm that (seems to) give the correct number of
block groups which can be allocated, given a current allocation state
of the FS. I haven't been able to prove it correct, but it seems to
work. Here's some pseudocode for it:

(Note that all arrays here are 1-based, not 0-based. I originally
wrote this using maths notation, not C. I've got a slightly more
formal write-up of it in LaTeX if anyone wants, but it's full of
unproven crap as well as the description of the algorithm, so I'd
rather edit that before releasing it).

Variables:
   n: Number of devices
   c[n]: Amount of unallocated space on each device
   s: Number of chunks per block group:
        s = 1 for single
        s = 2 for RAID-1
        s = floor(n/2) for RAID-10
        s = n for RAID-0, -5, -6

FUNCTION USABLE(s)
   if RAID0
      return s
   elif RAID1 or SINGLE
      return 1
   elif RAID10
      return s/2
   elif RAID5
      return s-1
   elif RAID6
      return s-2

FUNCTION CHUNKS(n)
   if RAID0 or RAID5 or RAID6
      return n
   elif RAID1
      return 2
   elif RAID10
      return floor(n/2)
   elif SINGLE
      return 1

FUNCTION LOCAL_BOUND(n, c, s, q)
   x := sum( i=q+1..n: c[i] )
   return floor( x / (s-q) )

FUNCTION ALL_BOUNDS(n, c, s)
   r: integer list

   for q=1..n
      if c[q] >= LOCAL_BOUND(n, c, s, q) then
         r.append(c[q])
      endif
   endfor

   return r

FUNCTION BOUND(n, c, s)
   total := ( sum i=1..n (c[i]) )
   return min(floor( total / s ), ALL_BOUNDS(n, c[n], s))

FUNCTION ALLOCATE(n, c, s)
   # Reduce the free space by the maximum amount possible with s-sized
   # allocations.
   r[n]: integer

   b := BOUND(n, c, s) * s
   for i=n..1
      a := min(c[i], floor( b/i ))
      b := b - a
      r[i] := c[i] - a

   return r

FUNCTION SPACE(n, c)
   s := CHUNKS(n)
   total := 0
   while BOUND(n, c, s) > 0
      # Increase the amount of usable space in this pass
      total := total + BOUND(n, c, s)*USABLE(s)
      c := ALLOCATE(n, c, s)

      # Find the new number of usable devices
      n := 0
      while c[n+1] != 0
         n := n + 1
      s := CHUNKS(n)

   return total

   The algorithm works by setting up the list of free space, c, one
entry for each device in the FS, and sorting it in decreasing
order. The values should be measured in chunks -- so divide the free
space on each device by 1 GiB. Devices with no free space should be
dropped from the list.

   The parameter s is dependent on the RAID level. See the list above
for what it should be set to.

   The BOUND function determines the number of block group allocations
possible for a given configuration, c, and stripe size, s. Multiply
the number of allocations by s to get the number of chunks that can be
allocated.

   The ALLOCATE function returns the list of free space on each device
after the maximum number of block groups has been allocated. This
should be called repeatedly, updating the value of s each time, until
no more allocations are possible.

   I hope that's of use to someone with more spare coding time than
me. And maybe we can finally have free space estimation that gets it
right...

   Hugo.

-- 
Hugo Mills             | A gentleman doesn't do damage unless he's paid for
hugo@... carfax.org.uk | it.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                                            Juri Papay

--nhAUiXSLan16V5i8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJW40PfAAoJEFheFHXiqx3kFa0QAKnZIdVQo+uZScQ1Yq/nXOj7
03Z5s8wOdzkoffx9NtEEzubgI/CvUNAy4OxmWd7rjJKfnBLYtplmLIzOTGujuTMe
vSWurJD9gb5VMt3y7EUgwIe7U5lIUqlIRasGjtJUH/biQY4YWowXSE0g5YdkYWlj
i9Dydj6w0qoIgI19NSd+EVN5qVMkszyKtImm5QGvRSeVh+y1OK2J9thHSGzaLxv4
ny3zf/bVsNybEwO3ojkmqvvAoMtS/bGvf0HOKnmQOEt7MzT8gMUPBHIHASwG3QhK
ChACFcMWouJ5QYg0LdxwFwj0Wszbi3S/wazPpXb/8YIohAVfqtNhf8/0TT4FMe1C
FA1ZlhU45H2H7ge2FEHbB242zqtSb7P2GST8JJA2KJJveWUFWGvjHuZCiFyht9Bb
TSWy3JMM3YgTvnKFyasJc+BPDLehFVnON9Zk+grm15Vz33fSgLWzZDdf/4+UJeP1
xmP+GfRS+2M1MlUkz/RMwlVTRv/CN+IfQ9CsoXzxOPcA10F8URs133s7vqBAI0tE
ApqmlZ2xUfUkuYh7z48HWhDo6b0CVxhslrdhmdZ2nVb/L/0SKt4hMLFba1j5mGx6
sZXN8fdi0APgGga8WA4jqRiAw+plLGk9JEmboAeCLSOesmH9xaz5umiwbUnyH9Ja
+OIhOU1ZJAqdO1Qilf2c
=ArTM
-----END PGP SIGNATURE-----

--nhAUiXSLan16V5i8--
