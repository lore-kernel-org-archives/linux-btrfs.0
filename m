From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH 1/2] stop using highmem for extent_buffers
Date: Wed, 20 Jul 2011 09:26:43 +0800
Message-ID: <4E262ED3.1050609@cn.fujitsu.com>
References: <1311096700-sup-8175@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1311096700-sup-8175@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

01:32, Chris Mason wrote:
> I haven't yet tested this on x86-32, if someone is willing to try this
> on non-critical test machines I'd appreciate it.
> 

Great work!

I pulled the integration-test branch, and I got this when mounting
a newly created btrfs:

[   65.544087] BUG: unable to handle kernel NULL pointer dereference at   (null)
[   65.544176] IP: [<f98cdc52>] write_extent_buffer+0xad/0xcb [btrfs]
[   65.544276] *pde = 00000000 
[   65.544314] Oops: 0002 [#1] SMP 
...
[   65.544980] Pid: 1419, comm: mount Not tainted 2.6.39+ #19 Acer ASPIRE AG1720/E945GCZ
[   65.545035] EIP: 0060:[<f98cdc52>] EFLAGS: 00010246 CPU: 0
[   65.545035] EIP is at write_extent_buffer+0xad/0xcb [btrfs]
[   65.545035] EAX: 00000000 EBX: f2c2be00 ECX: 00001000 EDX: 00000282
[   65.545035] ESI: f368c438 EDI: 00000000 EBP: f36a5d88 ESP: f36a5d70
[   65.545035]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[   65.545035] Process mount (pid: 1419, ti=f36a4000 task=f43f4aa0 task.ti=f36a4000)
[   65.545035] Stack:
[   65.545035]  00000000 f368c438 00001000 f368c000 f2c2be00 fffffff4 f36a5dc0 f98d3760
[   65.545035]  00001000 22222222 f4664630 22222222 f368dd50 00000000 f368e038 f36a5dc0
[   65.545035]  c0797b65 f368c000 00001000 f368e038 f36a5e68 f98b20f5 00000000 f368c150
[   65.545035] Call Trace:
[   65.545035]  [<f98d3760>] btrfs_read_sys_array+0x5a/0xf9 [btrfs]
[   65.545035]  [<c0797b65>] ? mutex_lock_nested+0x35/0x3d
[   65.545035]  [<f98b20f5>] open_ctree+0xbd6/0x12ed [btrfs]
[   65.545035]  [<c05aa989>] ? snprintf+0x15/0x17
[   65.545035]  [<c05a8c09>] ? strlcpy+0x13/0x2e
[   65.545035]  [<f989900d>] btrfs_mount+0x326/0x512 [btrfs]
[   65.545035]  [<c04c18ef>] ? pcpu_alloc+0x637/0x64d
[   65.545035]  [<c04f5ae9>] ? alloc_vfsmnt+0x90/0x123
[   65.545035]  [<c04f5a00>] ? mnt_get_writers.clone.20+0x20/0x3d
[   65.545035]  [<c04e3bba>] mount_fs+0x13/0x99
[   65.545035]  [<c04f5d19>] vfs_kern_mount+0x4a/0x7f
[   65.545035]  [<c04f5f7b>] do_kern_mount+0x34/0xb5
[   65.545035]  [<c04f72f2>] do_mount+0x59c/0x5ea
[   65.545035]  [<c04f7570>] sys_mount+0x66/0x94
[   65.545035]  [<c079e79f>] sysenter_do_call+0x12/0x38
[   65.545035] Code: 36 45 8f f9 e8 f0 c0 b6 c6 b8 00 10 00 00 29 f8 3b 45 08 0f 47 45 08 89 45 f0 89 f0 e8 75 43 bf c6 8b 75 ec 8b 4d f0 01 f8 89 c7 <f3> a4 31 ff 8b 45 f0 29 45 08 ff 45 e8 89 75 ec 83 7d 08 00 75 
[   65.545035] EIP: [<f98cdc52>] write_extent_buffer+0xad/0xcb [btrfs] SS:ESP 0068:f36a5d70
[   65.545035] CR2: 0000000000000000
[   65.547418] ---[ end trace daf6641da0b871f0 ]---


> ---------------------------------------------------------
> The extent_buffers have a very complex interface where
> we use HIGHMEM for metadata and try to cache a kmap mapping
> to access the memory.
> 
> The next commit adds reader/writer locks, and concurrent use
> of this kmap cache would make it even more complex.
> 
> This commit drops the ability to use HIGHMEM with extent buffers,
> and rips out all of the related code.
> 
> Signed-off-by: Chris Mason <chris.mason@oracle.com>
> 
