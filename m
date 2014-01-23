Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:56563 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752557AbaAWCFm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 Jan 2014 21:05:42 -0500
Received: from c-50-183-15-223.hsd1.co.comcast.net ([50.183.15.223]:53923 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1W69fp-000oiv-9r
	for linux-btrfs@vger.kernel.org; Wed, 22 Jan 2014 19:05:41 -0700
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: ERROR: error removing the device '/dev/sdf' - Input/output error
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <CANjusZco21bRxgdfTPrW6L9_2MD8GgBXayDHBQx=QMBxwTLHeg@mail.gmail.com>
Date: Wed, 22 Jan 2014 19:05:40 -0700
Message-Id: <0F112FF1-AED4-41E4-89C2-3CB62F9E93A0@colorremedies.com>
References: <CANjusZco21bRxgdfTPrW6L9_2MD8GgBXayDHBQx=QMBxwTLHeg@mail.gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jan 22, 2014, at 11:41 AM, G. Michael Carter <mikey@carterfamily.ca> wrote:

> How do I get around this.  The drive /dev/sdf has bad sectors.
> 
> Label: Store_01  uuid: ae612523-63cf-4860-a2cb-83a26d907e43
>    Total devices 5 FS bytes used 7.51TiB
>    devid    1 size 0.00 used 77.00GiB path /dev/sdf

size 0.00 used 77.00 GB? Does this even make sense?

>    devid    3 size 1.82TiB used 1.41TiB path /dev/sdd
>    devid    4 size 2.73TiB used 2.32TiB path /dev/sda
>    devid    5 size 2.73TiB used 2.32TiB path /dev/sdb
>    devid    6 size 1.82TiB used 1.41TiB path /dev/sdc
> 
> Btrfs v3.12
> Data, RAID0: total=1.86TiB, used=1.85TiB
> Data, single: total=5.65TiB, used=5.64TiB
> System, RAID1: total=32.00MiB, used=732.00KiB
> Metadata, RAID1: total=10.00GiB, used=8.69GiB
> 
> btrfs device delete /dev/sdf /mnt/Store
> ERROR: error removing the device '/dev/sdf' - Input/output error

Seems it can only be removed if all of the data on that device are successfully migrated to other devices.

> 
> I've tried rebalancing as much of the data off the drive I can.  But
> there's still bits in that 77GB that's good data.
> 
> Is there a way of having btrfs skip around the input/output error and
> then force the drive to remove?

It's a valid question for both raid0 and single data profiles, if there will one day be a possibility to tolerate read errors, migrate what can be migrated and then permit (bad) device removal. Already a scrub would identify corrupt files. An additional feature would be a way to cause corrupted files to be easily deleted.

In a case of multiple device raid0, without a regular balance being a requirement, I could very easily start with two disks, add two more disks, and so on, and end up with a significant amount of completely valid data that survives a one disk failure. Clearly the file system itself is OK due to metadata raid1.


Chris Murphy