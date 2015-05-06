Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:47748 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbbEFRsH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 May 2015 13:48:07 -0400
Date: Wed, 6 May 2015 17:48:04 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs-progs 4.0 breaks btrfs fi show?
Message-ID: <20150506174804.GK18480@carfax.org.uk>
References: <CAJCQCtR7ZT6vt06fbw3sh9sQxufsck=v2J+HJKz2DLFxR9q8RQ@mail.gmail.com>
 <5549CCD8.2010000@cn.fujitsu.com>
 <CAJCQCtT0ff8fVrMQ7rrgW1VFkiBL+f_upGOUZ7DY65N62jAsBQ@mail.gmail.com>
 <5549DF66.5090900@cn.fujitsu.com>
 <CAJCQCtSYbumV4-SPXRCxTzb0gXw6NaLYrNUCC79bz7eUNOiSPw@mail.gmail.com>
 <CAJCQCtRjWYgGJkKp0jOsb31cqjyh00K2tV-wbJqnSAYC3ekcMg@mail.gmail.com>
 <554A5012.1090801@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9a9Vq1BJdYBEXpLG"
In-Reply-To: <554A5012.1090801@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--9a9Vq1BJdYBEXpLG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 06, 2015 at 01:32:02PM -0400, Austin S Hemmelgarn wrote:
> On 2015-05-06 13:05, Chris Murphy wrote:
> >Ok so now that my mea culpa is out of the way, I'm actually wondering
> >why non-root users can't do certain btrfs tasks when they're read-only
> >commands.
> >
> >[chris@f22m ~]$ btrfs fi show
> >ERROR: could not open /dev/sda7   ##this is new it wasn't doing this last night
> >btrfs-progs v4.0
> >[chris@f22m ~]$ btrfs fi df /
> >Data, single: total=4.00GiB, used=3.57GiB
> >System, single: total=4.00MiB, used=16.00KiB
> >Metadata, single: total=1.01GiB, used=198.30MiB
> >GlobalReserve, single: total=80.00MiB, used=0.00B
> >[chris@f22m ~]$ btrfs fi usage /
> >WARNING: can't read detailed chunk info, RAID5/6 numbers will be
> >incorrect, run as root
> >WARNING: can't get filesystem info from ioctl(FS_INFO), run as root
> >ERROR: couldn't get space info on '/' - Operation not permitted
> >
> >
> >I think usage is more useful than df for users, and contains largely
> >the same information as df + show, so I think all three should be
> >non-root user usable.
> >
> That may be tricky to do, I think show and usage both access the
> underlying block device directly (or try to in any case), which
> would explain why they don't work as non-root; most modern linux
> distributions have permissions on (non-hot-plugged) block devices
> set to 660 and owned by root:disk.

   show certainly does, because it scans for devices, like btrfs dev
scan does. I think Anand has attempted to make it report data from the
kernel's internal FS table, but I'm not sure about the status of that
(and, TBH, not entirely sure about whether it exists. I may have got
the wrong end of the stick skimming through that patch set and
discussion).

   usage shouldn't need to access the device directly, but probably
does need to access the tree search ioctl. It's not the only tool that
does that, and that's probably the reason for most of the root-only
btrfs commands.

   I suspect that in most cases, there's no particularly good reason
for the use of TREE_SEARCH, other than it would require yet another
btrfs-specific ioctl to get the information out without handing the
entire FS's metadata to non-root users. TREE_SEARCH is great for
extracting random data from the FS, and is a really good way to hack
together a new userspace informational feature, but it does then mean
that you can't offer that feature to users that don't have root
permissions.

   Hugo.

-- 
Hugo Mills             | We don't just borrow words; on occasion, English has
hugo@... carfax.org.uk | pursued other languages down alleyways to beat them
http://carfax.org.uk/  | unconscious and rifle their pockets for new
PGP: E2AB1DE4          | vocabulary.                           James D. Nicoll

--9a9Vq1BJdYBEXpLG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJVSlPUAAoJEFheFHXiqx3kxTQP/iJFvPuFe6BFblx4d+J3TPln
ZdyPSSEX6g3xvC3EJAj6UrGgUlD2CR6K1eK9dMbzPH01b8kcPBWsFxS303QYLx77
kv2OqqWMPH+7er11vh2/9i4Uy+SYI8slYADGEk/CL5ttIG8YhMTLs+OUd0ge7F65
ApdPIZfiRaPbqWyYHLed89fSqzwnjox4YcN+X4UDCZn9jyHYbDtauSl7zq3oH7en
9T6tqJTsLBV8RRfP2PyU00WjAywGvk1K2uN4tVo4oaw9vMH0uys2kO3Jl7LCfTMf
+Ows12JB4vUVWx9zJ+xljt0DUDg42fC7iHuB1EJQgi8OaCIWiJjFMH6d+1Cd8kVz
VbEWlFfc0h/QJJkgMoBs60Q6shcHZ+JRxOKrhzfPcYUfGG0EyEt907XcMOPf2m1y
XiEMIfk2ZfEb1bv/YCOy3pq3Arj6JsAQ0QOsZJQjP7RtS9gvQ3oCXc/TDfKZrqnr
0g0F+mqNX/19gVrlzRFuKYGCjyys5/VUsDn71EC266QON1VvMvTHqXtgnVkuodgL
jU4we3pVdNT1ISfR3AmNcWx6EKYUTTx2OhPqKtg0DnGCv9L6/h01vMoVRaN/mQx3
ho3JiP4kaizQXIiS0tskrLZ39W9OQKtw9lyNtNlmOf5gmlYnx2DnOJwKbYTTEPIe
+tGET1X8Uqb4Lc0Dd8rg
=4Hom
-----END PGP SIGNATURE-----

--9a9Vq1BJdYBEXpLG--
