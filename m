Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:28974 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932949AbcJRAfu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Oct 2016 20:35:50 -0400
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id u9I0ZnAd022122
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Oct 2016 00:35:49 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.13.8/8.13.8) with ESMTP id u9I0ZnMQ014392
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Oct 2016 00:35:49 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id u9I0Znm1027399
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Oct 2016 00:35:49 GMT
From: Divya Indi <divya.indi@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: ashish.samant@oracle.com, bo.li.liu@oracle.com
Subject: btrfs-progs: Add 2 new subcommands to inspect-internal 
Date: Mon, 17 Oct 2016 17:35:12 -0700
Message-Id: <1476750915-3105-1-git-send-email-divya.indi@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

These patches aim to add 2 new subcommands that:
-> provide information about block groups
-> help to decide whether balance can reduce the no. of data block groups and if
 it can, provides the block group object id for "-dvrange"

[PATCH 1/3] btrfs-progs: Generic functions to retrieve chunks and their bg info
[PATCH 2/3] btrfs-progs: Add a command to show bg info
[PATCH 3/3] btrfs-progs: Add command to check if balance op is req

Now, you can run:
-------------------------------------------------------------------------------
$ btrfs inspect-internal balance_check /mnt/btrfs
               Start                 Len                Used
            12582912             8.00MiB           128.00KiB
           136708096           208.00MiB            74.00MiB

Total data bgs: 2
Total free space: 141.88MiB
For min used bg 12582912 used = 128.00KiB free = 7.88MiB
run 'btrfs balance start -dvrange=12582912..12582913 <mountpoint>'

$ btrfs balance start -dvrange=12582912..12582913 /mnt/btrfs
Done, had to relocate 1 out of 4 chunks

$ btrfs inspect-internal balance_check /mnt/btrfs
               Start                 Len                Used
           136708096           208.00MiB            74.12MiB
Data block groups in fs = 1, no need to do balance.

$ btrfs inspect-internal bg_analysis /mnt/btrfs

                Type               Start                 Len                Used
              SYSTEM            20971520             8.00MiB            16.00KiB
            METADATA            29360128           102.38MiB           192.00KiB
                DATA           136708096           208.00MiB            74.12MiB
-------------------------------------------------------------------------------

Thanks to the suggestion by Hans van Kranenburg, and the python-btrfs module,
an efficient alternative to retrieving block groups could be used:
Now, it first looks at the chunk tree, and for every chunk listed it looks up an
exact match in the extent tree.

