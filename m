From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: Premature -ENOSPC on btrfs?
Date: Fri, 29 Apr 2011 17:30:25 -0700
Message-ID: <20110430003025.GD18929@tux1.beaverton.ibm.com>
References: <20110429234805.GA20579@tux1.beaverton.ibm.com> <BANLkTimm00fwBukO_C=wS_jK6090rdj2pw@mail.gmail.com> <20110430001641.GC18929@tux1.beaverton.ibm.com> <BANLkTimzOxJTf5x8_odoogXF72wwP=6_+w@mail.gmail.com>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: linux-btrfs@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>
To: cwillu <cwillu@cwillu.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <BANLkTimzOxJTf5x8_odoogXF72wwP=6_+w@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 29, 2011 at 06:24:16PM -0600, cwillu wrote:
> On Fri, Apr 29, 2011 at 6:16 PM, Darrick J. Wong <djwong@us.ibm.com> =
wrote:
> > On Fri, Apr 29, 2011 at 06:00:16PM -0600, cwillu wrote:
> >> On Fri, Apr 29, 2011 at 5:48 PM, Darrick J. Wong <djwong@us.ibm.co=
m> wrote:
> >> > Hi,
> >> >
> >> > I was giving btrfs (2.6.39-rc4) a quick tryout today and noticed=
 some odd
> >> > behavior when running a rather stupid test.
> >> >
> >> > First, I create a 1GB test fs, format it, and mount it. =A0Then,=
 I run the
> >> > following command to create a huge file, truncate it, rewrite it=
, and report
> >> > what size file got created.
> >> >
> >> > # while true; do dd if=3D/dev/zero of=3D/mnt/testfile bs=3D1024k=
; done
> >> >
> >> > This is roughly what I see in terms of file size after filtering=
 out all the
> >> > "dd: writing `/mnt/testfile': No space left on device" messages.
> >> >
> >> > 782237696 bytes (782 MB) copied, 16.5647 s, 47.2 MB/s
> >> > 545259520 bytes (545 MB) copied, 14.061 s, 38.8 MB/s
> >> > 780140544 bytes (780 MB) copied, 15.2959 s, 51.0 MB/s
> >> > 933232640 bytes (933 MB) copied, 15.2241 s, 61.3 MB/s
> >> > 827326464 bytes (827 MB) copied, 14.8383 s, 55.8 MB/s
> >> > 931135488 bytes (931 MB) copied, 15.1554 s, 61.4 MB/s
> >> > 936378368 bytes (936 MB) copied, 2.98301 s, 314 MB/s
> >> > 393216000 bytes (393 MB) copied, 12.9202 s, 30.4 MB/s
> >> > 387973120 bytes (388 MB) copied, 13.4906 s, 28.8 MB/s
> >> > 932184064 bytes (932 MB) copied, 15.3356 s, 60.8 MB/s
> >> > 785383424 bytes (785 MB) copied, 14.6429 s, 53.6 MB/s
> >> > 927989760 bytes (928 MB) copied, 15.4386 s, 60.1 MB/s
> >> > 833617920 bytes (834 MB) copied, 14.6289 s, 57.0 MB/s
> >> > 936378368 bytes (936 MB) copied, 3.33651 s, 281 MB/s
> >> > 393216000 bytes (393 MB) copied, 12.9689 s, 30.3 MB/s
> >> > 389021696 bytes (389 MB) copied, 6.02794 s, 64.5 MB/s
> >> > 294649856 bytes (295 MB) copied, 1.05144 s, 280 MB/s
> >> >
> >> > Strangely, df reports that free space remains, and I can even cr=
eate a second
> >> > file to fill the empty space, so clearly the fs isn't full yet. =
=A0Is this the
> >> > intended behavior of btrfs? =A0ext4/vfat seem to produce the sam=
e size file
> >> > every time.
> >>
> >> https://btrfs.wiki.kernel.org/index.php/FAQ#if_your_device_is_smal=
l
> >>
> >> You'll want to use mixed block groups with such a small filesystem=
=2E
> >
> > The wiki seems dead, but the Google cache version implies that 2.6.=
37+ takes
> > care of enabling mixed block groups already. =A0I also pulled btrfs=
progs git and
> > built a new mkfs, but that didn't seem to solve anything.
>=20
> The wiki does that frequently :(
>=20
> Check the tmp branch of the progs git;  there should be a -M option t=
o
> mkfs.btrfs.

Yep, now I see it.  That -M seems to have stabilized it a bit:

945815552 bytes (946 MB) copied, 1.90592 s, 496 MB/s
1034944512 bytes (1.0 GB) copied, 4.55472 s, 227 MB/s
946864128 bytes (947 MB) copied, 2.55459 s, 371 MB/s
957349888 bytes (957 MB) copied, 2.55406 s, 375 MB/s
956301312 bytes (956 MB) copied, 2.63751 s, 363 MB/s
956301312 bytes (956 MB) copied, 2.44889 s, 391 MB/s
956301312 bytes (956 MB) copied, 2.50232 s, 382 MB/s
956301312 bytes (956 MB) copied, 2.97849 s, 321 MB/s
956301312 bytes (956 MB) copied, 2.4995 s, 383 MB/s
956301312 bytes (956 MB) copied, 2.44848 s, 391 MB/s
956301312 bytes (956 MB) copied, 2.45217 s, 390 MB/s
956301312 bytes (956 MB) copied, 2.60435 s, 367 MB/s
956301312 bytes (956 MB) copied, 2.49104 s, 384 MB/s
956301312 bytes (956 MB) copied, 2.45969 s, 389 MB/s
956301312 bytes (956 MB) copied, 3.02976 s, 316 MB/s
956301312 bytes (956 MB) copied, 2.96214 s, 323 MB/s

Still a little odd why the first four tries yield those results.

--D
