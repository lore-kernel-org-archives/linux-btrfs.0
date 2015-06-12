Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:65451 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751170AbbFLHag convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Jun 2015 03:30:36 -0400
Message-ID: <557A890D.8080306@cn.fujitsu.com>
Date: Fri, 12 Jun 2015 15:23:57 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Steve Dainard <sdainard@spd1.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: Can't mount btrfs volume on rbd
References: <CAEMJtDs=U5+YO9sbVvjxLthdxp6JvZO=07EMhcU5Smif_1m5QQ@mail.gmail.com>
In-Reply-To: <CAEMJtDs=U5+YO9sbVvjxLthdxp6JvZO=07EMhcU5Smif_1m5QQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



-------- Original Message  --------
Subject: Can't mount btrfs volume on rbd
From: Steve Dainard <sdainard@spd1.com>
To: <linux-btrfs@vger.kernel.org>
Date: 2015年06月11日 23:26

> Hello,
>
> I'm getting an error when attempting to mount a volume on a host that
> was forceably powered off:
>
> # mount /dev/rbd4 climate-downscale-CMIP5/
> mount: mount /dev/rbd4 on /mnt/climate-downscale-CMIP5 failed: Stale file handle
>
> /var/log/messages:
> Jun 10 15:31:07 node1 kernel: rbd4: unknown partition table
>
> # parted /dev/rbd4 print
> Model: Unknown (unknown)
> Disk /dev/rbd4: 36.5TB
> Sector size (logical/physical): 512B/512B
> Partition Table: loop
> Disk Flags:
>
> Number  Start  End     Size    File system  Flags
>   1      0.00B  36.5TB  36.5TB  btrfs
>
> # btrfs check --repair /dev/rbd4
> enabling repair mode
> Checking filesystem on /dev/rbd4
> UUID: dfe6b0c8-2866-4318-abc2-e1e75c891a5e
> checking extents
> cmds-check.c:2274: check_owner_ref: Assertion `rec->is_root` failed.
> btrfs[0x4175cc]
> btrfs[0x41b873]
> btrfs[0x41c3fe]
> btrfs[0x41dc1d]
> btrfs[0x406922]
>
>
> OS: CentOS 7.1
> btrfs-progs: 3.16.2
The btrfs-progs seems quite old, and the above btrfsck error seems quite
possible related to the old version.

Would you please upgrade btrfs-progs to 4.0 and see what will happen?
Hopes it can give better info.

BTW, it's a good idea to call btrfs-debug-tree /dev/rbd4 to see the output.

Thanks
Qu.
> Ceph: version: 0.94.1/CentOS 7.1
>
> I haven't found any references to 'stale file handle' on btrfs.
>
> The underlying block device is ceph rbd, so I've posted to both lists
> for any feedback. Also once I reformatted btrfs I didn't get a mount
> error.
>
> The btrfs volume has been reformatted so I won't be able to do much
> post mortem but I'm wondering if anyone has some insight.
>
> Thanks,
> Steve
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
