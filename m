From: Hubert Kario <hka@qbs.com.pl>
Subject: Re: [PATCH v2 0/5] Allow for quick removing of btrfs signature from block device
Date: Tue, 01 May 2012 15:37:17 +0200
Message-ID: <1769220.qV8MmucAeC@bursa01>
References: <1335875886-12087-1-git-send-email-kario@wit.edu.pl> <20120501124337.GA21063@mother.jarsat.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: linux-btrfs@vger.kernel.org
To: Tomasz Torcz <tomek@pipebreaker.pl>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120501124337.GA21063@mother.jarsat.pl>
List-ID: <linux-btrfs.vger.kernel.org>

On Tuesday 01 of May 2012 14:43:37 Tomasz Torcz wrote:
> On Tue, May 01, 2012 at 02:38:01PM +0200, Hubert Kario wrote:
> > This patch series adds `btrfs device zero super <dev>` command to r=
emove
> > the btrfs signature from the device as well as fix few minor proble=
ms in
> > btrfs_prepare_device function.
>=20
>   Shouldn't you rather extend =E2=80=9Cwipefs=E2=80=9D from util-linu=
x?

wipefs v.2.21.1 does detect btrfs so there's no need to.

I'd guess that most people will be thinking about btrfs RAID management=
 in LVM=20
or MD terms, so the zero-superblock option should be available in the b=
trfs=20
tool proper (as similar option is avaiable in mdadm).

Adding it is trivial (look at my V1 patch) and does not introduce speci=
al=20
code.

What's more, wipefs demages only the first superblock (so the fs is sti=
ll=20
mountable using btrfs-select-super -s 1 <dev>), while btrfs device zero=
-
superblock removes all superblocks.

Regards,
--=20
Hubert Kario
QBS - Quality Business Software
02-656 Warszawa, ul. Ksawer=C3=B3w 30/85
tel. +48 (22) 646-61-51, 646-74-24
www.qbs.com.pl
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
