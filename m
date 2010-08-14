From: Thomas Kuther <gimpel@sonnenkinder.org>
Subject: Re: volume broken? btrfsck fails
Date: Sat, 14 Aug 2010 13:08:13 +0200
Message-ID: <20100814130813.7445bf82@gimpel.ath.cx>
References: <569BCC7F-1920-4AC4-8069-369419029373@gmail.com>
	<20100707001622.GH15984@think>
	<20100804204840.1652f4cd@gimpel.ath.cx>
	<20100805013005.GC29506@think>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/gZGGovXml2/0OQ9gcdUYf3U"; protocol="application/pgp-signature"
Cc: The development of BTRFS <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100805013005.GC29506@think>
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/gZGGovXml2/0OQ9gcdUYf3U
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mi, 04.08.10 21:30 Chris Mason <chris.mason@oracle.com> wrote:

> On Wed, Aug 04, 2010 at 08:48:40PM +0200, Thomas Kuther wrote:
> > On Di, 06.07.10 20:16 Chris Mason <chris.mason@oracle.com> wrote:
> >=20
> > > On Sat, Jun 26, 2010 at 03:15:04PM -0700, Yee-Ting Li wrote:
> > > > Hi,
> > > >=20
> > > > i think my btrfs volume is hosed.... it mounts okay, but iostat
> > > > shows /dev/sdg on 100% load. dmesg shows lots of 'parent transid
> > > > verify failed on x wanted y found z'. then after a while i can't
> > > > read from it (access to the filesystem freezes).
> > > >=20
> > > > the machine had crashed (prob from some other process), and upon
> > > > reboot i've been experience this problem since.
> > > >=20
> > > > can anyone provide any guidance in how to proceed?
> > >=20
> > > These are definitely corruptions, and they probably came from the
> > > crash. Can you tell me more about the crash? (Power failure, what
> > > is the storage underneath etc, what are the write cache
> > > settings).  We don't expect these kinds corruptions to happen.
> > >=20
> > > Yan Zheng is making a lot of progress on btrfsck, but I don't
> > > think you'll want to be one of the first testers there.  I can
> > > definitely help copy things off if you're having trouble
> > > accessing the FS.
> > >=20
> > > -chris
> >=20
> > Hello Chris,
> >=20
> > sorry if I'm hijacking this thread. I got a similar problem,
> > probably caused by a system crash due to faulty/badly timed memory
> > dimms. The system suddenly hardlocked during write activity.
> >=20
> > - kernel is 2.6.35
> > - btrfs on top of a md raid5, which looks healthy. Desktop SATA
> > disks.
> >=20
> > # cat /proc/mdstat|grep -A1 md0
> > md0 : active raid5 sdb1[0] sdd1[1] sdc1[2]
> >       2930271872 blocks level 5, 64k chunk, algorithm 2 [3/3] [UUU]
> >=20
> > # btrfsck
> > usage: btrfsck dev
> > Btrfs v0.19-16-g075587c-dirty
> >=20
> > # btrfsck /dev/md0
> > parent transid verify failed on 2419218964480 wanted 127839 found
> > 127260 parent transid verify failed on 2419218964480 wanted 127839
> > found 127260 parent transid verify failed on 2419218915328 wanted
> > 127839 found 127260 parent transid verify failed on 2419218915328
> > wanted 127839 found 127260 parent transid verify failed on
> > 2419214266368 wanted 127839 found 127837 parent transid verify
> > failed on 2419214266368 wanted 127839 found 127837 parent transid
> > verify failed on 2419214266368 wanted 127839 found 127837
> > Segmentation fault
> >=20
> > Mount endlessly loops, like explained in this thread.
> >=20
> > If there is a way, I would really like some aid copying the data
> > off. The backup is quite out of date, shame on me.
>=20
> No problem, I'll get a test patch out in the morning.
>=20
> -chris
>=20

Hi Chris,

did you find the time to get that patch done meanwhile?
I'm willing to test.

Seems more people get this error after power outages, suspending or
similar.

Thanks in advance.

~Thomas

--Sig_/gZGGovXml2/0OQ9gcdUYf3U
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEYEARECAAYFAkxmeScACgkQMQFfAqZTGfwKxACfQXEZebCS9e27hY5qRSAaLkx1
TTsAmwUoKmwqNJjt7TeuRaZkLEW5qkiv
=YDVa
-----END PGP SIGNATURE-----

--Sig_/gZGGovXml2/0OQ9gcdUYf3U--
