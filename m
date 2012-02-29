From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Btrfs Storage Array Corrupted
Date: Wed, 29 Feb 2012 08:59:26 -0500
Message-ID: <20120229135926.GB5054@shiny>
References: <CAPeorG-1EtMAu9XzSNqMW-=QwhN-_bZorLXy9Pr5N+J-LKPzTg@mail.gmail.com>
 <4F4D8259.2090209@oracle.com>
 <20120229025027.GB15383@shiny>
 <CAPeorG_-z-UuVrzUhLucMnPg5QxUcQKh4r23ut6fOLObxL4C8A@mail.gmail.com>
 <CAE5mzvixYURzdNX3snjjJESUNUBz316YjzDxfZe6-Q2TGBMYww@mail.gmail.com>
 <CAPeorG9E0SDXqoa7VeUASxAbtBf+voQVRgfZ_FtOb3d6nbe-ZQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: cwillu <cwillu@cwillu.com>, Gurudas Pai <gurudas.pai@oracle.com>,
	linux-btrfs@vger.kernel.org
To: Travis Shivers <ttshivers@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAPeorG9E0SDXqoa7VeUASxAbtBf+voQVRgfZ_FtOb3d6nbe-ZQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 28, 2012 at 09:36:35PM -0600, Travis Shivers wrote:
> I upgraded my kernel so my version is now:
> Linux server 3.3.0-030300rc5-generic #201202251535 SMP Sat Feb 25
> 20:36:29 UTC 2012 x86_64 x86_64 x86_64 GNU/Linux
>=20
> The problem has not been solved and I still get the previous errors.

Ok,

Step one is to grab the development version of btrfs-progs, which
currently sits in the dangerdonteveruse branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git dan=
gerdonteveruse

Run btrfs-debug-tree -R /dev/sdh

and then run btrfs-debug-tree -b 5568194695168 /dev/sdh

and then run btrfsck /dev/sdh

Send the results of all three here, it should tell us which tree that
block belongs to, and from there we'll figure out the best way to fix
it.

-chris

>=20
> # mount /dev/sdh /mnt/main
> mount: wrong fs type, bad option, bad superblock on /dev/sdh,
>        missing codepage or helper program, or other error
>        In some cases useful info is found in syslog - try
>        dmesg | tail  or so
>=20
> # dmesg
> [  232.985248] device fsid 2c11a326-5630-484e-9f1d-9dab777a1028 devid
> 4 transid 43477 /dev/sdi
> [  232.985434] device fsid 2c11a326-5630-484e-9f1d-9dab777a1028 devid
> 3 transid 43477 /dev/sdh
> [  233.027881] device fsid 2c11a326-5630-484e-9f1d-9dab777a1028 devid
> 2 transid 43477 /dev/sdg
> [  233.065675] device fsid 2c11a326-5630-484e-9f1d-9dab777a1028 devid
> 1 transid 43476 /dev/sdf
> [  284.384320] device fsid 2c11a326-5630-484e-9f1d-9dab777a1028 devid
> 3 transid 43477 /dev/sdh
> [  284.427076] btrfs: disk space caching is enabled
> [  284.442565] verify_parent_transid: 2 callbacks suppressed
> [  284.442572] parent transid verify failed on 5568194695168 wanted
> 43477 found 43151
> [  284.442834] parent transid verify failed on 5568194695168 wanted
> 43477 found 43151
> [  284.443151] parent transid verify failed on 5568194695168 wanted
> 43477 found 43151
> [  284.443159] parent transid verify failed on 5568194695168 wanted
> 43477 found 43151
> [  284.445740] btrfs: open_ctree failed
>=20
>=20
> On Tue, Feb 28, 2012 at 9:16 PM, cwillu <cwillu@cwillu.com> wrote:
> > On Tue, Feb 28, 2012 at 9:00 PM, Travis Shivers <ttshivers@gmail.co=
m> wrote:
> >> Where should I grab the source from? The main repo that you have
> >> listed on your main wiki page
> >> (https://btrfs.wiki.kernel.org/articles/b/t/r/Btrfs_source_reposit=
ories.html)
> >> is down: git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs=
-progs-unstable.git
> >
> > The btrfs wiki is at http://btrfs.ipv5.de . =A0The kernel.org one i=
s a
> > static snapshot of the contents made nearly a year ago, prior to th=
e
> > kernel.org break-in, and should be ignored.
> >
> > git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git=
 is
> > the development tree, although the above patch is in mainline as of
> > 3.3rc5, which probably makes that the easiest way to try it.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
