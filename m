Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34253 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1161186AbcIZRwL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Sep 2016 13:52:11 -0400
Date: Mon, 26 Sep 2016 19:50:00 +0200
From: David Sterba <dsterba@suse.cz>
To: Anatoly Pugachev <matorola@gmail.com>
Cc: Omar Sandoval <osandov@osandov.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com, Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        bo.li.liu@oracle.com
Subject: Re: [PATCH v2 0/6] Btrfs: free space tree and sanity test fixes
Message-ID: <20160926175000.GF16983@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1474580472.git.osandov@fb.com>
 <20160925075524.GA3870@yogzotot>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160925075524.GA3870@yogzotot>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Sep 25, 2016 at 10:55:24AM +0300, Anatoly Pugachev wrote:
> applied patch to git kernel (v4.8-rc7-172-gbd5dbcb) cleanly. Did not used
> btrfs-progs.git, but debian shipped 4.7.3-1 .
> 
> (re)booted to a newly patched kernel and used xfstests.git (v1.1.0-1328-g06d4001):
> 
> # mount tmpfs -t tmpfs -o size=26g /ramdisk
> # cd /ramdisk
> # fallocate -l 10g testvol1
> # for i in 1 2 3 4; do fallocate -l 4g scratch${i}; done
> # for i in *; do losetup -f $i; done
> # losetup
> NAME       SIZELIMIT OFFSET AUTOCLEAR RO BACK-FILE         DIO
> /dev/loop0         0      0         0  0 /ramdisk/scratch1   0
> /dev/loop1         0      0         0  0 /ramdisk/scratch2   0
> /dev/loop2         0      0         0  0 /ramdisk/scratch3   0
> /dev/loop3         0      0         0  0 /ramdisk/scratch4   0
> /dev/loop4         0      0         0  0 /ramdisk/testvol1   0
> 
> mator@ttip:~/xfstests-dev$ cat local.config
> export TEST_DEV=/dev/loop4
> export TEST_DIR=/testvol
> export SCRATCH_DEV_POOL="/dev/loop0 /dev/loop1 /dev/loop2 /dev/loop3"
> export SCRATCH_MNT=/mnt/scratch
> 
> root@ttip:/home/mator/xfstests-dev# mkfs.btrfs /dev/loop4
> btrfs-progs v4.7.3
> See http://btrfs.wiki.kernel.org for more information.
> 
> Performing full device TRIM (10.00GiB) ...
> Label:              (null)
> UUID:
> Node size:          16384
> Sector size:        8192
> Filesystem size:    10.00GiB
> Block group profiles:
>   Data:             single            8.00MiB
>   Metadata:         DUP               1.00GiB
>   System:           DUP               8.00MiB
> SSD detected:       no
> Incompat features:  extref, skinny-metadata
> Number of devices:  1
> Devices:
>    ID        SIZE  PATH
>     1    10.00GiB  /dev/loop4
> 
> root@ttip:/home/mator/xfstests-dev# ./check 'btrfs/*'
> FSTYP         -- btrfs
> PLATFORM      -- Linux/sparc64 ttip 4.8.0-rc7+
> MKFS_OPTIONS  -- /dev/loop0
> MOUNT_OPTIONS -- /dev/loop0 /mnt/scratch
> 
> _check_btrfs_filesystem: filesystem on /dev/loop4 is inconsistent (see /home/mator/xfstests-dev/results//check.full)
> btrfs/001
> 
> 
> (on another screen/tmux window shell)
> 
> $ pstree -A | grep check 
>         |-sshd-+-sshd---sshd---bash---sudo---bash---check---001---mount
> 
> $ ps ax | grep mount
>  76344 pts/0    D+     0:00 /bin/mount -t btrfs /dev/loop4 /testvol
> 
> $ cat /home/mator/xfstests-dev/results//check.full
> _check_btrfs_filesystem: filesystem on /dev/loop4 is inconsistent
> *** fsck.btrfs output ***
> ERROR: cannot open device '/dev/loop4': Device or resource busy
> Couldn't open file system
> *** end fsck.btrfs output
> *** mount output ***
> sysfs on /sys type sysfs (rw,relatime)
> proc on /proc type proc (rw,relatime)
> udev on /dev type devtmpfs (rw,nosuid,relatime,size=16479064k,nr_inodes=2059883,mode=755)
> devpts on /dev/pts type devpts (rw,relatime,gid=5,mode=620,ptmxmode=000)
> tmpfs on /run type tmpfs (rw,nosuid,noexec,relatime,size=3314128k,mode=755)
> /dev/vdiska2 on / type ext4 (rw,relatime,errors=remount-ro,data=ordered)
> securityfs on /sys/kernel/security type securityfs (rw,nosuid,nodev,noexec,relatime)
> tmpfs on /dev/shm type tmpfs (rw)
> tmpfs on /run/lock type tmpfs (rw,nosuid,nodev,noexec,relatime,size=5120k)
> tmpfs on /sys/fs/cgroup type tmpfs (ro,nosuid,nodev,noexec,mode=755)
> cgroup on /sys/fs/cgroup/systemd type cgroup (rw,nosuid,nodev,noexec,relatime,xattr,release_agent=/lib/systemd/systemd-cgroups-agent,name=systemd)
> cgroup on /sys/fs/cgroup/cpu,cpuacct type cgroup (rw,nosuid,nodev,noexec,relatime,cpu,cpuacct)
> cgroup on /sys/fs/cgroup/cpuset type cgroup (rw,nosuid,nodev,noexec,relatime,cpuset)
> cgroup on /sys/fs/cgroup/blkio type cgroup (rw,nosuid,nodev,noexec,relatime,blkio)
> cgroup on /sys/fs/cgroup/net_cls,net_prio type cgroup (rw,nosuid,nodev,noexec,relatime,net_cls,net_prio)
> cgroup on /sys/fs/cgroup/perf_event type cgroup (rw,nosuid,nodev,noexec,relatime,perf_event)
> cgroup on /sys/fs/cgroup/pids type cgroup (rw,nosuid,nodev,noexec,relatime,pids)
> cgroup on /sys/fs/cgroup/memory type cgroup (rw,nosuid,nodev,noexec,relatime,memory)
> cgroup on /sys/fs/cgroup/devices type cgroup (rw,nosuid,nodev,noexec,relatime,devices)
> cgroup on /sys/fs/cgroup/freezer type cgroup (rw,nosuid,nodev,noexec,relatime,freezer)
> systemd-1 on /proc/sys/fs/binfmt_misc type autofs (rw,relatime,fd=29,pgrp=1,timeout=0,minproto=5,maxproto=5,direct,pipe_ino=23073)
> mqueue on /dev/mqueue type mqueue (rw,relatime)
> debugfs on /sys/kernel/debug type debugfs (rw,relatime)
> hugetlbfs on /dev/hugepages type hugetlbfs (rw,relatime)
> /dev/vdiska1 on /boot type ext3 (rw,relatime,data=ordered)
> /dev/vdiskb1 on /home type xfs (rw,relatime,attr2,inode64,noquota)
> binfmt_misc on /proc/sys/fs/binfmt_misc type binfmt_misc (rw,relatime)
> tmpfs on /run/user/1000 type tmpfs (rw,nosuid,nodev,relatime,size=3314120k,mode=700,uid=1000,gid=1000)
> tmpfs on /ramdisk type tmpfs (rw,relatime,size=27262976k)
> /dev/loop0 on /mnt/scratch type btrfs (rw,relatime,space_cache,subvolid=5,subvol=/)
> *** end mount output
> 
> in kernel logs and on console:
> 
> [3184224.438566] BTRFS: device fsid b54ec0aa-4187-419d-9de1-5ef284cd3b32 devid 1 transid 5 /dev/loop4
> [3184239.417845] BTRFS info (device loop4): disk space caching is enabled
> [3184239.417865] BTRFS info (device loop4): has skinny extents
> [3184239.417872] BTRFS info (device loop4): flagging fs with big metadata feature
> [3184239.421147] BTRFS info (device loop4): creating UUID tree
> [3184240.026601] BTRFS: device fsid 5383d227-9ea2-4514-8857-641c6e2e2063 devid 1 transid 5 /dev/loop0
> [3184240.131927] BTRFS info (device loop0): disk space caching is enabled
> [3184240.131956] BTRFS info (device loop0): has skinny extents
> [3184240.131971] BTRFS info (device loop0): flagging fs with big metadata feature
> [3184240.135182] BTRFS info (device loop0): creating UUID tree
> [3184240.252534] BTRFS critical (device loop4): corrupt leaf, non-root leaf's nritems is 0: block=29556736,root=1, slot=0

The error does not seem to be related to the free space bitmap issues
(at least I don't see a connection). The message is from

  1ba98d086fe3a14d6a31f2f66dbab70c45d00f63
  "Btrfs: detect corruption when non-root leaf has zero item"

called from btrfs_mark_buffer_dirty with integrity checker on.
Confirmed from the log:

> [3102837.870398] Btrfs loaded, crc32c=crc32c-sparc64, debug=on, assert=on, integrity-checker=on
...

This is fixed by patch

  "Btrfs: remove unnecessary btrfs_mark_buffer_dirty in split_leaf"

that's in the 4.9 queue. Other than that, the self-tests seem to pass,
thanks for the test. Would be good if you can test with the mentioned
patch included or without integrity checker. Thanks for testing.
