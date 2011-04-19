From: cwillu <cwillu@cwillu.com>
Subject: Re: Fwd: module/kernel crash while trying to delete missing device/balance
Date: Tue, 19 Apr 2011 07:19:33 -0600
Message-ID: <BANLkTi=mMmK0mKwSGFXE5M6xJOZ-TeJrSA@mail.gmail.com>
References: <BANLkTim+b7sApGb_0=g2Po0+swoMunOd7A@mail.gmail.com>
	<BANLkTinYEiWgw3ykLYr8yqLicjP7v1F5Hg@mail.gmail.com>
	<1303214237-sup-2056@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: brandon lansing <imraven@gmail.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1303214237-sup-2056@think>
List-ID: <linux-btrfs.vger.kernel.org>

>> [ 1770.041623] ------------[ cut here ]------------
>> [ 1770.041655] kernel BUG at /build/buildd/linux-2.6.35/fs/btrfs/vol=
umes.c:3037!
>> [ 1770.041684] invalid opcode: 0000 [#1] SMP
>> [ 1770.041707] last sysfs file: /sys/devices/virtual/bdi/btrfs-3/uev=
ent
>> [ 1770.041734] CPU 1
>> [ 1770.041744] Modules linked in: btrfs sha256_generic cryptd
>
> Could you please attached the fs/btrfs/volumes.c from this distro
> kernel? =C2=A0It'll help us figure out what is going wrong.

Btrfs is unpatched in ubuntu, it's just 2.6.35's fs/btrfs.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
