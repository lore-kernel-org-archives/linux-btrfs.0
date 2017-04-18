Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:34182 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752766AbdDRMU4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Apr 2017 08:20:56 -0400
Date: Tue, 18 Apr 2017 12:20:52 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Imran Geriskovan <imran.geriskovan@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Btrfs/SSD
Message-ID: <20170418122052.GI21462@carfax.org.uk>
References: <CAK5rZE4ko_xFr_Zv=bmZ4tR9X59jXaqFnTv16_ynEO0+E5uzeg@mail.gmail.com>
 <f5cb15a5-5566-b366-ebda-c3101fa96eec@gmail.com>
 <CAJCQCtS=xqcWMqiRxC_uoqTRUaW6aMwayoqjtMqq6XhcCJNVRg@mail.gmail.com>
 <8f046fa5-a458-9db8-b616-907afd34383b@gmail.com>
 <CAJCQCtTCd7BEwQN4k9n0Jm6ZQTnCS738ctEUnKDb2eENhe21Sg@mail.gmail.com>
 <18a01a39-9c2d-8a7a-7fba-1cd150976605@gmail.com>
 <CAJCQCtQn8kOrQBXc=xX8MbZnFnLQjECvEuc1zx0=5cAvGNLrJg@mail.gmail.com>
 <82484ebd-12e2-c3fe-2ae7-a4cfb3711f10@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="TKDEsImF70pdVIl+"
In-Reply-To: <82484ebd-12e2-c3fe-2ae7-a4cfb3711f10@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--TKDEsImF70pdVIl+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 18, 2017 at 07:31:34AM -0400, Austin S. Hemmelgarn wrote:
> On 2017-04-17 15:39, Chris Murphy wrote:
> >On Mon, Apr 17, 2017 at 1:26 PM, Austin S. Hemmelgarn
> ><ahferroin7@gmail.com> wrote:
> >>On 2017-04-17 14:34, Chris Murphy wrote:
[...]
> >>>>>It's almost like we need these things to not fsync at all, and just
> >>>>>rely on the filesystem commit time...
> >>>>
> >>>>
> >>>>Essentially yes, but that causes all kinds of other problems.
> >>>
> >>>
> >>>Drat.
> >>>
> >>Admittedly most of the problems are use-case specific (you can't afford to
> >>lose transactions in a financial database  for example, so it functionally
> >>has to call fsync after each transaction), but most of it stems from the
> >>fact that BTRFS is doing a lot of the same stuff that much of the 'problem'
> >>software is doing itself internally.
> >>
> >
> >Seems like the old way of doing things, and the staleness of the
> >internet, have colluded to create a lot of nervousness and misuse of
> >fsync. The very fact Btrfs needs a log tree to deal with fsync's in a
> >semi-sane way...
> Except that BTRFS is somewhat unusual.  Prior to this, the only
> 'mainstream' filesystem that provided most of these features was
> ZFS, and that does a good enough job that this doesn't matter.
> 
> For something like a database though, where you need ACID
> guarantees, you pretty much have to have COW semantics internally,
> and you have to force things to stable storage after each
> transaction that actually modifies data.  Looking at it another way,
> most database storage formats are essentially record-oriented
> filesystems (as opposed to block-oriented filesystems that most
> people think of).  This is part of why you see such similar access
> patterns in databases and VM disk images (even if the VM isn't
> running database software), they are essentially doing the same
> things at a low level.

   I remember thinking, when I was learning about the internals of
btrfs, that it looked an awful lot like the high-level description of
the internals of Oracle which I'd just been learning about. Most of
the same pieces, doing mostly the same kinds operations to achieve the
same effective results.

   Hugo.

-- 
Hugo Mills             | Don't worry, he's not drunk. He's like that all the
hugo@... carfax.org.uk | time.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                                           A.H. Deakin

--TKDEsImF70pdVIl+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJY9gSkAAoJEFheFHXiqx3kQcUP/jciMY9KDwI5UgFduHl1fRps
VoQs+T5PsNscAtAkN5+AGkYcvdb3PQvzQzq1xHAfDA+0rvHL4iFT9/1n0fLEw37O
y12nl6xFpvpg1JzVhxJLLiYSpuky2I020O+ZaCwMIM+DWHhdroiDZKiIqzQjqA2Z
x09PcrF0jl57noOT0Bt/wezs2FCOhjupk20ysLn8kWYMMha7r/XG5b6cO1nZtY6U
v4ecSZJQyI+ncBVgIbcTKEPZhFSlYVbiLiMUeWz62DH3d7aWWDyF3+F/lI95TRMv
4iUfsKAO5Fe852FjLNCmPC/YEz7QYtzi+4wB4sG3E91OhpFXa3BGsX93+MahoAo2
33ysEpk8z8uWDILF6A2LiJeOwUFODzOqJ3hSVPc4hQOiS9l3UTp6us6HSNq6/9kj
2Fb0/q/VyfnDaKecp2N8jmRIavjm+qHmEdfJ6kSEEQMw02CO26tYJ0rQEZ7wdd8O
VOo14JAFhC0XLILPmSkAyr/9SQd5yJZCdP9B5qsWOl1Z+LKsbKPxCnOLpSyYGVIR
wCcqf1Fed6dmMJiNgiiC9xy90kJSAXFdTx/fBc8O06AqfpC3J1/ivQI6NNu8Dq4G
ILvWAbno6AQhD4PbhmdnC5w0h6RHjDtDK0BKhwNUPtMzcXq+FiD/5j2FjJQ2V9q6
XrJX2yN1fqaOAG6LjFzZ
=/nrA
-----END PGP SIGNATURE-----

--TKDEsImF70pdVIl+--
