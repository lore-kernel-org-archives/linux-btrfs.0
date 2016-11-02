Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.knebb.de ([85.25.100.221]:55113 "EHLO mail.knebb.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754324AbcKBJJI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 2 Nov 2016 05:09:08 -0400
Received: from [192.168.0.229] (p5DE00D3E.dip0.t-ipconnect.de [93.224.13.62])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: cvoelker)
        by mail.knebb.de (Postfix) with ESMTPSA id 4954A9C0411
        for <linux-btrfs@vger.kernel.org>; Wed,  2 Nov 2016 10:25:04 +0100 (CET)
To: linux-btrfs@vger.kernel.org
From: =?UTF-8?Q?Christian_V=c3=b6lker?= <cvoelker@knebb.de>
Subject: Resizing BTRFS - raw partition
Message-ID: <92e3c63e-0301-7a25-7c56-56447a1948cc@knebb.de>
Date: Wed, 2 Nov 2016 09:58:41 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

I am using btrfs as follows:
root@srv:/srv# btrfs filesystem show
Label: none  uuid: c8f24351-ddc4-4866-843c-4e95fcb498d4
        Total devices 2 FS bytes used 1005.37GB
        devid    2 size 1.00TB used 1023.98GB path /dev/sdc
        devid    1 size 1.46TB used 1.00TB path /dev/sdb

Btrfs Btrfs v0.19

It is running inside a virtual machines running on VMware ESXi. I
increased both virtual disks to 1.5TB now. I did a scsi-rescan and fdisk
-l tells me the new size:
Disk /dev/sdb: 1610.6 GB, 1610612736000 bytes
Disk /dev/sdc: 1610.6 GB, 1610612736000 bytes

There are no partitions created on the disks, just raw devices used for
BTRFS. I found several sites where they resized a btrfs filesystem based
on LVM and the new size was immediately recognized. But how to do on raw
partitions?

How do I tell btrfs the devices have been resized?
I did not find a rescan command. btrfs scan does not change anything. 
Do I really have to reboot?

Thanks!

Christian

