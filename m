Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:50191 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751391AbaJXPxB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Oct 2014 11:53:01 -0400
Date: Fri, 24 Oct 2014 23:52:47 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        clm@fb.com, jbacik@fb.com, linux-btrfs@vger.kernel.org
Subject: Re: btrfs: WARN_ON(data_sinfo->bytes_may_use < bytes);
Message-ID: <20141024155245.GA14709@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <20141023010731.GA27796@redhat.com>
 <20141023012236.GA28429@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20141023012236.GA28429@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Dave,

On Wed, Oct 22, 2014 at 09:22:36PM -0400, Dave Jones wrote:
> On Wed, Oct 22, 2014 at 09:07:31PM -0400, Dave Jones wrote:
>  > Just hit this while running trinity.
>  > 
>  > WARNING: CPU: 3 PID: 9612 at fs/btrfs/extent-tree.c:3799 btrfs_free_reserved_data_space+0x1d1/0x280 [btrfs]()
>  > Modules linked in: rfcomm hidp bnep af_key llc2 scsi_transport_iscsi nfnetlink sctp libcrc32c can_raw can_bcm nfc caif_socket caif af_802154 ieee802154 phonet af_rxrpc bluetooth can pppoe pppox ppp_generic slhc irda crc_ccitt rds rose x25 atm netrom appletalk ipx p8023 psnap p8022 llc ax25 cfg80211 rfkill btrfs xor coretemp hwmon x86_pkg_temp_thermal kvm_intel snd_hda_codec_realtek snd_hda_codec_hdmi snd_hda_codec_generic kvm crct10dif_pclmul crc32c_intel ghash_clmulni_intel raid6_pq snd_hda_intel microcode snd_hda_controller pcspkr snd_hda_codec serio_raw snd_hwdep snd_seq snd_seq_device usb_debug snd_pcm e1000e ptp shpchp pps_core snd_timer snd soundcore
>  > CPU: 3 PID: 9612 Comm: trinity-c85 Not tainted 3.18.0-rc1+ #74
>  >  0000000000000009 000000009989d5b8 ffff88018a337ba8 ffffffffaf86cc97
>  >  0000000000000000 0000000000000000 ffff88018a337be8 ffffffffaf07f301
>  >  ffff88022ddf8d40 ffff88023f799148 000000007fbbf000 ffff88009c2b59c8
>  > Call Trace:
>  >  [<ffffffffaf86cc97>] dump_stack+0x4f/0x7c
>  >  [<ffffffffaf07f301>] warn_slowpath_common+0x81/0xa0
>  >  [<ffffffffaf07f41a>] warn_slowpath_null+0x1a/0x20
>  >  [<ffffffffc045b831>] btrfs_free_reserved_data_space+0x1d1/0x280 [btrfs]
>  >  [<ffffffffc045d0b2>] btrfs_delalloc_release_space+0x22/0x30 [btrfs]
>  >  [<ffffffffc047994b>] btrfs_direct_IO+0x33b/0x350 [btrfs]
>  >  [<ffffffffc0487400>] ? btrfs_page_exists_in_range+0x2c0/0x2c0 [btrfs]
>  >  [<ffffffffc047b2b0>] ? btrfs_real_readdir+0x5e0/0x5e0 [btrfs]
>  >  [<ffffffffaf1adbb4>] generic_file_direct_write+0xc4/0x1a0
>  >  [<ffffffffc048b246>] btrfs_file_write_iter+0x186/0x560 [btrfs]
>  >  [<ffffffffaf22abde>] new_sync_write+0x8e/0xd0
>  >  [<ffffffffaf22b5ca>] vfs_write+0xba/0x1f0
>  >  [<ffffffffaf24fbce>] ? __fget_light+0xbe/0xe0
>  >  [<ffffffffaf22c2d2>] SyS_pwrite64+0x92/0xc0
>  >  [<ffffffffaf877d49>] tracesys_phase2+0xd4/0xd9
> 
> I also see this WARN_ON being hit from the sync path..
> 
> WARNING: CPU: 2 PID: 11166 at fs/btrfs/extent-tree.c:3799 btrfs_free_reserved_data_space+0x1d1/0x280 [btrfs]()
> CPU: 2 PID: 11166 Comm: trinity-c61 Tainted: G        W      3.18.0-rc1+ #74
>  0000000000000009 00000000aee2e4e2 ffff8801b0dfbcc8 ffffffff8d86cc97
>  0000000000000000 0000000000000000 ffff8801b0dfbd08 ffffffff8d07f301
>  ffff88023f328000 ffff88023953d668 0000000000040000 ffff880239358548
> Call Trace:
>  [<ffffffff8d86cc97>] dump_stack+0x4f/0x7c
>  [<ffffffff8d07f301>] warn_slowpath_common+0x81/0xa0
>  [<ffffffff8d07f41a>] warn_slowpath_null+0x1a/0x20
>  [<ffffffffc0253831>] btrfs_free_reserved_data_space+0x1d1/0x280 [btrfs]
>  [<ffffffffc025ca63>] btrfs_write_dirty_block_groups+0x6f3/0x740 [btrfs]
>  [<ffffffffc02f7a41>] commit_cowonly_roots+0x17a/0x234 [btrfs]
>  [<ffffffffc026e60b>] btrfs_commit_transaction+0x45b/0xc10 [btrfs]
>  [<ffffffffc023a09b>] btrfs_sync_fs+0x8b/0x270 [btrfs]
>  [<ffffffff8d266ad0>] ? do_fsync+0x80/0x80
>  [<ffffffff8d266af0>] sync_fs_one_sb+0x20/0x30
>  [<ffffffff8d22f2f2>] iterate_supers+0xb2/0x110
>  [<ffffffff8d266c24>] sys_sync+0x64/0xb0
>  [<ffffffff8d877d49>] tracesys_phase2+0xd4/0xd9
> 
> After rebooting, and restarting the fuzzer, it happened again very quickly.

Could you please show us the trinity options you're using?

I also see this WARNing from other reports, but still try to reproduce..

thanks,
-liubo
