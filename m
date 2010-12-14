From: "Ian! D. Allen" <idallen@idallen.ca>
Subject: Re: btrfs subvolume snapshot hung in btrfs_commit_transaction
Date: Mon, 13 Dec 2010 21:23:24 -0500
Message-ID: <20101214022324.GA21001@idallen.ca>
References: <20101212034339.GA26170@idallen.ca>
 <20101212081359.GA7389@idallen.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101212081359.GA7389@idallen.ca>
List-ID: <linux-btrfs.vger.kernel.org>

I can reliably get btrfs 0.19 to hang in btrfs_commit_transaction.
Below is another case where it hung after creating just 110 snapshots
of /var/log/.  Here is an excerpt from the script log file showing the
last good snapshot followed by the hang:

>>> Dec 12 10:25:23 EST 2010 snapshot /mnt/sdf1/snap000108 /mnt/sdf1/snap000109
Create a snapshot of '/mnt/sdf1/snap000108' in '/mnt/sdf1/snap000109'
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/sdf1            195359960 133800028  61559932  69% /mnt/sdf1
Data: total=184.28GB, used=127.29GB
Metadata: total=1.01GB, used=161.60MB
System: total=12.00MB, used=28.00KB

>>> Dec 12 10:26:17 EST 2010 snapshot /mnt/sdf1/snap000109 /mnt/sdf1/snap000110
[... HUNG HERE in btrfs subvolume snapshot /mnt/sdf1/snap000109 /mnt/sdf1/snap000110 ...]

Here's a small example of what's in kern.log:

2010-12-12T10:28:18.721597-05:00 linux kernel: [31921.122910] INFO: task btrfs-transacti:26891 blocked for more than 120 seconds.
2010-12-12T10:28:18.721642-05:00 linux kernel: [31921.122918] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
2010-12-12T10:28:18.721656-05:00 linux kernel: [31921.122925] btrfs-transac D 00000001003010a3     0 26891      2 0x00000000
2010-12-12T10:28:18.721667-05:00 linux kernel: [31921.122936]  ffff8801b1649d40 0000000000000046 0000000000000000 0000000000015980
2010-12-12T10:28:18.721678-05:00 linux kernel: [31921.122946]  ffff8801b1649fd8 0000000000015980 ffff8801b1649fd8 ffff8800833f16e0
2010-12-12T10:28:18.721688-05:00 linux kernel: [31921.122956]  0000000000015980 0000000000015980 ffff8801b1649fd8 0000000000015980
2010-12-12T10:28:18.721696-05:00 linux kernel: [31921.122964] Call Trace:
2010-12-12T10:28:18.721708-05:00 linux kernel: [31921.123001]  [<ffffffffa05403a9>] wait_for_commit+0x89/0xf0 [btrfs]
2010-12-12T10:28:18.721718-05:00 linux kernel: [31921.123014]  [<ffffffff8107f620>] ? autoremove_wake_function+0x0/0x40
2010-12-12T10:28:18.721728-05:00 linux kernel: [31921.123047]  [<ffffffffa0541c20>] btrfs_commit_transaction+0x5f0/0x6f0 [btrfs]
2010-12-12T10:28:18.721738-05:00 linux kernel: [31921.123077]  [<ffffffffa054212b>] ? start_transaction+0x1ab/0x230 [btrfs]
2010-12-12T10:28:18.721751-05:00 linux kernel: [31921.123087]  [<ffffffff8107f620>] ? autoremove_wake_function+0x0/0x40
2010-12-12T10:28:18.721763-05:00 linux kernel: [31921.123115]  [<ffffffffa053bf33>] transaction_kthread+0x283/0x290 [btrfs]
2010-12-12T10:28:18.721774-05:00 linux kernel: [31921.123143]  [<ffffffffa053bcb0>] ? transaction_kthread+0x0/0x290 [btrfs]
2010-12-12T10:28:18.721782-05:00 linux kernel: [31921.123152]  [<ffffffff8107f0c6>] kthread+0x96/0xa0
2010-12-12T10:28:18.721792-05:00 linux kernel: [31921.123161]  [<ffffffff8100aee4>] kernel_thread_helper+0x4/0x10
2010-12-12T10:28:18.721800-05:00 linux kernel: [31921.123169]  [<ffffffff8107f030>] ? kthread+0x0/0xa0
2010-12-12T10:28:18.721812-05:00 linux kernel: [31921.123177]  [<ffffffff8100aee0>] ? kernel_thread_helper+0x0/0x10

After a reboot we try the fsck:

# btrfsck /dev/sdc1
fs tree 5151 refs 110 

followed by 110 lines of the form:

unresolved ref root NNNN dir 256 index 4898 namelen 10 name snap000001 error 600

where NNNN goes from 5150 to 5259.  Then this closing output:

found 136841752576 bytes used err is 1
total csum bytes: 133469012
total tree bytes: 169484288
total fs tree bytes: 4497408
btree space waste bytes: 22338098
file data blocks allocated: 149437534208
 referenced 149425737728
Btrfs Btrfs v0.19
Command exited with non-zero status 1

The "ps" listing showed the same as in my previous messages.

-- 
| Ian! D. Allen  -  idallen@idallen.ca  -  Ottawa, Ontario, Canada
| Home Page: http://idallen.com/   Contact Improv: http://contactimprov.ca/
| College professor (Free/Libre GNU+Linux) at: http://teaching.idallen.com/
| Defend digital freedom:  http://eff.org/  and have fun:  http://fools.ca/
