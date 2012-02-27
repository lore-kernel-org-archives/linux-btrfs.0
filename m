From: Nageswara R Sastry <rnsastry@linux.vnet.ibm.com>
Subject: Re: [BUG] Kernel Bug at fs/btrfs/volumes.c:3638
Date: Mon, 27 Feb 2012 11:26:28 +0530
Message-ID: <4F4B1B0C.4040100@linux.vnet.ibm.com>
References: <4F476959.2010400@linux.vnet.ibm.com> <4F487BB5.1060706@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	chris.mason@oracle.com, kamalesh@linux.vnet.ibm.com
To: Liu Bo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F487BB5.1060706@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On =E0=B0=AB=E0=B0=BF=E0=B0=AC=E0=B1=8D=E0=B0=B0=E0=B0=B5=E0=B0=B0=E0=B0=
=BF 25 =E0=B0=B6=E0=B0=A8=E0=B0=BF=E0=B0=B5=E0=B0=BE=E0=B0=B0=E0=B0=82 =
2012 =E0=B0=89. 11:42, Liu Bo wrote:
> Hi, I guess you're mounting a quite small partition. Given that this=20
> oops is in such an early stage, could you please show 1) your=20
> mkfs.btrfs options and 2) the log of "btrfs-debug-tree /dev/loop0"?=20
> thanks, liubo
Here are the steps with options,

1. dd if=3D/dev/zero of=3D<filename.img> bs=3D1M count=3D16

2. mkfs.btrfs <filename.img>

3. Corrupt the <filename.img> using 'mangle'

4. mount -t btrfs -o loop <filename.img> <mount point>

5. # btrfs-debug-tree <filename.img>
Couldn't map the block 3221392384
Couldn't read chunk root
unable to open <filename.img>
# btrfs-debug-tree /dev/loop0
Couldn't map the block 3221392384
Couldn't read chunk root
unable to open /dev/loop0

Regards,
R.Nageswara Sastry

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
