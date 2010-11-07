From: Brian Neu <proclivity76@yahoo.com>
Subject: postgresql activity causes crash, 2.6.36.1
Date: Sat, 6 Nov 2010 18:08:59 -0700 (PDT)
Message-ID: <225116.26295.qm@web51906.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

After a successful db startup, this crash was reproducible every time with db 
activity, or possibly just time.  The filesystem is a raid1 and even after a 
reformat and restore from backup, the crash remains:

Label: slash  uuid: a9730db3-a475-45bb-af94-a873e235114b
        Total devices 2 FS bytes used 39.04GB
        devid    2 size 97.66GB used 48.51GB path /dev/sdb2
        devid    1 size 97.66GB used 48.53GB path /dev/sda2

mounted as:
# mount |grep sdb2
/dev/sdb2 on / type btrfs (rw,noatime)



This is transcribed from the screen, so forgive type-o's and "<blah>"  .    Let 
me know if I skipped something important.
(every line starts with [27163.079010] )

Call trace:
__btrfs_submit_bio_done+0x1b/0x1d [btrfs]
run_one_async_done+0x94/0x98 [btrfs]
run_ordered_completions++0x78/0xaa [btrfs]
worker_loop+0x199/0x4ec [btrfs]
kthread+0x0d/0xa5
kernel_thread_helper+0x4/0x10
? restore_args+0x0/0x30
? kthread+0x0/0xa5
? kernel_thread_helper+0x0/0x10
Code: 74 04 <blah blah>
RIP [<ffff<blah> 7>] btrfs_map_bio+0x88/0x1c9
RSP <ffb<blah>>
---[ end trace f8<blah> ]---

