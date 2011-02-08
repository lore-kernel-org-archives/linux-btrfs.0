From: Hubert Kario <hka@qbs.com.pl>
Subject: Re: Error mounting multi-device fs after restart
Date: Tue, 8 Feb 2011 22:51:37 +0100
Message-ID: <201102082251.38094.hka@qbs.com.pl>
References: <AANLkTi=vSb0i-joekFrZRmwcAE+5w8FwV2FFWcbMvC6n@mail.gmail.com> <AANLkTikkUFDTiGqRkMk-VtvxSFS3vNGp0QCn=HPef89V@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Diwaker Gupta <diwaker@maginatics.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTikkUFDTiGqRkMk-VtvxSFS3vNGp0QCn=HPef89V@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tuesday 08 of February 2011 21:25:55 Diwaker Gupta wrote:
> Searching through the archives, it seems others have faced similar
> issues due to sudden power outages. AFAIK we did not have any power
> outage.

SysRq+B will have the same effect, OOPS or BUG will have similar effect

> I've run badblocks on all of the 10 drives and three of them had a fe=
w
> bad blocks. I'm inclined to rule out bad disks as the root cause. In
> any case, isn't this exactly the kind of situation btrfs should
> protect users against?

And in the end it will, unfortunately at the moment it will only report=
 the=20
read data doesn't match stored checksum in the dmesg. If you have redun=
dacy in=20
place it will try to read the other copy of data. That's it.

As a side note, if a drive made in the past 5 years has badblocks detec=
table=20
by `badblocks` it's long gone, probably it was silently corrupting data=
 for a=20
long time now.

> A 'btrfsck' aborts on all of the drives. I've tried running it with
> '-s 1' as well as '-s 2' with no success. Does that mean that none of
> the drives have any copy of the superblock intact?

-s 1 and -s 2 will try to read backup copies of superblock, not superbl=
ock=20
copies on other devices. Regular code should perform the latter by itse=
lf.
=20
> Diwaker
>=20
> On Mon, Feb 7, 2011 at 11:46 AM, Diwaker Gupta <diwaker@maginatics.co=
m>=20
wrote:
> > Hello,
> >=20
> > We have 10 1-TB drives hosting a multi-device btrfs filesystem,
> > configured with raid1+0 for both data and metadata. After some pack=
age
> > upgrades over the weekend I restarted the system and it did not com=
e
> > back up afterwards. I booted using a rescue disk and ran btrfsck (n=
ext
> > branch from Chris's git repository). Unfortunately btrfsck aborts o=
n
> > every single drive with errors like this:
> >=20
> > parent transid verify failed on 12050980864 wanted 377535 found 128=
327
> > parent transid verify failed on 12074557440 wanted 422817 found 126=
691
> > parent transid verify failed on 12057542656 wanted 422786 found 126=
395
> > parent transid verify failed on 12075556864 wanted 423004 found 126=
691
> > bad block 12095545344
> > parent transid verify failed on 12079190016 wanted 422826 found 105=
147
> > leaf parent key incorrect 12097544192
> > bad block 12097544192
> >=20
> > I'm running 10.04 Ubuntu Lucid with the lts-backport x86_64 kernel:
> > 2.6.35-23-server
> >=20
> > Attempting to mount the filesystem blocks indefinitely, with
> > /var/log/messages getting filled with the 'parent transid verify'
> > errors.

Define *indefinitely*.
Are the drives not working?
If the drives are working, have you tried waiting 2-3 days, possibly lo=
nger?
10TB is a *lot* of data

> >=20
> > IIUC the 'btrfs-select-super' utility is not really helpful in our
> > case. At this point, my only priority is to somehow rescue the data
> > from the filesystem. I'd really appreciate if someone on the list
> > could help me out.

getting the FS mountable is your best bet at the moment (apart from div=
ing in=20
the drive with dd in one hand and hexdump in the other...)

> >=20
> > I'm happy to provide any other information required. Please CC me o=
n
> > replies as I'm not subscribed to the list.
> >=20
> > Thanks,
> > Diwaker
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

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
