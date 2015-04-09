Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:52715 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753488AbbDIXjk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Apr 2015 19:39:40 -0400
Date: Thu, 9 Apr 2015 23:39:35 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Justin Maggard <jmaggard10@gmail.com>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, russell@coker.com.au,
        BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: snapshot space use
Message-ID: <20150409233935.GY13864@carfax.org.uk>
References: <201504091039.33442.russell@coker.com.au>
 <5525CBA1.5000408@cn.fujitsu.com>
 <CAKgsxVQ8=Y43DbJ+cNJSt6sb9uPKSfNx+HxErnVMvA6grBCVyg@mail.gmail.com>
 <20150409222421.GW13864@carfax.org.uk>
 <CAKgsxVRQ82aGuVUCFMs+Sn7khuXAZfz-Zm_K4SUHPkiR9u+tZA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WsiejqUMGToi5pfa"
In-Reply-To: <CAKgsxVRQ82aGuVUCFMs+Sn7khuXAZfz-Zm_K4SUHPkiR9u+tZA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--WsiejqUMGToi5pfa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 09, 2015 at 04:27:08PM -0700, Justin Maggard wrote:
> On Thu, Apr 9, 2015 at 3:24 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> > On Thu, Apr 09, 2015 at 03:01:55PM -0700, Justin Maggard wrote:
> >> On Wed, Apr 8, 2015 at 5:45 PM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
> >> > Hi,
> >> >
> >> > You can use btrfs quota feature to do it.
> >> > Like this:
> >> >
> >> > # btrfs quota enable <MNT_POINT>
> >> > # btrfs quota rescan -w <MNT_POINT>
> >> > # btrfs qgroup show -prce <MNT_POINT>
> >> > qgroupid rfer    excl    max_rfer max_excl parent  child
> >> > -------- ----    ----    -------- -------- ------  -----
> >> > 0/5      2248704 12288   0        0        ---     ---
> >> > 0/256    5509120 3272704 0        0        ---     ---
> >> >
> >> >
> >> > rfer is all the space the subvolume takes.
> >> > excl is the exclusive space the subvolume takes.
> >> >
> >>
> >> Yes, but this isn't as useful as it sounds if you have more than one
> >> snapshot.  Because if a file is included in at least two snapshots,
> >> it's no longer exclusive.  So AFAICT even with btrfs qgroups, you
> >> still cannot answer the question "How much space are my snapshots
> >> using?" for a given subvolume, unless you have only one snapshot.  But
> >> I'd be happy to be informed otherwise. :-)
> >
> >    There are basically two useful answers to that question, depending
> > on how the question is specified, exactly:
> >
> > 1) How much space would I use if I copied this subvolume to a
> >    different filesystem?
> >
> > 2) How much space would I free up if I deleted this subvolume?
> >
> >    Part 1 is the rfer answer. Part 2 is the excl answer.
> >
> >    Which of these do you mean by "How much space are my snapshots
> > using?". The question as posed is highly ambiguous, and needs
> > considerably more precision before it can be answered.
> >
> >    If you can pose the question more precisely, you might wish to ask
> > one of those questions about N subvolumes as a group -- this is
> > where(*) you would define a qgroup covering the subvols you're
> > interested in, and then use the above interface to ask the question
> > for the group of subvols as a whole.
> 
> To be more precise, let's consider an example, where we have a
> subvolume named "stuff"; and two snapshots of "stuff", "snap1" and
> "snap2".  So the question I'm posing is:
> 
> How much space would I free up if I were to remove my snapshots,
> "snap1" and "snap2", but keep "stuff" intact?
> 
> I can't use the rfer value from snap1 and snap2, because in general
> most of that space is shared by "stuff" and would not be freed.  I
> could look at the excl column for snap1 and snap2 and add them up; but
> if they shared extents with each other (and not with "stuff"), those
> extents are no longer exclusive, and thus not accounted for.  So I
> would have to delete either snap1 or snap2 in order to answer my
> question using qgroups.
> 
> I can't think of a way to define a qgroup that would be able to answer
> my question, although I'm admittedly no expert in qgroups either.

   I think you'd define a qgroup comtaining snap1 and snap2, and look
at the excl value. Anyone out there with qgroups experience who can
tell us how/whether that would do the job?

   Hugo.

> -Justin
> 
> >
> >    Hugo.
> >
> > (*) I'm not an expert in qgroups. I may have the idea completely
> > wrong, but I think this is the right kind of approach.
> >
> >
> >> -Justin
> >>
> >> > You can also refer to 'btrfs-quota'(8) and 'btrfs-qgroup'(8),
> >> > Also the following wiki can help:
> >> > https://btrfs.wiki.kernel.org/index.php/Quota_support
> >> >
> >> > NOTE: quota is not so stable and has some problem, but should give
> >> > you enough info.
> >> >
> >> > Thanks,
> >> > Qu
> >> >
> >> >> # zfs list -t snapshot
> >> >> NAME                        USED  AVAIL  REFER  MOUNTPOINT
> >> >> hetz0/be0-mail@2015-03-10  2.88G      -   387G  -
> >> >> hetz0/be0-mail@2015-03-11  1.12G      -   388G  -
> >> >> hetz0/be0-mail@2015-03-12  1.11G      -   388G  -
> >> >> hetz0/be0-mail@2015-03-13  1.19G      -   388G  -
> >> >> hetz0/be0-mail@2015-03-14  1.02G      -   388G  -
> >> >> hetz0/be0-mail@2015-03-15   989M      -   386G  -
> >> >>
> >> >> Is there any way to do something similar to the above ZFS command?  It's
> >> >> handy
> >> >> to know which snapshots are taking up the most space, especially when
> >> >> multiple
> >> >> subvols are being snapshotted.
> >> >>
> >

-- 
Hugo Mills             | Great films about cricket: The Third Man
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--WsiejqUMGToi5pfa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJVJw22AAoJEFheFHXiqx3k9hQP/RT0ltPpPvVbKYXz/lmHWe4N
nRvbghRrsoX8iVpw17xjyazJ7sVufn2EZM0yp7az/wG8TBnjI3nA44HUX6wBDEut
F2wO+s627j3yedbkdKE9fTEDlW519/fn+ZYOR4zs1Rmh6nsA1xyZ8fkChihlBEDs
XJ9z4eOCb1JvKiXu+H1YYdUJn/N0OL88htTpXdZe1EQJtM1PDUizyTrIm21v+IDn
nENBDl7Kj0hANU18v54mtyeBKft4lJYjuQt9O4zKAx1dkb1s1Tja4dD72V4brxWQ
ID9Ymmx/oAwB8HrkDHBjcgnhHJqrbWtuYlHhlFTf5zrsm2Zz3CFrDS7vBeG0/IaO
JGajYG+qjWFSIcYw9Hyv9zxToHWmnqQ5XN6UEKUMeIutGsCx/7R5t8uo2DdH0En2
xMhq+MmiXl2pVVCmwLteWoAUsobbfOKiwOEoLL43mFJifAdBDrkoAYUtOcKOWXDP
HSLW6tPr8zLZu7cN1ddTtH1JYk9TJkGBIMdfkirGCmuR3IeZCCANlu1kyHUZi4Yx
WSrJlWdX2cUoXM5+X1OiY20whB9RDcXC6QGeIG52+XV8TwDyHM+VmzFu1taNEfMR
EBo7IZzb8etSMTp98v3m2pd2inPQSGoEFWvbTmRvoyu9XIEswgMpcbJmtD6elEbV
CbFah2QyAZd78uuFm8pa
=GWvM
-----END PGP SIGNATURE-----

--WsiejqUMGToi5pfa--
