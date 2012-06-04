Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:36571 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013Ab2FDRE2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Jun 2012 13:04:28 -0400
Date: Mon, 4 Jun 2012 18:04:22 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Maxim Mikheev <mikhmv@gmail.com>
Cc: Liu Bo <liubo2009@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: Help with data recovering
Message-ID: <20120604170422.GD15986@carfax.org.uk>
References: <4FCC6F44.2030503@gmx.net>
 <4FCC9C63.7000605@gmail.com>
 <4FCC9CD5.2050309@gmx.net>
 <4FCC9F6C.5090305@gmail.com>
 <20120604114901.GA15986@carfax.org.uk>
 <4FCCA39C.8060409@gmail.com>
 <20120604121134.GB15986@carfax.org.uk>
 <4FCCA9E6.3030209@gmail.com>
 <20120604123431.GC15986@carfax.org.uk>
 <4FCCE125.7000004@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RYJh/3oyKhIjGcML"
In-Reply-To: <4FCCE125.7000004@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--RYJh/3oyKhIjGcML
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 04, 2012 at 12:24:05PM -0400, Maxim Mikheev wrote:
> I run through all potential tree roots. It gave me everytime
> messages like these:
> 
> parent transid verify failed on 3405159735296 wanted 9096 found 5263
> parent transid verify failed on 3405159735296 wanted 9096 found 5263
> parent transid verify failed on 3405159735296 wanted 9096 found 5263
> parent transid verify failed on 3405159735296 wanted 9096 found 5263
> Ignoring transid failure
> parent transid verify failed on 3356745109504 wanted 5263 found 9008
> parent transid verify failed on 3356745109504 wanted 5263 found 9008
> parent transid verify failed on 3356745109504 wanted 5263 found 9008
> parent transid verify failed on 3356745109504 wanted 5263 found 9008
> Ignoring transid failure
> parent transid verify failed on 3356744548352 wanted 5262 found 9008
> parent transid verify failed on 3356744548352 wanted 5262 found 9008
> parent transid verify failed on 3356744548352 wanted 5262 found 9008
> parent transid verify failed on 3356744548352 wanted 5262 found 9008
> Ignoring transid failure
> parent transid verify failed on 3356745035776 wanted 5263 found 9008
> parent transid verify failed on 3356745035776 wanted 5263 found 9008
> parent transid verify failed on 3356745035776 wanted 5263 found 9008
> parent transid verify failed on 3356745035776 wanted 5263 found 9008
> Ignoring transid failure
> parent transid verify failed on 3356745015296 wanted 5263 found 9008
> parent transid verify failed on 3356745015296 wanted 5263 found 9008
> parent transid verify failed on 3356745015296 wanted 5263 found 9008
> parent transid verify failed on 3356745015296 wanted 5263 found 9008
> Ignoring transid failure
> Root objectid is 5
> 
> The largest recovered data is 12Kb.
> max@s0:~/btrfs-recovering./recovered$ ls -lahs 3728819929088
> total 28K
> 4.0K drwxr-xr-x   3 root root 4.0K Jun  4 12:06 .
>  20K drwxrwxr-x 347 max  max   20K Jun  4 12:18 ..
> 4.0K drwxr-xr-x   3 root root 4.0K Jun  4 12:06 Irina
> max@s0:~/btrfs-recovering./recovered$ ls -lahs 3728819929088/Irina/
> total 12K
> 4.0K drwxr-xr-x 3 root root 4.0K Jun  4 12:06 .
> 4.0K drwxr-xr-x 3 root root 4.0K Jun  4 12:06 ..
> 4.0K drwxr-xr-x 2 root root 4.0K Jun  4 12:06 .idmapdir2
> max@s0:~/btrfs-recovering./recovered$ ls -lahs
> 3728819929088/Irina/.idmapdir2/
> total 8.0K
> 4.0K drwxr-xr-x 2 root root 4.0K Jun  4 12:06 .
> 4.0K drwxr-xr-x 3 root root 4.0K Jun  4 12:06 ..
>    0 -rw-r--r-- 1 root root    0 Jun  4 12:06 4.bucket.lock
>    0 -rw-r--r-- 1 root root    0 Jun  4 12:06 7.bucket
> max@s0:~/btrfs-recovering./recovered$
> 
> What can I do next?

   I'm out of ideas.

   At this point, though, you're probably looking at somebody writing
custom code to scan the FS and attempt to find and retrieve anything
that's recoverable.

   You might try writing a tool to scan all the disks for useful
fragments of old trees, and see if you can find some of the tree roots
independently of the tree of tree roots (which clearly isn't
particularly functional right now). You might try simply scanning the
disks looking for your lost data, and try to reconstruct as much of it
as you can from that. You could try to find a company specialising in
data recovery and pay them to try to get your data back. Or you might
just have to accept that the data's gone and work on reconstructing
it.

   Hugo.

> On 06/04/2012 08:34 AM, Hugo Mills wrote:
> >[trimmed Arne&  Jan from cc by request]
> >
> >On Mon, Jun 04, 2012 at 08:28:22AM -0400, Maxim Mikheev wrote:
> >>adding -v, as an example:
> >>sudo btrfs-find-root -v -v -v -v -v /dev/sdb
> >>
> >>didn't change output at all.
> >    OK, then all I can suggest is what I said below -- work through the
> >potential tree roots in order from largest generation id to smallest.
> >Given that it's not reporting any trees, though, I'm not certain that
> >you'll get any success with it.
> >
> >    Did you have your data in a subvolume?
> >
> >    Hugo.
> >
> >>On 06/04/2012 08:11 AM, Hugo Mills wrote:
> >>>On Mon, Jun 04, 2012 at 08:01:32AM -0400, Maxim Mikheev wrote:
> >>>>Thank you for helping.
> >>>    I'm not sure I can be of much help, but there were a few things
> >>>missing from the earlier conversation that I wanted to check the
> >>>details of.
> >>>
> >>>>~$ uname -a
> >>>>Linux s0 3.4.0-030400-generic #201205210521 SMP Mon May 21 09:22:02
> >>>>UTC 2012 x86_64 x86_64 x86_64 GNU/Linux
> >>>>
> >>>>I compiled progs from recent git (week or two ago). I can compile it
> >>>>again if there updates.
> >>>    No, that should be recent enough. I don't think there have been any
> >>>major updates since then.
> >>>
> >>>>The output of btrfs-find-root is pretty long and below:
> >>>>max@s0:~$ sudo btrfs-find-root /dev/sdb
> >>>>Super think's the tree root is at 5532762525696, chunk root 20979712
> >>>>Well block 619435147264 seems great, but generation doesn't match,
> >>>>have=8746, want=9096
> >>>    This is not long enough, unfortunately. At least some of these
> >>>should have a list of trees before them. At the moment, it's not
> >>>reporting any trees at all. (At least, it should be doing this unless
> >>>Chris took that line of code out). Do you get anything extra from
> >>>adding a few -v options to the command?
> >>>
> >>>    I would suggest, in the absence of any better ideas, sorting this
> >>>list by the "have=" value, and systematically working down from the
> >>>largest to the smallest, running btrfs-restore -t $n for each one
> >>>(where $n is corresponding block number).
> >>>
> >>>    Hugo.
> >[snip]
> >

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
               --- Quantum est ille canis in fenestra? ---               

--RYJh/3oyKhIjGcML
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFPzOqVIKyzvlFcI40RAtqWAJ4pytpkqGkjz26cdM/E4rxtQzXaFwCfQtms
A4Upp3kx91wnEaXxTRUOD/U=
=e4U2
-----END PGP SIGNATURE-----

--RYJh/3oyKhIjGcML--
