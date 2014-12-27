Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:42219 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbaL0TYJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 27 Dec 2014 14:24:09 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Hugo Mills <hugo@carfax.org.uk>
Cc: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
        Robert White <rwhite@pobox.com>, linux-btrfs@vger.kernel.org
Subject: Re: BTRFS free space handling still needs more work: Hangs again (no complete lockups, "just" tasks stuck for some time)
Date: Sat, 27 Dec 2014 20:23:59 +0100
Message-ID: <2138510.KXMt4iLDat@merkaba>
In-Reply-To: <20141227184017.GL25267@carfax.org.uk>
References: <3738341.y7uRQFcLJH@merkaba> <20141227182846.GA11878@hungrycats.org> <20141227184017.GL25267@carfax.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart28980453.7n3ZBEQpEO"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--nextPart28980453.7n3ZBEQpEO
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

Am Samstag, 27. Dezember 2014, 18:40:17 schrieb Hugo Mills:
> On Sat, Dec 27, 2014 at 01:28:46PM -0500, Zygo Blaxell wrote:
> > On Sat, Dec 27, 2014 at 09:30:43AM +0000, Hugo Mills wrote:
> > > On Sat, Dec 27, 2014 at 10:01:17AM +0100, Martin Steigerwald wrot=
e:
> > > > Am Freitag, 26. Dezember 2014, 14:48:38 schrieb Robert White:
> > > > > On 12/26/2014 05:37 AM, Martin Steigerwald wrote:
> > >    Now, since you're seeing lockups when the space on your disks =
is
> > > all allocated I'd say that's a bug. However, you're the *only* pe=
rson
> > > who's reported this as a regular occurrence. Does this happen wit=
h all
> > > filesystems you have, or just this one?
> >=20
> > I do see something similar, but there are so many problems going on=
 I
> > have no idea which ones to report, and which ones are my own doing.=
  :-P
> >=20
> > I see lots of CPU being burned when all the disk space is allocated=

> > to chunks, but there is still lots of space free (multiple GB) insi=
de
> > the chunks.
> >=20
> > iotop shows a crapton of disk writes (1-5MB/sec) from one kworker.
> > There are maybe a few kB/sec of writes through the filesystem at th=
e time.
> >=20
> > The filesystem where I see this most is on a laptop, so the disk wr=
ites
> > also hit the CPU again for encryption.  There's so much CPU usage i=
t's
> > worth mentioning twice.  :-(
> >=20
> > 'watch cat /proc/12345/stack' on the active processes shows the ker=
nel
> > fairly often in that new chunk deallocator function whose name esca=
pes
> > me at the moment.
> >=20
> > Deleting a bunch of data then running balance helps return to sane =
CPU
> > usage...for a while (maybe a week?).
> >=20
> > It's not technically "locked up" per se, but when a 5KB download ta=
kes
> > a minute or more, most users won't wait around to see the differenc=
e.
> >=20
> > Kernel versions I'm using are 3.17.7 and 3.18.1.
>=20
>    OK, so I'd like to change my statement above.
>=20
>    When I first read Martin's problem, I thought that he was referrin=
g
> to a complete, hit-the-power-button kind of lock-up. Given that
> (erroneous) assumption, I stand by my (now pointless) statement. :)
>=20
>    I realised during a brief conversation on IRC that Martin was
> actually referring to long but temporary periods where the machine is=

> unusable by any process requiring disk activity. There's clearly a
> number of people seeing that.
>=20
>    It doesn't stop it being a major problem, but it does change the
> interpretation considerably.

Ah, then my bet was right with whom I talked there. :)

Yeah, it does not seem to be a complete hang, I though so initially, ca=
use
honestly after waiting several minutes for my Plasma desktop to come ba=
ck
I just gave up. Maybe it would have returned at some time. I just didn=C2=
=B4t
have the patience to wait.

It now did at my last testing where I continued on tty1 (had all the te=
sting
in a screen) as the desktop session locked up. After some time after th=
e
test completed I was able to use that desktop again and I am still usin=
g it.

So the issue I see is: One kworker uses 100% of one core for minutes an=
d
while doing so processes that do I/O to the BTRFS that I test (/home) i=
n my
case seem to be stuck in uninteruptible sleep ("D" process state). Whil=
e I
see this there is no huge load on the SSDs so=E2=80=A6 it seems to be s=
omething
CPU bound. I didn=C2=B4t yet use a strace on the kworker process =E2=80=
=93 or at the
allocation time on the fio process =E2=80=93, Robert, thats a good sugg=
estion. From
a gut feeling I wouldn=C2=B4t be surprised if I see *nothing* in strace=
 as my bet
is that the kworker thread deals with finding free space inside the chu=
nks
and deals with some data structures while doing so. But that is really =
just
a gut feeling and so an strace would be nice.

I made a backup yesterday, so I think I can try the strace. But I also =
spend
a considerable amount of time of reproducing it and digging deeper into=
 it
so likely not this weekend anymore although this even makes some fun. B=
ut
I see myself neglecting other stuff thats important to me as well, so=E2=
=80=A6

My simple test case didn=C2=B4t trigger it, and I so not have another t=
wice 160
GiB available on this SSDs available to try with a copy of my home
filesystem. Then I could safely test without bringing the desktop sessi=
on to
an halt. Maybe someone has an idea on how to "enhance" my test case in
order to reliably trigger the issue.

It may be challenging tough. My /home is quite a filesystem. It has a m=
aildir
with at least one million of files (yeah, I am performance testing KMai=
l and
Akonadi as well to the limit!), and it has git repos and this one VM im=
age,
and the desktop search and the Akonadi database. In other words: It has=

been hit nicely with various mostly random I think workloads over the l=
ast
about six months. I bet its not that easy to simulate that. Maybe some =
runs
of compilebench to age the filesystem before the fio test?

That said, BTRFS performs a lot better. The complete lockups without an=
y
CPU usage of 3.15 and 3.16 have gone for sure. Thats wonderful. But the=
re
is this kworker issue now. I noticed it that gravely just while trying =
to
complete this tax returns stuff with the Windows XP VM. Otherwise it ma=
y
have happened, I have seen some backtraces in kern.log, but it didn=C2=B4=
t last
for minutes. So this indeed is of less severity than the full lockups w=
ith
3.15 and 3.16.

Zygo, was is the characteristics of your filesystem. Do you use
compress=3Dlzo and skinny metadata as well? How are the chunks allocate=
d?
What kind of data you have on it?

Well now off to some dancing event. Thats just right now :)

Ciao,
=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
--nextPart28980453.7n3ZBEQpEO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEABECAAYFAlSfB1MACgkQmRvqrKWZhMdo9QCgtX9PvOonejBzXUUVimDSEzAH
/6IAn31tWaDpKM4541jEljUdT9bdRgrR
=fqeB
-----END PGP SIGNATURE-----

--nextPart28980453.7n3ZBEQpEO--

