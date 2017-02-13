Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36620 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752188AbdBML0a (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Feb 2017 06:26:30 -0500
Received: by mail-wm0-f68.google.com with SMTP id r18so18923224wmd.3
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Feb 2017 03:26:30 -0800 (PST)
Received: from [192.168.4.20] (to.netbox.cz. [83.240.2.228])
        by smtp.gmail.com with ESMTPSA id w30sm13499131wrb.5.2017.02.13.03.26.23
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 13 Feb 2017 03:26:23 -0800 (PST)
To: linux-btrfs@vger.kernel.org
From: =?UTF-8?B?TWFydGluIE1seW7DocWZ?= <nextsux@gmail.com>
Subject: Root volume (ID 5) in deleting state
Message-ID: <ed8d7383-c75c-584e-4722-c889c6f19a46@gmail.com>
Date: Mon, 13 Feb 2017 12:26:22 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,


I've currently run into strange problem with BTRFS. I'm using it as my 
daily driver as root FS. Nothing complicated, just few subvolumes and 
incremental backups using btrbk.

Now I've noticed that my btrfs root volume (absolute top, ID 5) is in 
"deleting" state. As I've done some testing and googling it seems that 
this should not be possible.

I've tried scrubbing and checking, but nothing changed. Volume is not 
being deleted in reality. It just sits there in this state.

Is there anything I can do to fix this?

# btrfs sub list -a /mnt/btrfs_root/
ID 1339 gen 262150 top level 5 path rootfs
ID 1340 gen 262101 top level 5 path .btrbk
ID 1987 gen 262149 top level 5 path no_backup
ID 4206 gen 255869 top level 1340 path <FS_TREE>/.btrbk/rootfs.20170121T1829
ID 4272 gen 257460 top level 1340 path <FS_TREE>/.btrbk/rootfs.20170123T0933
ID 4468 gen 259194 top level 1340 path <FS_TREE>/.btrbk/rootfs.20170131T1132
ID 4474 gen 260911 top level 1340 path <FS_TREE>/.btrbk/rootfs.20170207T0927
ID 4476 gen 261712 top level 1340 path <FS_TREE>/.btrbk/rootfs.20170211T0000
ID 4477 gen 261970 top level 1340 path <FS_TREE>/.btrbk/rootfs.20170212T1331
ID 4478 gen 262102 top level 1340 path <FS_TREE>/.btrbk/rootfs.20170213T0000

# btrfs sub list -ad /mnt/btrfs_root/
ID 5 gen 257505 top level 0 path <FS_TREE>/DELETED

# mount | grep btr
/dev/mapper/vg0-btrfsroot on / type btrfs 
(rw,noatime,nodatasum,nodatacow,ssd,discard,space_cache,subvolid=1339,subvol=/rootfs)
/dev/mapper/vg0-btrfsroot on /mnt/btrfs_root type btrfs 
(rw,noatime,nodatasum,nodatacow,ssd,discard,space_cache,subvolid=5,subvol=/)

# uname -a
Linux interceptor 4.9.6-1-ARCH #1 SMP PREEMPT Thu Jan 26 09:22:26 CET 
2017 x86_64 GNU/Linux

# btrfs fi show  /
Label: none  uuid: 859dec5c-850c-4660-ad99-bc87456aa309
     Total devices 1 FS bytes used 132.89GiB
     devid    1 size 200.00GiB used 200.00GiB path /dev/mapper/vg0-btrfsroot


Thank you for your time,


Best regards

--

Martin Mlynář

