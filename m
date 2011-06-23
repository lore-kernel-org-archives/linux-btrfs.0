From: Josef Bacik <josef@redhat.com>
Subject: Re: btrfs: failed to load =?iso-8859-1?Q?f?=
	=?iso-8859-1?Q?ree_space_cache_for_block_group_on_rsync=B4in?=
	=?iso-8859-1?Q?g?= to space_cache BTRFS with subvolume
Date: Thu, 23 Jun 2011 16:05:26 -0400
Message-ID: <20110623200526.GB21007@dhcp231-156.rdu.redhat.com>
References: <201106231937.12848.Martin@lichtvoll.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Martin Steigerwald <Martin@lichtvoll.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201106231937.12848.Martin@lichtvoll.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 23, 2011 at 07:37:12PM +0200, Martin Steigerwald wrote:
> Hi!
>=20
> Short summary: I suspect that rsync=B4ing files to a newly created BT=
RFS=20
> partition with a subvolume *and* enabled space_cache triggers the err=
or=20
> mentioned in the subject line of this mail. I reported this also as:
>=20
> Bug 38112 -  btrfs: failed to load free space cache for block group o=
n=20
> rsync=B4ing to space_cache BTRFS with subvolume
>=20
> https://bugzilla.kernel.org/show_bug.cgi?id=3D38112
>=20
> I will add a reference to my post here to the bug report, so feel fre=
e to=20
> use whatever suits you best to follow up.
>=20
>=20
> This happened on a ThinkPad T520 with 3.0.0-rc3-amd64 Debian/GNU Linu=
x=20
> kernel. The issue happened on a 2.5 inch external eSATA/USB harddisk =
which=20
> I changed to BTRFS. On the repoot after the rsync process was stalled=
 the=20
> unrelated non space cache using root filesystem did not mount anymore=
 with=20
> 3.0.0-rc3-amd64 and 2.6.39-2-amd64 kernel. But thankfully it did moun=
t=20
> with a 2.6.38 grml 2011 amd64 kernel and now work again.
>=20
>=20
> Thus I did
>=20
> merkaba:~> mkfs.btrfs -L daten /dev/sdc2
>=20
> WARNING! - Btrfs Btrfs v0.19 IS EXPERIMENTAL
> WARNING! - see http://btrfs.wiki.kernel.org before using
>=20
> fs created label daten on /dev/sdc2
>         nodesize 4096 leafsize 4096 sectorsize 4096 size 447.13GB
> Btrfs Btrfs v0.19
>=20
> merkaba:~> mount -o space_cache,compress=3Dlzo /dev/sdc2 /mnt/amazon-=
daten=20
> merkaba:~> dmesg | tail -3
> [137440.930038] device label daten devid 1 transid 7 /dev/sdc2
> [137440.930507] btrfs: enabling disk space caching
> [137440.930518] btrfs: use lzo compression
>=20
>=20
> Then I unmounted, added a fstab entry without space_cache option sinc=
e I=20
> read that once BTRFS created a space_cache it would use it anyway it =
is=20
> mounted with clear_cache to clear the cache again.
>=20
> I created a sub volume for movies, cause I wanted to be able to not=20
> snapshot the movie files:
>=20
> merkaba:~> btrfs subvolume create /mnt/amazon-daten/Filme
> Create subvolume '/mnt/amazon-daten/Filme'
>=20
> I then did my rsync from the backup which BTW was a BTRFS with space_=
cache=20
> as well - created today:
>=20
> merkaba:~> rsync -a -H --acls --xattrs --sparse /mnt/steigerwald-date=
n/=20
> /mnt/amazon-daten
>=20
> A short while after starting the rsync I got:
>=20

I've just posted a patch for this, sorry about that I've fixed this bef=
ore but
there has been recent work in this area to make it more generic and we =
lost that
particular fix.  Thanks,

Josef
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
