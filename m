Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from gourmet.spamgourmet.com ([216.75.62.102]:39488 "EHLO
        gourmet8.spamgourmet.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751695AbdJCKoc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 3 Oct 2017 06:44:32 -0400
Received: from spamgourmet by gourmet7.spamgourmet.com with local (Exim 4.80)
        (envelope-from <btrfs.fredo@xoxy.net>)
        id 1dzKgi-00056j-6a
        for linux-btrfs@vger.kernel.org; Tue, 03 Oct 2017 10:44:32 +0000
Received: from smtp3-g21.free.fr ([212.27.42.3])
        by gourmet7.spamgourmet.com with esmtps (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <btrfs.fredo@xoxy.net>)
        id 1dzKgh-00054S-MW
        for linux-btrfs@vger.kernel.org; Tue, 03 Oct 2017 10:44:32 +0000
Received: from zimbra65-e11.priv.proxad.net (unknown [172.20.243.215])
        by smtp3-g21.free.fr (Postfix) with ESMTP id 061F213F8B6
        for <linux-btrfs@vger.kernel.org>; Tue,  3 Oct 2017 12:44:29 +0200 (CEST)
Date: Tue, 3 Oct 2017 12:44:29 +0200 (CEST)
From: btrfs.fredo@xoxy.net
To: linux-btrfs@vger.kernel.org
Message-ID: <357972705.433103936.1507027469780.JavaMail.root@zimbra65-e11.priv.proxad.net>
In-Reply-To: <134025801.432834337.1507024250294.JavaMail.root@zimbra65-e11.priv.proxad.net>
Subject: Lost about 3TB
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I can't figure out were 3TB on a 36 TB BTRFS volume (on LVM) are gone !

I know BTRFS can be tricky when speaking about space usage when using many physical drives in a RAID setup, but my conf is a very simple BTRFS volume without RAID(single Data type) using the whole disk (perhaps did I do something wrong with the LVM setup ?).

My BTRFS volume is mounted on /RAID01/.

There's only one folder in /RAID01/ shared with Samba, Windows also see a total of 28 TB used.

It only contains 443 files (big backup files created by Veeam), most of the file size is greater than 1GB and be be up to 5TB.

######> du -hs /RAID01/
28T     /RAID01/

If I sum up the result of : ######> find . -printf '%s\n'
I also find 28TB.

I extracted btrfs binary from rpm version v4.9.1 and used ######> btrfs fi du
on each file and the result is 28TB.



OS : CentOS Linux release 7.3.1611 (Core)
btrfs-progs v4.4.1


######> ssm list

-------------------------------------------------------------------------
Device        Free      Used      Total  Pool                 Mount point
-------------------------------------------------------------------------
/dev/sda                       36.39 TB                       PARTITIONED
/dev/sda1                     200.00 MB                       /boot/efi
/dev/sda2                       1.00 GB                       /boot
/dev/sda3  0.00 KB  36.32 TB   36.32 TB  lvm_pool
/dev/sda4  0.00 KB  54.00 GB   54.00 GB  cl_xxx-xxxamrepo-01
-------------------------------------------------------------------------
-------------------------------------------------------------------
Pool                    Type   Devices     Free      Used     Total
-------------------------------------------------------------------
cl_xxx-xxxamrepo-01     lvm    1        0.00 KB  54.00 GB  54.00 GB
lvm_pool                lvm    1        0.00 KB  36.32 TB  36.32 TB
btrfs_lvm_pool-lvol001  btrfs  1        4.84 TB  36.32 TB  36.32 TB
-------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------
Volume                         Pool                    Volume size  FS        FS size       Free  Type    Mount point
---------------------------------------------------------------------------------------------------------------------
/dev/cl_xxx-xxxamrepo-01/root  cl_xxx-xxxamrepo-01        50.00 GB  xfs      49.97 GB   48.50 GB  linear  /
/dev/cl_xxx-xxxamrepo-01/swap  cl_xxx-xxxamrepo-01         4.00 GB                                linear
/dev/lvm_pool/lvol001          lvm_pool                   36.32 TB                                linear  /RAID01
btrfs_lvm_pool-lvol001         btrfs_lvm_pool-lvol001     36.32 TB  btrfs    36.32 TB    4.84 TB  btrfs   /RAID01
/dev/sda1                                                200.00 MB  vfat                          part    /boot/efi
/dev/sda2                                                  1.00 GB  xfs    1015.00 MB  882.54 MB  part    /boot
---------------------------------------------------------------------------------------------------------------------


######> btrfs fi sh

Label: none  uuid: df7ce232-056a-4c27-bde4-6f785d5d9f68
        Total devices 1 FS bytes used 31.48TiB
        devid    1 size 36.32TiB used 31.66TiB path /dev/mapper/lvm_pool-lvol001



######> btrfs fi df /RAID01/

Data, single: total=31.58TiB, used=31.44TiB
System, DUP: total=8.00MiB, used=3.67MiB
Metadata, DUP: total=38.00GiB, used=35.37GiB
GlobalReserve, single: total=512.00MiB, used=0.00B



I tried to repair it :


######> btrfs check --repair -p /dev/mapper/lvm_pool-lvol001

enabling repair mode
Checking filesystem on /dev/mapper/lvm_pool-lvol001
UUID: df7ce232-056a-4c27-bde4-6f785d5d9f68
checking extents
Fixed 0 roots.
cache and super generation don't match, space cache will be invalidated
checking fs roots
checking csums
checking root refs
found 34600611349019 bytes used err is 0
total csum bytes: 33752513152
total tree bytes: 38037848064
total fs tree bytes: 583942144
total extent tree bytes: 653754368
btree space waste bytes: 2197658704
file data blocks allocated: 183716661284864 ?? what's this ??
 referenced 30095956975616 = 27.3 TB !!



Tried the "new usage" display but the problem is the same : 31 TB used but total file size is 28TB

Overall:
    Device size:                  36.32TiB
    Device allocated:             31.65TiB
    Device unallocated:            4.67TiB
    Device missing:                  0.00B
    Used:                         31.52TiB
    Free (estimated):              4.80TiB      (min: 2.46TiB)
    Data ratio:                       1.00
    Metadata ratio:                   2.00
    Global reserve:              512.00MiB      (used: 0.00B)

Data,single: Size:31.58TiB, Used:31.45TiB
   /dev/mapper/lvm_pool-lvol001   31.58TiB

Metadata,DUP: Size:38.00GiB, Used:35.37GiB
   /dev/mapper/lvm_pool-lvol001   76.00GiB

System,DUP: Size:8.00MiB, Used:3.69MiB
   /dev/mapper/lvm_pool-lvol001   16.00MiB

Unallocated:
   /dev/mapper/lvm_pool-lvol001    4.67TiB
The only btrfs tool speaking about 28TB is btrfs check (but I'm not sure if it's bytes because it speaks about "referenced blocks" and I don't understand the meaning of "file data blocks allocated")
Code:
file data blocks allocated: 183716661284864 ?? what's this ??
 referenced 30095956975616 = 27.3 TB !!



I also used the verbose option of https://github.com/knorrie/btrfs-heatmap/ to sum up the total size of all DATA EXTENT and found 32TB.

I did scrub, balance up to -dusage=90 (and also dusage=0) and ended up with 32TB used.
No snasphots nor subvolumes nor TB hidden under the mount point after unmounting the BTRFS volume  


What did I do wrong or am I missing ?

Thanks in advance.
Frederic Larive.

