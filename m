From: Chris Mason <chris.mason@oracle.com>
Subject: Re: BTRFS fsck ?
Date: Tue, 22 Nov 2011 17:31:40 -0500
Message-ID: <20111122223140.GT28259@shiny>
References: <4ECB8A60.2020402@chibois.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: linux-btrfs@vger.kernel.org
To: =?iso-8859-1?Q?Herv=E9?= CHIBOIS <herve@chibois.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4ECB8A60.2020402@chibois.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 22, 2011 at 12:41:20PM +0100, Herv=E9 CHIBOIS wrote:
> Hello Team
>=20
> for personnal use, I'm interested in cosolidating all my ext4
> sub-filesystems into a single one using BTRFS.
>=20
> I can"t afford loosing my data... and my question is : is there a
> release date for the fsck tool for btrfs ?
>=20
> Thanx in advance

I've set myself up for disappointment with release dates in the past.

We've found put some really important corruption fixes into the 3.2
merge window, and the current for-linus branch of the btrfs kernel repo
has a fix for write cache flushing bugs that are probably responsible
for most of the corruptions people have seen with power failures.

With this settled down, I'm back on fsck full time.

-chris

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
