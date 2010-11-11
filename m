From: Sage Weil <sage@newdream.net>
Subject: new lockdep warnings in 2.6.37-rc1
Date: Thu, 11 Nov 2010 14:49:26 -0800 (PST)
Message-ID: <Pine.LNX.4.64.1011111443340.12688@cobra.newdream.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hey,

I saw a few variations of this lockdep on about a dozen different nodes 
running 2.6.37-rc1+ (mainline from earlier this week).  They all look to 
be the same issue, hit via a few different call paths.  I haven't seen 
these before...

sage


[10862.369802] =======================================================
[10862.373287] [ INFO: possible circular locking dependency detected ]
[10862.373287] 2.6.37-rc1+ #44
[10862.373287] -------------------------------------------------------
[10862.373287] syslogd/2091 is trying to acquire lock:
[10862.373287]  (&(&eb->lock)->rlock){+.+...}, at: [<ffffffffa0048bbe>] btrfs_try_spin_lock+0x26/0x80 [btrfs]
[10862.373287] 
[10862.373287] but task is already holding lock:
[10862.373287]  (btrfs-extent-01){+.+...}, at: [<ffffffffa0048b8f>] btrfs_clear_lock_blocking+0x1d/0x26 [btrfs]
[10862.373287] 
[10862.373287] which lock already depends on the new lock.
[10862.373287] 
[10862.373287] 
[10862.373287] the existing dependency chain (in reverse order) is:
[10862.373287] 
[10862.373287] -> #1 (btrfs-extent-01){+.+...}:
[10862.442464]        [<ffffffff810634ad>] __lock_acquire+0x82d/0x8aa
[10862.442464]        [<ffffffff810635b2>] lock_acquire+0x88/0xa5
[10862.442464]        [<ffffffff814cf403>] _raw_spin_lock+0x3c/0x6f
[10862.442464]        [<ffffffffa0048bbe>] btrfs_try_spin_lock+0x26/0x80 [btrfs]
[10862.442464]        [<ffffffffa0009de5>] btrfs_search_slot+0x723/0x851 [btrfs]
[10862.442464]        [<ffffffffa0018340>] btrfs_lookup_csum+0x5c/0x135 [btrfs]
[10862.442464]        [<ffffffffa00185bd>] __btrfs_lookup_bio_sums+0x1a4/0x343 [btrfs]
[10862.442464]        [<ffffffffa001877e>] btrfs_lookup_bio_sums+0x11/0x13 [btrfs]
[10862.442464]        [<ffffffffa0022764>] btrfs_submit_bio_hook+0x99/0x10a [btrfs]
[10862.442464]        [<ffffffffa0039440>] submit_one_bio+0x6c/0x96 [btrfs]
[10862.442464]        [<ffffffffa003b4a4>] extent_read_full_page+0x41/0x4a [btrfs]
[10862.442464]        [<ffffffffa00218e1>] btrfs_readpage+0x1e/0x20 [btrfs]
[10862.442464]        [<ffffffffa002bfec>] btrfs_file_aio_write+0x405/0x885 [btrfs]
[10862.442464]        [<ffffffff810ba061>] do_sync_readv_writev+0xc4/0x10c
[10862.442464]        [<ffffffff810ba6fa>] do_readv_writev+0xb8/0x190
[10862.442464]        [<ffffffff810ba813>] vfs_writev+0x41/0x4c
[10862.442464]        [<ffffffff810bb008>] sys_writev+0x4a/0x75
[10862.442464]        [<ffffffff81002a2b>] system_call_fastpath+0x16/0x1b
[10862.442464] 
[10862.442464] -> #0 (&(&eb->lock)->rlock){+.+...}:
[10862.442464]        [<ffffffff8106265c>] validate_chain+0x7a9/0xdcd
[10862.442464]        [<ffffffff810634ad>] __lock_acquire+0x82d/0x8aa
[10862.442464]        [<ffffffff810635b2>] lock_acquire+0x88/0xa5
[10862.442464]        [<ffffffff814cf403>] _raw_spin_lock+0x3c/0x6f
[10862.442464]        [<ffffffffa0048bbe>] btrfs_try_spin_lock+0x26/0x80 [btrfs]
[10862.442464]        [<ffffffffa0009de5>] btrfs_search_slot+0x723/0x851 [btrfs]
[10862.442464]        [<ffffffffa0018340>] btrfs_lookup_csum+0x5c/0x135 [btrfs]
[10862.442464]        [<ffffffffa00185bd>] __btrfs_lookup_bio_sums+0x1a4/0x343 [btrfs]
[10862.620387]        [<ffffffffa001877e>] btrfs_lookup_bio_sums+0x11/0x13 [btrfs]
[10862.620387]        [<ffffffffa0022764>] btrfs_submit_bio_hook+0x99/0x10a [btrfs]
[10862.620387]        [<ffffffffa0039440>] submit_one_bio+0x6c/0x96 [btrfs]
[10862.620387]        [<ffffffffa003b4a4>] extent_read_full_page+0x41/0x4a [btrfs]
[10862.620387]        [<ffffffffa00218e1>] btrfs_readpage+0x1e/0x20 [btrfs]
[10862.620387]        [<ffffffffa002bfec>] btrfs_file_aio_write+0x405/0x885 [btrfs]
[10862.620387]        [<ffffffff810ba061>] do_sync_readv_writev+0xc4/0x10c
[10862.620387]        [<ffffffff810ba6fa>] do_readv_writev+0xb8/0x190
[10862.620387]        [<ffffffff810ba813>] vfs_writev+0x41/0x4c
[10862.620387]        [<ffffffff810bb008>] sys_writev+0x4a/0x75
[10862.620387]        [<ffffffff81002a2b>] system_call_fastpath+0x16/0x1b
[10862.620387] 
[10862.620387] other info that might help us debug this:
[10862.620387] 
[10862.620387] 2 locks held by syslogd/2091:
[10862.620387]  #0:  (&sb->s_type->i_mutex_key#11){+.+.+.}, at: [<ffffffffa002bd36>] btrfs_file_aio_write+0x14f/0x885 [btrfs]
[10862.620387]  #1:  (btrfs-extent-01){+.+...}, at: [<ffffffffa0048b8f>] btrfs_clear_lock_blocking+0x1d/0x26 [btrfs]
[10862.730233] 
[10862.730233] stack backtrace:
[10862.730233] Pid: 2091, comm: syslogd Not tainted 2.6.37-rc1+ #44
[10862.730233] Call Trace:
[10862.730233]  [<ffffffff81061876>] print_circular_bug+0xb3/0xc1
[10862.730233]  [<ffffffff8106265c>] validate_chain+0x7a9/0xdcd
[10862.730233]  [<ffffffff81009948>] ? native_sched_clock+0x37/0x71
[10862.730233]  [<ffffffff810634ad>] __lock_acquire+0x82d/0x8aa
[10862.730233]  [<ffffffff810635b2>] lock_acquire+0x88/0xa5
[10862.730233]  [<ffffffffa0048bbe>] ? btrfs_try_spin_lock+0x26/0x80 [btrfs]
[10862.730233]  [<ffffffff814cf403>] _raw_spin_lock+0x3c/0x6f
[10862.730233]  [<ffffffffa0048bbe>] ? btrfs_try_spin_lock+0x26/0x80 [btrfs]
[10862.730233]  [<ffffffffa0048b8f>] ? btrfs_clear_lock_blocking+0x1d/0x26 [btrfs]
[10862.730233]  [<ffffffffa0048bbe>] btrfs_try_spin_lock+0x26/0x80 [btrfs]
[10862.730233]  [<ffffffffa0009de5>] btrfs_search_slot+0x723/0x851 [btrfs]
[10862.730233]  [<ffffffffa0018340>] btrfs_lookup_csum+0x5c/0x135 [btrfs]
[10862.730233]  [<ffffffffa003865b>] ? btrfs_find_ordered_sum+0x37/0xd6 [btrfs]
[10862.730233]  [<ffffffffa00185bd>] __btrfs_lookup_bio_sums+0x1a4/0x343 [btrfs]
[10862.730233]  [<ffffffffa001877e>] btrfs_lookup_bio_sums+0x11/0x13 [btrfs]
[10862.730233]  [<ffffffffa0022764>] btrfs_submit_bio_hook+0x99/0x10a [btrfs]
[10862.730233]  [<ffffffffa0039440>] submit_one_bio+0x6c/0x96 [btrfs]
[10862.730233]  [<ffffffffa003b4a4>] extent_read_full_page+0x41/0x4a [btrfs]
[10862.730233]  [<ffffffffa00218e1>] btrfs_readpage+0x1e/0x20 [btrfs]
[10862.730233]  [<ffffffffa002bfec>] btrfs_file_aio_write+0x405/0x885 [btrfs]
[10862.730233]  [<ffffffff81031b8a>] ? get_parent_ip+0x11/0x42
[10862.730233]  [<ffffffff81032f06>] ? sub_preempt_count+0x92/0x9e
[10862.730233]  [<ffffffffa002bbe7>] ? btrfs_file_aio_write+0x0/0x885 [btrfs]
[10862.730233]  [<ffffffff810ba061>] do_sync_readv_writev+0xc4/0x10c
[10862.730233]  [<ffffffff810a1f26>] ? might_fault+0x63/0xb3
[10862.730233]  [<ffffffff8122b35b>] ? security_file_permission+0x1d/0x8a
[10862.730233]  [<ffffffff810ba37f>] ? rw_verify_area+0xb2/0xd2
[10862.730233]  [<ffffffff810ba6fa>] do_readv_writev+0xb8/0x190
[10862.730233]  [<ffffffff810ba813>] vfs_writev+0x41/0x4c
[10862.730233]  [<ffffffff810bb008>] sys_writev+0x4a/0x75
[10862.730233]  [<ffffffff81002a2b>] system_call_fastpath+0x16/0x1b

and

[12064.990630] =============================================
[12064.994267] [ INFO: possible recursive locking detected ]
[12064.994267] 2.6.37-rc1+ #44
[12064.994267] ---------------------------------------------
[12064.994267] syslogd/2078 is trying to acquire lock:
[12064.994267]  (&(&eb->lock)->rlock){+.+...}, at: [<ffffffffa0048bbe>] btrfs_try_spin_lock+0x26/0x80 [btrfs]
[12064.994267] 
[12064.994267] but task is already holding lock:
[12064.994267]  (&(&eb->lock)->rlock){+.+...}, at: [<ffffffffa0048b8f>] btrfs_clear_lock_blocking+0x1d/0x26 [btrfs]
[12065.038868] 
[12065.038868] other info that might help us debug this:
[12065.038868] 2 locks held by syslogd/2078:
[12065.038868]  #0:  (&sb->s_type->i_mutex_key#11){+.+.+.}, at: [<ffffffffa002bd36>] btrfs_file_aio_write+0x14f/0x885 [btrfs]
[12065.053813]  #1:  (&(&eb->lock)->rlock){+.+...}, at: [<ffffffffa0048b8f>] btrfs_clear_lock_blocking+0x1d/0x26 [btrfs]
[12065.053813] 
[12065.053813] stack backtrace:
[12065.053813] Pid: 2078, comm: syslogd Not tainted 2.6.37-rc1+ #44
[12065.053813] Call Trace:
[12065.053813]  [<ffffffff81062494>] validate_chain+0x5e1/0xdcd
[12065.053813]  [<ffffffff81009948>] ? native_sched_clock+0x37/0x71
[12065.053813]  [<ffffffff81057a5a>] ? sched_clock_local+0x11/0x73
[12065.053813]  [<ffffffff81057b82>] ? sched_clock_cpu+0xc6/0xd4
[12065.107027]  [<ffffffff810634ad>] __lock_acquire+0x82d/0x8aa
[12065.107027]  [<ffffffff810635b2>] lock_acquire+0x88/0xa5
[12065.107027]  [<ffffffffa0048bbe>] ? btrfs_try_spin_lock+0x26/0x80 [btrfs]
[12065.107027]  [<ffffffff814cf403>] _raw_spin_lock+0x3c/0x6f
[12065.107027]  [<ffffffffa0048bbe>] ? btrfs_try_spin_lock+0x26/0x80 [btrfs]
[12065.135622]  [<ffffffffa0048b8f>] ? btrfs_clear_lock_blocking+0x1d/0x26 [btrfs]
[12065.135622]  [<ffffffffa0048bbe>] btrfs_try_spin_lock+0x26/0x80 [btrfs]
[12065.135622]  [<ffffffffa0009de5>] btrfs_search_slot+0x723/0x851 [btrfs]
[12065.135622]  [<ffffffffa0017a21>] btrfs_lookup_xattr+0x73/0xee [btrfs]
[12065.135622]  [<ffffffffa00373f9>] __btrfs_getxattr+0x74/0xfd [btrfs]
[12065.135622]  [<ffffffffa00374e9>] btrfs_getxattr+0x67/0x76 [btrfs]
[12065.135622]  [<ffffffff81229521>] cap_inode_need_killpriv+0x2b/0x35
[12065.135622]  [<ffffffff8122a6b7>] security_inode_need_killpriv+0x11/0x13
[12065.135622]  [<ffffffff81088590>] file_remove_suid+0x21/0x57
[12065.135622]  [<ffffffffa002bdd6>] btrfs_file_aio_write+0x1ef/0x885 [btrfs]
[12065.135622]  [<ffffffff81057a5a>] ? sched_clock_local+0x11/0x73
[12065.135622]  [<ffffffff81031b8a>] ? get_parent_ip+0x11/0x42
[12065.135622]  [<ffffffff81032f06>] ? sub_preempt_count+0x92/0x9e
[12065.135622]  [<ffffffff8105ed5c>] ? put_lock_stats+0xe/0x29
[12065.135622]  [<ffffffffa002bbe7>] ? btrfs_file_aio_write+0x0/0x885 [btrfs]
[12065.135622]  [<ffffffff810ba061>] do_sync_readv_writev+0xc4/0x10c
[12065.135622]  [<ffffffff810a1f26>] ? might_fault+0x63/0xb3
[12065.135622]  [<ffffffff8122b35b>] ? security_file_permission+0x1d/0x8a
[12065.135622]  [<ffffffff810ba37f>] ? rw_verify_area+0xb2/0xd2
[12065.135622]  [<ffffffff810ba6fa>] do_readv_writev+0xb8/0x190
[12065.135622]  [<ffffffff810ba813>] vfs_writev+0x41/0x4c
[12065.135622]  [<ffffffff810bb008>] sys_writev+0x4a/0x75
[12065.135622]  [<ffffffff81002a2b>] system_call_fastpath+0x16/0x1b

and

[12064.990630] =============================================
[12064.994267] [ INFO: possible recursive locking detected ]
[12064.994267] 2.6.37-rc1+ #44
[12064.994267] ---------------------------------------------
[12064.994267] syslogd/2078 is trying to acquire lock:
[12064.994267]  (&(&eb->lock)->rlock){+.+...}, at: [<ffffffffa0048bbe>] btrfs_try_spin_lock+0x26/0x80 [btrfs]
[12064.994267] 
[12064.994267] but task is already holding lock:
[12064.994267]  (&(&eb->lock)->rlock){+.+...}, at: [<ffffffffa0048b8f>] btrfs_clear_lock_blocking+0x1d/0x26 [btrfs]
[12065.038868] 
[12065.038868] other info that might help us debug this:
[12065.038868] 2 locks held by syslogd/2078:
[12065.038868]  #0:  (&sb->s_type->i_mutex_key#11){+.+.+.}, at: [<ffffffffa002bd36>] btrfs_file_aio_write+0x14f/0x885 [btrfs]
[12065.053813]  #1:  (&(&eb->lock)->rlock){+.+...}, at: [<ffffffffa0048b8f>] btrfs_clear_lock_blocking+0x1d/0x26 [btrfs]
[12065.053813] 
[12065.053813] stack backtrace:
[12065.053813] Pid: 2078, comm: syslogd Not tainted 2.6.37-rc1+ #44
[12065.053813] Call Trace:
[12065.053813]  [<ffffffff81062494>] validate_chain+0x5e1/0xdcd
[12065.053813]  [<ffffffff81009948>] ? native_sched_clock+0x37/0x71
[12065.053813]  [<ffffffff81057a5a>] ? sched_clock_local+0x11/0x73
[12065.053813]  [<ffffffff81057b82>] ? sched_clock_cpu+0xc6/0xd4
[12065.107027]  [<ffffffff810634ad>] __lock_acquire+0x82d/0x8aa
[12065.107027]  [<ffffffff810635b2>] lock_acquire+0x88/0xa5
[12065.107027]  [<ffffffffa0048bbe>] ? btrfs_try_spin_lock+0x26/0x80 [btrfs]
[12065.107027]  [<ffffffff814cf403>] _raw_spin_lock+0x3c/0x6f
[12065.107027]  [<ffffffffa0048bbe>] ? btrfs_try_spin_lock+0x26/0x80 [btrfs]
[12065.135622]  [<ffffffffa0048b8f>] ? btrfs_clear_lock_blocking+0x1d/0x26 [btrfs]
[12065.135622]  [<ffffffffa0048bbe>] btrfs_try_spin_lock+0x26/0x80 [btrfs]
[12065.135622]  [<ffffffffa0009de5>] btrfs_search_slot+0x723/0x851 [btrfs]
[12065.135622]  [<ffffffffa0017a21>] btrfs_lookup_xattr+0x73/0xee [btrfs]
[12065.135622]  [<ffffffffa00373f9>] __btrfs_getxattr+0x74/0xfd [btrfs]
[12065.135622]  [<ffffffffa00374e9>] btrfs_getxattr+0x67/0x76 [btrfs]
[12065.135622]  [<ffffffff81229521>] cap_inode_need_killpriv+0x2b/0x35
[12065.135622]  [<ffffffff8122a6b7>] security_inode_need_killpriv+0x11/0x13
[12065.135622]  [<ffffffff81088590>] file_remove_suid+0x21/0x57
[12065.135622]  [<ffffffffa002bdd6>] btrfs_file_aio_write+0x1ef/0x885 [btrfs]
[12065.135622]  [<ffffffff81057a5a>] ? sched_clock_local+0x11/0x73
[12065.135622]  [<ffffffff81031b8a>] ? get_parent_ip+0x11/0x42
[12065.135622]  [<ffffffff81032f06>] ? sub_preempt_count+0x92/0x9e
[12065.135622]  [<ffffffff8105ed5c>] ? put_lock_stats+0xe/0x29
[12065.135622]  [<ffffffffa002bbe7>] ? btrfs_file_aio_write+0x0/0x885 [btrfs]
[12065.135622]  [<ffffffff810ba061>] do_sync_readv_writev+0xc4/0x10c
[12065.135622]  [<ffffffff810a1f26>] ? might_fault+0x63/0xb3
[12065.135622]  [<ffffffff8122b35b>] ? security_file_permission+0x1d/0x8a
[12065.135622]  [<ffffffff810ba37f>] ? rw_verify_area+0xb2/0xd2
[12065.135622]  [<ffffffff810ba6fa>] do_readv_writev+0xb8/0x190
[12065.135622]  [<ffffffff810ba813>] vfs_writev+0x41/0x4c
[12065.135622]  [<ffffffff810bb008>] sys_writev+0x4a/0x75
[12065.135622]  [<ffffffff81002a2b>] system_call_fastpath+0x16/0x1b
