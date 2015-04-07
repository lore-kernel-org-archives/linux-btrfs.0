Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:57574 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754037AbbDGPM1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 7 Apr 2015 11:12:27 -0400
Message-ID: <5523F39A.1050405@fb.com>
Date: Tue, 7 Apr 2015 11:11:22 -0400
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Filipe Manana <fdmanana@suse.com>, <fstests@vger.kernel.org>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v3] fstests: test for btrfs transaction abortion on device
 with discard support
References: <1427990272-27107-1-git-send-email-fdmanana@suse.com> <1428087215-2475-1-git-send-email-fdmanana@suse.com>
In-Reply-To: <1428087215-2475-1-git-send-email-fdmanana@suse.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/03/2015 02:53 PM, Filipe Manana wrote:
> Test that btrfs' transaction abortion does not corrupt a filesystem
> mounted with -o discard nor allows a subsequent fstrim to corrupt the
> filesystem (regardless of being mounted with or without -o discard).
>
> This issue was fixed by the following linux kernel patch:
>
>      Btrfs: fix fs corruption on transaction abort if device supports discard
>      (commit 678886bdc6378c1cbd5072da2c5a3035000214e3)
>
> Without the corresponding btrfs fix the fs becomes unmountable and fails
> like this:
>
>    $ ./check btrfs/089
>    FSTYP         -- btrfs
>    PLATFORM      -- Linux/x86_64 debian3 3.19.0-btrfs-next-7+
>    MKFS_OPTIONS  -- /dev/sdc
>    MOUNT_OPTIONS -- /dev/sdc /home/fdmanana/btrfs-tests/scratch_1
>
>    btrfs/089 2s ... - output mismatch (see /home/fdmanana/git/hub/xfstests/results//btrfs/089.out.bad)
>        --- tests/btrfs/089.out	2015-04-03 19:29:42.969594083 +0100
>        +++ /home/fdmanana/git/hub/xfstests/results//btrfs/089.out.bad	2015-04-03 19:42:37.419181019 +0100
>        @@ -3,7 +3,10 @@
>         XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
>         wrote 1048576/1048576 bytes at offset 524288
>         XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
>        +mount: wrong fs type, bad option, bad superblock on /dev/sdc,
>        +       missing codepage or helper program, or other error
>        +       In some cases useful info is found in syslog - try
>        +       dmesg | tail  or so
>        ...
>        (Run 'diff -u tests/btrfs/089.out /home/fdmanana/git/hub/xfstests/results//btrfs/089.out.bad'  to see the entire diff)
>    _check_btrfs_filesystem: filesystem on /dev/sdc is inconsistent (see /home/fdmanana/git/hub/xfstests/results//btrfs/089.full)
>    Ran: btrfs/089
>    Failures: btrfs/089
>    Failed 1 of 1 tests
>
>    $ cat /home/fdmanana/git/hub/xfstests/results//btrfs/089.full
>    Performing full device TRIM (100.00GiB) ...
>    touch: cannot touch '/home/fdmanana/btrfs-tests/scratch_1/abc': Read-only file system
>    _check_btrfs_filesystem: filesystem on /dev/sdc is inconsistent
>    *** fsck.btrfs output ***
>    Check tree block failed, want=29589504, have=0
>    Check tree block failed, want=29589504, have=0
>    Check tree block failed, want=29589504, have=0
>    Check tree block failed, want=29589504, have=0
>    Check tree block failed, want=29589504, have=0
>    read block failed check_tree_block
>    Couldn't read tree root
>    Couldn't open file system
>    (...)
>
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef

