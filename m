Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:41575 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310AbaAVSll (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 Jan 2014 13:41:41 -0500
Received: by mail-la0-f48.google.com with SMTP id mc6so649008lab.35
        for <linux-btrfs@vger.kernel.org>; Wed, 22 Jan 2014 10:41:40 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 22 Jan 2014 13:41:39 -0500
Message-ID: <CANjusZco21bRxgdfTPrW6L9_2MD8GgBXayDHBQx=QMBxwTLHeg@mail.gmail.com>
Subject: ERROR: error removing the device '/dev/sdf' - Input/output error
From: "G. Michael Carter" <mikey@carterfamily.ca>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

How do I get around this.  The drive /dev/sdf has bad sectors.

Label: Store_01  uuid: ae612523-63cf-4860-a2cb-83a26d907e43
    Total devices 5 FS bytes used 7.51TiB
    devid    1 size 0.00 used 77.00GiB path /dev/sdf
    devid    3 size 1.82TiB used 1.41TiB path /dev/sdd
    devid    4 size 2.73TiB used 2.32TiB path /dev/sda
    devid    5 size 2.73TiB used 2.32TiB path /dev/sdb
    devid    6 size 1.82TiB used 1.41TiB path /dev/sdc

Btrfs v3.12
Data, RAID0: total=1.86TiB, used=1.85TiB
Data, single: total=5.65TiB, used=5.64TiB
System, RAID1: total=32.00MiB, used=732.00KiB
Metadata, RAID1: total=10.00GiB, used=8.69GiB

btrfs device delete /dev/sdf /mnt/Store
ERROR: error removing the device '/dev/sdf' - Input/output error

I've tried rebalancing as much of the data off the drive I can.  But
there's still bits in that 77GB that's good data.

Is there a way of having btrfs skip around the input/output error and
then force the drive to remove?
