Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f171.google.com ([209.85.223.171]:35505 "EHLO
	mail-io0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698AbbJURo2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 21 Oct 2015 13:44:28 -0400
Received: by iofz202 with SMTP id z202so65521378iof.2
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2015 10:44:28 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20150807040119.GA8887@localhost.localdomain>
References: <55C1C915.4070106@eliasprobst.eu>
	<20150807040119.GA8887@localhost.localdomain>
Date: Wed, 21 Oct 2015 18:44:25 +0100
Message-ID: <CAL3q7H5P5CgF-DhQVig-edUDOgtDV8rQohsObdYPctgq6J-hzQ@mail.gmail.com>
Subject: Re: Lockup in BTRFS_IOC_CLONE/Kernel 4.2.0-rc5
From: Filipe Manana <fdmanana@gmail.com>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: Elias Probst <mail@eliasprobst.eu>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 7, 2015 at 5:01 AM, Liu Bo <bo.li.liu@oracle.com> wrote:
> Hi,
>
> On Wed, Aug 05, 2015 at 10:28:05AM +0200, Elias Probst wrote:
>> I can reproduce a hard btrfs lockup (process issuing the ioctl() is in
>> D-state, same goes for btrfs-transacti process) on Kernel 4.2.0-rc5.
>>
>> I had the same issue on 4.1, so it's unlikely a regression introduced in
>> 4.2.
>>
>> ## With the following steps, I can reproduce the problem:
>>
>> 1. Create a new clean btrfs volume for /var/lib/machines
>> machinectl set-limit 6G
>>
>> 2. Paste this to /tmp/yum.conf
>> [main]
>> reposdir=/dev/null
>> gpgcheck=0
>> logfile=/var/log/yum.log
>> installroot=/var/lib/machines/centos7.1-base
>> assumeyes=1
>>
>> [base]
>> name=CentOS 7.1.1503 - x86_64
>> baseurl=http://mirror.centos.org/centos/7.1.1503/os/x86_64/
>> enabled=1
>>
>> 3. Bootstrap a CentOS 7.1 base image
>> /usr/bin/yum -c /tmp/yum.conf groupinstall Base
>>
>> 4. Start an ephemeral systemd-nspawn container based on 'centos7.1-base'
>> strace -o /tmp/systemd-nspawn.out -s 500 -f systemd-nspawn -xbD
>> /var/lib/machines/centos7.1-base/
>>
>>
>> `systemd-nspawn` will now just hang forever.
>> I couldn't come up yet with a shorter/more low-level way to reproduce this as I lack quite a bit of btrfs experience.
>
> Thank you for reporting this.
>
> Could you do 'echo w > /proc/sysrq-trigger' to gather the whole hang call stack?
>
> Here's a quick patch that may address your problem, can you give it a shot after
> getting sysrq-w output?

Hi Liu,

Can you please send the patch git formatted, in a dedicated thread,
with a change log, signed-off-by tag, etc, so that it hopefully gets
in to 4.4? You can also add my Reviewed-by: Filipe Manana
<fdmanana@suse.com>

Thanks

>
> Thanks,
>
> -liubo
>
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 0770c91..b52bd66 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -3478,6 +3478,22 @@ process_slot:
>                                 drop_start = new_key.offset;
>
>                         /*
> +                        * We need to look up the roots that point at
> +                        * this bytenr and see if the new root does.  If
> +                        * it does not we need to make sure we update
> +                        * quotas appropriately.
> +                        */
> +                       if (disko && root != BTRFS_I(src)->root &&
> +                           disko != last_disko) {
> +                               no_quota = check_ref(trans, root,
> +                                                    disko);
> +                               if (no_quota < 0) {
> +                                       ret = no_quota;
> +                                       goto out;
> +                               }
> +                       }
> +
> +                       /*
>                          * 1 - adjusting old extent (we may have to * split it)
>                          * 1 - add new extent
>                          * 1 - inode update
> @@ -3544,27 +3560,6 @@ process_slot:
>                                 btrfs_set_file_extent_num_bytes(leaf, extent,
>                                                                 datal);
>
> -                               /*
> -                                * We need to look up the roots that point at
> -                                * this bytenr and see if the new root does.  If
> -                                * it does not we need to make sure we update
> -                                * quotas appropriately.  -                              */
> -                               if (disko && root != BTRFS_I(src)->root &&
> -                                   disko != last_disko) {
> -                                       no_quota = check_ref(trans, root,
> -                                                            disko);
> -                                       if (no_quota < 0) {
> -                                               btrfs_abort_transaction(trans,
> -                                                                       root,
> -                                                                       ret);
> -                                               btrfs_end_transaction(trans,
> -                                                                     root);
> -                                               ret = no_quota;
> -                                               goto out;
> -                                       }
> -                               }
> -
>                                 if (disko) {
>                                         inode_add_bytes(inode, datal);
>                                         ret = btrfs_inc_extent_ref(trans, root,
>
>
>>
>> ## Results:
>>
>> - Last 'strace' lines
>> 6095  fchown(16, 0, 0)                  = 0
>> 6095  fchmod(16, 0755)                  = 0
>> 6095  utimensat(16, NULL, {{1402362275, 0}, {1438761285, 819041906}}, 0) = 0
>> 6095  flistxattr(15, "", 100)           = 0
>> 6095  getdents(15, /* 3 entries */, 32768) = 80
>> 6095  newfstatat(15, "coreutils.mo", {st_mode=S_IFREG|0644, st_size=357263, ...}, AT_SYMLINK_NOFOLLOW) = 0
>> 6095  openat(15, "coreutils.mo", O_RDONLY|O_NOCTTY|O_NOFOLLOW|O_CLOEXEC) = 17
>> 6095  openat(16, "coreutils.mo", O_WRONLY|O_CREAT|O_EXCL|O_NOCTTY|O_NOFOLLOW|O_CLOEXEC, 0644) = 18
>> 6095  fstat(18, {st_mode=S_IFREG|0644, st_size=0, ...}) = 0
>> 6095  ioctl(18, BTRFS_IOC_CLONE
>>
>> - call trace in Kernel journal:
>> Aug 05 10:10:03 moria kernel: INFO: task btrfs-transacti:4175 blocked for more than 120 seconds.
>> Aug 05 10:10:03 moria kernel:       Tainted: G           O    4.2.0-rc5 #2
>> Aug 05 10:10:03 moria kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> Aug 05 10:10:03 moria kernel: btrfs-transacti D ffff8800b13279f8     0  4175      2 0x00080080
>> Aug 05 10:10:03 moria kernel:  ffff8800b13279f8 ffff88018fd3a380 ffff8800ab4521c0 0000000000000246
>> Aug 05 10:10:03 moria kernel:  ffff8800b1328000 ffff88018d5c8518 ffff88018debdba0 ffff880232d64990
>> Aug 05 10:10:03 moria kernel:  0000000000000197 ffff8800b1327a18 ffffffff86999201 0000000000000000
>> Aug 05 10:10:03 moria kernel: Call Trace:
>> Aug 05 10:10:03 moria kernel:  [<ffffffff86999201>] schedule+0x74/0x83
>> Aug 05 10:10:03 moria kernel:  [<ffffffff863ef8f0>] btrfs_tree_lock+0xa7/0x1b7
>> Aug 05 10:10:03 moria kernel:  [<ffffffff86137ed7>] ? wait_woken+0x74/0x74
>> Aug 05 10:10:03 moria kernel:  [<ffffffff8639d30f>] push_leaf_right+0x9a/0x19f
>> Aug 05 10:10:03 moria kernel:  [<ffffffff8639dd9b>] split_leaf+0x100/0x63f
>> Aug 05 10:10:03 moria kernel:  [<ffffffff86398f09>] ? leaf_space_used+0xbb/0xea
>> Aug 05 10:10:03 moria kernel:  [<ffffffff863efa61>] ? btrfs_set_lock_blocking_rw+0x52/0x95
>> Aug 05 10:10:03 moria kernel:  [<ffffffff8639ea46>] btrfs_search_slot+0x76c/0x8b3
>> Aug 05 10:10:03 moria kernel:  [<ffffffff863a0107>] btrfs_insert_empty_items+0x58/0xa3
>> Aug 05 10:10:03 moria kernel:  [<ffffffff8640805a>] btrfs_insert_delayed_items+0x7f/0x3bb
>> Aug 05 10:10:03 moria kernel:  [<ffffffff8640842e>] __btrfs_run_delayed_items+0x98/0x1c0
>> Aug 05 10:10:03 moria kernel:  [<ffffffff86408739>] btrfs_run_delayed_items+0xc/0xe
>> Aug 05 10:10:03 moria kernel:  [<ffffffff863bdc50>] btrfs_commit_transaction+0x298/0xb66
>> Aug 05 10:10:03 moria kernel:  [<ffffffff863be8d0>] ? start_transaction+0x3b2/0x535
>> Aug 05 10:10:03 moria kernel:  [<ffffffff863b9cd9>] transaction_kthread+0x100/0x1d6
>> Aug 05 10:10:03 moria kernel:  [<ffffffff863b9bd9>] ? btrfs_cleanup_transaction+0x49f/0x49f
>> Aug 05 10:10:03 moria kernel:  [<ffffffff8611eca9>] kthread+0xcd/0xd5
>> Aug 05 10:10:03 moria kernel:  [<ffffffff8611ebdc>] ? kthread_create_on_node+0x17d/0x17d
>> Aug 05 10:10:03 moria kernel:  [<ffffffff8699d29f>] ret_from_fork+0x3f/0x70
>> Aug 05 10:10:03 moria kernel:  [<ffffffff8611ebdc>] ? kthread_create_on_node+0x17d/0x17d
>> Aug 05 10:10:03 moria kernel: INFO: task systemd-nspawn:6095 blocked for more than 120 seconds.
>> Aug 05 10:10:03 moria kernel:       Tainted: G           O    4.2.0-rc5 #2
>> Aug 05 10:10:03 moria kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> Aug 05 10:10:03 moria kernel: systemd-nspawn  D ffff88019f3e3668     0  6095   6090 0x00080083
>> Aug 05 10:10:03 moria kernel:  ffff88019f3e3668 ffffffff86e5d480 ffff88018fd3a380 0000000000000246
>> Aug 05 10:10:03 moria kernel:  ffff88019f3e4000 ffff88018debdc08 ffff88018fd3a380 ffff88019f3e36b8
>> Aug 05 10:10:03 moria kernel:  ffff88018fd3a380 ffff88019f3e3688 ffffffff86999201 0000000000000000
>> Aug 05 10:10:03 moria kernel: Call Trace:
>> Aug 05 10:10:03 moria kernel:  [<ffffffff86999201>] schedule+0x74/0x83
>> Aug 05 10:10:03 moria kernel:  [<ffffffff863ef64c>] btrfs_tree_read_lock+0xc0/0xea
>> Aug 05 10:10:03 moria kernel:  [<ffffffff86137ed7>] ? wait_woken+0x74/0x74
>> Aug 05 10:10:03 moria kernel:  [<ffffffff8639f0a7>] btrfs_search_old_slot+0x51a/0x810
>> Aug 05 10:10:03 moria kernel:  [<ffffffff863a129b>] btrfs_next_old_leaf+0xdf/0x3ce
>> Aug 05 10:10:03 moria kernel:  [<ffffffff86413a00>] ? ulist_add_merge+0x1b/0x127
>> Aug 05 10:10:03 moria kernel:  [<ffffffff86411688>] __resolve_indirect_refs+0x62a/0x667
>> Aug 05 10:10:03 moria kernel:  [<ffffffff863ef546>] ? btrfs_clear_lock_blocking_rw+0x78/0xbe
>> Aug 05 10:10:03 moria kernel:  [<ffffffff864122d3>] find_parent_nodes+0xaf3/0xfc6
>> Aug 05 10:10:03 moria kernel:  [<ffffffff86412838>] __btrfs_find_all_roots+0x92/0xf0
>> Aug 05 10:10:03 moria kernel:  [<ffffffff864128f2>] btrfs_find_all_roots+0x45/0x65
>> Aug 05 10:10:03 moria kernel:  [<ffffffff8639a75b>] ? btrfs_get_tree_mod_seq+0x2b/0x88
>> Aug 05 10:10:03 moria kernel:  [<ffffffff863e852e>] check_ref+0x64/0xc4
>> Aug 05 10:10:03 moria kernel:  [<ffffffff863e9e01>] btrfs_clone+0x66e/0xb5d
>> Aug 05 10:10:03 moria kernel:  [<ffffffff863ea77f>] btrfs_ioctl_clone+0x48f/0x5bb
>> Aug 05 10:10:03 moria kernel:  [<ffffffff86048a68>] ? native_sched_clock+0x28/0x77
>> Aug 05 10:10:03 moria kernel:  [<ffffffff863ed9b0>] btrfs_ioctl+0xabc/0x25cb
>> Aug 05 10:10:03 moria kernel:  [<ffffffff86998f25>] ? __schedule+0x590/0x7f8
>> Aug 05 10:10:03 moria kernel:  [<ffffffff86999201>] ? schedule+0x74/0x83
>> Aug 05 10:10:03 moria kernel:  [<ffffffff86111b2e>] ? ptrace_stop+0x227/0x236
>> Aug 05 10:10:03 moria kernel:  [<ffffffff8612ba10>] ? account_system_time+0xf2/0x10f
>> Aug 05 10:10:03 moria kernel:  [<ffffffff86111bbc>] ? ptrace_do_notify+0x7f/0x8c
>> Aug 05 10:10:03 moria kernel:  [<ffffffff861fff2e>] do_vfs_ioctl+0x369/0x423
>> Aug 05 10:10:03 moria kernel:  [<ffffffff8617c29f>] ? __audit_syscall_entry+0xba/0xdc
>> Aug 05 10:10:03 moria kernel:  [<ffffffff86200021>] SyS_ioctl+0x39/0x61
>> Aug 05 10:10:03 moria kernel:  [<ffffffff8699cfd5>] tracesys_phase2+0x84/0x89
>>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
