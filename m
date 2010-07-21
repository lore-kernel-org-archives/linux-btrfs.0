From: Chris Mason <chris.mason@oracle.com>
Subject: Re: File cloning across subvolumes with BTRFS_IOC_CLONE ioctl
Date: Wed, 21 Jul 2010 11:32:24 -0400
Message-ID: <20100721153224.GY3133@think>
References: <20100720053934.GA14402@epicurus>
 <AANLkTil_bqyOwBIlkdZGyn1HAVKBMuEu4cem2UAhei3A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: redneb <redneb@gmx.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
To: =?iso-8859-1?B?Suly9G1l?= Poulin <jeromepoulin@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTil_bqyOwBIlkdZGyn1HAVKBMuEu4cem2UAhei3A@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 21, 2010 at 11:11:13AM -0400, J=E9r=F4me Poulin wrote:
> I've got the same problem, and that post clearly seems to say it is p=
ossible.
> cp --reflink=3Dalways source subvolume1/   gives me:
> cp: failed to clone `xxxx': Invalid cross-device link
>=20
> Even on the same subvolume I get 10% of the files telling me the same=
=2E
>=20
> btrfs-bcp copy the files in its integrity.

Ok, this is a bug in the ioctl.  I'll fix it up.

-chris
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
