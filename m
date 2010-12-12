From: "Ian! D. Allen" <idallen@idallen.ca>
Subject: Re: btrfs subvolume snapshot hung in btrfs_commit_transaction
Date: Sat, 11 Dec 2010 22:43:39 -0500
Message-ID: <20101212034339.GA26170@idallen.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This is a second try to post this follow-up, with the dmesg log info
deleted.  What is the size/length limit on this mailing list?

On Thu, Dec 09, 2010 at 02:46:39PM -0500, Ian! D. Allen wrote:
> Hello developers - Last chance to get more details on this btrfs hang
> (below) before I reboot the machine.  Anything I can do to gather
> more data?

Too late.  The machine eventually hung and had to be rebooted.  I've saved
that hung btrfs disk partition (185GB) if anyone wants to contact me to
examine it further.

I put in a larger disk (250GB), set up a partition for btrfs, and ran
the same continuous snapshotting test.  It got up to creating snapshot
150 and then btrfs hung again.  So the bug is repeatable and makes btrfs
0.19 on Ubuntu 10.10 unusable.

# ps laxgww | awk '$10 ~ /D/ {print }'
0     0  3723 28355  35   -   6224   332 btrfs_ DN+  pts/7      0:00 btrfs subvolume snapshot /mnt/sdb1/snap000150 /mnt/sdb1/snap000151
1     0 27334     2  20   0      0     0 wait_f D    ?          0:02 [btrfs-transacti]

I ran an "ls" on the root of the btrfs partition and it hung, too,
as does anything trying to access anything in that partition:

0   777 10005  3732  20   0  21856   692 vfs_re D    pts/11     0:00 ls -abp --color=auto /mnt/sdb1

Here are the blocked process WCHANs:

# ps -o wchan 3723 27334 10005 
WCHAN
btrfs_commit_transaction
wait_for_commit
vfs_readdir

Here is what appeared in /var/log/kernel.log regarding the above processes:

2010-12-11T10:47:32.583745-05:00 linux kernel: [43201.070404] INFO: task btrfs-transacti:27334 blocked for more than 120 seconds.

[... 175 more related dmesg lines deleted ... ]

-- 
| Ian! D. Allen  -  idallen@idallen.ca  -  Ottawa, Ontario, Canada
| Home Page: http://idallen.com/   Contact Improv: http://contactimprov.ca/
| College professor (Free/Libre GNU+Linux) at: http://teaching.idallen.com/
| Defend digital freedom:  http://eff.org/  and have fun:  http://fools.ca/
