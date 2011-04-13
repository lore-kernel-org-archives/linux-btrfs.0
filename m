From: David Miller <davem@davemloft.net>
Subject: Re: Warning when mounting btrfs partition, kernel unaligned access
Date: Wed, 13 Apr 2011 10:48:31 -0700 (PDT)
Message-ID: <20110413.104831.189703153.davem@davemloft.net>
References: <4DA4DA5C.3050703@frankengul.org>
	<20110413094037.GL31675@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Cc: seb@frankengul.org, linux-btrfs@vger.kernel.org,
	sparclinux@vger.kernel.org, debian-sparc@lists.debian.org
To: dave@jikos.cz
Return-path: <sparclinux-owner@vger.kernel.org>
In-Reply-To: <20110413094037.GL31675@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

=46rom: David Sterba <dave@jikos.cz>
Date: Wed, 13 Apr 2011 11:40:37 +0200

> On Wed, Apr 13, 2011 at 01:03:56AM +0200, S=E9bastien Bernard wrote:
>> Then, after writing on the disk, I got a lot of warning:
>> [  822.515875] Kernel unaligned access at TPC[103c2204]
>>=20
>> I peeked a look at the btrf_csum_final and here's the function :
>> void btrfs_csum_final(u32 crc, char *result)
>> {
>>         *(__le32 *)result =3D ~cpu_to_le32(crc);
>> }
>=20
> FYI, this has been fixed and is already merged into Linus' tree. Comm=
it
> 7e75bf3ff3a716d7b21d8fb43bf823115801c1e9.

Might I suggest adding a BUG_ON() validation of the alignment or
similar here?

You can make the test really cheap, and this way no matter what kind
of systems the btrfs folks do their testing on this kind of regression
will be spotted fast.
--
To unsubscribe from this list: send the line "unsubscribe sparclinux" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
