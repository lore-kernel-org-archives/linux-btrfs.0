Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:52752 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751855AbdBHTDf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 Feb 2017 14:03:35 -0500
Date: Wed, 8 Feb 2017 18:03:11 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Peter Grandi <pg@btrfs.list.sabi.co.UK>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: understanding disk space usage
Message-ID: <20170208180311.GB4249@carfax.org.uk>
References: <CALg=eG_C-Xkw+TTHpNq9y_euza81TPTd+YN10_V=9WSprN0BPw@mail.gmail.com>
 <7912da41-d58a-d57f-47cd-508bc709a761@cn.fujitsu.com>
 <22683.12104.679173.639568@tree.ty.sabi.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="EuxKj2iCbKjpUGkD"
In-Reply-To: <22683.12104.679173.639568@tree.ty.sabi.co.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--EuxKj2iCbKjpUGkD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 08, 2017 at 02:46:32PM +0000, Peter Grandi wrote:
> >> My system is or seems to be running out of disk space but I
> >> can't find out how or why. [ ... ]
> >> Filesystem            Size  Used Avail Use% Mounted on
> >> /dev/sda3              28G   26G  2.1G  93% /
> [ ... ]
> > So from chunk level, your fs is already full.  And balance
> > won't success since there is no unallocated space at all.
> 
> To add to this, 28GiB is a bit too small for Btrfs, because at
> that point chunk size is 1GiB. I have the habit of sizing
> partitions to an exact number of GiB, and that means that most
> of 1GiB will never be used by Btrfs because there is a small
> amount of space allocated that is smaller than 1GiB and thus
> there will be eventually just less than 1GiB unallocated.

   Not true -- the last chunk can be smaller than 1 GiB, to use the
available space completely.

   Hugo.

> Unfortunately the chunk size is not manually settable.
> 
> Example here from 'btrfs fi usage':
> 
> Overall:
>     Device size:                  88.00GiB
>     Device allocated:             86.06GiB
>     Device unallocated:            1.94GiB
>     Device missing:                  0.00B
>     Used:                         80.11GiB
>     Free (estimated):              6.26GiB      (min: 5.30GiB)
> 
> That means that I should 'btrfs balance' now, because of the
> 1.94GiB "unallocated", 0.94GiB will never be allocated, and that
> leaves just 1GiB "unallocated" which is the minimum for running
> 'btrfs balance'. I have just done so and this is the result:
> 
> Overall:
>     Device size:                  88.00GiB
>     Device allocated:             82.03GiB
>     Device unallocated:            5.97GiB
>     Device missing:                  0.00B
>     Used:                         80.11GiB
>     Free (estimated):              6.26GiB      (min: 3.28GiB)
> 
> At some point I had decided to use 'mixedbg' allocation to
> reduce this problem and hopefully improve locality, but that
> means that metadata and data need to have the same profile, and
> I really want metadata to be 'dup' because of checksumming,
> and I don't want data to be 'dup' too.
> 
> > [ ... ] To proceed, add a larger device to current fs, and do
> > a balance or just delete the 28G partition then btrfs will
> > handle the rest well.
> 
> Usually for this I use a USB stick, with a 1-3GiB partition plus
> a bit extra because of that extra bit of space.
> 
> https://btrfs.wiki.kernel.org/index.php/FAQ#How_much_free_space_do_I_have.3F
> https://btrfs.wiki.kernel.org/index.php/FAQ#Help.21_Btrfs_claims_I.27m_out_of_space.2C_but_it_looks_like_I_should_have_lots_left.21
> marc.merlins.org/perso/btrfs/post_2014-05-04_Fixing-Btrfs-Filesystem-Full-Problems.html
> 
> Unfortunately if it is a single device volume and metadata is
> 'dup' to remove the extra temporary device one has first to
> convert the metadata to 'single' and then back to 'dup' after
> removal.
> 
> There are also some additional reasons why space used (rather
> than allocated) may be larger than expected, in special but not
> wholly infrequent cases. My impression is that the Btrfs design
> trades space for performance and reliability.

-- 
Hugo Mills             | Alert status chocolate viridian: Authorised
hugo@... carfax.org.uk | personnel only. Dogs must be carried on escalator.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--EuxKj2iCbKjpUGkD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJYm11fAAoJEFheFHXiqx3k9ZcP/0uvh8Cb5JqDPimrEnX5Myc4
QdfXa0xggiPvOaFtR7gV2Pyt3K2y12vAxeGlCfQDyKRyfpB20uZ8wlB+sTAm4s3S
GJVKMyUEFXCOp4+Cd1bjFie5st+kW2tE46+0nmPyMWnYxDeqMTvyDqNhI0S7qCHG
gCC1XZ8UL13jB4LhduK6aCcYQkRzGHQg8ysJSNg3N9E1b7fze9adSBgAdT2mQ7QG
XM3aMYghtmnHB/93EemNXc5E93dgmfu+2w1JJ5VShf1bsIO6SGS9SvEYGs1aSwKy
TxsstOf4TAnnCAMErpLr5/mlmmw7G1XxxjcXR6FIIeA0FBur8xHS+VFCBOXkwoQD
Svy1Pq55RNq17ThM8Pne23XXC0jFviAFwn3HiaJj1bIHRGQR7E3a1aWzBHHWvcyL
I9syh9rZ0fJNI5tC2SQqJY61hNMsGUuywvwNv6gk17v2Kb6r0eCWm3x6rmRXss0d
xmk/EvIZmPqLSjazTJSNJFrYjZFZdriWfQZvUz9A5DU2Fqi1dHqgQFIY7gMES3Z5
wOe5gVmL66NLp18WWvc9+VpJpd9Pz0aQOIZeEsi9PwUKHWGrgInNO1BO29z7Ogd2
GDfmM5GtSsHEAxUZbPQ0FTeJQKM7+s7DWcTFjlCFa++LN+WNpMXJ6aHLIPwdYWlG
XHuB8ZiH2vWhQZkPMf0X
=kFK3
-----END PGP SIGNATURE-----

--EuxKj2iCbKjpUGkD--
