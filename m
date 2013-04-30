Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:46679 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760420Ab3D3LzF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Apr 2013 07:55:05 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UX99D-0003y8-Aw
	for linux-btrfs@vger.kernel.org; Tue, 30 Apr 2013 13:55:03 +0200
Received: from 212.71.117.85 ([212.71.117.85])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Apr 2013 13:55:03 +0200
Received: from alexanders.mailinglists+nospam by 212.71.117.85 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Apr 2013 13:55:03 +0200
To: linux-btrfs@vger.kernel.org
From: Alexander Skwar <alexanders.mailinglists+nospam@gmail.com>
Subject: Re: WARNING: at fs/btrfs/free-space-cache.c:921 =?utf-8?b?X19idHJmc193cml0ZV9vdXRfY2FjaGUrMHg2YjkvMHg5YTA=?= [btrfs]()
Date: Tue, 30 Apr 2013 11:51:17 +0000 (UTC)
Message-ID: <loom.20130430T133556-803@post.gmane.org>
References: <CADn-QaMao+mtnJVuwjbnqHgFzKhqUfn2uiDgN5hFw_fHP+mGcQ@mail.gmail.com> <CVrGRAreCXB@helmut.hullen.de> <20130430094131.GA8274@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hugo Mills <hugo <at> carfax.org.uk> writes:

>    The differences in btrfs between the two are very small, and even
> I(*) wouldn't call 3.8.0 "very old" quite yet, given that 3.9 was only
> released yesterday. From memory, there's one btrfs patch in the 3.8
> stable series.
> 
>    Your problem is "just" a warning, and appears to be something to do
> with running out of space, or having too many CRCs... I don't really
> know the free space cache code at all well, so I'm mostly guessing
> here, from looking at the WARN_ON in __btrfs_write_out_cache.

Yes, I'm aware that this just a warning, but I'm a bit scared
because of the big number of those warnings.

FWIW, I also got that exact same kernel trace on the Ubuntu
kernel 3.5.0-28-lowlatency; see http://pastebin.com/rmPAqcTu or here:

------------[ cut here ]------------
WARNING: at fs/btrfs/free-space-cache.c:922 
__btrfs_write_out_cache+0x6b9/0x990 [btrfs]()
Hardware name: HP Compaq dc5800 Microtower
Modules linked in: btrfs zlib_deflate libcrc32c des_generic md4 nvidia(PO) 
snd_hda_codec_analog arc4 tpm_infineon coretemp snd_hda_intel rtl8192cu 
snd_hda_codec kvm_intel rtl8192c_common rtlwifi kvm snd_hwdep snd_pcm 
parport_pc snd_seq_midi bnep rfcomm mac80211 ppdev snd_rawmidi bluetooth 
snd_seq_midi_event snd_seq binfmt_misc snd_timer snd_seq_device cfg80211 
dm_multipath psmouse hp_wmi snd scsi_dh gpio_ich sparse_keymap soundcore 
microcode serio_raw tpm_tis mei mac_hid snd_page_alloc wmi lpc_ich lp 
parport nls_utf8 cifs fscache ext2 hid_generic usbhid hid usb_storage floppy 
e1000e
Pid: 25834, comm: btrfs Tainted: P           O 3.5.0-28-lowlatency #31-
Ubuntu
Call Trace:
 [<ffffffff81053d5f>] warn_slowpath_common+0x7f/0xc0
 [<ffffffff81053dba>] warn_slowpath_null+0x1a/0x20
 [<ffffffffa0f83fd9>] __btrfs_write_out_cache+0x6b9/0x990 [btrfs]
 [<ffffffffa0f29325>] ? __find_space_info+0x85/0xa0 [btrfs]
 [<ffffffff8168f76e>] ? _raw_spin_unlock+0xe/0x40
 [<ffffffffa0f32fbc>] ? btrfs_run_delayed_refs+0x1ec/0x470 [btrfs]
 [<ffffffffa0f84345>] btrfs_write_out_cache+0x95/0xf0 [btrfs]
 [<ffffffffa0f3375f>] btrfs_write_dirty_block_groups+0x51f/0x5f0 [btrfs]
 [<ffffffffa0f9edc2>] commit_cowonly_roots+0xfd/0x1c7 [btrfs]
 [<ffffffffa0f94121>] ? btrfs_run_delayed_items+0xd1/0x150 [btrfs]
 [<ffffffffa0f44725>] btrfs_commit_transaction+0x5d5/0xb00 [btrfs]
 [<ffffffff81078ff0>] ? finish_wait+0x80/0x80
 [<ffffffff8119f122>] ? __d_instantiate+0xd2/0x110
 [<ffffffff812bf11b>] ? security_d_instantiate+0x1b/0x30
 [<ffffffffa0f9f8ab>] create_subvol+0x4d1/0x4f8 [btrfs]
 [<ffffffffa0f794e5>] btrfs_mksubvol+0x3a5/0x400 [btrfs]
 [<ffffffffa0f795fe>] btrfs_ioctl_snap_create_transid+0xbe/0x180 [btrfs]
 [<ffffffffa0f79716>] btrfs_ioctl_snap_create+0x56/0x80 [btrfs]
 [<ffffffffa0f7baba>] btrfs_ioctl+0xc0a/0x1280 [btrfs]
 [<ffffffff81692b84>] ? do_page_fault+0x1b4/0x4b0
 [<ffffffff8119b307>] do_vfs_ioctl+0x97/0x530
 [<ffffffff811898c5>] ? vfs_write+0x105/0x180
 [<ffffffff8119b839>] sys_ioctl+0x99/0xa0
 [<ffffffff8169081e>] ? do_device_not_available+0xe/0x10
 [<ffffffff816969e9>] system_call_fastpath+0x16/0x1b
---[ end trace fadd80d2b7f6ec9f ]---



Both traces (from 3.8.0 and 3.5.0) are in fs/btrfs/free-space-cache.c
and have warn_slowpath_common as the first function. Strange, isn't
it?

Since the problem exists for a long time, I pretty much doubt that
just updating the kernel source would help. I'd rather not, I'd 
rather stay with the kernel of my distribution.

I should have mentioned in my OP, that the btrfs is on a LVM. Right
now, I've got two distinct btrfs filesystems on the system; both
on LVM and on seperate logical volumes.

I get this kernel trace / warning only on one of these filesystems.
The LV existed also "back in kernel 3.5.0 times". I've since ran
a btrfs scrub, but it didn't find any errors:


a@ewzw032:~$ sudo btrfs scrub status -d /data
scrub status for 8009e99c-726d-46fb-b68c-be57fb66ca05
scrub device /dev/mapper/system-Data (id 1) history
	scrub started at Tue Apr 30 08:55:27 2013 and finished after 2989 
seconds
	total bytes scrubbed: 146.82GB with 0 errors
a@ewzw032:~$ sudo btrfs scrub status -R /data
scrub status for 8009e99c-726d-46fb-b68c-be57fb66ca05
	scrub started at Tue Apr 30 08:55:27 2013 and finished after 2989 
seconds
	data_extents_scrubbed: 2564422
	tree_extents_scrubbed: 107996
	data_bytes_scrubbed: 157200080896
	tree_bytes_scrubbed: 442351616
	read_errors: 0
	csum_errors: 0
	verify_errors: 0
	no_csum: 0
	csum_discards: 0
	super_errors: 0
	malloc_errors: 0
	uncorrectable_errors: 0
	unverified_errors: 0
	corrected_errors: 0
	last_physical: 251959246848

Best regards,
Alexander

