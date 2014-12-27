Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:56821 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795AbaL0Q0p (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 27 Dec 2014 11:26:45 -0500
Date: Sat, 27 Dec 2014 16:26:42 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Robert White <rwhite@pobox.com>
Cc: Martin Steigerwald <Martin@lichtvoll.de>, linux-btrfs@vger.kernel.org
Subject: Re: BTRFS free space handling still needs more work: Hangs again
Message-ID: <20141227162642.GK25267@carfax.org.uk>
References: <3738341.y7uRQFcLJH@merkaba>
 <4232026.31LFOYpm2s@merkaba>
 <20141227093043.GJ25267@carfax.org.uk>
 <2235526.D1sZ4Blnlh@merkaba>
 <549EC829.8080808@pobox.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="huBJOJF9BsF479P6"
In-Reply-To: <549EC829.8080808@pobox.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--huBJOJF9BsF479P6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Dec 27, 2014 at 06:54:33AM -0800, Robert White wrote:
> On 12/27/2014 05:55 AM, Martin Steigerwald wrote:
[snip]
> >while fio was just *laying* out the 4 GiB file. Yes, thats 100% system CPU
> >for 10 seconds while allocatiing a 4 GiB file on a filesystem like:
> >
> >martin@merkaba:~> LANG=C df -hT /home
> >Filesystem             Type   Size  Used Avail Use% Mounted on
> >/dev/mapper/msata-home btrfs  170G  156G   17G  91% /home
> >
> >where a 4 GiB file should easily fit, no? (And this output is with the 4
> >GiB file. So it was even 4 GiB more free before.)
> 
> No. /usr/bin/df is an _approximation_ in BTRFS because of the limits
> of the fsstat() function call. The fstat function call was defined
> in 1990 and "can't understand" the dynamic allocation model used in
> BTRFS as it assumes fixed geometry for filesystems. You do _not_
> have 17G actually available. You need to rely on btrfs fi df and
> btrfs fi show to figure out how much space you _really_ have.
> 
> According to this block you have a RAID1 of ~ 160GB expanse (two 160G disks)
> 
> > merkaba:~> date; btrfs fi sh /home ; btrfs fi df /home
> > Sa 27. Dez 13:26:39 CET 2014
> > Label: 'home'  uuid: [some UUID]
> >          Total devices 2 FS bytes used 152.83GiB
> >          devid    1 size 160.00GiB used 160.00GiB path
> /dev/mapper/msata-home
> >          devid    2 size 160.00GiB used 160.00GiB path
> /dev/mapper/sata-home
> 
> And according to this block you have about 4.49GiB of data space:
> 
> > Btrfs v3.17
> > Data, RAID1: total=154.97GiB, used=149.58GiB
> > System, RAID1: total=32.00MiB, used=48.00KiB
> > Metadata, RAID1: total=5.00GiB, used=3.26GiB
> > GlobalReserve, single: total=512.00MiB, used=0.00B
> 
> 154.97
>   5.00
>   0.032
> + 0.512
> 
> Pretty much as close to 160GiB as you are going to get (those
> numbers being rounded up in places for "human readability") BTRFS
> has allocate 100% of the raw storage into typed extents.
> 
> A large datafile can only fit in the 154.97-149.58 = 5.39

   I appreciate that this is something of a minor point in the grand
scheme of things, but I'm afraid I've lost the enthusiasm to engage
with the broader (somewhat rambling, possibly-at-cross-purposes)
conversation in this thread. However...

> Trying to allocate that 4GiB file into that 5.39GiB of space becomes
> an NP-complete (e.g. "very hard") problem if it is very fragmented.

   This is... badly mistaken, at best. The problem of where to write a
file into a set of free extents is definitely *not* an NP-hard
problem. It's a P problem, with an O(n log n) solution, where n is the
number of free extents in the free space cache. The simple approach:
fill the first hole with as many bytes as you can, then move on to the
next hole. More complex: order the free extents by size first. Both of
these are O(n log n) algorithms, given an efficient general-purpose
index of free space.

   The problem of placing file data isn't a bin-packing problem; it's
not like allocating RAM (where each allocation must be contiguous).
The items being placed may be split as much as you like, although
minimising the amount of splitting is a goal.

   I suspect that the performance problems that Martin is seeing may
indeed be related to free space fragmentation, in that finding and
creating all of those tiny extents for a huge file is causing
problems. I believe that btrfs isn't alone in this, but it may well be
showing the problem to a far greater degree than other FSes. I don't
have figures to compare, I'm afraid.

> I also don't know what kind of tool you are using, but it might be
> repeatedly trying and failing to fallocate the file as a single
> extent or something equally dumb.

   Userspace doesn't as far as I know, get to make that decision. I've
just read the fallocate(2) man page, and it says nothing at all about
the contiguity of the extent(s) storage allocated by the call.

   Hugo.

[snip]

-- 
Hugo Mills             | O tempura! O moresushi!
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: 65E74AC0          |

--huBJOJF9BsF479P6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUnt3CAAoJEFheFHXiqx3kcpMQALQykoJAiJNDr0Jeqxhnw4w4
Tp3R1M3ZIPhnJNbLhVX9w0Mim9IHB5kC05t4vzDsTM+/T7+AICv9EBs22yUfviyn
Yh0HdrJNoHmqUh+Ok6nWEG3v9DJT6pVfFmw0UGhou9JsmTNG8KvPA5tjNjeijLK0
HsFxAiH6wxH7Kna2UJmhOIiC/e/+hg65r4UZyGtC6lzUtzXargfHJYua/2tgx9H3
lbFUOLI5YnTzViDYKDgzxB6eQoAVpbwg3qHoncRHWIVwWAHS8a9TZIKQHLW7dn1H
2aebXC0VCmFLAtzOzw8jKzMMXvdtVlL/AZIjH3Shu6yRvBBmdFukEG4vMH9AY9MJ
YNOlryURN+0y/6mk5xmbecAruwBPjZg0GWCdpYHtJx4B8kUqCW9hT/t7Nlpc58CB
ikvn5CAFSiTeBSVQeHa3G1f3qckMNI+2958zhVaE8huVdGvuCNU6fZ6stQFT+IsD
2E7fViJJA2P3mDEtMT4N0ftFavX3k9vfCZKzU4EzJ58ienygFLLPBu/nWs9kpm7M
IUj8PJxZ2rsPUgtjgSTJL/0h6qJziO+24i/xbeWNWmlBjKS17363k3R1ySO4lMR3
KW4AIonEqcmdEN6iYrhvDm+qx3duG+0M7rdyK/GUHMW+USZcnmHwG93jxX3CjdMs
klSHiJx9c+B4e9ilFn/E
=vKPs
-----END PGP SIGNATURE-----

--huBJOJF9BsF479P6--
