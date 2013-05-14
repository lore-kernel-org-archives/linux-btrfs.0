Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ve0-f171.google.com ([209.85.128.171]:41252 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756630Ab3ENT1J (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 May 2013 15:27:09 -0400
Received: by mail-ve0-f171.google.com with SMTP id m1so1108553ves.16
        for <linux-btrfs@vger.kernel.org>; Tue, 14 May 2013 12:27:08 -0700 (PDT)
Received: from wepa.arachnorican.com (rrcs-208-105-151-74.nys.biz.rr.com. [208.105.151.74])
        by mx.google.com with ESMTPSA id xe6sm17761146vec.6.2013.05.14.12.27.08
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=RC4-SHA bits=128/128);
        Tue, 14 May 2013 12:27:08 -0700 (PDT)
From: dose <orlando.cruz@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: soft lockup btrfs
Date: Tue, 14 May 2013 15:27:07 -0400
Message-ID: <23200321.jz1jcOnznO@wepa.arachnorican.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,
I created a btrfs volume adding drive by drive and after ran a convert and 
balance to raid0. After 3 or 4 hours it seg faulted. I issued a reboot but it 
would took about an hour. Now it will not mount. This is what i see in my 
error log. Any ideas?

Thanks
Orlando Cruz
 
[  115.510395] ------------[ cut here ]------------
[  115.510426] WARNING: at fs/btrfs/delayed-ref.c:454 
update_existing_ref+0x119/0x150 [btrfs]()
[  115.510428] Hardware name: MS-7666
[  115.510429] Modules linked in: tda18271 s5h1411 ip6table_filter ip6_tables 
ebtable_nat ebtables bnep bluetooth rfkill be2iscsi iscsi_boot_sysfs bnx2i 
cnic uio cxgb4i cxgb4 cxgb3i cxgb3 mdio libcxgbi ib_iser rdma_cm ib_addr iw_cm 
ib_cm ib_sa ib_mad ib_core iscsi_tcp libiscsi_tcp libiscsi 
scsi_transport_iscsi snd_hda_codec_hdmi nvidia(POF) coretemp iTCO_wdt 
iTCO_vendor_support snd_hda_codec_realtek microcode uvcvideo snd_hda_intel 
snd_usb_audio serio_raw videobuf2_vmalloc snd_hda_codec videobuf2_memops 
snd_usbmidi_lib i2c_i801 videobuf2_core snd_rawmidi snd_hwdep saa7164 snd_seq 
tveeprom snd_seq_device dvb_core vhost_net snd_pcm lpc_ich v4l2_common 
mfd_core tun videodev macvtap macvlan media snd_page_alloc kvm_intel 
i7core_edac snd_timer r8169 snd edac_core mii soundcore i2c_core kvm uinput 
binfmt_misc btrfs zlib_deflate libcrc32c mxm_wmi crc32c_intel firewire_ohci 
firewire_core crc_itu_t wmi
[  115.510461] Pid: 2313, comm: mount Tainted: PF          O 
3.8.11-200.fc18.x86_64 #1
[  115.510462] Call Trace:
[  115.510468]  [<ffffffff8105e675>] warn_slowpath_common+0x75/0xa0
[  115.510470]  [<ffffffff8105e6ba>] warn_slowpath_null+0x1a/0x20
[  115.510481]  [<ffffffffa00f5a79>] update_existing_ref+0x119/0x150 [btrfs]
[  115.510492]  [<ffffffffa00f5d0f>] add_delayed_tree_ref+0xcf/0x190 [btrfs]
[  115.510503]  [<ffffffffa00f58cf>] ? add_delayed_ref_head.isra.7+0xcf/0x160 
[btrfs]
[  115.510515]  [<ffffffffa00f6519>] btrfs_add_delayed_tree_ref+0x109/0x1a0 
[btrfs]
[  115.510523]  [<ffffffffa00a0591>] btrfs_free_extent+0xa1/0xf0 [btrfs]
[  115.510534]  [<ffffffffa00fa2d2>] replace_path+0x782/0x7f0 [btrfs]
[  115.510546]  [<ffffffffa00fced8>] merge_reloc_root+0x1f8/0x510 [btrfs]
[  115.510553]  [<ffffffffa008f2da>] ? btrfs_free_path+0x2a/0x40 [btrfs]
[  115.510564]  [<ffffffffa00fd2bc>] merge_reloc_roots+0xcc/0x150 [btrfs]
[  115.510575]  [<ffffffffa00fe268>] btrfs_recover_relocation+0x398/0x410 [btrfs]
[  115.510585]  [<ffffffffa00b2d97>] open_ctree+0x1b07/0x1cf0 [btrfs]
[  115.510589]  [<ffffffff812e328a>] ? disk_name+0xba/0xc0
[  115.510595]  [<ffffffffa008bafc>] btrfs_mount+0x62c/0x770 [btrfs]
[  115.510601]  [<ffffffff811a15d3>] mount_fs+0x43/0x1b0
[  115.510605]  [<ffffffff811bacef>] vfs_kern_mount+0x6f/0x100
[  115.510607]  [<ffffffff811bd10f>] do_mount+0x21f/0xab0
[  115.510609]  [<ffffffff811bcd5a>] ? copy_mount_options+0x3a/0x180
[  115.510611]  [<ffffffff811bda2e>] sys_mount+0x8e/0xe0
[  115.510615]  [<ffffffff8165be19>] system_call_fastpath+0x16/0x1b
[  115.510616] ---[ end trace 09e1d738feb203b9 ]---
[  115.510773] ------------[ cut here ]------------

