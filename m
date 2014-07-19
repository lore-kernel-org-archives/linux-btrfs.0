Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:46545 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530AbaGSAd7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Jul 2014 20:33:59 -0400
Date: Fri, 18 Jul 2014 17:33:45 -0700
From: Marc MERLIN <marc@merlins.org>
To: Chris Mason <clm@fb.com>
Cc: Cody P Schafer <dev@codyps.com>, Chris Samuel <chris@csamuel.org>,
        linux-btrfs@vger.kernel.org
Message-ID: <20140719003345.GB11996@merlins.org>
References: <CAPoQQ-093rEw6mRRDCS4bq8oGOvmuR_a6UAVOjK_ytb=Yq2BSw@mail.gmail.com>
 <53B1A862.50503@fb.com>
 <53B1ACAA.5040505@fb.com>
 <CAPoQQ-14VPzzwTDDXmLSmEUs2Rm_HyukoYjeFfOi9LOjqaRCWw@mail.gmail.com>
 <53B32275.6010200@fb.com>
 <CAPoQQ-3DmAg=s0eBKirGmkfMhaC1bEyJu8fSJc-6fV-EvUbmxQ@mail.gmail.com>
 <CAPoQQ-1kn+UNfcE4+qeO4yKaX43PenqxBtMXABuP=Ot8=ZB2Gw@mail.gmail.com>
 <53B40FEC.4030902@fb.com>
 <53B4140C.8060406@fb.com>
 <53C7CD0F.7070603@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <53C7CD0F.7070603@fb.com>
Subject: Re: Blocked tasks on 3.15.1, raid1 btrfs is no ends of trouble for me
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 17, 2014 at 09:18:07AM -0400, Chris Mason wrote:
> 
> [ deadlocks during rsync in 3.15 with compression enabled ]
> 
> Hi everyone,
> 
> I still haven't been able to reproduce this one here, but I'm going
> through a series of tests with lzo compression foraced and every
> operation forced to ordered.  Hopefully it'll kick it out soon.
> 
> While I'm hammering away, could you please try this patch.  If this is
> the buy you're hitting, the deadlock will go away and you'll see this
> printk in the log.
> 
> thanks!
> 
> -chris
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 3668048..8ab56df 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -8157,6 +8157,13 @@ void btrfs_destroy_inode(struct inode *inode)
>  		spin_unlock(&root->fs_info->ordered_root_lock);
>  	}
>  
> +	spin_lock(&root->fs_info->ordered_root_lock);
> +	if (!list_empty(&BTRFS_I(inode)->ordered_operations)) {
> +		list_del_init(&BTRFS_I(inode)->ordered_operations);
> +printk(KERN_CRIT "racing inode deletion with ordered operations!!!!!!!!!!!\n");
> +	}
> +	spin_unlock(&root->fs_info->ordered_root_lock);
> +
>  	if (test_bit(BTRFS_INODE_HAS_ORPHAN_ITEM,
>  		     &BTRFS_I(inode)->runtime_flags)) {
>  		btrfs_info(root->fs_info, "inode %llu still on the orphan list",

I've gotten more blocked messages with your patch:


See also the message I sent about memory leaks, and how enabling
kmemleak gets btrfs to deadlock soon after boot relibably.
https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg35568.html
(this was before your patch though)

With your patch (and without kmemleak):

gargamel:/etc/apache2/sites-enabled# ps -eo pid,etime,wchan:30,args |grep df
 3495    01:48:38 btrfs_statfs                   df -hP -x none -x tmpfs -x iso9660 -x udf -x nfs
 4105    07:48:39 btrfs_statfs                   df -hP -x none -x tmpfs -x iso9660 -x udf -x nfs
12639       48:38 btrfs_statfs                   df -hP -x none -x tmpfs -x iso9660 -x udf -x nfs
12691       48:37 btrfs_statfs                   df
14753    06:48:38 btrfs_statfs                   df -hP -x none -x tmpfs -x iso9660 -x udf -x nfs
17214    10:48:39 btrfs_statfs                   df -hP -x none -x tmpfs -x iso9660 -x udf -x nfs
17526    03:48:38 btrfs_statfs                   df -hP -x none -x tmpfs -x iso9660 -x udf -x nfs
18710    09:48:38 btrfs_statfs                   df -hP -x none -x tmpfs -x iso9660 -x udf -x nfs
23668    05:48:38 btrfs_statfs                   df -hP -x none -x tmpfs -x iso9660 -x udf -x nfs
26675    11:37:42 btrfs_statfs                   df .
26828    02:48:38 btrfs_statfs                   df -hP -x none -x tmpfs -x iso9660 -x udf -x nfs
27515    08:48:38 btrfs_statfs                   df -hP -x none -x tmpfs -x iso9660 -x udf -x nfs

sysrq-w does not show me output for those and I cannot understand why.

Howver, I have found that btrfs raid 1 on top of dmcrypt has given me no ends of trouble.
I lost that filesystem twice due to corruption, and now it hangs my machine (strace finds
that df is hanging on that partition).
gargamel:~# btrfs fi df /mnt/btrfs_raid0
Data, RAID1: total=222.00GiB, used=221.61GiB
Data, single: total=8.00MiB, used=0.00
System, RAID1: total=8.00MiB, used=48.00KiB
System, single: total=4.00MiB, used=0.00
Metadata, RAID1: total=2.00GiB, used=1.10GiB
Metadata, single: total=8.00MiB, used=0.00
unknown, single: total=384.00MiB, used=0.00
gargamel:~# btrfs fi show /mnt/btrfs_raid0
Label: 'btrfs_raid0'  uuid: 74279e10-46e7-4ac4-8216-a291819a6691
        Total devices 2 FS bytes used 222.71GiB
        devid    1 size 836.13GiB used 224.03GiB path /dev/dm-3
        devid    2 size 836.13GiB used 224.01GiB path /dev/mapper/raid0d2

Btrfs v3.14.1


This is not encouraging, I think I'm going to stop using raid1 in btrfs :(

I tried sysrq-t, but the output goes faster than my serial console can
capture it, I can't get you a traceback on those df processes.
the dmesg buffer is too small
I already have 
Kernel log buffer size (16 => 64KB, 17 => 128KB) (LOG_BUF_SHIFT) [17] (NEW) 17
and the kernel config does not let me increase it to something more useful like 24.

Btrfs in 3.15 has been no end of troubles for me on my 2 machines, and I can't even capture
useful info when it happens since my long sysrq dumps get truncated and
flow faster than syslog can capture and relay them it seems.

Do you have any suggestions on how to capture that data better?

In the meantime, kernel log when things started hanging is below. the zm processes 
are indeed accessing that raid1 partition.

[67499.502755] INFO: task btrfs-transacti:2867 blocked for more than 120 seconds.
[67499.526860]       Not tainted 3.15.5-amd64-i915-preempt-20140714cm1 #1
[67499.548624] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[67499.575212] btrfs-transacti D 0000000000000001     0  2867      2 0x00000000
[67499.598611]  ffff8802135e7e10 0000000000000046 ffff880118322158 ffff8802135e7fd8
[67499.623218]  ffff8800c96242d0 00000000000141c0 ffff880213496000 ffff880046d1fd40
[67499.647684]  ffff880118322158 ffff880118322100 0000000000000000 ffff8802135e7e20
[67499.672179] Call Trace:
[67499.681567]  [<ffffffff8161fa5e>] schedule+0x73/0x75
[67499.698510]  [<ffffffff8122ceb9>] btrfs_commit_transaction+0x333/0x8b0
[67499.720117]  [<ffffffff8108489d>] ? finish_wait+0x65/0x65
[67499.738331]  [<ffffffff8122966a>] transaction_kthread+0xf8/0x1ab
[67499.758313]  [<ffffffff81229572>] ? btrfs_cleanup_transaction+0x44c/0x44c
[67499.780605]  [<ffffffff8106b564>] kthread+0xae/0xb6
[67499.798238]  [<ffffffff8106b4b6>] ? __kthread_parkme+0x61/0x61
[67499.817609]  [<ffffffff81628d7c>] ret_from_fork+0x7c/0xb0
[67499.835645]  [<ffffffff8106b4b6>] ? __kthread_parkme+0x61/0x61
[67499.856079] INFO: task zma:5225 blocked for more than 120 seconds.
[67499.877451]       Not tainted 3.15.5-amd64-i915-preempt-20140714cm1 #1
[67499.899807] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[67499.926049] zma             D 0000000000000000     0  5225   4863 0x20020084
[67499.950039]  ffff8801f4117bb0 0000000000000082 ffff880211e5b270 ffff8801f4117fd8
[67499.975054]  ffff8801c74c8590 00000000000141c0 ffff880118322100 ffff8800c9e341e8
[67500.000049]  0000000000000000 ffff8800c9e34000 ffff880046d1ff20 ffff8801f4117bc0
[67500.024086] Call Trace:
[67500.033079]  [<ffffffff8161fa5e>] schedule+0x73/0x75
[67500.050477]  [<ffffffff8122c3b4>] wait_current_trans.isra.15+0x98/0xf4
[67500.071684]  [<ffffffff8108489d>] ? finish_wait+0x65/0x65
[67500.089422]  [<ffffffff8122d8ce>] start_transaction+0x498/0x4fc
[67500.108678]  [<ffffffff8122d94d>] btrfs_start_transaction+0x1b/0x1d
[67500.128989]  [<ffffffff81237b3f>] btrfs_create+0x3c/0x1ce
[67500.147460]  [<ffffffff8129a57d>] ? security_inode_permission+0x1c/0x23
[67500.168738]  [<ffffffff81160430>] ? __inode_permission+0x79/0xa4
[67500.188164]  [<ffffffff811616ee>] vfs_create+0x66/0x8c
[67500.204923]  [<ffffffff81162450>] do_last+0x5af/0xa23
[67500.221393]  [<ffffffff81162afb>] path_openat+0x237/0x4de
[67500.238899]  [<ffffffff816225a9>] ? _raw_spin_lock_irqsave+0x21/0x4a
[67500.259953]  [<ffffffff8162223d>] ? _raw_spin_unlock_irqrestore+0x1f/0x32
[67500.281773]  [<ffffffff81163efa>] do_filp_open+0x3a/0x7f
[67500.298935]  [<ffffffff8162220b>] ? _raw_spin_unlock+0x17/0x2a
[67500.317622]  [<ffffffff8116dedd>] ? __alloc_fd+0xea/0xf9
[67500.334714]  [<ffffffff8115648f>] do_sys_open+0x70/0xff
[67500.351512]  [<ffffffff8119691b>] compat_SyS_open+0x1b/0x1d
[67500.369317]  [<ffffffff8162ab2c>] sysenter_dispatch+0x7/0x21
[67500.387936] INFO: task zma:5245 blocked for more than 120 seconds.
[67500.407543]       Not tainted 3.15.5-amd64-i915-preempt-20140714cm1 #1
[67500.428139] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[67500.452610] zma             D ffff88021371eb80     0  5245   4863 0x20020080
[67500.474872]  ffff8800b2fd3bb0 0000000000000086 ffff880211e5b270 ffff8800b2fd3fd8
[67500.498274]  ffff8801889b61d0 00000000000141c0 ffff880118322100 ffff8800c9e341e8
[67500.521624]  0000000000000000 ffff8800c9e34000 ffff880102fce0c0 ffff8800b2fd3bc0
[67500.544987] Call Trace:
[67500.553292]  [<ffffffff8161fa5e>] schedule+0x73/0x75
[67500.569694]  [<ffffffff8122c3b4>] wait_current_trans.isra.15+0x98/0xf4
[67500.590266]  [<ffffffff8108489d>] ? finish_wait+0x65/0x65
[67500.607468]  [<ffffffff8122d8ce>] start_transaction+0x498/0x4fc
[67500.626205]  [<ffffffff8122d94d>] btrfs_start_transaction+0x1b/0x1d
[67500.645984]  [<ffffffff81237b3f>] btrfs_create+0x3c/0x1ce
[67500.663666]  [<ffffffff8129a57d>] ? security_inode_permission+0x1c/0x23
[67500.684852]  [<ffffffff81160430>] ? __inode_permission+0x79/0xa4
[67500.703862]  [<ffffffff811616ee>] vfs_create+0x66/0x8c
[67500.720746]  [<ffffffff81162450>] do_last+0x5af/0xa23
[67500.736856]  [<ffffffff81162afb>] path_openat+0x237/0x4de
[67500.754513]  [<ffffffff816225a9>] ? _raw_spin_lock_irqsave+0x21/0x4a
[67500.775057]  [<ffffffff8162223d>] ? _raw_spin_unlock_irqrestore+0x1f/0x32
[67500.796364]  [<ffffffff81163efa>] do_filp_open+0x3a/0x7f
[67500.813245]  [<ffffffff8162220b>] ? _raw_spin_unlock+0x17/0x2a
[67500.831682]  [<ffffffff8116dedd>] ? __alloc_fd+0xea/0xf9
[67500.848983]  [<ffffffff8115648f>] do_sys_open+0x70/0xff
[67500.866040]  [<ffffffff8119691b>] compat_SyS_open+0x1b/0x1d
[67500.883677]  [<ffffffff8162ab2c>] sysenter_dispatch+0x7/0x21

-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
