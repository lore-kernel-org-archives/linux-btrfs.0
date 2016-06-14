Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33030 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932125AbcFNSWe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jun 2016 14:22:34 -0400
Date: Tue, 14 Jun 2016 11:24:04 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: Eryu Guan <guaneryu@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: BUG: unable to mount btrfs on ppc64 starting from v4.7-rc3 kernel
Message-ID: <20160614182404.GA4398@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <20160614111322.GN10350@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160614111322.GN10350@eguan.usersys.redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On Tue, Jun 14, 2016 at 07:13:22PM +0800, Eryu Guan wrote:
> Hi,
> 
> I'm unable to mount btrfs on ppc64 hosts and other hosts with 64k
> pagesize(like aarch64, ppc64le). It seems that it's commit 99e3ecfcb9f4
> ("Btrfs: add more validation checks for superblock") introduced this
> failure, btrfs fails stripesize check.
> 
> [root@ibm-p8-kvm-09-guest-06 btrfs-progs]# uname -r
> 4.7.0-rc3
> [root@ibm-p8-kvm-09-guest-06 btrfs-progs]# ./mkfs.btrfs -f /dev/vda3
> btrfs-progs v4.4
> See http://btrfs.wiki.kernel.org for more information.
> 
> Label:              (null)
> UUID:               06813ff6-d585-4c54-b4df-b7d6920d27ba
> Node size:          65536
> Sector size:        65536
> Filesystem size:    15.00GiB
> Block group profiles:
>   Data:             single            8.00MiB
>   Metadata:         DUP               1.01GiB
>   System:           DUP              12.00MiB
> SSD detected:       no
> Incompat features:  extref, skinny-metadata
> Number of devices:  1
> Devices:
>    ID        SIZE  PATH
>     1    15.00GiB  /dev/vda3
> 
> [root@ibm-p8-kvm-09-guest-06 btrfs-progs]# mount /dev/vda3 /mnt
> mount: wrong fs type, bad option, bad superblock on /dev/vda3,
>        missing codepage or helper program, or other error
> 
>        In some cases useful info is found in syslog - try
>        dmesg | tail or so.
> [root@ibm-p8-kvm-09-guest-06 btrfs-progs]# dmesg | tail
> ...
> [ 1910.048650] BTRFS: device fsid 06813ff6-d585-4c54-b4df-b7d6920d27ba devid 1 transid 3 /dev/vda3
> [ 1913.152085] BTRFS error (device vda3): invalid stripesize 4096
> [ 1913.154349] BTRFS error (device vda3): superblock contains fatal errors
> [ 1913.200300] BTRFS: open_ctree failed

Ah, that's right, we need to update btrfs-progs to set super_stripesize to
sectorsize.

In mkfs.c we have,

{
	u32 sectorsize = 4096;
	u32 stripesize = 4096;
	...
	sectorsize = max(sectorsize, (u32)sysconf(_SC_PAGESIZE));
	...
	mkfs_cfg.sectorsize = sectorsize;
	mkfs_cfg.stripesize = stripesize;

	ret = make_btrfs(fd, &mkfs_cfg, NULL);
	...
}

Thanks,

-liubo
