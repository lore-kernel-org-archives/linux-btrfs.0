From: jim owens <owens6336@gmail.com>
Subject: Re: fsck.btrfs dumps core
Date: Thu, 25 Feb 2010 09:08:31 -0500
Message-ID: <4B86845F.7080500@gmail.com>
References: <4B8638AD.5090408@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Cc: linux-btrfs@vger.kernel.org
To: =?UTF-8?B?QWRhbSBLxYJvYnVrb3dza2k=?= <adamklobukowski@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4B8638AD.5090408@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Adam K=C5=82obukowski wrote:
> Hello
>=20
> I'm running Ubuntu Lucid (2.6.32-14-generic-pae #20-Ubuntu SMP Sat Fe=
b
> 20 07:07:46 UTC 2010 i686 GNU/Linux)
>=20
> Doing online fsck.btrfs on 2TB volume dumps core:

fsck with the fs mounted is not supported.

there is a pending patch for fsck.btrfs to prevent it from
running instead of failing in ugly ways.

jim
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
