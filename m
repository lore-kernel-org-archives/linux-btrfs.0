Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:63547 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753509Ab3KDVOK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Nov 2013 16:14:10 -0500
Message-ID: <52780E20.8020405@friedels.name>
Date: Mon, 04 Nov 2013 22:14:08 +0100
From: Hendrik Friedel <hendrik@friedels.name>
MIME-Version: 1.0
To: cwillu <cwillu@cwillu.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: btrfsck errors is it save to fix?
References: <52742B59.3060405@friedels.name> <CAE5mzvijfSOi9dP0MWCMd6=R5MW3bhabote4QYmFnqNEerDifw@mail.gmail.com> <5274BEC8.5060804@friedels.name>
In-Reply-To: <5274BEC8.5060804@friedels.name>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

the list was quite full with patches, so this might have been hidden.
Here the complete Stack.
Does this help? Is this what you needed?

Greetings,
Hendrik


> sorry about that:
> [  126.444603] init: plymouth-stop pre-start process (3446) terminated
> with status 1
> [11189.299864] hda-intel: IRQ timing workaround is activated for card
> #0. Suggest a bigger bdl_pos_adj.
> [94999.489736] device fsid 989306aa-d291-4752-8477-0baf94f8c42f devid 2
> transid 140408 /dev/sdc1
> [94999.489755] device fsid 989306aa-d291-4752-8477-0baf94f8c42f devid 1
> transid 140408 /dev/sdb1
> [95394.400840] device fsid 989306aa-d291-4752-8477-0baf94f8c42f devid 1
> transid 140420 /dev/sdb1
> [95394.400872] device fsid 989306aa-d291-4752-8477-0baf94f8c42f devid 2
> transid 140420 /dev/sdc1
> [95585.149738] init: smbd main process (1168) killed by TERM signal
> [95725.171156] nfsd: last server has exited, flushing export cache
> [95764.899173] ------------[ cut here ]------------
> [95764.899216] WARNING: CPU: 1 PID: 21798 at
> /home/apw/COD/linux/fs/btrfs/disk-io.c:3423 free_fs_root+0x99/0xa
> 0 [btrfs]()
> [95764.899219] Modules linked in: nvram pci_stub vboxpci(OF)
> vboxnetadp(OF) vboxnetflt(OF) vboxdrv(OF) ip6tabl
> e_filter ip6_tables ebtable_nat ebtables ipt_MASQUERADE iptable_nat
> nf_nat_ipv4 nf_nat nf_conntrack_ipv4 nf_de
> frag_ipv4 xt_state nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle
> xt_tcpudp iptable_filter ip_tables x_tab
> les bridge stp llc kvm_intel kvm nfsd nfs_acl auth_rpcgss nfs fscache
> binfmt_misc lockd sunrpc ftdi_sio usbser
> ial stv6110x lnbp21 snd_hda_codec_realtek snd_hda_intel stv090x
> snd_hda_codec snd_hwdep snd_pcm ddbridge dvb_c
> ore snd_timer snd soundcore snd_page_alloc cxd2099(C) mei_me psmouse
> i915 drm_kms_helper mei drm lpc_ich i2c_a
> lgo_bit serio_raw video mac_hid coretemp lp parport hid_generic usbhid
> hid btrfs raid6_pq e1000e ptp pps_core
> ahci libahci xor zlib_deflate libcrc32c
> [95764.899294] CPU: 1 PID: 21798 Comm: umount Tainted: GF        CIO
> 3.11.0-031100rc2-generic #201307211535
> [95764.899297] Hardware name:                  /DH87RL, BIOS
> RLH8710H.86A.0320.2013.0606.1802 06/06/2013
> [95764.899300]  0000000000000d5f ffff880118b59cb8 ffffffff8171e74d
> 0000000000000007
> [95764.899306]  0000000000000000 ffff880118b59cf8 ffffffff8106532c
> ffff880118b59d08
> [95764.899311]  ffff8801184cb800 ffff8801184cb800 ffff880118118000
> ffff880118b59d78
> [95764.899315] Call Trace:
> [95764.899324]  [<ffffffff8171e74d>] dump_stack+0x46/0x58
> [95764.899331]  [<ffffffff8106532c>] warn_slowpath_common+0x8c/0xc0
> [95764.899336]  [<ffffffff8106537a>] warn_slowpath_null+0x1a/0x20
> [95764.899359]  [<ffffffffa00d9a59>] free_fs_root+0x99/0xa0 [btrfs]
> [95764.899384]  [<ffffffffa00dd653>]
> btrfs_drop_and_free_fs_root+0x93/0xc0 [btrfs]
> [95764.899408]  [<ffffffffa00dd74f>] del_fs_roots+0xcf/0x130 [btrfs]
> [95764.899433]  [<ffffffffa00ddac6>] close_ctree+0x146/0x270 [btrfs]
> [95764.899441]  [<ffffffff811cd24e>] ? evict_inodes+0xce/0x130
> [95764.899461]  [<ffffffffa00b4eb9>] btrfs_put_super+0x19/0x20 [btrfs]
> [95764.899467]  [<ffffffff811b47e2>] generic_shutdown_super+0x62/0xf0
> [95764.899475]  [<ffffffff811b4906>] kill_anon_super+0x16/0x30
> [95764.899493]  [<ffffffffa00b754a>] btrfs_kill_super+0x1a/0x90 [btrfs]
> [95764.899500]  [<ffffffff811b512d>] deactivate_locked_super+0x4d/0x80
> [95764.899505]  [<ffffffff811b57ae>] deactivate_super+0x4e/0x70
> [95764.899510]  [<ffffffff811d1266>] mntput_no_expire+0x106/0x160
> [95764.899515]  [<ffffffff811d2b79>] SyS_umount+0xa9/0xf0
> [95764.899520]  [<ffffffff817333ef>] tracesys+0xe1/0xe6
> [95764.899524] ---[ end trace 0024dfebf572e76c ]---
> [95764.985245] VFS: Busy inodes after unmount of sdb1. Self-destruct in
> 5 seconds.  Have a nice day...
> [95790.079663] device fsid 989306aa-d291-4752-8477-0baf94f8c42f devid 1
> transid 140425 /dev/sdb1
> [95790.101778] device fsid 989306aa-d291-4752-8477-0baf94f8c42f devid 2
> transid 140425 /dev/sdc1
> [95790.162960] device fsid 989306aa-d291-4752-8477-0baf94f8c42f devid 1
> transid 140425 /dev/sdb1
> [95790.163825] device fsid 989306aa-d291-4752-8477-0baf94f8c42f devid 2
> transid 140425 /dev/sdc1
> [95924.393344] device fsid 989306aa-d291-4752-8477-0baf94f8c42f devid 1
> transid 140425 /dev/sdb1
> [95924.421118] device fsid 989306aa-d291-4752-8477-0baf94f8c42f devid 2
> transid 140425 /dev/sdc1
> [95924.676571] device fsid 989306aa-d291-4752-8477-0baf94f8c42f devid 1
> transid 140425 /dev/sdb1
> [95924.677046] device fsid 989306aa-d291-4752-8477-0baf94f8c42f devid 2
> transid 140425 /dev/sdc1
>
>
> Greetings,
> Hendrik
>
>
> Am 02.11.2013 09:12, schrieb cwillu:
>>> Now that I am searching, I see this in dmesg:
>>> [95764.899359]  [<ffffffffa00d9a59>] free_fs_root+0x99/0xa0 [btrfs]
>>> [95764.899384]  [<ffffffffa00dd653>]
>>> btrfs_drop_and_free_fs_root+0x93/0xc0
>>> [btrfs]
>>> [95764.899408]  [<ffffffffa00dd74f>] del_fs_roots+0xcf/0x130 [btrfs]
>>> [95764.899433]  [<ffffffffa00ddac6>] close_ctree+0x146/0x270 [btrfs]
>>> [95764.899461]  [<ffffffffa00b4eb9>] btrfs_put_super+0x19/0x20 [btrfs]
>>> [95764.899493]  [<ffffffffa00b754a>] btrfs_kill_super+0x1a/0x90 [btrfs]
>>
>> Need to see the rest of the trace this came from.
>>
>
>


-- 
Hendrik Friedel
Auf dem Brink 12
28844 Weyhe
Mobil 0178 1874363
