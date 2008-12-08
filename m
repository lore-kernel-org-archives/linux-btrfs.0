From: dcg <diegocalleja@gmail.com>
Subject: Re: No space left on device
Date: Mon, 8 Dec 2008 15:02:30 +0100
Message-ID: <20081208150230.699aa8b7@diego-desktop>
References: <1228729585.6954.26.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Gabor MICSKO <gabor.micsko@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1228729585.6954.26.camel@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

El Mon, 08 Dec 2008 10:46:25 +0100, Gabor MICSKO <gabor.micsko@gmail.co=
m> escribi=C3=B3:

> # df -h
> [...]
> /dev/sdb1              75G   61G   15G  81% /media/coolermaster
>=20
> It seems like i have 15GB free space on the btrfs formatted partition=
,
> but when i try to create a file of 4GB on the btrfs filesystem i get =
the
> following error:


btrfs has an (artificial) limit of 85% of the space which won't be lift=
ed until
the allocation code is mature. So you can't use the 100% for now...that
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
