From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: btrfs hang (deadlock?) when trying to create a ext4 filesystem
 in KVM guest
Date: Thu, 28 Oct 2010 08:29:27 +0200
Message-ID: <4CC91847.6020205@wpkg.org>
References: <4CC82942.1020101@wpkg.org> <20101027225541.GT27796@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101027225541.GT27796@think>
List-ID: <linux-btrfs.vger.kernel.org>

On 28.10.2010 00:55, Chris Mason wrote:
> On Wed, Oct 27, 2010 at 03:29:38PM +0200, Tomasz Chmielewski wrote:
>> There are a couple of problems when running KVM guests with images stored on btrfs filesystem.
>>
>> One of them is inability to create a filesystem (i.e. ext4) in the guest:
>>
>> - btrfs filesystem on the host was mounted with noatime,compress-force
>> - guest was using a 50 GB sparse file,
>> - attempt to create a ext4 filesystem within the guest does not succeed (hangs); host prints below messages in dmesg - some deadlock in btrfs?
>>
>> kernel: 2.6.36
>> qemu-kvm: 0.13.0
> 
> Is this the full dmesg output?  I think there are other messages hiding
> in there.

There were indeed "bad ordered accounting left" (see below), I think they are coming from btrfs?


> Is this a single disk btrfs?

Yes.



[ 8072.773053] device fsid 1142843480ad2d13-4bdc742fd9b1f7b0 devid 1 transid 1508 /dev/sdb4
[ 8072.773674] btrfs: forcing compression
[ 8122.052221] device tap0 entered promiscuous mode
[ 8122.052245] br0: port 2(tap0) entering learning state
[ 8122.052248] br0: port 2(tap0) entering learning state
[ 8122.451587] br0: port 2(tap0) entering learning state
[ 8122.543477] br0: port 2(tap0) entering disabled state
[ 8122.609645] device tap0 left promiscuous mode
[ 8122.609650] br0: port 2(tap0) entering disabled state
[ 8131.325647] EXT4-fs (md4): recovery complete
[ 8131.325809] EXT4-fs (md4): mounted filesystem with ordered data mode. Opts: (null)
[ 8133.392100] device tap0 entered promiscuous mode
[ 8133.392127] br0: port 2(tap0) entering learning state
[ 8133.392131] br0: port 2(tap0) entering learning state
[ 8134.106594] kvm: 5004: cpu0 unhandled wrmsr: 0x198 data 0
[ 8134.106618] kvm: 5004: cpu1 unhandled wrmsr: 0x198 data 0
[ 8143.460927] tap0: no IPv6 routers present
[ 8148.359485] br0: port 2(tap0) entering forwarding state
[ 8309.103502] bad ordered accounting left 65536 size 385024
[ 8309.106206] bad ordered accounting left 65536 size 385024
[ 8309.108915] bad ordered accounting left 65536 size 385024
[ 8309.111630] bad ordered accounting left 36864 size 385024
[ 8501.965625] INFO: task qemu-system-x86:5148 blocked for more than 120 seconds.
[ 8501.965629] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 8501.965632] qemu-system-x D ffff880001e14cc0     0  5148   4924 0x00000000
[ 8501.965638]  ffff880223bc3b38 0000000000000086 ffff880223bc3fd8 0000000000014cc0
[ 8501.965642]  0000000000014cc0 ffff880223bc3fd8 0000000000014cc0 ffff880223bc3fd8
[ 8501.965647]  0000000000014cc0 ffff880221965f18 ffff880221965f20 ffff880221965b80
[ 8501.965651] Call Trace:
[ 8501.965678]  [<ffffffffa024c52c>] btrfs_start_ordered_extent+0x6c/0xb0 [btrfs]
[ 8501.965685]  [<ffffffff81083200>] ? autoremove_wake_function+0x0/0x40
[ 8501.965701]  [<ffffffffa024d1c2>] btrfs_wait_ordered_range+0xd2/0x160 [btrfs]
[ 8501.965716]  [<ffffffffa0240059>] btrfs_file_aio_write+0x269/0x990 [btrfs]
[ 8501.965721]  [<ffffffff8105ca94>] ? try_to_wake_up+0xf4/0x3f0
[ 8501.965726]  [<ffffffff81168119>] ? __pollwake+0x49/0x50
[ 8501.965730]  [<ffffffff8105cd90>] ? default_wake_function+0x0/0x20
[ 8501.965733]  [<ffffffff8105ca94>] ? try_to_wake_up+0xf4/0x3f0
[ 8501.965737]  [<ffffffff8116813b>] ? pollwake+0x1b/0x20
[ 8501.965752]  [<ffffffffa023fdf0>] ? btrfs_file_aio_write+0x0/0x990 [btrfs]
[ 8501.965761]  [<ffffffff8115664b>] do_sync_readv_writev+0xcb/0x110
[ 8501.965769]  [<ffffffff81294d98>] ? apparmor_file_permission+0x18/0x20
[ 8501.965776]  [<ffffffff8126356e>] ? security_file_permission+0x1e/0x80
[ 8501.965781]  [<ffffffff811576e0>] do_readv_writev+0xd0/0x1d0
[ 8501.965787]  [<ffffffff81076d72>] ? kill_something_info+0x42/0x130
[ 8501.965793]  [<ffffffff81076ee0>] ? sys_kill+0x80/0x90
[ 8501.965798]  [<ffffffff8115781e>] vfs_writev+0x3e/0x60
[ 8501.965802]  [<ffffffff811578e7>] sys_pwritev+0xa7/0xc0
[ 8501.965806]  [<ffffffff8100b0f2>] system_call_fastpath+0x16/0x1b
[ 8501.965810] INFO: task qemu-system-x86:5150 blocked for more than 120 seconds.
[ 8501.965812] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 8501.965814] qemu-system-x D ffff880001e94cc0     0  5150   4924 0x00000000
[ 8501.965819]  ffff8801aba4bb38 0000000000000086 ffff8801aba4bfd8 0000000000014cc0
[ 8501.965823]  0000000000014cc0 ffff8801aba4bfd8 0000000000014cc0 ffff8801aba4bfd8
[ 8501.965827]  0000000000014cc0 ffff880226d14838 ffff880226d14840 ffff880226d144a0
[ 8501.965832] Call Trace:
[ 8501.965847]  [<ffffffffa024c52c>] btrfs_start_ordered_extent+0x6c/0xb0 [btrfs]
[ 8501.965852]  [<ffffffff81083200>] ? autoremove_wake_function+0x0/0x40
[ 8501.965867]  [<ffffffffa024d1c2>] btrfs_wait_ordered_range+0xd2/0x160 [btrfs]
[ 8501.965883]  [<ffffffffa0240059>] btrfs_file_aio_write+0x269/0x990 [btrfs]
[ 8501.965887]  [<ffffffff8105ca94>] ? try_to_wake_up+0xf4/0x3f0
[ 8501.965891]  [<ffffffff81168119>] ? __pollwake+0x49/0x50
[ 8501.965894]  [<ffffffff8105cd90>] ? default_wake_function+0x0/0x20
[ 8501.965897]  [<ffffffff8105ca94>] ? try_to_wake_up+0xf4/0x3f0
[ 8501.965901]  [<ffffffff8116813b>] ? pollwake+0x1b/0x20
[ 8501.965916]  [<ffffffffa023fdf0>] ? btrfs_file_aio_write+0x0/0x990 [btrfs]
[ 8501.965920]  [<ffffffff8115664b>] do_sync_readv_writev+0xcb/0x110
[ 8501.965924]  [<ffffffff81076736>] ? send_signal+0x56/0xa0
[ 8501.965928]  [<ffffffff81294d98>] ? apparmor_file_permission+0x18/0x20
[ 8501.965932]  [<ffffffff8126356e>] ? security_file_permission+0x1e/0x80
[ 8501.965936]  [<ffffffff811576e0>] do_readv_writev+0xd0/0x1d0
[ 8501.965940]  [<ffffffff8115781e>] vfs_writev+0x3e/0x60
[ 8501.965943]  [<ffffffff811578e7>] sys_pwritev+0xa7/0xc0
[ 8501.965946]  [<ffffffff8100b0f2>] system_call_fastpath+0x16/0x1b
[ 8501.965950] INFO: task qemu-system-x86:5151 blocked for more than 120 seconds.
[ 8501.965952] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 8501.965954] qemu-system-x D ffff880001e94cc0     0  5151   4924 0x00000000
[ 8501.965958]  ffff88021923fb38 0000000000000086 ffff88021923ffd8 0000000000014cc0
[ 8501.965963]  0000000000014cc0 ffff88021923ffd8 0000000000014cc0 ffff88021923ffd8
[ 8501.965967]  0000000000014cc0 ffff880226d13158 ffff880226d13160 ffff880226d12dc0
[ 8501.965971] Call Trace:
[ 8501.965986]  [<ffffffffa024c52c>] btrfs_start_ordered_extent+0x6c/0xb0 [btrfs]
[ 8501.965990]  [<ffffffff81083200>] ? autoremove_wake_function+0x0/0x40
[ 8501.966005]  [<ffffffffa024d1c2>] btrfs_wait_ordered_range+0xd2/0x160 [btrfs]
[ 8501.966021]  [<ffffffffa0240059>] btrfs_file_aio_write+0x269/0x990 [btrfs]
[ 8501.966025]  [<ffffffff8105ca94>] ? try_to_wake_up+0xf4/0x3f0
[ 8501.966029]  [<ffffffff81168119>] ? __pollwake+0x49/0x50
[ 8501.966032]  [<ffffffff8105cd90>] ? default_wake_function+0x0/0x20
[ 8501.966036]  [<ffffffff8105ca94>] ? try_to_wake_up+0xf4/0x3f0
[ 8501.966039]  [<ffffffff8116813b>] ? pollwake+0x1b/0x20
[ 8501.966054]  [<ffffffffa023fdf0>] ? btrfs_file_aio_write+0x0/0x990 [btrfs]
[ 8501.966058]  [<ffffffff8115664b>] do_sync_readv_writev+0xcb/0x110
[ 8501.966062]  [<ffffffff81076736>] ? send_signal+0x56/0xa0
[ 8501.966066]  [<ffffffff81294d98>] ? apparmor_file_permission+0x18/0x20
[ 8501.966070]  [<ffffffff8126356e>] ? security_file_permission+0x1e/0x80
[ 8501.966074]  [<ffffffff811576e0>] do_readv_writev+0xd0/0x1d0
[ 8501.966078]  [<ffffffff8115781e>] vfs_writev+0x3e/0x60
[ 8501.966081]  [<ffffffff811578e7>] sys_pwritev+0xa7/0xc0
[ 8501.966084]  [<ffffffff8100b0f2>] system_call_fastpath+0x16/0x1b


-- 
Tomasz Chmielewski
http://wpkg.org
