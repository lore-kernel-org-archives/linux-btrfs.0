From: =?UTF-8?B?QWRhbSBLxYJvYnVrb3dza2k=?= <adamklobukowski@gmail.com>
Subject: Re: fsck.btrfs dumps core
Date: Thu, 25 Feb 2010 15:19:28 +0100
Message-ID: <4B8686F0.2040400@gmail.com>
References: <4B8638AD.5090408@gmail.com> <4B86845F.7080500@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4B86845F.7080500@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

W dniu 25.02.2010 15:08, jim owens pisze:
> Adam K=C5=82obukowski wrote:
>> Hello
>>
>> I'm running Ubuntu Lucid (2.6.32-14-generic-pae #20-Ubuntu SMP Sat F=
eb
>> 20 07:07:46 UTC 2010 i686 GNU/Linux)
>>
>> Doing online fsck.btrfs on 2TB volume dumps core:
>=20
> fsck with the fs mounted is not supported.
>=20
> there is a pending patch for fsck.btrfs to prevent it from
> running instead of failing in ugly ways.

Ok.

Is it possible to find out if I've done any harm to the fs by trying to
do online fsck?

Adam Klobukowski

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
