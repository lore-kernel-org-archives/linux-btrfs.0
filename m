From: Max <mikhmv@gmail.com>
Subject: Re:
Date: Tue, 31 Jan 2012 15:53:48 +0000 (UTC)
Message-ID: <loom.20120131T164351-772@post.gmane.org>
References: <loom.20111221T141346-863@post.gmane.org> <20111221190605.GY19266@shiny> <4EF2FBDD.3090709@rootbox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Malwina Bartoszynska <m.bartoszynska <at> rootbox.com> writes:

> 
> W dniu 2011-12-21 20:06, Chris Mason pisze:
> > On Wed, Dec 21, 2011 at 01:54:06PM +0000, Malwina Bartoszynska wrote:
> >> Hello,
> >> after unmounting btrfs partition, I can't mount it again.
> >>
> >> root <at> xxx:~# btrfs device scan
> >> Scanning for Btrfs filesystems
> >> root <at> xxx:~# mount /dev/sdb /data/osd.0/
> >> mount: wrong fs type, bad option, bad superblock on /dev/sdb,
> >>         missing codepage or helper program, or other error
> >>         In some cases useful info is found in syslog - try
> >>         dmesg | tail  or so
> >>
> >> root <at> xxxx:~# dmesg|tail
> >> [57192.607912] device fsid ed25c604-3e11-4459-85b5-e4090c4d22d0 devid
> >> 2 transid14429 /dev/sda
> >> [57204.796573] end_request: I/O error, dev fd0, sector 0
> >> [57231.660913] device fsid ed25c604-3e11-4459-85b5-e4090c4d22d0 devid 1
> >>   transid 14429 /dev/sdb
> >> [57231.680387] parent transid verify failed on 424308420608 wanted 6970
> >>   found 8959
> >> [57231.680546] parent transid verify failed on 424308420608 wanted 6970
> >> found 8959
> >> [57231.680705] parent transid verify failed on 424308420608 wanted 6970
> >> found 8959
> >> [57231.680861] parent transid verify failed on 424308420608 wanted 6970
> >> found 8959
> >> [57231.680869] parent transid verify failed on 424308420608 wanted 6970
> >> found 8959
> >> [57231.680875] Failed to read block groups: -5
> >> [57231.704165] btrfs: open_ctree failed
> > Can you tell us more about this filesystem?  Was there an unclean
> > shutdown or did you just unmount, mount again?
> >
> > The confusing thing is that all of your disks seem to have the same copy
> > of the block, so it looks like things were written properly.
> >
> > -chris
> There was no shutdown before this, filesystem was just unmounted(which 
> looked as properly done - no errors). Then tried to mount it again.
> Is there way of fixing it?
> --
> Malwina Bartoszynska
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo <at> vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

I have the same problem. In my case the failure happens during parallel writing 
several files. I did wget from several sources in parallel

'ls /srv/shared/Downloads/xxx/xxx/' blocked.
and dmesg gave:
[112920.940110] INFO: task btrfs-transacti:719 blocked for more than 120 
seconds.
[112920.965833] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this 
message.
[112920.988255] btrfs-transacti D ffffffff81805120     0   719      2 0x00000000
[112920.988266]  ffff880b857e3d10 0000000000000046 ffff880b80b08198 
0000000000000000
[112920.988273]  ffff880b857e3fd8 ffff880b857e3fd8 ffff880b857e3fd8 
0000000000012a40
[112920.988279]  ffffffff81c0b020 ffff880b8c0c0000 ffff880b857e3d10 
ffff880945187a40
[112920.988298] Call Trace:
[112920.988315]  [<ffffffff8160492f>] schedule+0x3f/0x60
[112920.988326]  [<ffffffff81604f75>] schedule_timeout+0x2a5/0x320
[112920.988338]  [<ffffffff810329a9>] ? default_spin_lock_flags+0x9/0x10
[112920.988371]  [<ffffffffa003ba15>] btrfs_commit_transaction+0x245/0x860 
[btrfs]
[112920.988384]  [<ffffffff81081660>] ? add_wait_queue+0x60/0x60
[112920.988414]  [<ffffffffa00347b5>] transaction_kthread+0x275/0x290 [btrfs]
[112920.988437]  [<ffffffffa0034540>] ? btrfs_congested_fn+0xb0/0xb0 [btrfs]
[112920.988448]  [<ffffffff81080bbc>] kthread+0x8c/0xa0
[112920.988458]  [<ffffffff8160fca4>] kernel_thread_helper+0x4/0x10
[112920.988469]  [<ffffffff81080b30>] ? flush_kthread_worker+0xa0/0xa0
[112920.988479]  [<ffffffff8160fca0>] ? gs_change+0x13/0x13

after reboot the disk was not mounted at all. 

I tried to fix it. 
original btrfsck didn't work at all. 
~$ btrfsck /dev/vdc
Could not open /dev/vdc

after manual update to btrfs-tools_0.19+20111105-2_amd64.deb
it gave me: 

~$ sudo btrfsck /dev/vdc
parent transid verify failed on 20971520 wanted 1347 found 3121
parent transid verify failed on 20971520 wanted 1347 found 3121
parent transid verify failed on 20971520 wanted 1347 found 3121
parent transid verify failed on 20971520 wanted 1347 found 3121
Ignoring transid failure
parent transid verify failed on 29470720 wanted 1357 found 3231
parent transid verify failed on 29470720 wanted 1357 found 3231
parent transid verify failed on 29470720 wanted 1357 found 3231
parent transid verify failed on 29470720 wanted 1357 found 3231
Ignoring transid failure
parent transid verify failed on 29470720 wanted 1357 found 3231
Ignoring transid failure
parent transid verify failed on 29487104 wanted 1357 found 3235
parent transid verify failed on 29487104 wanted 1357 found 3235
parent transid verify failed on 29487104 wanted 1357 found 3235
parent transid verify failed on 29487104 wanted 1357 found 3235
Ignoring transid failure
leaf 29487104 items 1 free space 3454 generation 3235 owner 7
fs uuid c5ce4702-2dbf-4b57-8067-bd6129fc124b
chunk uuid 0ffa84fe-33a3-4b8e-95a4-de5f93e88163
	item 0 key (EXTENT_CSUM EXTENT_CSUM 64343257088) itemoff 3479 itemsize 
516
		extent csum item
failed to find block number 150802432

Is it possible to fix it? 
I don't want to download 500 GB data again. 

Regards, 
    Max


