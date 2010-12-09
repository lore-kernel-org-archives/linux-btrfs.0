From: "Ian! D. Allen" <idallen@idallen.ca>
Subject: Re: btrfs subvolume snapshot hung in btrfs_commit_transaction
Date: Thu, 9 Dec 2010 14:46:39 -0500
Message-ID: <20101209194639.GA10171@idallen.ca>
References: <20101208140102.GA30686@idallen.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101208140102.GA30686@idallen.ca>
List-ID: <linux-btrfs.vger.kernel.org>

Hello developers - Last chance to get more details on this btrfs hang
(below) before I reboot the machine.  Anything I can do to gather
more data?

Linux linux 2.6.35-23-generic #40-Ubuntu SMP Wed Nov 17 22:14:33 UTC 2010 x86_64 GNU/Linux

Description: Ubuntu 10.10

Package: btrfs-tools
Status: install ok installed
Priority: optional
Section: admin
Installed-Size: 1408
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Architecture: amd64
Version: 0.19+20100601-3
Depends: e2fslibs (>= 1.37), libc6 (>= 2.7), libcomerr2 (>= 1.01), libuuid1 (>= 2.16), zlib1g (>= 1:1.2.0)
Original-Maintainer: Daniel Baumann <daniel@lists.debian-maintainers.org>
Homepage: http://btrfs.wiki.kernel.org/

On Wed, Dec 08, 2010 at 09:01:02AM -0500, Ian! D. Allen wrote:
> I've been exercising btrfs doing a continuous loop of:
> 
>     - delete an old snapshot to keep disk space about the same
>     - create snapshot from previous snapshot
>     - rsync root into new snapshot
> 
> I have room for 150 snapshots on disk.  I delete the oldest, create
> the newest, do the rsync into the newest, repeat.  It hung today on
> snapshot 564:
> 
> $ ps uww 24575
> USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
> root     24575  0.0  0.0   6224   332 pts/10   DN   07:35   0:00 btrfs subvolume snapshot /mnt/sde1/snap564 /mnt/sde1/snap565
> 
> $ ps lww 24575
> F   UID   PID  PPID PRI  NI    VSZ   RSS WCHAN  STAT TTY        TIME COMMAND
> 4     0 24575 27716  35   -   6224   332 btrfs_ DN   pts/10     0:00 btrfs subvolume snapshot /mnt/sde1/snap564 /mnt/sde1/snap565
> 
> $ ps -o wchan 24575
> WCHAN
> btrfs_commit_transaction
> 
> No messages in "dmesg" or kernel log.  Anyone want me to run some other
> debug tests to find out what is wrong?  Anything that tries to access
> anything inside the btrfs file system /dev/sde1 hangs uninterruptably:
> 
> 1     0  1863     2  20   0      0     0 wait_f D    ?          0:29 [btrfs-transacti]
> 4     0  4933  4925  20   0  26524  2864 lookup D+   pts/10     0:02 /bin/bash
> 1   777 27995  7318  20   0  26576  1784 vfs_re D+   pts/52     0:00 bash
> 0   777 29395  7284  20   0  21856   688 vfs_re D    pts/51     0:00 ls -abp --color=auto /mnt/sde1
> 0   777 29510  7284  20   0  21856   692 vfs_re D    pts/51     0:00 /bin/ls /mnt/sde1
> 
> $ ps -o wchan 1863
> WCHAN
> wait_for_commit
> 
> $ ps -o wchan 27995
> WCHAN
> vfs_readdir

-- 
| Ian! D. Allen  -  idallen@idallen.ca  -  Ottawa, Ontario, Canada
| Home Page: http://idallen.com/   Contact Improv: http://contactimprov.ca/
| College professor (Free/Libre GNU+Linux) at: http://teaching.idallen.com/
| Defend digital freedom:  http://eff.org/  and have fun:  http://fools.ca/
