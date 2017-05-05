Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f50.google.com ([209.85.214.50]:35705 "EHLO
        mail-it0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750734AbdEERDK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 May 2017 13:03:10 -0400
Received: by mail-it0-f50.google.com with SMTP id c15so31466003ith.0
        for <linux-btrfs@vger.kernel.org>; Fri, 05 May 2017 10:03:09 -0700 (PDT)
Received: from [192.168.11.140] (mtrlpq4362w-lp130-04-76-68-247-163.dsl.bell.ca. [76.68.247.163])
        by smtp.googlemail.com with ESMTPSA id a10sm809288itj.1.2017.05.05.10.03.08
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 May 2017 10:03:08 -0700 (PDT)
From: Lewis Diamond <me@lewisdiamond.com>
Subject: Wrong received UUIDs after backup restore and onward
To: linux-btrfs@vger.kernel.org
Message-ID: <b1fca88c-19d1-6f16-1967-9eb637a874d9@lewisdiamond.com>
Date: Fri, 5 May 2017 13:03:07 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I ran into a situation where my incremental backups using send|receive 
are failing after a full file system failure followed by restore from an 
external backup. The reason for the failures seem to be that the 
Received UUID of snapshots and backups are not properly updated. In 
short, everything (snapshots and backups) from the time of restore 
onward has the same Received UUID. Here is an example:

    [root@ldiamond-desktop test_btrfs]# btrfs sub create test1
    Create subvolume './test1'
    [root@ldiamond-desktop test_btrfs]# echo '1' > test1/test
    [root@ldiamond-desktop test_btrfs]# btrfs sub snap -r test1/ test1_snap
    Create a readonly snapshot of 'test1/' in './test1_snap'
    [root@ldiamond-desktop test_btrfs]# btrfs send test1_snap/ | btrfs receive /media/backup/test_btrfs/
    At subvol test1_snap/
    At subvol test1_snap
    [root@ldiamond-desktop test_btrfs]# echo '2' >> test1/test
    [root@ldiamond-desktop test_btrfs]# btrfs sub snap -r test1 test1_snap2
    Create a readonly snapshot of 'test1' in './test1_snap2'
    [root@ldiamond-desktop test_btrfs]# btrfs send test1_snap2 -p test1_snap | btrfs receive /media/backup/test_btrfs/
    At subvol test1_snap2
    At snapshot test1_snap2
    [root@ldiamond-desktop test_btrfs]# btrfs sub show test1
    /media/btr0/test_btrfs/test1
             Name:                   test1
             UUID:                   6eb0318e-f036-7840-a39f-f9f56b3769f4
             Parent UUID:            -
             Received UUID:          -
             Creation time:          2017-05-05 12:29:16 -0400
             Subvolume ID:           698
             Generation:             11566
             Gen at creation:        11558
             Parent ID:              5
             Top level ID:           5
             Flags:                  -
             Snapshot(s):
                                     test_btrfs/test1_snap
                                     test_btrfs/test1_snap2
    [root@ldiamond-desktop test_btrfs]# btrfs sub show test1_snap
    /media/btr0/test_btrfs/test1_snap
             Name:                   test1_snap
             UUID:                   8afd7fec-5141-7b46-af05-77c78b051977
             Parent UUID:            6eb0318e-f036-7840-a39f-f9f56b3769f4
             Received UUID:          -
             Creation time:          2017-05-05 12:30:17 -0400
             Subvolume ID:           700
             Generation:             11561
             Gen at creation:        11561
             Parent ID:              5
             Top level ID:           5
             Flags:                  readonly
             Snapshot(s):
    [root@ldiamond-desktop test_btrfs]# btrfs sub show test1_snap2
    /media/btr0/test_btrfs/test1_snap2
             Name:                   test1_snap2
             UUID:                   fc8a9859-962d-954b-92df-32ef31b88bc9
             Parent UUID:            6eb0318e-f036-7840-a39f-f9f56b3769f4
             Received UUID:          -
             Creation time:          2017-05-05 12:32:46 -0400
             Subvolume ID:           702
             Generation:             11566
             Gen at creation:        11566
             Parent ID:              5
             Top level ID:           5
             Flags:                  readonly
             Snapshot(s):
    [root@ldiamond-desktop test_btrfs]# btrfs sub d test1 test1_snap*
    Delete subvolume (no-commit): '/media/btr0/test_btrfs/test1'
    Delete subvolume (no-commit): '/media/btr0/test_btrfs/test1_snap'
    Delete subvolume (no-commit): '/media/btr0/test_btrfs/test1_snap2'
    [root@ldiamond-desktop test_btrfs]# btrfs send /media/backup/test_btrfs/test1_snap2/ | btrfs receive ./
    At subvol /media/backup/test_btrfs/test1_snap2/
    At subvol test1_snap2
    [root@ldiamond-desktop test_btrfs]# btrfs property set -ts test1_snap2/ ro false
    [root@ldiamond-desktop test_btrfs]# echo '3' >> test1_snap2/test
    [root@ldiamond-desktop test_btrfs]# cat test1_snap2/test
    1
    2
    3
    [root@ldiamond-desktop test_btrfs]# btrfs sub snap -r test1_snap2/ test1_snap3
    Create a readonly snapshot of 'test1_snap2/' in './test1_snap3'
    [root@ldiamond-desktop test_btrfs]# btrfs send test1_snap3/ | btrfs receive /media/backup/test_btrfs/
    At subvol test1_snap3/
    At subvol test1_snap3
    [root@ldiamond-desktop test_btrfs]# echo '4' >> test1_snap2/test
    [root@ldiamond-desktop test_btrfs]# btrfs sub snap -r test1_snap2/ test1_snap4
    Create a readonly snapshot of 'test1_snap2/' in './test1_snap4'
    [root@ldiamond-desktop test_btrfs]# btrfs send test1_snap4/ -p test1_snap3/ | btrfs receive /media/backup/test_btrfs/
    At subvol test1_snap4/
    At snapshot test1_snap4
    [root@ldiamond-desktop test_btrfs]# btrfs sub show test1_snap2
    /media/btr0/test_btrfs/test1_snap2
             Name:                   test1_snap2
             UUID:                   5f505e2f-2e0a-8840-8132-08ba3bdb4484
             Parent UUID:            -
             Received UUID:          fc8a9859-962d-954b-92df-32ef31b88bc9
             Creation time:          2017-05-05 12:34:25 -0400
             Subvolume ID:           703
             Generation:             11579
             Gen at creation:        11569
             Parent ID:              5
             Top level ID:           5
             Flags:                  -
             Snapshot(s):
                                     test_btrfs/test1_snap3
                                     test_btrfs/test1_snap4
    [root@ldiamond-desktop test_btrfs]# btrfs sub show test1_snap3
    /media/btr0/test_btrfs/test1_snap3
             Name:                   test1_snap3
             UUID:                   6321f351-2a36-b94b-b2a3-85250eecc4fb
             Parent UUID:            5f505e2f-2e0a-8840-8132-08ba3bdb4484
             Received UUID:          fc8a9859-962d-954b-92df-32ef31b88bc9
             Creation time:          2017-05-05 12:36:00 -0400
             Subvolume ID:           704
             Generation:             11575
             Gen at creation:        11575
             Parent ID:              5
             Top level ID:           5
             Flags:                  readonly
             Snapshot(s):
    [root@ldiamond-desktop test_btrfs]# btrfs sub show test1_snap4
    /media/btr0/test_btrfs/test1_snap4
             Name:                   test1_snap4
             UUID:                   4863c19e-48ba-ce49-892a-4f98f101ffb8
             Parent UUID:            5f505e2f-2e0a-8840-8132-08ba3bdb4484
             Received UUID:          fc8a9859-962d-954b-92df-32ef31b88bc9
             Creation time:          2017-05-05 12:37:38 -0400
             Subvolume ID:           706
             Generation:             11579
             Gen at creation:        11579
             Parent ID:              5
             Top level ID:           5
             Flags:                  readonly
             Snapshot(s):
    [root@ldiamond-desktop test_btrfs]# btrfs sub show /media/backup/test_btrfs/test1_snap
    test1_snap/  test1_snap2/ test1_snap3/ test1_snap4/
    [root@ldiamond-desktop test_btrfs]# btrfs sub show /media/backup/test_btrfs/test1_snap
    /media/backup/test_btrfs/test1_snap
             Name:                   test1_snap
             UUID:                   dd86dd56-0dfe-4f48-b040-6b12fcc07965
             Parent UUID:            -
             Received UUID:          8afd7fec-5141-7b46-af05-77c78b051977
             Creation time:          2017-05-05 12:31:03 -0400
             Subvolume ID:           1163
             Generation:             2813
             Gen at creation:        2810
             Parent ID:              5
             Top level ID:           5
             Flags:                  readonly
             Snapshot(s):
                                     test_btrfs/test1_snap2
    [root@ldiamond-desktop test_btrfs]# btrfs sub show /media/backup/test_btrfs/test1_snap2
    /media/backup/test_btrfs/test1_snap2
             Name:                   test1_snap2
             UUID:                   957baf65-eb56-7546-8d22-dca29733fdd3
             Parent UUID:            dd86dd56-0dfe-4f48-b040-6b12fcc07965
             Received UUID:          fc8a9859-962d-954b-92df-32ef31b88bc9
             Creation time:          2017-05-05 12:32:55 -0400
             Subvolume ID:           1164
             Generation:             2820
             Gen at creation:        2813
             Parent ID:              5
             Top level ID:           5
             Flags:                  readonly
             Snapshot(s):
                                     test_btrfs/test1_snap4
    [root@ldiamond-desktop test_btrfs]# btrfs sub show /media/backup/test_btrfs/test1_snap3
    /media/backup/test_btrfs/test1_snap3
             Name:                   test1_snap3
             UUID:                   6e2369f8-dd57-fd4c-9ef9-8467cf1eb00f
             Parent UUID:            -
             Received UUID:          fc8a9859-962d-954b-92df-32ef31b88bc9
             Creation time:          2017-05-05 12:36:38 -0400
             Subvolume ID:           1165
             Generation:             2818
             Gen at creation:        2817
             Parent ID:              5
             Top level ID:           5
             Flags:                  readonly
             Snapshot(s):
    [root@ldiamond-desktop test_btrfs]# btrfs sub show /media/backup/test_btrfs/test1_snap4
    /media/backup/test_btrfs/test1_snap4
             Name:                   test1_snap4
             UUID:                   d255acb5-cc6c-0141-a697-071ebdbb8771
             Parent UUID:            957baf65-eb56-7546-8d22-dca29733fdd3
             Received UUID:          fc8a9859-962d-954b-92df-32ef31b88bc9
             Creation time:          2017-05-05 12:37:56 -0400
             Subvolume ID:           1166
             Generation:             2821
             Gen at creation:        2820
             Parent ID:              5
             Top level ID:           5
             Flags:                  readonly
             Snapshot(s):



These are my kernel/btrfs versions

  $ uname -a
Linux ldiamond-desktop 4.10.11-1-ARCH #1 SMP PREEMPT Tue Apr 18 08:39:42 CEST 2017 x86_64 GNU/Linux
ldiamond@ldiamond-desktop ~/tmp
  $ btrfs --version
btrfs-progs v4.10.2
ldiamond@ldiamond-desktop ~/tmp
  $


Are those Received UUIDs the expected values for the provided test-case? Aren't the Received UUID always supposed to reflect the sent subvolume UUID value?

Thanks,
Lewis Diamond

