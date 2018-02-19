Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([46.4.129.203]:34584 "EHLO mail.virtall.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751628AbeBSIae (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Feb 2018 03:30:34 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Mon, 19 Feb 2018 17:30:26 +0900
From: Tomasz Chmielewski <tch@virtall.com>
To: Anand Jain <anand.jain@oracle.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: fatal database corruption with btrfs "out of space" with ~50 GB
 left
In-Reply-To: <d8289a56-5874-dfe9-60fd-72b3c06b1664@oracle.com>
References: <de1fdabb35ffe14eb92433ef444494e7@virtall.com>
 <d8289a56-5874-dfe9-60fd-72b3c06b1664@oracle.com>
Message-ID: <facafa76748644bd90a7cd283a0444f0@virtall.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-02-19 13:29, Anand Jain wrote:
> On 02/14/2018 10:19 PM, Tomasz Chmielewski wrote:
>> Just FYI, how dangerous running btrfs can be - we had a fatal, 
>> unrecoverable MySQL corruption when btrfs decided to do one of these 
>> "I have ~50 GB left, so let's do out of space (and corrupt some files 
>> at the same time, ha ha!)".
> 
>  Thanks for reporting.
> 
>> Running btrfs RAID-1 with kernel 4.14.
> 
>  Can you pls let us know..
>  1. What tool cli/reported/identified that data is corrupted?

mysqld log - mysqld would refuse to start because of database 
corruption.

And, the database wouldn't start even when "innodb_force_recovery = " 
was set to a high/max value.


In the past, with lower kernel versions, we had a similar issue with 
mongod - it wouldn't start anymore due to some corruption which happened 
when we hit "out of space" (again, with dozens of GBs free space).


>  2. Disk error stat using.. btrfs dev stat <mnt>
>     (dev stat is stored on disk)

# btrfs dev stat /var/lib/lxd
[/dev/sda3].write_io_errs    0
[/dev/sda3].read_io_errs     0
[/dev/sda3].flush_io_errs    0
[/dev/sda3].corruption_errs  0
[/dev/sda3].generation_errs  0
[/dev/sdb3].write_io_errs    0
[/dev/sdb3].read_io_errs     0
[/dev/sdb3].flush_io_errs    0
[/dev/sdb3].corruption_errs  0
[/dev/sdb3].generation_errs  0


>  3. Wheather the disk was mounted as degraded any time before?

No. Everything healthy with the disks.


Tomasz Chmielewski
https://lxadm.com
