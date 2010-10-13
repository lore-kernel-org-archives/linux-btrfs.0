From: Chris Mason <chris.mason@oracle.com>
Subject: Re: the idea for improving the performance of b-tree search
Date: Wed, 13 Oct 2010 11:45:45 -0400
Message-ID: <20101013154545.GW22691@think>
References: <4CB57548.7000304@cn.fujitsu.com>
 <20101013112445.GP22691@think>
 <AANLkTimC=HXPBMxcCL5dx0edN-Z+XzcHpe+G5Bi1hqoX@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: David Nicol <davidnicol@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTimC=HXPBMxcCL5dx0edN-Z+XzcHpe+G5Bi1hqoX@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 13, 2010 at 10:22:30AM -0500, David Nicol wrote:
> On Wed, Oct 13, 2010 at 6:24 AM, Chris Mason <chris.mason@oracle.com>=
 wrote:
>=20
> > 3) Do delayed inode deletion. =A0See above, but change the word ins=
ert
> > with delete ;)
>=20
> And the reserved-for-the-future-but-not-used-yet flags field in the
> ioctl#21 control structure gets a use: bits to indicate for the
> completion of which of the potential delayed things the caller is
> waiting.

This is similar to the delayed allocation we already do for file data
extents.  It is supposed to be transparent to userland, and just a way
to more efficiently poke the on disk structures.

-chris
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
