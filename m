From: Tomas Carnecky <tomas.carnecky@gmail.com>
Subject: Re: Bug in btrfs_rename (kernel BUG at fs/btrfs/inode.c:5595!)
Date: Wed, 13 Jan 2010 21:11:59 +0100
Message-ID: <4B4E290F.9010100@gmail.com>
References: <4B4E1A5D.1070203@gmail.com> <20100113201317.GC2774@dhcp231-156.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100113201317.GC2774@dhcp231-156.rdu.redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

  On 1/13/10 9:13 PM, Josef Bacik wrote:
> On Wed, Jan 13, 2010 at 08:09:17PM +0100, Tomas Carnecky wrote:
>>   I was running v2.6.33-rc2-187-g08d869a and everything was ok. Today I
>> decided to update the kernel (to v2.6.33-rc4) and a minute or two after
>> logging into the gnome desktop this kernel bug appeared in dmesg. I then
>> went back to the old kernel but the bug didn't disappear, not even after
>> running btrfsck on the filesystem.
>>
> Ok will you please run with this patch?  It shouldn't panic your box, since it
> seems ret is -EEXIST.  Just watch your logs for
>
> OH NO, ORPHAN ENTRY ALREADY EXISTS FOR<number>
>
> and then look up and find all occurances of
>
> Btrfs: orphan add<number>
>
> with the stack trace and send it back to me so I can verify that nothing heinous
> is happening.  I assume we're just racing with unlink/rename so all that needs
> to be done is to take that BUG_ON out, but it would be nice to know for sure.

Btrfs: orphan add 3021394
Pid: 2029, comm: gdm Not tainted 2.6.33-rc2-00202-g63ebcc6-dirty #15
Call Trace:
  [<ffffffff8132e05b>] btrfs_orphan_add+0xcb/0xf0
  [<ffffffff8132e8ab>] btrfs_unlink+0xfb/0x120
  [<ffffffff81129e10>] ? inode_permission+0x70/0x90
  [<ffffffff8112b093>] vfs_unlink+0x83/0xf0
  [<ffffffff8112a710>] ? lookup_hash+0x30/0x40
  [<ffffffff8112d253>] do_unlinkat+0x183/0x1c0
  [<ffffffff8139aa65>] ? __up_write+0xe5/0x150
  [<ffffffff8112d2a1>] sys_unlink+0x11/0x20
  [<ffffffff81035e6b>] system_call_fastpath+0x16/0x1b
Btrfs: orphan add 3021395
Pid: 2029, comm: gdm Not tainted 2.6.33-rc2-00202-g63ebcc6-dirty #15
Call Trace:
  [<ffffffff8132e05b>] btrfs_orphan_add+0xcb/0xf0
  [<ffffffff8132e8ab>] btrfs_unlink+0xfb/0x120
  [<ffffffff81129e10>] ? inode_permission+0x70/0x90
  [<ffffffff8112b093>] vfs_unlink+0x83/0xf0
  [<ffffffff8112a710>] ? lookup_hash+0x30/0x40
  [<ffffffff8112d253>] do_unlinkat+0x183/0x1c0
  [<ffffffff8139aa65>] ? __up_write+0xe5/0x150
  [<ffffffff8112d2a1>] sys_unlink+0x11/0x20
  [<ffffffff81035e6b>] system_call_fastpath+0x16/0x1b
Btrfs: orphan add 3021384
Pid: 2029, comm: gdm Not tainted 2.6.33-rc2-00202-g63ebcc6-dirty #15
Call Trace:
  [<ffffffff8132e05b>] btrfs_orphan_add+0xcb/0xf0
  [<ffffffff8132e8ab>] btrfs_unlink+0xfb/0x120
  [<ffffffff81129e10>] ? inode_permission+0x70/0x90
  [<ffffffff8112b093>] vfs_unlink+0x83/0xf0
  [<ffffffff8112a710>] ? lookup_hash+0x30/0x40
  [<ffffffff8112d253>] do_unlinkat+0x183/0x1c0
  [<ffffffff8109de67>] ? __put_cred+0x37/0x50
  [<ffffffff8109e0a2>] ? commit_creds+0xb2/0x120
  [<ffffffff81090670>] ? sys_setresuid+0x150/0x160
  [<ffffffff8112d2a1>] sys_unlink+0x11/0x20
  [<ffffffff81035e6b>] system_call_fastpath+0x16/0x1b
Btrfs: orphan add 3021385
Pid: 2345, comm: gdm Not tainted 2.6.33-rc2-00202-g63ebcc6-dirty #15
Call Trace:
  [<ffffffff8132e05b>] btrfs_orphan_add+0xcb/0xf0
  [<ffffffff8132e540>] btrfs_rename+0x4c0/0x590
  [<ffffffff8112b56a>] vfs_rename+0x3da/0x420
  [<ffffffff8112d07e>] sys_renameat+0x23e/0x270
  [<ffffffff810fd6f8>] ? handle_mm_fault+0x188/0x840
  [<ffffffff8109bf89>] ? up_read+0x9/0x10
  [<ffffffff8105b071>] ? do_page_fault+0x141/0x2e0
  [<ffffffff8112d0c6>] sys_rename+0x16/0x20
  [<ffffffff81035e6b>] system_call_fastpath+0x16/0x1b
Btrfs: orphan add 1891
Pid: 2357, comm: dbus-launch Not tainted 2.6.33-rc2-00202-g63ebcc6-dirty #15
Call Trace:
  [<ffffffff8132e05b>] btrfs_orphan_add+0xcb/0xf0
  [<ffffffff8132ef33>] btrfs_setattr+0xf3/0x270
  [<ffffffff81137b64>] notify_change+0x104/0x2e0
  [<ffffffff8111f8ff>] do_truncate+0x5f/0x90
  [<ffffffff8112a03c>] ? get_write_access+0x3c/0x60
  [<ffffffff8112e4da>] do_filp_open+0x99a/0xf00
  [<ffffffff8112a67d>] ? __lookup_hash+0xed/0x150
  [<ffffffff81138a92>] ? alloc_fd+0xf2/0x140
  [<ffffffff8111e8e4>] do_sys_open+0x64/0x140
  [<ffffffff81036e3c>] ? math_state_restore+0x2c/0x50
  [<ffffffff8111e9eb>] sys_open+0x1b/0x20
  [<ffffffff81035e6b>] system_call_fastpath+0x16/0x1b
Btrfs: orphan add 3021399
Pid: 2345, comm: gnome-session Not tainted 
2.6.33-rc2-00202-g63ebcc6-dirty #15
Call Trace:
  [<ffffffff8132e05b>] btrfs_orphan_add+0xcb/0xf0
  [<ffffffff8132e8ab>] btrfs_unlink+0xfb/0x120
  [<ffffffff81129e10>] ? inode_permission+0x70/0x90
  [<ffffffff8112b093>] vfs_unlink+0x83/0xf0
  [<ffffffff8112a710>] ? lookup_hash+0x30/0x40
  [<ffffffff8112d253>] do_unlinkat+0x183/0x1c0
  [<ffffffff8139aa65>] ? __up_write+0xe5/0x150
  [<ffffffff8112d2a1>] sys_unlink+0x11/0x20
  [<ffffffff81035e6b>] system_call_fastpath+0x16/0x1b
Btrfs: orphan add 3021400
Pid: 2368, comm: gconf-sanity-ch Not tainted 
2.6.33-rc2-00202-g63ebcc6-dirty #15
Call Trace:
  [<ffffffff8132e05b>] btrfs_orphan_add+0xcb/0xf0
  [<ffffffff8132e8ab>] btrfs_unlink+0xfb/0x120
  [<ffffffff81129e10>] ? inode_permission+0x70/0x90
  [<ffffffff8112b093>] vfs_unlink+0x83/0xf0
  [<ffffffff8112a710>] ? lookup_hash+0x30/0x40
  [<ffffffff8112d253>] do_unlinkat+0x183/0x1c0
  [<ffffffff81121d0d>] ? fput+0x1d/0x30
  [<ffffffff8111e73d>] ? filp_close+0x4d/0x80
  [<ffffffff8112d2a1>] sys_unlink+0x11/0x20
  [<ffffffff81035e6b>] system_call_fastpath+0x16/0x1b
CE: hpet increasing min_delta_ns to 15000 nsec
Btrfs: orphan add 3021401
Pid: 2374, comm: gconfd-2 Not tainted 2.6.33-rc2-00202-g63ebcc6-dirty #15
Call Trace:
  [<ffffffff8132e05b>] btrfs_orphan_add+0xcb/0xf0
  [<ffffffff8132e8ab>] btrfs_unlink+0xfb/0x120
  [<ffffffff81129e10>] ? inode_permission+0x70/0x90
  [<ffffffff8112b093>] vfs_unlink+0x83/0xf0
  [<ffffffff8112a710>] ? lookup_hash+0x30/0x40
  [<ffffffff8112d253>] do_unlinkat+0x183/0x1c0
  [<ffffffff8109bf89>] ? up_read+0x9/0x10
  [<ffffffff8105b071>] ? do_page_fault+0x141/0x2e0
  [<ffffffff8112d2a1>] sys_unlink+0x11/0x20
  [<ffffffff81035e6b>] system_call_fastpath+0x16/0x1b
Btrfs: orphan add 3021402
Pid: 2429, comm: gpg Not tainted 2.6.33-rc2-00202-g63ebcc6-dirty #15
Call Trace:
  [<ffffffff8132e05b>] btrfs_orphan_add+0xcb/0xf0
  [<ffffffff8132e8ab>] btrfs_unlink+0xfb/0x120
  [<ffffffff81129e10>] ? inode_permission+0x70/0x90
  [<ffffffff8112b093>] vfs_unlink+0x83/0xf0
  [<ffffffff8112a710>] ? lookup_hash+0x30/0x40
  [<ffffffff8112d253>] do_unlinkat+0x183/0x1c0
  [<ffffffff8109bf89>] ? up_read+0x9/0x10
  [<ffffffff8105b071>] ? do_page_fault+0x141/0x2e0
  [<ffffffff8112d2a1>] sys_unlink+0x11/0x20
  [<ffffffff81035e6b>] system_call_fastpath+0x16/0x1b
Btrfs: orphan add 3021403
Pid: 2436, comm: gpg Not tainted 2.6.33-rc2-00202-g63ebcc6-dirty #15
Call Trace:
  [<ffffffff8132e05b>] btrfs_orphan_add+0xcb/0xf0
  [<ffffffff8132e8ab>] btrfs_unlink+0xfb/0x120
  [<ffffffff81129e10>] ? inode_permission+0x70/0x90
  [<ffffffff8112b093>] vfs_unlink+0x83/0xf0
  [<ffffffff8112a710>] ? lookup_hash+0x30/0x40
  [<ffffffff8112d253>] do_unlinkat+0x183/0x1c0
  [<ffffffff8109bf89>] ? up_read+0x9/0x10
  [<ffffffff8105b071>] ? do_page_fault+0x141/0x2e0
  [<ffffffff8112d2a1>] sys_unlink+0x11/0x20
  [<ffffffff81035e6b>] system_call_fastpath+0x16/0x1b
Btrfs: orphan add 3021404
Pid: 2374, comm: gconfd-2 Not tainted 2.6.33-rc2-00202-g63ebcc6-dirty #15
Call Trace:
  [<ffffffff8132e05b>] btrfs_orphan_add+0xcb/0xf0
  [<ffffffff8132e8ab>] btrfs_unlink+0xfb/0x120
  [<ffffffff81129e10>] ? inode_permission+0x70/0x90
  [<ffffffff8112b093>] vfs_unlink+0x83/0xf0
  [<ffffffff8112a710>] ? lookup_hash+0x30/0x40
  [<ffffffff8112d253>] do_unlinkat+0x183/0x1c0
  [<ffffffff81121d0d>] ? fput+0x1d/0x30
  [<ffffffff8111e73d>] ? filp_close+0x4d/0x80
  [<ffffffff8112d2a1>] sys_unlink+0x11/0x20
  [<ffffffff81035e6b>] system_call_fastpath+0x16/0x1b
Btrfs: orphan add 3021392
Pid: 2374, comm: gconfd-2 Not tainted 2.6.33-rc2-00202-g63ebcc6-dirty #15
Call Trace:
  [<ffffffff8132e05b>] btrfs_orphan_add+0xcb/0xf0
  [<ffffffff8132e8ab>] btrfs_unlink+0xfb/0x120
  [<ffffffff81129e10>] ? inode_permission+0x70/0x90
  [<ffffffff8112b093>] vfs_unlink+0x83/0xf0
  [<ffffffff8112a710>] ? lookup_hash+0x30/0x40
  [<ffffffff8112d253>] do_unlinkat+0x183/0x1c0
  [<ffffffff810c0600>] ? call_rcu+0x10/0x20
  [<ffffffff8109de67>] ? __put_cred+0x37/0x50
  [<ffffffff8111f84a>] ? sys_faccessat+0x19a/0x1d0
  [<ffffffff8112d2a1>] sys_unlink+0x11/0x20
  [<ffffffff81035e6b>] system_call_fastpath+0x16/0x1b
Btrfs: orphan add 3021396
Pid: 2522, comm: xauth Not tainted 2.6.33-rc2-00202-g63ebcc6-dirty #15
Call Trace:
  [<ffffffff8132e05b>] btrfs_orphan_add+0xcb/0xf0
  [<ffffffff8132e8ab>] btrfs_unlink+0xfb/0x120
  [<ffffffff81129e10>] ? inode_permission+0x70/0x90
  [<ffffffff8112b093>] vfs_unlink+0x83/0xf0
  [<ffffffff8112a710>] ? lookup_hash+0x30/0x40
  [<ffffffff8112d253>] do_unlinkat+0x183/0x1c0
  [<ffffffff8139aa65>] ? __up_write+0xe5/0x150
  [<ffffffff8112d2a1>] sys_unlink+0x11/0x20
  [<ffffffff81035e6b>] system_call_fastpath+0x16/0x1b
Btrfs: orphan add 3021406
Pid: 2522, comm: xauth Not tainted 2.6.33-rc2-00202-g63ebcc6-dirty #15
Call Trace:
  [<ffffffff8132e05b>] btrfs_orphan_add+0xcb/0xf0
  [<ffffffff8132e8ab>] btrfs_unlink+0xfb/0x120
  [<ffffffff81129e10>] ? inode_permission+0x70/0x90
  [<ffffffff8112b093>] vfs_unlink+0x83/0xf0
  [<ffffffff8112a710>] ? lookup_hash+0x30/0x40
  [<ffffffff8112d253>] do_unlinkat+0x183/0x1c0
  [<ffffffff8139aa65>] ? __up_write+0xe5/0x150
  [<ffffffff8112d2a1>] sys_unlink+0x11/0x20
  [<ffffffff81035e6b>] system_call_fastpath+0x16/0x1b
Btrfs: orphan add 11796
Pid: 2445, comm: nautilus Not tainted 2.6.33-rc2-00202-g63ebcc6-dirty #15
Call Trace:
  [<ffffffff8132e05b>] btrfs_orphan_add+0xcb/0xf0
  [<ffffffff8132ef33>] btrfs_setattr+0xf3/0x270
  [<ffffffff81137b64>] notify_change+0x104/0x2e0
  [<ffffffff81134d9a>] ? __d_lookup+0xfa/0x140
  [<ffffffff8111f8ff>] do_truncate+0x5f/0x90
  [<ffffffff8112a03c>] ? get_write_access+0x3c/0x60
  [<ffffffff8112e4da>] do_filp_open+0x99a/0xf00
  [<ffffffff811324e0>] ? pollwake+0x0/0x60
  [<ffffffff81097580>] ? autoremove_wake_function+0x0/0x40
  [<ffffffff81138a92>] ? alloc_fd+0xf2/0x140
  [<ffffffff8111e8e4>] do_sys_open+0x64/0x140
  [<ffffffff8111e9eb>] sys_open+0x1b/0x20
  [<ffffffff81035e6b>] system_call_fastpath+0x16/0x1b
Btrfs: orphan add 3021266
Pid: 2374, comm: gconfd-2 Not tainted 2.6.33-rc2-00202-g63ebcc6-dirty #15
Call Trace:
  [<ffffffff8132e05b>] btrfs_orphan_add+0xcb/0xf0
  [<ffffffff8132e540>] btrfs_rename+0x4c0/0x590
  [<ffffffff8112b56a>] vfs_rename+0x3da/0x420
  [<ffffffff8112d07e>] sys_renameat+0x23e/0x270
  [<ffffffff813952cb>] ? _atomic_dec_and_lock+0x6b/0x90
  [<ffffffff8113ac14>] ? mntput_no_expire+0x24/0xf0
  [<ffffffff8111f448>] ? sys_fchmodat+0x78/0x100
  [<ffffffff8112a19c>] ? path_put+0x2c/0x40
  [<ffffffff8112d0c6>] sys_rename+0x16/0x20
  [<ffffffff81035e6b>] system_call_fastpath+0x16/0x1b
OH NO, ORPHAN ENTRY ALREADY EXISTS FOR 3021266
Btrfs: orphan add 3021267
Pid: 2374, comm: gconfd-2 Not tainted 2.6.33-rc2-00202-g63ebcc6-dirty #15
Call Trace:
  [<ffffffff8132e05b>] btrfs_orphan_add+0xcb/0xf0
  [<ffffffff8132e540>] btrfs_rename+0x4c0/0x590
  [<ffffffff8112b56a>] vfs_rename+0x3da/0x420
  [<ffffffff8112d07e>] sys_renameat+0x23e/0x270
  [<ffffffff813952cb>] ? _atomic_dec_and_lock+0x6b/0x90
  [<ffffffff8113ac14>] ? mntput_no_expire+0x24/0xf0
  [<ffffffff8111f448>] ? sys_fchmodat+0x78/0x100
  [<ffffffff8112a19c>] ? path_put+0x2c/0x40
  [<ffffffff8112d0c6>] sys_rename+0x16/0x20
  [<ffffffff81035e6b>] system_call_fastpath+0x16/0x1b
OH NO, ORPHAN ENTRY ALREADY EXISTS FOR 3021267
Btrfs: orphan add 3021268
Pid: 2374, comm: gconfd-2 Not tainted 2.6.33-rc2-00202-g63ebcc6-dirty #15
Call Trace:
  [<ffffffff8132e05b>] btrfs_orphan_add+0xcb/0xf0
  [<ffffffff8132e540>] btrfs_rename+0x4c0/0x590
  [<ffffffff8112b56a>] vfs_rename+0x3da/0x420
  [<ffffffff8112d07e>] sys_renameat+0x23e/0x270
  [<ffffffff813952cb>] ? _atomic_dec_and_lock+0x6b/0x90
  [<ffffffff8113ac14>] ? mntput_no_expire+0x24/0xf0
  [<ffffffff8111f448>] ? sys_fchmodat+0x78/0x100
  [<ffffffff8112a19c>] ? path_put+0x2c/0x40
  [<ffffffff8112d0c6>] sys_rename+0x16/0x20
  [<ffffffff81035e6b>] system_call_fastpath+0x16/0x1b
OH NO, ORPHAN ENTRY ALREADY EXISTS FOR 3021268
Btrfs: orphan add 3021269
Pid: 2374, comm: gconfd-2 Not tainted 2.6.33-rc2-00202-g63ebcc6-dirty #15
Call Trace:
  [<ffffffff8132e05b>] btrfs_orphan_add+0xcb/0xf0
  [<ffffffff8132e540>] btrfs_rename+0x4c0/0x590
  [<ffffffff8112b56a>] vfs_rename+0x3da/0x420
  [<ffffffff8112d07e>] sys_renameat+0x23e/0x270
  [<ffffffff813952cb>] ? _atomic_dec_and_lock+0x6b/0x90
  [<ffffffff8113ac14>] ? mntput_no_expire+0x24/0xf0
  [<ffffffff8111f448>] ? sys_fchmodat+0x78/0x100
  [<ffffffff8112a19c>] ? path_put+0x2c/0x40
  [<ffffffff8112d0c6>] sys_rename+0x16/0x20
  [<ffffffff81035e6b>] system_call_fastpath+0x16/0x1b
OH NO, ORPHAN ENTRY ALREADY EXISTS FOR 3021269
Btrfs: orphan add 3021271
Pid: 2502, comm: gvfsd-metadata Not tainted 
2.6.33-rc2-00202-g63ebcc6-dirty #15
Call Trace:
  [<ffffffff8132e05b>] btrfs_orphan_add+0xcb/0xf0
  [<ffffffff8132e540>] btrfs_rename+0x4c0/0x590
  [<ffffffff8112b56a>] vfs_rename+0x3da/0x420
  [<ffffffff8112d07e>] sys_renameat+0x23e/0x270
  [<ffffffff810fd6f8>] ? handle_mm_fault+0x188/0x840
  [<ffffffff8111e983>] ? do_sys_open+0x103/0x140
  [<ffffffff8112d0c6>] sys_rename+0x16/0x20
  [<ffffffff81035e6b>] system_call_fastpath+0x16/0x1b
OH NO, ORPHAN ENTRY ALREADY EXISTS FOR 3021271
Btrfs: orphan add 3021272
Pid: 2502, comm: gvfsd-metadata Not tainted 
2.6.33-rc2-00202-g63ebcc6-dirty #15
Call Trace:
  [<ffffffff8132e05b>] btrfs_orphan_add+0xcb/0xf0
  [<ffffffff8132e8ab>] btrfs_unlink+0xfb/0x120
  [<ffffffff81129e10>] ? inode_permission+0x70/0x90
  [<ffffffff8112b093>] vfs_unlink+0x83/0xf0
  [<ffffffff8112a710>] ? lookup_hash+0x30/0x40
  [<ffffffff8112d253>] do_unlinkat+0x183/0x1c0
  [<ffffffff8109bf89>] ? up_read+0x9/0x10
  [<ffffffff8105b071>] ? do_page_fault+0x141/0x2e0
  [<ffffffff8112d2a1>] sys_unlink+0x11/0x20
  [<ffffffff81035e6b>] system_call_fastpath+0x16/0x1b
OH NO, ORPHAN ENTRY ALREADY EXISTS FOR 3021272
