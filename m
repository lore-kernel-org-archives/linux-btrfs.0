Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fallbackmx08.syd.optusnet.com.au ([211.29.132.10]:52476 "EHLO
	fallbackmx08.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751273Ab3AUGJY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Jan 2013 01:09:24 -0500
Received: from mail12.syd.optusnet.com.au (mail12.syd.optusnet.com.au [211.29.132.193])
	by fallbackmx08.syd.optusnet.com.au (8.13.1/8.13.1) with ESMTP id r0L62pWG008113
	for <linux-btrfs@vger.kernel.org>; Mon, 21 Jan 2013 17:02:51 +1100
Received: from blackspider (c58-109-90-42.rivrw4.nsw.optusnet.com.au [58.109.90.42])
	by mail12.syd.optusnet.com.au (8.13.1/8.13.1) with ESMTP id r0L61b2p006547
	for <linux-btrfs@vger.kernel.org>; Mon, 21 Jan 2013 17:01:38 +1100
Date: Mon, 21 Jan 2013 17:01:36 +1100
From: Skender <skender@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: BTRFS dmesg error
Message-ID: <20130121060136.GA11275@blackspider>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi there,

I noticed in the dmesg logs that there seems to be a bug/issue with btrfs. Here is the trace/message from dmesg. Im going by the instructions from 
the https://btrfs.wiki.kernel.org/index.php/Problem_FAQ#How_do_I_report_bugs_and_issues.3F . Let me know if you need anything else.

Thanks,
Skender Haxhimolla.

skender@blackspider:~$ [655330.131113] ------------[ cut here ]------------
[655330.131123] WARNING: at fs/btrfs/super.c:246 __btrfs_abort_transaction+0x46/0xa0()
[655330.131125] Hardware name: Precision WorkStation T3400
[655330.131126] btrfs: Transaction aborted
[655330.131128] Modules linked in: xt_limit xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ip6table_filter ip6_tables iptable_filter ip_tables x_tables rfcomm bnep bluetooth dm_crypt dvb_usb_cxusb snd_hda_codec_analog dib7000p dibx000_common dvb_usb snd_hda_intel snd_hda_codec snd_hwdep dvb_core snd_pcm snd_seq_midi snd_rawmidi snd_seq_midi_event rc_core dib0070 snd_seq coretemp snd_timer snd_seq_device snd kvm_intel soundcore kvm psmouse snd_page_alloc microcode x38_edac lpc_ich dcdbas serio_raw edac_core ppdev parport_pc lp parport floppy firewire_ohci firewire_core crc_itu_t nouveau tg3 ttm drm_kms_helper drm i2c_algo_bit mxm_wmi video wmi
[655330.131182] Pid: 5838, comm: btrfs-delalloc- Not tainted 3.6.11-custom #1
[655330.131183] Call Trace:
[655330.131190]  [<ffffffff810507dc>] warn_slowpath_common+0x83/0x9c
[655330.131193]  [<ffffffff81050898>] warn_slowpath_fmt+0x46/0x48
[655330.131197]  [<ffffffff81231e0b>] ? btrfs_reserve_extent+0xbd/0x1c6
[655330.131200]  [<ffffffff812208a7>] __btrfs_abort_transaction+0x46/0xa0
[655330.131203]  [<ffffffff812468f4>] submit_compressed_extents+0x1bd/0x415
[655330.131207]  [<ffffffff81246bd2>] async_cow_submit+0x86/0x8b
[655330.131210]  [<ffffffff8125ec27>] run_ordered_completions+0x76/0xd5
[655330.131213]  [<ffffffff8125f49e>] worker_loop+0x183/0x4b9
[655330.131216]  [<ffffffff8125f31b>] ? btrfs_queue_worker+0x288/0x288
[655330.131220]  [<ffffffff8106d9d0>] kthread+0x6f/0x77
[655330.131225]  [<ffffffff815b59c4>] kernel_thread_helper+0x4/0x10
[655330.131228]  [<ffffffff8106d961>] ? kthread_freezable_should_stop+0x48/0x48
[655330.131231]  [<ffffffff815b59c0>] ? gs_change+0x13/0x13
[655330.131233] ---[ end trace bc2b68accbd79b9c ]---

