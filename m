Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:34516 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226AbcFNLNb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jun 2016 07:13:31 -0400
Received: by mail-pa0-f47.google.com with SMTP id bz2so55634618pad.1
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Jun 2016 04:13:30 -0700 (PDT)
Date: Tue, 14 Jun 2016 19:13:22 +0800
From: Eryu Guan <guaneryu@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Liu Bo <bo.li.liu@oracle.com>
Subject: BUG: unable to mount btrfs on ppc64 starting from v4.7-rc3 kernel
Message-ID: <20160614111322.GN10350@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I'm unable to mount btrfs on ppc64 hosts and other hosts with 64k
pagesize(like aarch64, ppc64le). It seems that it's commit 99e3ecfcb9f4
("Btrfs: add more validation checks for superblock") introduced this
failure, btrfs fails stripesize check.

[root@ibm-p8-kvm-09-guest-06 btrfs-progs]# uname -r
4.7.0-rc3
[root@ibm-p8-kvm-09-guest-06 btrfs-progs]# ./mkfs.btrfs -f /dev/vda3
btrfs-progs v4.4
See http://btrfs.wiki.kernel.org for more information.

Label:              (null)
UUID:               06813ff6-d585-4c54-b4df-b7d6920d27ba
Node size:          65536
Sector size:        65536
Filesystem size:    15.00GiB
Block group profiles:
  Data:             single            8.00MiB
  Metadata:         DUP               1.01GiB
  System:           DUP              12.00MiB
SSD detected:       no
Incompat features:  extref, skinny-metadata
Number of devices:  1
Devices:
   ID        SIZE  PATH
    1    15.00GiB  /dev/vda3

[root@ibm-p8-kvm-09-guest-06 btrfs-progs]# mount /dev/vda3 /mnt
mount: wrong fs type, bad option, bad superblock on /dev/vda3,
       missing codepage or helper program, or other error

       In some cases useful info is found in syslog - try
       dmesg | tail or so.
[root@ibm-p8-kvm-09-guest-06 btrfs-progs]# dmesg | tail
...
[ 1910.048650] BTRFS: device fsid 06813ff6-d585-4c54-b4df-b7d6920d27ba devid 1 transid 3 /dev/vda3
[ 1913.152085] BTRFS error (device vda3): invalid stripesize 4096
[ 1913.154349] BTRFS error (device vda3): superblock contains fatal errors
[ 1913.200300] BTRFS: open_ctree failed

Thanks,
Eryu
