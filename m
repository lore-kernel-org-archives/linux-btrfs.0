Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:36512 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367AbbH1JfG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 28 Aug 2015 05:35:06 -0400
Date: Fri, 28 Aug 2015 09:35:02 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: George Duffield <forumscollective@gmail.com>
Cc: Austin S Hemmelgarn <ahferroin7@gmail.com>, Roman Mamedov <rm@romanrm.net>,
        linux-btrfs@vger.kernel.org
Subject: Re: Understanding BTRFS storage
Message-ID: <20150828093502.GO23769@carfax.org.uk>
References: <CAG__1a4T=d_O49CnOw+0gtKr56xtrmcjRcmujtUff_s_-oL0Jw@mail.gmail.com>
 <20150826165024.05af044f@natsu>
 <55DDAB1C.90406@gmail.com>
 <CAG__1a4x_bv2DURyT0ZW0p+udh43ifcn=bHjUKM4NF1Tk=cYDw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TYjWXklH5JTzT8n9"
In-Reply-To: <CAG__1a4x_bv2DURyT0ZW0p+udh43ifcn=bHjUKM4NF1Tk=cYDw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--TYjWXklH5JTzT8n9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Aug 28, 2015 at 10:50:12AM +0200, George Duffield wrote:
> Running a traditional raid5 array of that size is statistically
> guaranteed to fail in the event of a rebuild.

   Except that if it were, you wouldn't see anyone running RAID-5
arrays of that size and (considerably) larger. And successfully
replacing devices in them.

   As I understand it, the calculations that lead to the conclusion
you quote are based on the assumption that the bit error rate (BER) of
the drive is applied on all reads -- this is not the case. The BER is
the error rate of the platter after the device has been left unread
(and powered off) for some long period of time. (I've seen 5 years
been quoted for that).

   Hugo.

> I also need to expand
> the size of available storage to accomodate future storage
> requirements. My understanding is that a Btrfs array is easily
> expanded without the overhead associated with expanding a traditional
> array.  Add to that the ability to throw varying drive sizes at the
> problem and a Btrfs RAID array looks pretty appealing.
> 
> For clarity, my intention is to create a Btrfs array using new drives,
> not to convert the existing ext4 raid5 array.
> 
> On Wed, Aug 26, 2015 at 2:03 PM, Austin S Hemmelgarn
> <ahferroin7@gmail.com> wrote:
> > On 2015-08-26 07:50, Roman Mamedov wrote:
> >>
> >> On Wed, 26 Aug 2015 10:56:03 +0200
> >> George Duffield <forumscollective@gmail.com> wrote:
> >>
> >>> I'm looking to switch from a 5x3TB mdadm raid5 array to a Btrfs based
> >>> solution that will involve duplicating a data store on a second
> >>> machine for backup purposes (the machine is only powered up for
> >>> backups).
> >>
> >>
> >> What do you want to achieve by switching? As Btrfs RAID5/6 is not safe
> >> yet, do
> >> you also plan to migrate to RAID10, losing in storage efficiency?
> >>
> >> Why not use Btrfs in single-device mode on top of your mdadm RAID5/6? Can
> >> even
> >> migrate without moving any data if you currently use Ext4, as it can be
> >> converted to Btrfs in-place.
> >>
> > As of right now, btrfs-convert does not work reliably or safely.  I would
> > strongly advise against using it unless you are trying to help get it
> > working again.
> >

-- 
Hugo Mills             | Beware geeks bearing GIFs
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--TYjWXklH5JTzT8n9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJV4CtGAAoJEFheFHXiqx3kvQwQAJhX6u7+naFi3Z3JYCMgssT0
Kgcv8LfxW9EpliuAJDOp8Sy5XoyCuP+Q3OJqQt0YYfzvDHkl/UW4zsle1Ze/N0Rv
xyw0UosjMdrRq8Xhqo3uRe047HKVed6j+FkmB/Hb8djrv0Z439lclnkg3YmRqduQ
4At+iASN8/EUMjSbYEY8o/Vi7eUwDPZmrzZjwGSb3fu3+W3yZGrtaYseo72Aug/X
NlGs5i/GmU779oVGbFU5mOK2oQKABgcel8jcXCGzgZlkjbZGBZWCdD5/RJLPuHAV
6DcBtMiXkfpJ2+Z6RCgiR7JWW5JtU842B9o9mFSPfSV8NIRq0s0EatF1PPqjiPkM
wLS0NqexfpnytfxomWjafcdLe8sZoiuspLN0ELnSQ2myYve6T6JpamhEBvGuaMNL
A74lxV46cEy5PItaBJOuetcpG5F11kwIv/4DCVqsKmeVY3AMKNckMKzuUingg+CA
n6C45RzUqX1efny5BU7v2bhhwPmerUVbrH22TlTy1TEHN5emt+repvhjF6MZojsa
oy2wCnXRtjynCcShlzuzEJenBWJOkOv2BqSrHUqz2JbRLJot1KQDxKHiLa8pToph
TDD3FnTFJPb3dPZfPNh4PlTyzmu1beCaOKZsPi4/RxrSVk8hI/bXQGNQUEdVxJ+3
z3lfDhBTdilB92myp3oa
=y9zy
-----END PGP SIGNATURE-----

--TYjWXklH5JTzT8n9--
