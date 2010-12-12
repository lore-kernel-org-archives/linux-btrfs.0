From: "Ian! D. Allen" <idallen@idallen.ca>
Subject: Re: btrfs subvolume snapshot hung in btrfs_commit_transaction
Date: Sun, 12 Dec 2010 03:14:00 -0500
Message-ID: <20101212081359.GA7389@idallen.ca>
References: <20101212034339.GA26170@idallen.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101212034339.GA26170@idallen.ca>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Dec 11, 2010 at 10:43:39PM -0500, Ian! D. Allen wrote:
> I put in a larger disk (250GB), set up a partition for btrfs, and ran
> the same continuous snapshotting test.  It got up to creating snapshot
> 150 and then btrfs hung again.  So the bug is repeatable and makes
> btrfs 0.19 on Ubuntu 10.10 unusable.

I rebooted the above machine (had to use SYSRQ to do it - the regular
shutdown hung) and ran btrfsck on the partition.  It produced 50,572
lines of output: 151 different unique root numbers between 5 and 409
and 342 different unique inodes between 32465 and 184349.  Sample:

    root 5 inode 32465 errors 2000
    root 5 inode 32468 errors 2000
    root 5 inode 32471 errors 2000
    root 5 inode 32477 errors 2000
    root 5 inode 32483 errors 2000
    root 5 inode 32492 errors 2000
    root 5 inode 32495 errors 2000
    root 5 inode 32499 errors 2000
    root 5 inode 32501 errors 2000
    root 5 inode 32504 errors 2000
    [... 50,500+ lines deleted ...]
    root 409 inode 175629 errors 2000
    root 409 inode 175637 errors 2000
    root 409 inode 175652 errors 2000
    root 409 inode 175655 errors 2000
    root 409 inode 175657 errors 2000
    root 409 inode 175661 errors 2000
    root 409 inode 175667 errors 2000
    root 409 inode 175668 errors 2000
    root 409 inode 175676 errors 2000
    root 409 inode 175677 errors 2000
    root 409 inode 175680 errors 2000
    root 409 inode 175689 errors 2000
    root 409 inode 184349 errors 2000
    found 142348439552 bytes used err is 1
    total csum bytes: 138091404
    total tree bytes: 942841856
    total fs tree bytes: 692547584
    btree space waste bytes: 158649297
    file data blocks allocated: 219977064448
     referenced 219976880128
    Btrfs Btrfs v0.19

More info:

    # btrfs file show
    failed to read /dev/fd0u800
    failed to read /dev/sr1
    failed to read /dev/sr0
    failed to read /dev/fd0
    Label: none  uuid: b9865e4e-1890-4a1b-8f85-597774822f42
            Total devices 1 FS bytes used 132.57GB
            devid    1 size 232.88GB used 140.29GB path /dev/sdb1
    Btrfs Btrfs v0.19

    # mount -r /dev/sdb1 /mnt/sdb1

    # tail -1 /var/log/kern.log
    2010-12-12T02:05:08.962448-05:00 linux kernel: [ 1731.373691] device fsid 1b4a90184e5e86b9-422f82747759858f devid 1 transid 429 /dev/sdb1

    # df /mnt/sdb1
    Filesystem           1K-blocks      Used Available Use% Mounted on
    /dev/sdb1            244197560 139932892 104264668  58% /mnt/sdb1

    # btrfs file df /mnt/sdb1
    Data: total=137.01GB, used=131.69GB
    Metadata: total=1.63GB, used=899.14MB
    System: total=12.00MB, used=20.00KB

    # btrfs subvolume list /mnt/sdb1
    ID 258 top level 5 path snap000001
    ID 259 top level 5 path snap000002
    ID 260 top level 5 path snap000003
    ID 261 top level 5 path snap000004
    ID 262 top level 5 path snap000005
    [...]
    ID 405 top level 5 path snap000146
    ID 406 top level 5 path snap000147
    ID 407 top level 5 path snap000148
    ID 408 top level 5 path snap000149
    ID 409 top level 5 path snap000150

There are 140 snapshots listed.  There should be 150, since my script
creates each snapshot from the previous one without gaps.  Inspection
shows that from missing snap000024 onward every 13th snapshot is missing:

    snap000024
    snap000037
    snap000050
    snap000063
    snap000076
    snap000089
    snap000102
    snap000115
    snap000128
    snap000141

I had interrupted and restarted my snapshotting script at snap 13 and
so I had deleted (the incomplete) snap 13 and restarted the script to
recreate it and continue on.  I also interrupted at snap 24 and did a
similar thing, deleting snap 24 and restarting the script to recreate it.

I interrupted again at snap 74, deleted 74, and restarted, and looking
back at the log file from that time I see now that snaps 24, 37, 50,
and 63 were already "missing" from the "btrfs subvolume list" output
issued by the script starting up at snap 74.  So the missing snaps
weren't caused by file system damage caused by the hang and reboot -
they were already missing long before the system hung at snap 151.

On disk, all 150 snapshots have directory entries:

    total 608
        256 drwxr-xr-x  1 root root 3008 Dec 11 05:08 ./
    2621441 drwxr-xr-x 20 root root 4096 Dec 11 03:27 ../
     550940 drwxr-xr-x  1 root root  328 Dec 11 03:58 ROOT/
        256 drwxr-xr-x  1 root root   28 Dec 11 04:33 snap000001/
        256 drwxr-xr-x  1 root root   28 Dec 11 04:33 snap000002/
        256 drwxr-xr-x  1 root root   28 Dec 11 04:33 snap000003/
        256 drwxr-xr-x  1 root root   28 Dec 11 04:33 snap000004/
        256 drwxr-xr-x  1 root root   28 Dec 11 04:33 snap000005/
        256 drwxr-xr-x  1 root root   28 Dec 11 04:33 snap000006/
        [...]
        256 drwxr-xr-x  1 root root   28 Dec 11 04:33 snap000141/
        256 drwxr-xr-x  1 root root   28 Dec 11 04:33 snap000142/
        256 drwxr-xr-x  1 root root   28 Dec 11 04:33 snap000143/
        256 drwxr-xr-x  1 root root   28 Dec 11 04:33 snap000144/
        256 drwxr-xr-x  1 root root   28 Dec 11 04:33 snap000145/
        256 drwxr-xr-x  1 root root   28 Dec 11 04:33 snap000146/
        256 drwxr-xr-x  1 root root   28 Dec 11 04:33 snap000147/
        256 drwxr-xr-x  1 root root   28 Dec 11 04:33 snap000148/
        256 drwxr-xr-x  1 root root   28 Dec 11 04:33 snap000149/
        256 drwxr-xr-x  1 root root   28 Dec 11 04:33 snap000150/

Running "rsync -avxn snap000023/. snap000024" turns up the expected
number of different files, as does "rsync -avxn snap000024/. snap000025".
So the snapshot 24 "works"; it just isn't listed in the output of btrfs
subvolume list.  More testing needed.

-- 
| Ian! D. Allen  -  idallen@idallen.ca  -  Ottawa, Ontario, Canada
| Home Page: http://idallen.com/   Contact Improv: http://contactimprov.ca/
| College professor (Free/Libre GNU+Linux) at: http://teaching.idallen.com/
| Defend digital freedom:  http://eff.org/  and have fun:  http://fools.ca/
