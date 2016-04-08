Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33020 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752872AbcDHCAp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Apr 2016 22:00:45 -0400
Date: Thu, 7 Apr 2016 19:01:23 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: Holger =?iso-8859-1?Q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: WARN_ON in record_root_in_trans() when deleting freshly renamed
 subvolume
Message-ID: <20160408020123.GG5596@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <57068E64.7000408@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <57068E64.7000408@googlemail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 07, 2016 at 06:44:20PM +0200, Holger Hoffstätte wrote:
> Hi,
> 
> Looks like I just found an exciting new corner case.
> kernel 4.4.6 with btrfs ~4.6, so 4.6 should reproduce.
> 
> Try on a fresh volume:
> 
> $btrfs subvolume create foo
> Create subvolume './foo'
> $sync
> $btrfs subvolume snapshot foo foo-1
> Create a snapshot of 'foo' in './foo-1'
> $sync
> $mv foo-1 foo.new
> $btrfs subvolume delete foo.new 
> Delete subvolume (no-commit): '/mnt/test/foo.new'
> $dmesg 
> [  226.923316] ------------[ cut here ]------------
> [  226.923339] WARNING: CPU: 1 PID: 5863 at fs/btrfs/transaction.c:319 record_root_in_trans+0xd6/0x100 [btrfs]()
> [  226.923340] Modules linked in: auth_rpcgss oid_registry nfsv4 btrfs xor raid6_pq loop nfs lockd grace sunrpc autofs4 sch_fq_codel radeon snd_hda_codec_realtek x86_pkg_temp_thermal snd_hda_codec_generic coretemp crc32_pclmul crc32c_intel aesni_intel i2c_algo_bit uvcvideo snd_hda_codec_hdmi aes_x86_64 drm_kms_helper videobuf2_vmalloc glue_helper videobuf2_memops syscopyarea lrw sysfillrect gf128mul videobuf2_v4l2 sysimgblt snd_usb_audio fb_sys_fops ablk_helper snd_hda_intel videobuf2_core ttm cryptd snd_hwdep v4l2_common usbhid snd_hda_codec snd_usbmidi_lib videodev snd_rawmidi drm snd_hda_core snd_seq_device i2c_i801 snd_pcm i2c_core snd_timer snd r8169 soundcore mii parport_pc parport
> [  226.923365] CPU: 1 PID: 5863 Comm: ls Not tainted 4.4.6 #1
> [  226.923366] Hardware name: Gigabyte Technology Co., Ltd. P67-DS3-B3/P67-DS3-B3, BIOS F1 05/06/2011
> [  226.923367]  0000000000000000 ffff8800da677d20 ffffffff813181a8 0000000000000000
> [  226.923368]  ffffffffa0aacdbf ffff8800da677d58 ffffffff810507b2 ffff880601e90800
> [  226.923369]  ffff8800dacf10a0 ffff880601e90800 ffff880601e909f0 0000000000000001
> [  226.923371] Call Trace:
> [  226.923374]  [<ffffffff813181a8>] dump_stack+0x4d/0x65
> [  226.923376]  [<ffffffff810507b2>] warn_slowpath_common+0x82/0xc0
> [  226.923378]  [<ffffffff810508aa>] warn_slowpath_null+0x1a/0x20
> [  226.923387]  [<ffffffffa0a2cf46>] record_root_in_trans+0xd6/0x100 [btrfs]
> [  226.923395]  [<ffffffffa0a2db24>] btrfs_record_root_in_trans+0x44/0x70 [btrfs]
> [  226.923404]  [<ffffffffa0a2fb5e>] start_transaction+0x9e/0x4c0 [btrfs]
> [  226.923412]  [<ffffffffa0a2ffd7>] btrfs_join_transaction+0x17/0x20 [btrfs]
> [  226.923421]  [<ffffffffa0a359b5>] btrfs_dirty_inode+0x35/0xd0 [btrfs]
> [  226.923430]  [<ffffffffa0a35acd>] btrfs_update_time+0x7d/0xb0 [btrfs]
> [  226.923432]  [<ffffffff81187028>] touch_atime+0x88/0xa0
> [  226.923434]  [<ffffffff8117ec9b>] iterate_dir+0xdb/0x120
> [  226.923435]  [<ffffffff8117f0c8>] SyS_getdents+0x88/0xf0
> [  226.923437]  [<ffffffff8117edb0>] ? fillonedir+0xd0/0xd0
> [  226.923439]  [<ffffffff815b8257>] entry_SYSCALL_64_fastpath+0x12/0x6a
> [  226.923440] ---[ end trace 9c78caf253e284fe ]---
> 
> Code looks like:
> 
> ..
> static int record_root_in_trans(struct btrfs_trans_handle *trans,
> 			       struct btrfs_root *root)
> {
> 	if (test_bit(BTRFS_ROOT_REF_COWS, &root->state) &&
> 	    root->last_trans < trans->transid) {
> 		WARN_ON(root == root->fs_info->extent_root);
> 		WARN_ON(root->commit_root != root->node);
> ..
> 
> There's been a few journal/recovery/directory consistency patches recently,
> so maybe it's a corner case or an older problem. I'll try to bisect, but
> meanwhile wanted to report it for discussion.

Vanilla 4.5.0 is fine with the above test, you may bisect between 4.5 with upstream.

Thanks,

-liubo

> 
> Holger
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
