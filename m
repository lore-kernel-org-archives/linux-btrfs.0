From: Josef Bacik <josef@redhat.com>
Subject: Re: very poor read / write performance compared to other FS's?
Date: Thu, 12 May 2011 11:39:01 -0400
Message-ID: <20110512153901.GA19041@dhcp231-156.rdu.redhat.com>
References: <BANLkTinRa9TdVOAaMt9_gcR2xDhbDWVJcA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: linux-btrfs@vger.kernel.org
To: Marek Fstump <marekfstump@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BANLkTinRa9TdVOAaMt9_gcR2xDhbDWVJcA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 11, 2011 at 11:33:35PM +0100, Marek Fstump wrote:
> Hi
>=20
> I am very interested in using BTRFS for my solution but in basic test=
s
> it seems to be very poor on read and write performance.  I am
> surprised by this so suspect that maybe I am doing something
> incorrectly or that there are updates I should be using, but I am not
> sure how I update BTRFS on SLES11
>=20
> Summary:
> RESULTS on link below
> SLES11 SP1
> Compared Sequential read/write performance against XFS and OCFS2
> Backend storage =E2=80=93 FusionIO SLC SSD =3D circa 750MBsec
>=20
> Tests  set as follows:
> Filesystem contains 30 x 4GB files (made of random data)
> Read tests will read from 1 to 30 files concurrently
> Write tests will write 1 to 30 concurrent NEW files (simple 000=E2=80=
=99s)
> dd -direct flag used on writes
>=20
> All defaults used for mounting etc.
>=20
> Results shown in attachment.
>=20
> BTRFS looks an excellent FS and perfect for my application and I am
> hoping that there are some factors that I am missing
> and would appreciate any advice / help
>=20

Yeah our O_DIRECT performance is less than stellar, I just did a bunch =
of work
to try and help us get a little better performance.  Would you mind pul=
ling
down linus's git tree and testing on that and seeing if you get better
performance?  Thanks,

Josef
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
