From: Josef Bacik <josef@redhat.com>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference at (null)
Date: Tue, 5 Apr 2011 14:53:24 -0400
Message-ID: <20110405185324.GB484@dhcp231-156.rdu.redhat.com>
References: <201104051938.14319.johannes.hirte@fem.tu-ilmenau.de> <20110405174202.GA484@dhcp231-156.rdu.redhat.com> <201104052052.21623.johannes.hirte@fem.tu-ilmenau.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org
To: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201104052052.21623.johannes.hirte@fem.tu-ilmenau.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 05, 2011 at 08:52:21PM +0200, Johannes Hirte wrote:
> On Tuesday 05 April 2011 19:42:03 Josef Bacik wrote:
> > On Tue, Apr 05, 2011 at 07:38:13PM +0200, Johannes Hirte wrote:
> > > With the latest btrfs changes, I got this Oops when doing rm on a large
> > > directory:
> > > 
> > > BUG: unable to handle kernel NULL pointer dereference at   (null)
> > > IP: [<c101c838>] kunmap+0x46/0x46
> > > *pdpt = 0000000034a85001 *pde = 0000000000000000
> > > Oops: 0000 [#1] PREEMPT SMP
> > > last sysfs file: /sys/devices/virtual/vtconsole/vtcon1/uevent
> > > Modules linked in: snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device
> > > snd_pcm_oss snd_mixer_oss fuse dm_crypt dm_mod usbhid snd_intel8x0
> > > snd_ac97_codec ac97_bus snd_pcm snd_timer sr_mod cdrom sg snd fschmd
> > > e1000 uhci_hcd snd_page_alloc i2c_i801 [last unloaded: microcode]
> > > 
> > > Pid: 1156, comm: btrfs-transacti Tainted: G        W   2.6.39-rc1-00262-
> > > gc53813f #20 FUJITSU SIEMENS SCENIC P / SCENICO P/D1561
> > > EIP: 0060:[<c101c838>] EFLAGS: 00010296 CPU: 1
> > > EIP is at kmap+0x0/0x38
> > > EAX: 00000000 EBX: 00000000 ECX: 00000000 EDX: 00000010
> > > ESI: f5bc6400 EDI: f3c75520 EBP: f3c755f0 ESP: f58f9e10
> > > 
> > >  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> > > 
> > > Process btrfs-transacti (pid: 1156, ti=f58f8000 task=f6516f40
> > > task.ti=f58f8000)
> > > 
> > > Stack:
> > >  c1186d15 ffc22000 f58f9ec0 00000010 f3c75610 00000000 f5885780 f52339e8
> > >  00000009 f5bc6400 00010000 00000000 f6415800 f3c75638 000008bb f5bc63c0
> > >  f58857b4 f60b68a0 00000040 f52338e8 ffc22000 00000000 00000008 00000010
> > > 
> > > Call Trace:
> > >  [<c1186d15>] ? btrfs_write_out_cache+0x60c/0xa3c
> > >  [<c114a815>] ? btrfs_write_dirty_block_groups+0x400/0x494
> > >  [<c11566a7>] ? commit_cowonly_roots+0xa9/0x180
> > >  [<c1157799>] ? btrfs_commit_transaction+0x2ee/0x59c
> > >  [<c1037c85>] ? wake_up_bit+0x16/0x16
> > >  [<c1152a83>] ? transaction_kthread+0x149/0x1d6
> > >  [<c101d1b9>] ? complete+0x28/0x36
> > >  [<c115293a>] ? btrfs_congested_fn+0x5d/0x5d
> > >  [<c10379c4>] ? kthread+0x63/0x68
> > >  [<c1037961>] ? kthread_worker_fn+0xeb/0xeb
> > >  [<c13cba36>] ? kernel_thread_helper+0x6/0xd
> > > 
> > > Code: 8d 8a 00 e4 54 c1 2b 8a 8c e7 54 c1 81 f9 00 08 00 00 74 11 81 f9
> > > 00 0c 00 00 75 0e 83 3d 10 2f 60 c1 02 75 05 e9 5e a3 04 00 c3 <8b> 10
> > > c1 ea 1e c1 e2 0a 8d 8a 00 e4 54 c1 2b 8a 8c e7 54 c1 81
> > > EIP: [<c101c838>] kmap+0x0/0x38 SS:ESP 0068:f58f9e10
> > > CR2: 0000000000000000
> > > ---[ end trace c8511126ee91dfdf ]---
> > > 
> > > This is the second Oops. On the first one I wasn't able to catch the
> > > backtrace, but IIRC the bug happend on kmap not kunmap the first time.
> > 
> > Yeah I think I know what this is but I need somebody to verify it for me. 
> > Can you run with this patch and let me know what happens?  Thanks,
> > 
> > Josef
> > 
> > diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
> > index 74bc432..5e6f4b3 100644
> > --- a/fs/btrfs/free-space-cache.c
> > +++ b/fs/btrfs/free-space-cache.c
> > @@ -624,6 +624,7 @@ int btrfs_write_out_cache(struct btrfs_root *root,
> > 
> >  		next_page = false;
> > 
> > +		BUG_ON(index > last_index);
> >  		if (index == 0) {
> >  			start_offset = first_page_offset;
> >  			offset = start_offset;
> > @@ -732,6 +733,7 @@ int btrfs_write_out_cache(struct btrfs_root *root,
> >  		struct btrfs_free_space *entry =
> >  			list_entry(pos, struct btrfs_free_space, list);
> > 
> > +		BUG_ON(index > last_index);
> >  		page = find_get_page(inode->i_mapping, index);
> > 
> >  		addr = kmap(page);
> 
> Hm, I tried but now I hit the 
> BUG_ON(block_group->total_bitmaps >= max_bitmaps); in add_new_bitmap in
> fs/btrfs/free-space-cache.c:1255 when booting the system.

Can you mount -o clear_cache to make sure it's not the cache thats causing that?
Thanks,

Josef
