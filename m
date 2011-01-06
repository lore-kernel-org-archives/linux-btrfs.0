From: Hubert Kario <hka@qbs.com.pl>
Subject: Re: Offline Deduplication for Btrfs
Date: Thu, 6 Jan 2011 17:57:32 +0100
Message-ID: <201101061757.32454.hka@qbs.com.pl>
References: <4D258D6A.9010903@wpkg.org> <20110106095104.GA5787@glandium.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Cc: Tomasz Chmielewski <mangoo@wpkg.org>,
	"linux-btrfs" <linux-btrfs@vger.kernel.org>
To: Mike Hommey <mh@glandium.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110106095104.GA5787@glandium.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Thursday 06 of January 2011 10:51:04 Mike Hommey wrote:
> On Thu, Jan 06, 2011 at 10:37:46AM +0100, Tomasz Chmielewski wrote:
> > >I have been thinking a lot about de-duplication for a backup appli=
cation
> > >I am writing. I wrote a little script to figure out how much it wo=
uld
> > >save me. For my laptop home directory, about 100 GiB of data, it w=
as a
> > >couple of percent, depending a bit on the size of the chunks. With=
 4 KiB
> > >chunks, I would save about two gigabytes. (That's assuming no MD5 =
hash
> > >collisions.) I don't have VM images, but I do have a fair bit of s=
aved
> > >e-mail. So, for backups, I concluded it was worth it to provide an
> > >option to do this. I have no opinion on whether it is worthwhile t=
o do
> > >in btrfs.
> >=20
> > Online deduplication is very useful for backups of big,
> > multi-gigabyte files which change constantly.
> > Some mail servers store files this way; some MUA store the files
> > like this; databases are also common to pack everything in big file=
s
> > which tend to change here and there almost all the time.
> >=20
> > Multi-gigabyte files which only have few megabytes changed can't be
> > hardlinked; simple maths shows that even compressing multiple files
> > which have few differences will lead to greater space usage than a
> > few megabytes extra in each (because everything else is
> > deduplicated).
> >=20
> > And I don't even want to think about IO needed to offline dedup a
> > multi-terabyte storage (1 TB disks and bigger are becoming standard
> > nowadays) i.e. daily, especially when the storage is already heavil=
y
> > used in IO terms.
> >=20
> >=20
> > Now, one popular tool which can deal with small changes in files is
> > rsync. It can be used to copy files over the network - so that if
> > you want to copy/update a multi-gigabyte file which only has a few
> > changes, rsync would need to transfer just a few megabytes.
> >=20
> > On disk however, rsync creates a "temporary copy" of the original
> > file, where it packs unchanged contents together with any changes
> > made. For example, while it copies/updates a file, we will have:
> >=20
> > original_file.bin
> > .temporary_random_name
> >=20
> > Later, original_file.bin would be removed, and
> > .temporary_random_name would be renamed to original_file.bin. Here
> > goes away any deduplication we had so far, we have to start the IO
> > over again.
>=20
> Sounds like all you need is cp --reflink=3Dalways and rsync --inplace=
=2E
>=20
> Haven't tested is that works well, though.

It works very well, btrfs with snapshots, compression and rsync --inpla=
ce has=20
better storage utilisation than lessfs at around 10-15 snapshots with a=
round=20
600GB of test data in small files.

--=20
Hubert Kario
QBS - Quality Business Software
02-656 Warszawa, ul. Ksawer=F3w 30/85
tel. +48 (22) 646-61-51, 646-74-24
www.qbs.com.pl
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
