Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:36782 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627AbbGNTQA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jul 2015 15:16:00 -0400
Date: Tue, 14 Jul 2015 19:15:58 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Patrik Lundquist <patrik.lundquist@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: counting fragments takes more time than defragmenting
Message-ID: <20150714191558.GM10539@carfax.org.uk>
References: <20150604084245.GR23272@merlins.org>
 <20150624032008.GF20517@merlins.org>
 <CAA7pwKOA1yyA8kyB+a3iTOp8TnkRzAErF1Mo=2t5M3pFn2tjUw@mail.gmail.com>
 <pan$5335b$94315604$8405c6ac$de90de30@cox.net>
 <CAA7pwKNtS6UB+tXdB9c4D9J2gOk56gM-O1q+19A6SZcdcdFVtw@mail.gmail.com>
 <20150714184122.GL10539@carfax.org.uk>
 <CAA7pwKOytX18=mtPjfGmGgvd-x=nNpFYSsHX3m7uMJCCjZU8zg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bZ2MuwyI/0uB8yuJ"
In-Reply-To: <CAA7pwKOytX18=mtPjfGmGgvd-x=nNpFYSsHX3m7uMJCCjZU8zg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--bZ2MuwyI/0uB8yuJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 14, 2015 at 09:09:00PM +0200, Patrik Lundquist wrote:
> On 14 July 2015 at 20:41, Hugo Mills <hugo@carfax.org.uk> wrote:
> > On Tue, Jul 14, 2015 at 01:57:07PM +0200, Patrik Lundquist wrote:
> >> On 24 June 2015 at 12:46, Duncan <1i5t5.duncan@cox.net> wrote:
> >> >
> >> > Regardless of whether 1 or huge -t means maximum defrag, however, the
> >> > nominal data chunk size of 1 GiB means that 30 GiB file you mentioned
> >> > should be considered ideally defragged at 31 extents.  This is a
> >> > departure from ext4, which AFAIK in theory has no extent upper limit, so
> >> > should be able to do that 30 GiB file in a single extent.
> >> >
> >> > But btrfs or ext4, 31 extents ideal or a single extent ideal, 150 extents
> >> > still indicates at least some remaining fragmentation.
> >>
> >> So I converted the VMware VMDK file to a VirtualBox VDI file:
> >>
> >> -rw------- 1 plu plu 28845539328 jul 13 13:36 Windows7-disk1.vmdk
> >> -rw------- 1 plu plu 28993126400 jul 13 14:04 Windows7.vdi
> >>
> >> $ filefrag Windows7.vdi
> >> Windows7.vdi: 15 extents found
> >>
> >> $ btrfs filesystem defragment -t 3g Windows7.vdi
> >> $ filefrag Windows7.vdi
> >> Windows7.vdi: 24 extents found
> >>
> >> How can it be less than 28 extents with a chunk size of 1 GiB?
> >
> >    I _think_ the fragment size will be limited by the block group
> > size. This is not the same as the chunk size for some RAID levels --
> > for example, RAID-0, a block group can be anything from 2 to n chunks
> > (across the same number of devices), where each chunk is 1 GiB, so
> > potentially you could have arbitrary-sized block groups. The same
> > would apply to RAID-10, -5 and -6.
> >
> >    (Note, I haven't verified this, but it makes sense based on what I
> > know of the internal data structures).
> 
> It's a raid1 filesystem, so the block group ought to be the same size
> as the chunk, right?

   Yes.

> A 2GiB block group would suffice to explain it though.

   Not with RAID-1 -- I'd expect the block group size to be 1 GiB.

   Hugo.

-- 
Hugo Mills             | There isn't a noun that can't be verbed.
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--bZ2MuwyI/0uB8yuJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJVpV/uAAoJEFheFHXiqx3kv6QQALQtuiTx++mmsUpCTuroQoQm
E0ZmfiBVSAu4feYyhitMoZJO1Fxf6ein17VMx0HKH9NMUXaiKpF+HWXd758e8wpC
6PBW5ABD4p+cWEvEaiLF1QBO/0pu6EwieVVwYBXRwEJijtjoTGKuAkTzH4tp5H1/
RpW+nT9aq4OaRdJwiREWA+yLysVw/AuGi8NtTv2kTOjaOG8VBk6eaB016WX7nrL5
3cdpyO3zKcBitQ8wRISv/UJsbFXDN/j2SzYBF+DUsakfEsS73ByR5l74rgHt0NOU
nGDnDcmthr9hEnQrrim3xe5AE6qQWsfCrmYGXZ8v6bSRx8XKaiOm9rBUoPYbfAHw
lRCxrQO4w86nNhhoicuxmCZxuJWPBAFuyRAOVb5w2QechAHZiVjv3TInqOmq/Ihj
DgKr70Xm0eLF8vYzIiLDsq3f4Hh3d6Q3oCk0my7LcrAYjf+mHMOFCkQmZtEw4q91
HKbBaoqVa4kEUW9bfbYuvSDSb0QpHUDcN8Vw1Pg38ie8KJv3ZZFAP34k7sVltZCu
CXBP2tsOquCnwutu+iMlcMbPZ3EdPh7iwfPR/hO4LzzxN/TnpsJlgblrKG+mPuBx
8IB6s1G6XZoRQXBCHfeCB2ZPHKitM6IbVfHWHGE5hT7ZHuC8yeHlxoUIKNAfzyFs
a38qSL1flU9by3Cjjl2k
=OLIK
-----END PGP SIGNATURE-----

--bZ2MuwyI/0uB8yuJ--
