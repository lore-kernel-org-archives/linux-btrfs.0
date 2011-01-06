From: =?UTF-8?B?SXZhbiBMYWLDoXRo?= <ilabath@gmail.com>
Subject: Re: raw fs backup/copy
Date: Thu, 06 Jan 2011 20:26:10 +0100
Message-ID: <4D261752.9030800@gmail.com>
References: <4D25EFA0.9010809@gmail.com> <20110106183507.GA19633@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Hugo Mills <hugo-lkml@carfax.org.uk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110106183507.GA19633@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

On 01/06/11 19:35, Hugo Mills wrote:
> On Thu, Jan 06, 2011 at 05:36:48PM +0100, Ivan Lab=C3=A1th wrote:
>> Is there a reason one can not mount a btrfs and it's byte-for-byte
>> copy in parallel, or is the driver just acting silly?
>=20
>    Probably because both filesystems have identical UUIDs (and labels=
)
> and so will (I suspect) end up being identified as the same filesyste=
m
> by the btrfs code.
>=20
>    Hugo.
>=20

The reason I ask is, that I had a mirror RAID (btrfs on LVM on LUKS on =
RAID)
across 2 disks. Then I snatched one to take with me when going away for
holidays, copied some files on to it and when I came back, I wanted to =
get
to those files. The problem was, I couldn't mount the fs I took with me=
,
because a similar fs was already mounted. As it wasn't the root fs,
I could unmount it and copy the files on some other fs
(though one could use pivot_root, if it was the root fs).

It seems to me there are cases, where one would want to mount two copie=
s of
originally the same filesystem - think of RAID, VMs, distributing fs im=
ages
on a network, LVM snapshots, backups, etc.

--
ivan
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
