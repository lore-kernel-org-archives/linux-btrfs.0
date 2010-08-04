From: "Yan, Zheng " <yanzheng@21cn.com>
Subject: Re: Intermittent no space errors
Date: Wed, 4 Aug 2010 19:21:00 +0800
Message-ID: <AANLkTimc57W-o7eTwfKPjeb8qwwWy0gw53aobU3+NqX9@mail.gmail.com>
References: <AANLkTik_Dbk7cyS6FR0G9r-MFYq1bCCmbJ-HyHKgpUBr@mail.gmail.com>
	<AANLkTimVKtyPHi3zadx66i0dbPKzF4CbGJT=OEukLM6R@mail.gmail.com>
	<AANLkTimir3SMbevD_PCXOUQgda-3BkiAE01cYcAMz_BR@mail.gmail.com>
	<AANLkTikP_q7zhA2J69Rai964StGtMqCrhf2hGKPA9+J7@mail.gmail.com>
	<20100804002415.GA23720@hostway.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Dave Cundiff <syshackmin@gmail.com>, linux-btrfs@vger.kernel.org
To: Simon Kirby <sim@hostway.ca>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100804002415.GA23720@hostway.ca>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 4, 2010 at 8:24 AM, Simon Kirby <sim@hostway.ca> wrote:
> On Wed, Jul 28, 2010 at 08:31:10AM +0800, Yan, Zheng =A0wrote:
>
>> On Wed, Jul 28, 2010 at 4:30 AM, Dave Cundiff <syshackmin@gmail.com>=
 wrote:
>> > Hello,
>> >
>> > I installed the git repo kernel and added some debug to the ENOSPC
>> > returns. Unfortunately its still failing. If it helps any its bomb=
ing
>> > out in btrfs_check_data_free_space() in extent-tree.c. Returning o=
n
>> > the ENOSPC at line 2959.
>> >
>> > Unfortunately that is the extent of my ability to debug a filesyst=
em. :P
>>
>> This is really helpful, thank you very much.
>
> We're seeing this too, since upgrading from 2.6.33.2 + merged old git=
 btrfs
> unstable HEAD to plain 2.6.35.
>
> [sroot@backup01:.../.rmagic]# rm *
> rm: cannot remove `WEEKLY_bar3d.png': No space left on device
> rm: cannot remove `WEEKLY.html': No space left on device
> rm: cannot remove `YEARLY_bar3d.png': No space left on device
> rm: cannot remove `YEARLY.html': No space left on device
> [sroot@backup01:.../.rmagic]# l
> total 25
> drwxr-xr-x 1 1037300 1037300 =A0 108 2010-08-03 18:19 ./
> drwxr-xr-x 1 1037300 1037300 =A0 =A028 2009-11-07 05:57 ../
> -rw-r--r-- 1 1037300 1037300 =A05720 2010-04-23 13:39 WEEKLY_bar3d.pn=
g
> -rw-r--r-- 1 1037300 1037300 11882 2010-04-23 13:39 WEEKLY.html
> -rw-r--r-- 1 1037300 1037300 =A02998 2010-04-23 13:39 YEARLY_bar3d.pn=
g
> -rw-r--r-- 1 1037300 1037300 =A03016 2010-04-23 13:39 YEARLY.html
> [sroot@backup01:.../.rmagic]# rm *
> rm: cannot remove `WEEKLY_bar3d.png': No space left on device
> rm: cannot remove `YEARLY.html': No space left on device
> [sroot@backup01:.../.rmagic]# rm *
> rm: cannot remove `WEEKLY_bar3d.png': No space left on device
> rm: cannot remove `YEARLY.html': No space left on device
> [sroot@backup01:.../.rmagic]# rm *
> [sroot@backup01:.../.rmagic]#
>
> [sroot@backup01:/root]# btrfs filesystem df /backup/bu001/vol04
> Data: total=3D2.55TB, used=3D2.20TB
> Metadata: total=3D230.13GB, used=3D183.83GB
> System: total=3D12.00MB, used=3D548.00KB
> [sroot@backup01:/root]# df -P /backup/bu001/vol04
> Filesystem =A0 =A0 =A0 =A0 1024-blocks =A0 =A0 =A0Used Available Capa=
city Mounted on
> /dev/mapper/bu001-vol04 3221225472 2742785400 478440072 =A0 =A0 =A086=
% /backup/bu001/vol04
> [sroot@backup01:/root]# l /dev/mapper/bu001-vol04
> brw-rw---- 1 root disk 252, 10 2010-08-03 16:02 /dev/mapper/bu001-vol=
04
> [sroot@backup01:/root]# btrfs filesystem show /dev/dm-10
> failed to read /dev/sr0
> Label: none =A0uuid: 0c55f5f4-b618-4ec2-9dbc-e3e70a901e1a
> =A0 =A0 =A0 =A0Total devices 1 FS bytes used 2.37TB
> =A0 =A0 =A0 =A0devid =A0 =A01 size 3.00TB used 3.00TB path /dev/dm-10
>
> Btrfs Btrfs v0.19
>
> We're also seeing things like this in dmesg, which appear to be comin=
g
> from btrfs-cleaner cleaning some old snapshot:
>
> Aug =A03 18:40:45 backup01 kernel: ------------[ cut here ]----------=
--
> Aug =A03 18:40:45 backup01 kernel: WARNING: at fs/btrfs/extent-tree.c=
:3441 btrfs_block_rsv_check+0x151/0x180()
> Aug =A03 18:40:45 backup01 kernel: Hardware name: PowerEdge 1950
> Aug =A03 18:40:45 backup01 kernel: Modules linked in: ipmi_devintf ip=
mi_si ipmi_msghandler aoe bnx2
> Aug =A03 18:40:45 backup01 kernel: Pid: 7525, comm: btrfs-cleaner Tai=
nted: G =A0 =A0 =A0 =A0W =A0 2.6.35-hw #1
> Aug =A03 18:40:45 backup01 kernel: Call Trace:
> Aug =A03 18:40:45 backup01 kernel: [<ffffffff812c56a1>] ? btrfs_block=
_rsv_check+0x151/0x180
> Aug =A03 18:40:45 backup01 kernel: [<ffffffff8104b270>] warn_slowpath=
_common+0x80/0xd0
> Aug =A03 18:40:45 backup01 kernel: [<ffffffff8104b2d5>] warn_slowpath=
_null+0x15/0x20
> Aug =A03 18:40:45 backup01 kernel: [<ffffffff812c56a1>] btrfs_block_r=
sv_check+0x151/0x180
> Aug =A03 18:40:45 backup01 kernel: [<ffffffff812d5ea1>] btrfs_should_=
end_transaction+0x61/0x90
> Aug =A03 18:40:45 backup01 kernel: [<ffffffff812c842d>] btrfs_drop_sn=
apshot+0x21d/0x5f0
> Aug =A03 18:40:45 backup01 kernel: [<ffffffff81662d72>] ? schedule+0x=
3f2/0x750
> Aug =A03 18:40:45 backup01 kernel: [<ffffffff812d463a>] btrfs_clean_o=
ld_snapshots+0x12a/0x160
> Aug =A03 18:40:45 backup01 kernel: [<ffffffff812d0f00>] cleaner_kthre=
ad+0x160/0x190
> Aug =A03 18:40:45 backup01 kernel: [<ffffffff812d0da0>] ? cleaner_kth=
read+0x0/0x190
> Aug =A03 18:40:45 backup01 kernel: [<ffffffff81067ea6>] kthread+0x96/=
0xb0
> Aug =A03 18:40:45 backup01 kernel: [<ffffffff8100aca4>] kernel_thread=
_helper+0x4/0x10
> Aug =A03 18:40:45 backup01 kernel: [<ffffffff81067e10>] ? kthread+0x0=
/0xb0
> Aug =A03 18:40:45 backup01 kernel: [<ffffffff8100aca0>] ? kernel_thre=
ad_helper+0x0/0x10
> Aug =A03 18:40:45 backup01 kernel: ---[ end trace cffc4418e2c1f45d ]-=
--
> Aug =A03 18:40:45 backup01 kernel: block_rsv size 16194207744 reserve=
d 4497289216 freed 0 78598144
> Aug =A03 18:40:45 backup01 kernel: ------------[ cut here ]----------=
--
> Aug =A03 18:40:45 backup01 kernel: WARNING: at fs/btrfs/extent-tree.c=
:3441 btrfs_block_rsv_check+0x151/0x180()
> Aug =A03 18:40:45 backup01 kernel: Hardware name: PowerEdge 1950
> Aug =A03 18:40:45 backup01 kernel: Modules linked in: ipmi_devintf ip=
mi_si ipmi_msghandler aoe bnx2
> Aug =A03 18:40:45 backup01 kernel: Pid: 7525, comm: btrfs-cleaner Tai=
nted: G =A0 =A0 =A0 =A0W =A0 2.6.35-hw #1
> Aug =A03 18:40:45 backup01 kernel: Call Trace:
> Aug =A03 18:40:45 backup01 kernel: [<ffffffff812f2eb0>] ? map_extent_=
buffer+0xb0/0xc0
> Aug =A03 18:40:45 backup01 kernel: [<ffffffff812c56a1>] ? btrfs_block=
_rsv_check+0x151/0x180
> Aug =A03 18:40:45 backup01 kernel: [<ffffffff8104b270>] warn_slowpath=
_common+0x80/0xd0
> Aug =A03 18:40:45 backup01 kernel: [<ffffffff8104b2d5>] warn_slowpath=
_null+0x15/0x20
> Aug =A03 18:40:45 backup01 kernel: [<ffffffff812c56a1>] btrfs_block_r=
sv_check+0x151/0x180
> Aug =A03 18:40:45 backup01 kernel: [<ffffffff812d56fa>] __btrfs_end_t=
ransaction+0x19a/0x220
> Aug =A03 18:40:45 backup01 kernel: [<ffffffff812d578e>] btrfs_end_tra=
nsaction_throttle+0xe/0x10
> Aug =A03 18:40:45 backup01 kernel: [<ffffffff812c84f1>] btrfs_drop_sn=
apshot+0x2e1/0x5f0
> Aug =A03 18:40:45 backup01 kernel: [<ffffffff81662d72>] ? schedule+0x=
3f2/0x750
> Aug =A03 18:40:45 backup01 kernel: [<ffffffff812d463a>] btrfs_clean_o=
ld_snapshots+0x12a/0x160
> Aug =A03 18:40:45 backup01 kernel: [<ffffffff812d0f00>] cleaner_kthre=
ad+0x160/0x190
> Aug =A03 18:40:45 backup01 kernel: [<ffffffff812d0da0>] ? cleaner_kth=
read+0x0/0x190
> Aug =A03 18:40:45 backup01 kernel: [<ffffffff81067ea6>] kthread+0x96/=
0xb0
> Aug =A03 18:40:45 backup01 kernel: [<ffffffff8100aca4>] kernel_thread=
_helper+0x4/0x10
> Aug =A03 18:40:45 backup01 kernel: [<ffffffff81067e10>] ? kthread+0x0=
/0xb0
> Aug =A03 18:40:45 backup01 kernel: [<ffffffff8100aca0>] ? kernel_thre=
ad_helper+0x0/0x10
> Aug =A03 18:40:45 backup01 kernel: ---[ end trace cffc4418e2c1f45e ]-=
--
> Aug =A03 18:40:45 backup01 kernel: block_rsv size 16194207744 reserve=
d 4497281024 freed 8192 78598144
> Aug =A03 18:44:44 backup01 kernel: ------------[ cut here ]----------=
--
> Aug =A03 18:44:44 backup01 kernel: WARNING: at fs/btrfs/extent-tree.c=
:3441 btrfs_block_rsv_check+0x151/0x180()
> Aug =A03 18:44:44 backup01 kernel: Hardware name: PowerEdge 1950
> Aug =A03 18:44:44 backup01 kernel: Modules linked in: ipmi_devintf ip=
mi_si ipmi_msghandler aoe bnx2
> Aug =A03 18:44:44 backup01 kernel: Pid: 7526, comm: btrfs-transacti T=
ainted: G =A0 =A0 =A0 =A0W =A0 2.6.35-hw #1
> Aug =A03 18:44:44 backup01 kernel: Call Trace:
> Aug =A03 18:44:44 backup01 kernel: [<ffffffff812c56a1>] ? btrfs_block=
_rsv_check+0x151/0x180
> Aug =A03 18:44:44 backup01 kernel: [<ffffffff8104b270>] warn_slowpath=
_common+0x80/0xd0
> Aug =A03 18:44:44 backup01 kernel: [<ffffffff8104b2d5>] warn_slowpath=
_null+0x15/0x20
> Aug =A03 18:44:44 backup01 kernel: [<ffffffff812c56a1>] btrfs_block_r=
sv_check+0x151/0x180
> Aug =A03 18:44:44 backup01 kernel: [<ffffffff812d56fa>] __btrfs_end_t=
ransaction+0x19a/0x220
> Aug =A03 18:44:44 backup01 kernel: [<ffffffff812d579b>] btrfs_end_tra=
nsaction+0xb/0x10
> Aug =A03 18:44:44 backup01 kernel: [<ffffffff812d5d63>] btrfs_commit_=
transaction+0x5c3/0x6a0
> Aug =A03 18:44:44 backup01 kernel: [<ffffffff810683e0>] ? autoremove_=
wake_function+0x0/0x40
> Aug =A03 18:44:44 backup01 kernel: [<ffffffff812d0d90>] transaction_k=
thread+0x250/0x260
> Aug =A03 18:44:44 backup01 kernel: [<ffffffff812d0b40>] ? transaction=
_kthread+0x0/0x260
> Aug =A03 18:44:44 backup01 kernel: [<ffffffff81067ea6>] kthread+0x96/=
0xb0
> Aug =A03 18:44:44 backup01 kernel: [<ffffffff8100aca4>] kernel_thread=
_helper+0x4/0x10
> Aug =A03 18:44:44 backup01 kernel: [<ffffffff81067e10>] ? kthread+0x0=
/0xb0
> Aug =A03 18:44:44 backup01 kernel: [<ffffffff8100aca0>] ? kernel_thre=
ad_helper+0x0/0x10
> Aug =A03 18:44:44 backup01 kernel: ---[ end trace cffc4418e2c1f45f ]-=
--
> Aug =A03 18:44:44 backup01 kernel: block_rsv size 16194207744 reserve=
d 4522696704 freed 53190656 0
>

These warning is because btrfs in 2.6.35 reserves more metadata space
for internal use
than older kernel. Your FS is too full, btrfs can't reserve enough
metadata space.

> I rebuilt with the #if 0 changed to #if 1 on extent-tree.c:2947:
>
> #if 1 /* I hope we never need this code again, just in case */
>
> ha! :) =A0"rm" is succeeding everywhere so far, and so this path hasn=
't
> been hit yet. =A0Perhaps it has to fight with the btrfs-cleaner, or
> something. =A0Will post a follow-up later.

yes, it has to fight with the btrfs-cleaner.

Yan, Zheng
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
