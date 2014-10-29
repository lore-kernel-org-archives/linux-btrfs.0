Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39169 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751993AbaJ2C0R (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 Oct 2014 22:26:17 -0400
Message-ID: <54505040.6050004@redhat.com>
Date: Tue, 28 Oct 2014 21:26:08 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: [bug] df reports wrong Size and Avail on raid1, 3.18rc2
References: <B3CDA0F0-14F7-4539-B7FF-B2D2E5F7CAF2@colorremedies.com>
In-Reply-To: <B3CDA0F0-14F7-4539-B7FF-B2D2E5F7CAF2@colorremedies.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/28/14 9:19 PM, Chris Murphy wrote:
> 3.18.0-0.rc2.git1.1.fc22.x86_64
> btrfs-progs-3.17-1.fc21.x86_64
> 
> # btrfs fi show /mnt
> Label: 'btrfs1'  uuid: 0f1c615f-30a0-4166-8a3c-987849551513
> 	Total devices 2 FS bytes used 233.54GiB
> 	devid    1 size 465.76GiB used 236.03GiB path /dev/sdb
> 	devid    2 size 298.09GiB used 236.03GiB path /dev/sdc
> 
> # df -h /mnt
> Filesystem      Size  Used Avail Use% Mounted on
> /dev/sdb        382G  234G   65G  79% /mnt
> 
> 
> a. df -h should report Size as 298GiB rather than as 382GiB.
> Because this is 2 device raid1, the limiting factor is devid 2 @ 298GiB.
> 
> b. df -h should report Avail as 62GiB or less, rather than as 65GiB.
> 298.09 - 236.03 = 62.06

Is there an fstest for btrfs disk space reporting?

ext2/3/4 used to keep getting "overhead" wrong for various filesystem
types ... until we wrote a regression test.

Just sayin' :)

-Eric
