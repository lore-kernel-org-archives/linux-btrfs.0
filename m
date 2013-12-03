Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ve0-f181.google.com ([209.85.128.181]:38969 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752535Ab3LCRDi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Dec 2013 12:03:38 -0500
Received: by mail-ve0-f181.google.com with SMTP id oy12so10370143veb.26
        for <linux-btrfs@vger.kernel.org>; Tue, 03 Dec 2013 09:03:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJtFHUSDn6TTd2MLuTmvX+pxitFQj2mwm7LuCoHNux8KgC-ZTQ@mail.gmail.com>
References: <CAJtFHUSDn6TTd2MLuTmvX+pxitFQj2mwm7LuCoHNux8KgC-ZTQ@mail.gmail.com>
Date: Tue, 3 Dec 2013 12:03:37 -0500
Message-ID: <CAJtFHUQn2w3tbTM6WyoXSvJ47t8NbATDGBvQB+b5QByhXAU9YA@mail.gmail.com>
Subject: Fwd: no space left on balance
From: E V <eliventer@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Looks like the same issue as kernel bugzilla 66221

just different config. debian wheezy with hand built 3.11.9. Ideas for
fixing would be great.
I guess I'll try deleting a couple snapshots and try again.

btrfs balance start -dconvert=single /mirror
ERROR: error during balancing '/mirror' - No space left on device

(btrfs file show && btrfs file df /mirror && df -h /mirror)
Label: isibackup  uuid: 550c0f77-8f75-40f3-a64e-42c87a0c8e8d
        Total devices 3 FS bytes used 83.42TiB
        devid    1 size 30.01TiB used 24.52TiB path /dev/sdb
        devid    2 size 30.01TiB used 24.52TiB path /dev/sdc
        devid    3 size 40.02TiB used 34.52TiB path /dev/sdd

Btrfs v0.20-rc1-335-gf00dd83
Data, RAID0: total=27.64TiB, used=27.64TiB
Data, single: total=55.65TiB, used=55.65TiB
System, RAID1: total=40.00MiB, used=7.84MiB
System, single: total=4.00MiB, used=0.00
Metadata, RAID1: total=134.00GiB, used=132.34GiB
Metadata, single: total=8.00MiB, used=0.00

Filesystem      Size  Used Avail Use% Mounted on
/dev/sdb        101T   84T   17T  84% /mirror
