Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp73.iad3a.emailsrvr.com ([173.203.187.73]:53253 "EHLO
        smtp73.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754102AbeAKLuI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Jan 2018 06:50:08 -0500
Subject: Re: recommendations and contraindications of using btrfs for Oracle
 Database Server
To: Ext-Strii-Houttemane Philippe <Philippe.Houttemane@cetim.fr>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <8444d2a08c8f4e8dab2ee48139ce5bb9@AQUILON.cetim.priv>
From: Marat Khalili <mkh@rqc.ru>
Message-ID: <5b918559-4db5-5d83-3db0-1bf4bb0c55d7@rqc.ru>
Date: Thu, 11 Jan 2018 14:49:31 +0300
MIME-Version: 1.0
In-Reply-To: <8444d2a08c8f4e8dab2ee48139ce5bb9@AQUILON.cetim.priv>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'd advice to migrate from this configuration ASAP. Each of the 
following is enough reason to do so:

1. Running BTRFS on top of kernel 3.10 (there can be vendor backports, 
but most likely they only include absolutely critical fixes for the 
BTRFS part, not the whole stuff). And RedHat (that's your vendor, 
right?) recently abandoned BTRFS.

2. Running a database on top of BTRFS with snapshots, unless write load 
is very light and snapshots are very rare and few.

Besides, taking storage snapshots is hardly a good way to backup 
databases. Oracle certainly provides better methods like online replication.

On 11/01/18 13:51, Ext-Strii-Houttemane Philippe wrote:
> ORA-63999: data file suffered media failure
> ORA-01114: IO error writing block to file 99 (block # 99994)
> ORA-01110: data file 99: '/oradata/PS92PRD/data/pcapp.dbf'
> ORA-27072: File I/O error
> Linux-x86_64 Error: 5: Input/output error
> Additional information: 4
> Additional information: 99994
There might be messages in syslog/dmesg about this.

> It nevers append with over filesystem types, all the hardware has been checked.
> I suspect a Btrfs activated feature via our mount options instead of a bug: Oracle see a ghost or a duplicated bloc even if copy on cow feature is disabled.
Never saw this even while using BTRFS on kernel 3.11. But note that 
snapshots kind of disable nodatacow, so you still effectively have cow 
among them (that's the price of convenience).

> Mount options: defaults,nofail,nodatacow,nobarrier,noatime
"nobarrier" looks a bit scary, unless you're using some fancy 
battery-backed controller.

> btrfs fi show:
> Label: 'oradataBtrfs'
>          Total devices 1 FS bytes used 1.98TiB
>          devid    1 size 3.18TiB used 2.02TiB path /dev/sdb1
At least you are not using BTRFS RAID in this configuration, good.

--

With Best Regards,
Marat Khalili
