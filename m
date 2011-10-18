From: Jim <jim@webstarts.com>
Subject: ls hangs filesystem
Date: Tue, 18 Oct 2011 09:25:46 -0400
Message-ID: <4E9D7E5A.2010403@webstarts.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Good morning btrfs list,
I have been rsyncing files from an nfs mount to a btrfs filesystem.  
After an rsync run I ls random subvols or directorys to check the copy.  
About 60% to 70% of the time ls completely hangs.  Ps aux shows it as 
running but even when I let it go for up to an hour it never finishes.  
Kill -9 will not stop the process.  Dmesg shows nothing beyond a 
successful mount at boot.  I can't umount the system because "filesystem 
is busy".  I find that a forced reboot is the only way to recapture the 
system.  /var/log/messages has the only indication (that I can find) 
that anything abnormal is happening.  A tail of the file is below.  
Thank you for any help and advice.
Jim

[root@btrfs ~]# tail -20 /var/log/messages
Oct 18 05:06:36 btrfs kernel: [<ffffffff81142849>] sys_getdents+0x89/0xf0
Oct 18 05:06:36 btrfs kernel: [<ffffffff814b19ab>] 
system_call_fastpath+0x16/0x1b
Oct 18 05:08:36 btrfs kernel: INFO: task ls:7100 blocked for more than 
120 seconds.
Oct 18 05:08:36 btrfs kernel: "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Oct 18 05:08:36 btrfs kernel: ls              D ffff88080bc843d8     0  
7100   7047 0x00000084
Oct 18 05:08:36 btrfs kernel: ffff8804f526dd68 0000000000000086 
ffff8804f526dd18 ffffffff00000000
Oct 18 05:08:36 btrfs kernel: ffff88080bc84000 0000000000011900 
ffff8804f526dfd8 ffff8804f526c010
Oct 18 05:08:36 btrfs kernel: ffff8804f526dfd8 0000000000011900 
ffff88080f64d7f0 ffff88080bc84000
Oct 18 05:08:36 btrfs kernel: Call Trace:
Oct 18 05:08:36 btrfs kernel: [<ffffffffa01a0f45>] 
wait_current_trans+0xa5/0x110 [btrfs]
Oct 18 05:08:36 btrfs kernel: [<ffffffff8106c0e0>] ? wake_up_bit+0x40/0x40
Oct 18 05:08:36 btrfs kernel: [<ffffffffa01a2540>] 
start_transaction+0x1e0/0x2b0 [btrfs]
Oct 18 05:08:36 btrfs kernel: [<ffffffffa01a2665>] 
btrfs_join_transaction+0x15/0x20 [btrfs]
Oct 18 05:08:36 btrfs kernel: [<ffffffffa01ad360>] 
btrfs_dirty_inode+0x50/0x160 [btrfs]
Oct 18 05:08:36 btrfs kernel: [<ffffffff8115631f>] 
__mark_inode_dirty+0x3f/0x200
Oct 18 05:08:36 btrfs kernel: [<ffffffff81148bf5>] touch_atime+0x115/0x150
Oct 18 05:08:36 btrfs kernel: [<ffffffff81142520>] ? sys_ioctl+0xb0/0xb0
Oct 18 05:08:36 btrfs kernel: [<ffffffff811426ce>] vfs_readdir+0xce/0xe0
Oct 18 05:08:36 btrfs kernel: [<ffffffff81142849>] sys_getdents+0x89/0xf0
Oct 18 05:08:36 btrfs kernel: [<ffffffff814b19ab>] 
system_call_fastpath+0x16/0x1b
