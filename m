Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from lambda.cetim.fr ([93.20.250.198]:56292 "EHLO lambda.cetim.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933762AbeAKLQN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Jan 2018 06:16:13 -0500
Received: from lambda.cetim.fr (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 81DB2422D9
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Jan 2018 11:51:43 +0100 (CET)
Received: from lambda.cetim.fr (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 74003422D5
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Jan 2018 11:51:43 +0100 (CET)
Received: from aquilon.cetim.priv (unknown [172.16.9.29])
        by lambda.cetim.fr (Postfix) with ESMTPS
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Jan 2018 11:51:43 +0100 (CET)
From: Ext-Strii-Houttemane Philippe <Philippe.Houttemane@cetim.fr>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: recommendations and contraindications of using btrfs for Oracle
 Database Server
Date: Thu, 11 Jan 2018 10:51:43 +0000
Message-ID: <8444d2a08c8f4e8dab2ee48139ce5bb9@AQUILON.cetim.priv>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

   We are using btrfs filesystem on local disks (RAID 1) as underlying filesystem to host our Oracle 12c datafiles.
This allow us to cold backup databases via snapshot in a few seconds and benefit from higher performance than over Linux filesystem formats.
This is the problem we meet: Oracle regularly crashes with error of this 2 types, the errors occur on different physical machines with same softwares:

ORA-63999: data file suffered media failure
ORA-01114: IO error writing block to file 99 (block # 99968)
ORA-01110: data file 99: '/oradata/PS92PRD/data/pcapp.dbf'
ORA-27072: File I/O error
Linux-x86_64 Error: 17: File exists
Additional information: 4
Additional information: 99968

And 

ORA-63999: data file suffered media failure
ORA-01114: IO error writing block to file 99 (block # 99994)
ORA-01110: data file 99: '/oradata/PS92PRD/data/pcapp.dbf'
ORA-27072: File I/O error
Linux-x86_64 Error: 5: Input/output error
Additional information: 4
Additional information: 99994

It nevers append with over filesystem types, all the hardware has been checked.
I suspect a Btrfs activated feature via our mount options instead of a bug: Oracle see a ghost or a duplicated bloc even if copy on cow feature is disabled.

Here are few details of the system:

Mount options: defaults,nofail,nodatacow,nobarrier,noatime

uname -a:
Linux 3.10.0-514.10.2.el7.x86_64 #1 SMP Fri Mar 3 00:04:05 UTC 2017 x86_64 x86_64 x86_64 GNU/Linux
btrfs -version: btrfs-progs v4.9.1

btrfs fi show:
Label: 'oradataBtrfs'  
        Total devices 1 FS bytes used 1.98TiB
        devid    1 size 3.18TiB used 2.02TiB path /dev/sdb1

Thank you very much for your advice.

Philippe Houttemane
System, network and DBA engineer.




