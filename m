Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tty0.vserver.softronics.ch ([91.214.169.36]:53494 "EHLO
        fe1.digint.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751519AbdEHNSB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 8 May 2017 09:18:01 -0400
Received: from [10.0.1.10] (77-59-134-149.dclient.hispeed.ch [77.59.134.149])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by fe1.digint.ch (Postfix) with ESMTPSA id 963E130398
        for <linux-btrfs@vger.kernel.org>; Mon,  8 May 2017 15:11:35 +0200 (CEST)
Subject: Re: Wrong received UUIDs after backup restore and onward
To: linux-btrfs@vger.kernel.org
References: <b1fca88c-19d1-6f16-1967-9eb637a874d9@lewisdiamond.com>
From: Axel Burri <axel@tty0.ch>
Message-ID: <6b1caec6-b3ff-e451-d933-fe820966bfd8@tty0.ch>
Date: Mon, 8 May 2017 15:10:40 +0200
MIME-Version: 1.0
In-Reply-To: <b1fca88c-19d1-6f16-1967-9eb637a874d9@lewisdiamond.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-05-05 19:03, Lewis Diamond wrote:
> Hi,
> 
> I ran into a situation where my incremental backups using send|receive
> are failing after a full file system failure followed by restore from an
> external backup. The reason for the failures seem to be that the
> Received UUID of snapshots and backups are not properly updated. In
> short, everything (snapshots and backups) from the time of restore
> onward has the same Received UUID. Here is an example:
> 
>    [root@ldiamond-desktop test_btrfs]# btrfs sub create test1
>    Create subvolume './test1'
>    [root@ldiamond-desktop test_btrfs]# echo '1' > test1/test
>    [root@ldiamond-desktop test_btrfs]# btrfs sub snap -r test1/ test1_snap
>    Create a readonly snapshot of 'test1/' in './test1_snap'
>    [root@ldiamond-desktop test_btrfs]# btrfs send test1_snap/ | btrfs
> receive /media/backup/test_btrfs/
>    At subvol test1_snap/
>    At subvol test1_snap
>    [root@ldiamond-desktop test_btrfs]# echo '2' >> test1/test
>    [root@ldiamond-desktop test_btrfs]# btrfs sub snap -r test1 test1_snap2
>    Create a readonly snapshot of 'test1' in './test1_snap2'
>    [root@ldiamond-desktop test_btrfs]# btrfs send test1_snap2 -p
> test1_snap | btrfs receive /media/backup/test_btrfs/
>    At subvol test1_snap2
>    At snapshot test1_snap2
>    [root@ldiamond-desktop test_btrfs]# btrfs sub show test1
>    /media/btr0/test_btrfs/test1
>             Name:                   test1
>             UUID:                   6eb0318e-f036-7840-a39f-f9f56b3769f4
>             Parent UUID:            -
>             Received UUID:          -
>             Creation time:          2017-05-05 12:29:16 -0400
>             Subvolume ID:           698
>             Generation:             11566
>             Gen at creation:        11558
>             Parent ID:              5
>             Top level ID:           5
>             Flags:                  -
>             Snapshot(s):
>                                     test_btrfs/test1_snap
>                                     test_btrfs/test1_snap2
>    [root@ldiamond-desktop test_btrfs]# btrfs sub show test1_snap
>    /media/btr0/test_btrfs/test1_snap
>             Name:                   test1_snap
>             UUID:                   8afd7fec-5141-7b46-af05-77c78b051977
>             Parent UUID:            6eb0318e-f036-7840-a39f-f9f56b3769f4
>             Received UUID:          -
>             Creation time:          2017-05-05 12:30:17 -0400
>             Subvolume ID:           700
>             Generation:             11561
>             Gen at creation:        11561
>             Parent ID:              5
>             Top level ID:           5
>             Flags:                  readonly
>             Snapshot(s):
>    [root@ldiamond-desktop test_btrfs]# btrfs sub show test1_snap2
>    /media/btr0/test_btrfs/test1_snap2
>             Name:                   test1_snap2
>             UUID:                   fc8a9859-962d-954b-92df-32ef31b88bc9
>             Parent UUID:            6eb0318e-f036-7840-a39f-f9f56b3769f4
>             Received UUID:          -
>             Creation time:          2017-05-05 12:32:46 -0400
>             Subvolume ID:           702
>             Generation:             11566
>             Gen at creation:        11566
>             Parent ID:              5
>             Top level ID:           5
>             Flags:                  readonly
>             Snapshot(s):
>    [root@ldiamond-desktop test_btrfs]# btrfs sub d test1 test1_snap*
>    Delete subvolume (no-commit): '/media/btr0/test_btrfs/test1'
>    Delete subvolume (no-commit): '/media/btr0/test_btrfs/test1_snap'
>    Delete subvolume (no-commit): '/media/btr0/test_btrfs/test1_snap2'
>    [root@ldiamond-desktop test_btrfs]# btrfs send
> /media/backup/test_btrfs/test1_snap2/ | btrfs receive ./
>    At subvol /media/backup/test_btrfs/test1_snap2/
>    At subvol test1_snap2
>    [root@ldiamond-desktop test_btrfs]# btrfs property set -ts
> test1_snap2/ ro false
>    [root@ldiamond-desktop test_btrfs]# echo '3' >> test1_snap2/test
>    [root@ldiamond-desktop test_btrfs]# cat test1_snap2/test
>    1
>    2
>    3
>    [root@ldiamond-desktop test_btrfs]# btrfs sub snap -r test1_snap2/
> test1_snap3
>    Create a readonly snapshot of 'test1_snap2/' in './test1_snap3'
>    [root@ldiamond-desktop test_btrfs]# btrfs send test1_snap3/ | btrfs
> receive /media/backup/test_btrfs/
>    At subvol test1_snap3/
>    At subvol test1_snap3
>    [root@ldiamond-desktop test_btrfs]# echo '4' >> test1_snap2/test
>    [root@ldiamond-desktop test_btrfs]# btrfs sub snap -r test1_snap2/
> test1_snap4
>    Create a readonly snapshot of 'test1_snap2/' in './test1_snap4'
>    [root@ldiamond-desktop test_btrfs]# btrfs send test1_snap4/ -p
> test1_snap3/ | btrfs receive /media/backup/test_btrfs/
>    At subvol test1_snap4/
>    At snapshot test1_snap4
>    [root@ldiamond-desktop test_btrfs]# btrfs sub show test1_snap2
>    /media/btr0/test_btrfs/test1_snap2
>             Name:                   test1_snap2
>             UUID:                   5f505e2f-2e0a-8840-8132-08ba3bdb4484
>             Parent UUID:            -
>             Received UUID:          fc8a9859-962d-954b-92df-32ef31b88bc9
>             Creation time:          2017-05-05 12:34:25 -0400
>             Subvolume ID:           703
>             Generation:             11579
>             Gen at creation:        11569
>             Parent ID:              5
>             Top level ID:           5
>             Flags:                  -
>             Snapshot(s):
>                                     test_btrfs/test1_snap3
>                                     test_btrfs/test1_snap4
>    [root@ldiamond-desktop test_btrfs]# btrfs sub show test1_snap3
>    /media/btr0/test_btrfs/test1_snap3
>             Name:                   test1_snap3
>             UUID:                   6321f351-2a36-b94b-b2a3-85250eecc4fb
>             Parent UUID:            5f505e2f-2e0a-8840-8132-08ba3bdb4484
>             Received UUID:          fc8a9859-962d-954b-92df-32ef31b88bc9
>             Creation time:          2017-05-05 12:36:00 -0400
>             Subvolume ID:           704
>             Generation:             11575
>             Gen at creation:        11575
>             Parent ID:              5
>             Top level ID:           5
>             Flags:                  readonly
>             Snapshot(s):
>    [root@ldiamond-desktop test_btrfs]# btrfs sub show test1_snap4
>    /media/btr0/test_btrfs/test1_snap4
>             Name:                   test1_snap4
>             UUID:                   4863c19e-48ba-ce49-892a-4f98f101ffb8
>             Parent UUID:            5f505e2f-2e0a-8840-8132-08ba3bdb4484
>             Received UUID:          fc8a9859-962d-954b-92df-32ef31b88bc9
>             Creation time:          2017-05-05 12:37:38 -0400
>             Subvolume ID:           706
>             Generation:             11579
>             Gen at creation:        11579
>             Parent ID:              5
>             Top level ID:           5
>             Flags:                  readonly
>             Snapshot(s):
>    [root@ldiamond-desktop test_btrfs]# btrfs sub show
> /media/backup/test_btrfs/test1_snap
>    test1_snap/  test1_snap2/ test1_snap3/ test1_snap4/
>    [root@ldiamond-desktop test_btrfs]# btrfs sub show
> /media/backup/test_btrfs/test1_snap
>    /media/backup/test_btrfs/test1_snap
>             Name:                   test1_snap
>             UUID:                   dd86dd56-0dfe-4f48-b040-6b12fcc07965
>             Parent UUID:            -
>             Received UUID:          8afd7fec-5141-7b46-af05-77c78b051977
>             Creation time:          2017-05-05 12:31:03 -0400
>             Subvolume ID:           1163
>             Generation:             2813
>             Gen at creation:        2810
>             Parent ID:              5
>             Top level ID:           5
>             Flags:                  readonly
>             Snapshot(s):
>                                     test_btrfs/test1_snap2
>    [root@ldiamond-desktop test_btrfs]# btrfs sub show
> /media/backup/test_btrfs/test1_snap2
>    /media/backup/test_btrfs/test1_snap2
>             Name:                   test1_snap2
>             UUID:                   957baf65-eb56-7546-8d22-dca29733fdd3
>             Parent UUID:            dd86dd56-0dfe-4f48-b040-6b12fcc07965
>             Received UUID:          fc8a9859-962d-954b-92df-32ef31b88bc9
>             Creation time:          2017-05-05 12:32:55 -0400
>             Subvolume ID:           1164
>             Generation:             2820
>             Gen at creation:        2813
>             Parent ID:              5
>             Top level ID:           5
>             Flags:                  readonly
>             Snapshot(s):
>                                     test_btrfs/test1_snap4
>    [root@ldiamond-desktop test_btrfs]# btrfs sub show
> /media/backup/test_btrfs/test1_snap3
>    /media/backup/test_btrfs/test1_snap3
>             Name:                   test1_snap3
>             UUID:                   6e2369f8-dd57-fd4c-9ef9-8467cf1eb00f
>             Parent UUID:            -
>             Received UUID:          fc8a9859-962d-954b-92df-32ef31b88bc9
>             Creation time:          2017-05-05 12:36:38 -0400
>             Subvolume ID:           1165
>             Generation:             2818
>             Gen at creation:        2817
>             Parent ID:              5
>             Top level ID:           5
>             Flags:                  readonly
>             Snapshot(s):
>    [root@ldiamond-desktop test_btrfs]# btrfs sub show
> /media/backup/test_btrfs/test1_snap4
>    /media/backup/test_btrfs/test1_snap4
>             Name:                   test1_snap4
>             UUID:                   d255acb5-cc6c-0141-a697-071ebdbb8771
>             Parent UUID:            957baf65-eb56-7546-8d22-dca29733fdd3
>             Received UUID:          fc8a9859-962d-954b-92df-32ef31b88bc9
>             Creation time:          2017-05-05 12:37:56 -0400
>             Subvolume ID:           1166
>             Generation:             2821
>             Gen at creation:        2820
>             Parent ID:              5
>             Top level ID:           5
>             Flags:                  readonly
>             Snapshot(s):
> 
> 
> 
> These are my kernel/btrfs versions
> 
>  $ uname -a
> Linux ldiamond-desktop 4.10.11-1-ARCH #1 SMP PREEMPT Tue Apr 18 08:39:42
> CEST 2017 x86_64 GNU/Linux
> ldiamond@ldiamond-desktop ~/tmp
>  $ btrfs --version
> btrfs-progs v4.10.2
> ldiamond@ldiamond-desktop ~/tmp
>  $
> 
> 
> Are those Received UUIDs the expected values for the provided test-case?

I did not check everything in detail, but:

At some point above, you use:

  btrfs property set -ts test1_snap2/ ro false

While this effectively does what it is supposed to (sets read-only flag
of subvolume to false), it does NOT clear the "Received UUID" of this
subvolume. This causes problems for tools like btrbk that rely on
"Received UUID" being "correct" (i.e. stating "all subvolume with
matching UUID/Received_UUID contain the same data and can be used as
parents for subsequent send/receive", which is not true any more after
writing some data into test1_snap2).

If you want the Received UUID "correctly" cleared, you should use:

  btrfs sub snap test1_snap2 test1_snap2_rw
  btrfs sub delete test1_snap2


> Aren't the Received UUID always supposed to reflect the sent subvolume
> UUID value?

Not always. If the sent subvolume already has a "Received UUID" set, the
"Received UUID" reflects the "Received UUID" of the sent subvolume, NOT
its UUID.
