From: Yan Zheng <ukernel@gmail.com>
Subject: Re: space info full
Date: Sat, 04 Oct 2008 20:17:23 +0800
Message-ID: <48E75ED3.1000404@gmail.com>
References: <200810040945.56118.mbuerger@edu.uni-klu.ac.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: linux-btrfs@vger.kernel.org
To: =?UTF-8?B?TWFydGluIELDvHJnZXI=?= <mbuerger@edu.uni-klu.ac.at>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200810040945.56118.mbuerger@edu.uni-klu.ac.at>
List-ID: <linux-btrfs.vger.kernel.org>

Martin B=C3=BCrger wrote:
> Hello,
> 'space info full' was the only message I got from dmesg. df reports:
>=20
> /dev/sdb1             33551720  28504548   5047172 =20
> 85% /mnt/btrfstest

The output of df can be inaccurate. Although df shows the FS is 85% ful=
l,
It's possible the FS is completely full.

>=20
> df -i reports:
> /dev/sdb1                  0       0       0    -  /mnt/btrfstest
>=20
> Any (e.g., touch, rm) operation on that mounted filesystem lets the=20
> CPU rise and the system hang...

btrfs can't properly handle disk full condition currently. ENOSPC can
result in BUG()

>=20
> I was filling up the partition with compilebench to the ration=20
> mentioned above. During this process I tried to create a subvolume=20
> with
> 	btrfsctl -s sub_vol /mnt/btrfstest
> which did not, as opposed to the advices from the INSTALL file,=20
> create anything within /mnt/btrfstest.

Please try mount the FS with -o subvol=3D. option, you will see the new
subvol.

Regards
Yan Zheng
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
