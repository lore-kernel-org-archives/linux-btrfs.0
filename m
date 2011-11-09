From: Stefan Kleijkers <stefan@unilogicnetworks.net>
Subject: WARNING: at fs/btrfs/inode.c:2198 btrfs_orphan_commit_root+0xa8/0xc0
Date: Wed, 09 Nov 2011 11:24:50 +0100
Message-ID: <4EBA54F2.3030801@unilogicnetworks.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I'm seeing a lot of warnings in dmesg with a BTRFS filesystem. I'm using 
the 3.1 kernel, I found a patch for these warnings ( 
http://marc.info/?l=linux-btrfs&m=131547325515336&w=2) 
<http://marc.info/?l=linux-btrfs&m=131547325515336&w=2>, but that patch 
has already been included in 3.1. Are there any other patches I can try?

I'm using BTRFS in combination with Ceph and it looks like after a while 
with a high rsync workload that the IO stalls for some time, could the 
warnings result in IO stall?

Kind regards,
Stefan Kleijkers

Output of dmesg:
[ 3924.297754] ------------[ cut here ]------------
[ 3924.297772] WARNING: at fs/btrfs/inode.c:2198 
btrfs_orphan_commit_root+0xa8/0xc0 [btrfs]()
[ 3924.297774] Hardware name: X8ST3
[ 3924.297776] Modules linked in: nfs lockd nfs_acl sunrpc btrfs 
zlib_deflate lzo_compress md_mod target_core_mod configfs ahci libahci 
e1000e mptsas mptscsih mptbase i7core_edac scsi_transport_sas bnx2 
i5000_edac edac_core ipmi_devintf ipmi_msghandler
[ 3924.297793] Pid: 7672, comm: kworker/2:1 Not tainted 
3.1.0-un13.1-64-nohz #1
[ 3924.297795] Call Trace:
[ 3924.297802]  [<ffffffff81036dca>] warn_slowpath_common+0x7a/0xb0
[ 3924.297806]  [<ffffffff81036e15>] warn_slowpath_null+0x15/0x20
[ 3924.297816]  [<ffffffffa0137478>] btrfs_orphan_commit_root+0xa8/0xc0 
[btrfs]
[ 3924.297825]  [<ffffffffa012bc54>] commit_fs_roots+0xc4/0x1b0 [btrfs]
[ 3924.297835]  [<ffffffffa012cc1e>] 
btrfs_commit_transaction+0x3be/0x7e0 [btrfs]
[ 3924.297840]  [<ffffffff813fa0fb>] ? __schedule+0x2fb/0x940
[ 3924.297845]  [<ffffffff810a1f20>] ? refresh_cpu_vm_stats+0x150/0x150
[ 3924.297849]  [<ffffffff81052840>] ? wake_up_bit+0x40/0x40
[ 3924.297858]  [<ffffffffa012d040>] ? 
btrfs_commit_transaction+0x7e0/0x7e0 [btrfs]
[ 3924.297868]  [<ffffffffa012d05a>] do_async_commit+0x1a/0x30 [btrfs]
[ 3924.297873]  [<ffffffff81350b70>] ? powersave_bias_target+0x170/0x170
[ 3924.297877]  [<ffffffff8104e0bb>] process_one_work+0x10b/0x3d0
[ 3924.297880]  [<ffffffff8104e7b6>] worker_thread+0x156/0x410
[ 3924.297884]  [<ffffffff81029f59>] ? __wake_up_common+0x59/0x90
[ 3924.297887]  [<ffffffff8104e660>] ? rescuer_thread+0x2e0/0x2e0
[ 3924.297890]  [<ffffffff810523b6>] kthread+0x96/0xa0
[ 3924.297893]  [<ffffffff813feaf4>] kernel_thread_helper+0x4/0x10
[ 3924.297896]  [<ffffffff81052320>] ? kthread_worker_fn+0x130/0x130
[ 3924.297898]  [<ffffffff813feaf0>] ? gs_change+0xb/0xb
[ 3924.297901] ---[ end trace 67e9a1054a2684f7 ]---
[ 4033.512469] ------------[ cut here ]------------
[ 4033.512496] WARNING: at fs/btrfs/inode.c:2198 
btrfs_orphan_commit_root+0xa8/0xc0 [btrfs]()
[ 4033.512500] Hardware name: X8ST3
[ 4033.512502] Modules linked in: nfs lockd nfs_acl sunrpc btrfs 
zlib_deflate lzo_compress md_mod target_core_mod configfs ahci libahci 
e1000e mptsas mptscsih mptbase i7core_edac scsi_transport_sas bnx2 
i5000_edac edac_core ipmi_devintf ipmi_msghandler
[ 4033.512531] Pid: 8, comm: kworker/1:0 Tainted: G        W   
3.1.0-un13.1-64-nohz #1
[ 4033.512535] Call Trace:
[ 4033.512546]  [<ffffffff81036dca>] warn_slowpath_common+0x7a/0xb0
[ 4033.512551]  [<ffffffff81036e15>] warn_slowpath_null+0x15/0x20
[ 4033.512570]  [<ffffffffa0137478>] btrfs_orphan_commit_root+0xa8/0xc0 
[btrfs]
[ 4033.512586]  [<ffffffffa012bc54>] commit_fs_roots+0xc4/0x1b0 [btrfs]
[ 4033.512604]  [<ffffffffa012cc1e>] 
btrfs_commit_transaction+0x3be/0x7e0 [btrfs]
[ 4033.512611]  [<ffffffff813fa0fb>] ? __schedule+0x2fb/0x940
[ 4033.512618]  [<ffffffff810a1f20>] ? refresh_cpu_vm_stats+0x150/0x150
[ 4033.512625]  [<ffffffff81052840>] ? wake_up_bit+0x40/0x40
[ 4033.512641]  [<ffffffffa012d040>] ? 
btrfs_commit_transaction+0x7e0/0x7e0 [btrfs]
[ 4033.512669]  [<ffffffffa012d05a>] do_async_commit+0x1a/0x30 [btrfs]
[ 4033.512681]  [<ffffffff81350b70>] ? powersave_bias_target+0x170/0x170
[ 4033.512693]  [<ffffffff8104e0bb>] process_one_work+0x10b/0x3d0
[ 4033.512702]  [<ffffffff8104e7b6>] worker_thread+0x156/0x410
[ 4033.512713]  [<ffffffff81029f59>] ? __wake_up_common+0x59/0x90
[ 4033.512722]  [<ffffffff8104e660>] ? rescuer_thread+0x2e0/0x2e0
[ 4033.512731]  [<ffffffff810523b6>] kthread+0x96/0xa0
[ 4033.512740]  [<ffffffff813feaf4>] kernel_thread_helper+0x4/0x10
[ 4033.512749]  [<ffffffff81052320>] ? kthread_worker_fn+0x130/0x130
[ 4033.512757]  [<ffffffff813feaf0>] ? gs_change+0xb/0xb
[ 4033.512764] ---[ end trace 67e9a1054a2684f8 ]---
[ 4450.920336] ------------[ cut here ]------------
[ 4450.920364] WARNING: at fs/btrfs/inode.c:2198 
btrfs_orphan_commit_root+0xa8/0xc0 [btrfs]()
[ 4450.920368] Hardware name: X8ST3
[ 4450.920370] Modules linked in: nfs lockd nfs_acl sunrpc btrfs 
zlib_deflate lzo_compress md_mod target_core_mod configfs ahci libahci 
e1000e mptsas mptscsih mptbase i7core_edac scsi_transport_sas bnx2 
i5000_edac edac_core ipmi_devintf ipmi_msghandler
[ 4450.920399] Pid: 7717, comm: kworker/3:2 Tainted: G        W   
3.1.0-un13.1-64-nohz #1
[ 4450.920402] Call Trace:
[ 4450.920413]  [<ffffffff81036dca>] warn_slowpath_common+0x7a/0xb0
[ 4450.920419]  [<ffffffff81036e15>] warn_slowpath_null+0x15/0x20
[ 4450.920437]  [<ffffffffa0137478>] btrfs_orphan_commit_root+0xa8/0xc0 
[btrfs]
[ 4450.920454]  [<ffffffffa012bc54>] commit_fs_roots+0xc4/0x1b0 [btrfs]
[ 4450.920471]  [<ffffffffa012cc1e>] 
btrfs_commit_transaction+0x3be/0x7e0 [btrfs]
[ 4450.920479]  [<ffffffff813fa0fb>] ? __schedule+0x2fb/0x940
[ 4450.920486]  [<ffffffff810a1f20>] ? refresh_cpu_vm_stats+0x150/0x150
[ 4450.920492]  [<ffffffff81052840>] ? wake_up_bit+0x40/0x40
[ 4450.920509]  [<ffffffffa012d040>] ? 
btrfs_commit_transaction+0x7e0/0x7e0 [btrfs]
[ 4450.920526]  [<ffffffffa012d05a>] do_async_commit+0x1a/0x30 [btrfs]
[ 4450.920534]  [<ffffffff81350b70>] ? powersave_bias_target+0x170/0x170
[ 4450.920541]  [<ffffffff8104e0bb>] process_one_work+0x10b/0x3d0
[ 4450.920546]  [<ffffffff8104e7b6>] worker_thread+0x156/0x410
[ 4450.920553]  [<ffffffff81029f59>] ? __wake_up_common+0x59/0x90
[ 4450.920558]  [<ffffffff8104e660>] ? rescuer_thread+0x2e0/0x2e0
[ 4450.920563]  [<ffffffff810523b6>] kthread+0x96/0xa0
[ 4450.920568]  [<ffffffff813feaf4>] kernel_thread_helper+0x4/0x10
[ 4450.920573]  [<ffffffff81052320>] ? kthread_worker_fn+0x130/0x130
[ 4450.920578]  [<ffffffff813feaf0>] ? gs_change+0xb/0xb
[ 4450.920581] ---[ end trace 67e9a1054a2684f9 ]---
[ 5280.880652] ------------[ cut here ]------------
[ 5280.880680] WARNING: at fs/btrfs/inode.c:2198 
btrfs_orphan_commit_root+0xa8/0xc0 [btrfs]()
[ 5280.880684] Hardware name: X8ST3
[ 5280.880686] Modules linked in: nfs lockd nfs_acl sunrpc btrfs 
zlib_deflate lzo_compress md_mod target_core_mod configfs ahci libahci 
e1000e mptsas mptscsih mptbase i7core_edac scsi_transport_sas bnx2 
i5000_edac edac_core ipmi_devintf ipmi_msghandler
[ 5280.880714] Pid: 7645, comm: kworker/0:2 Tainted: G        W   
3.1.0-un13.1-64-nohz #1
[ 5280.880718] Call Trace:
[ 5280.880729]  [<ffffffff81036dca>] warn_slowpath_common+0x7a/0xb0
[ 5280.880735]  [<ffffffff81036e15>] warn_slowpath_null+0x15/0x20
[ 5280.880753]  [<ffffffffa0137478>] btrfs_orphan_commit_root+0xa8/0xc0 
[btrfs]
[ 5280.880770]  [<ffffffffa012bc54>] commit_fs_roots+0xc4/0x1b0 [btrfs]
[ 5280.880787]  [<ffffffffa012cc1e>] 
btrfs_commit_transaction+0x3be/0x7e0 [btrfs]
[ 5280.880795]  [<ffffffff813fa0fb>] ? __schedule+0x2fb/0x940
[ 5280.880802]  [<ffffffff8104d698>] ? queue_delayed_work_on+0x78/0x110
[ 5280.880807]  [<ffffffff81052840>] ? wake_up_bit+0x40/0x40
[ 5280.880824]  [<ffffffffa012d040>] ? 
btrfs_commit_transaction+0x7e0/0x7e0 [btrfs]
[ 5280.880841]  [<ffffffffa012d05a>] do_async_commit+0x1a/0x30 [btrfs]
[ 5280.880847]  [<ffffffff8104e0bb>] process_one_work+0x10b/0x3d0
[ 5280.880853]  [<ffffffff8104e7b6>] worker_thread+0x156/0x410
[ 5280.880859]  [<ffffffff81029f59>] ? __wake_up_common+0x59/0x90
[ 5280.880865]  [<ffffffff8104e660>] ? rescuer_thread+0x2e0/0x2e0
[ 5280.880869]  [<ffffffff810523b6>] kthread+0x96/0xa0
[ 5280.880875]  [<ffffffff813feaf4>] kernel_thread_helper+0x4/0x10
[ 5280.880880]  [<ffffffff81052320>] ? kthread_worker_fn+0x130/0x130
[ 5280.880885]  [<ffffffff813feaf0>] ? gs_change+0xb/0xb
[ 5280.880888] ---[ end trace 67e9a1054a2684fa ]---
