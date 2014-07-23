Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:41938 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755937AbaGWDVe convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Jul 2014 23:21:34 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: BUGS: bogus out of space reported when mounted raid1 degraded, btrfs replace failure, then oops
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20140723030142.GA4955@localhost.localdomain>
Date: Tue, 22 Jul 2014 21:21:32 -0600
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-Id: <C67FB7F2-72D4-48A2-801A-6C47957788DA@colorremedies.com>
References: <3823A5F4-169B-4EAC-A548-B0E4FE782F0E@colorremedies.com> <20140723030142.GA4955@localhost.localdomain>
To: bo.li.liu@oracle.com, Eric Sandeen <sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jul 22, 2014, at 9:01 PM, Liu Bo <bo.li.liu@oracle.com> wrote:
>> 
>> ============so then he gets curious about replacing the missing disk==============
>> 
>> 
>> 7. btrfs replace start 2 /dev/sdb1 /   ## this is a ~13GB partition that matches the size of the missing device
>> 
>> This completes, no disk activity for a little over a minute, and then I see a call trace with btrfs_replace implicated. Unfortunately the system becomes so unstable at this point, I can't even capture a dmesg to a separate volume. After 30 minutes of unresponsive local shells, I force a poweroff.

OK I've reproduced this original oops that causes the problem during device replace. The command above is correct, it is devid 2. Here's the trace that happens during rebuild. It's only slightly different than the -o rw,degraded trace. What I note is that it reports the device replace is finished, yet also at that time it barfs, probably before it finishes writing whatever's needed so that subsequent mounts can be done normally rather than with -o degraded.



[  423.512988] BTRFS: dev_replace from <missing disk> (devid 2) to /dev/sdb1 started
[  651.671835] BTRFS: dev_replace from <missing disk> (devid 2) to /dev/sdb1) finished
[  651.672485] BUG: unable to handle kernel NULL pointer dereference at 0000000000000088
[  651.673144] IP: [<ffffffffa03da551>] btrfs_kobj_rm_device+0x21/0x40 [btrfs]
[  651.673834] PGD 8723b067 PUD 8723c067 PMD 0 
[  651.674512] Oops: 0000 [#1] SMP 
[  651.675184] Modules linked in: ccm xt_CHECKSUM ipt_MASQUERADE ip6t_rpfilter ip6t_REJECT xt_conntrack ebtable_nat ebtable_broute bridge stp llc ebtable_filter ebtables ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_security ip6table_raw ip6table_filter ip6_tables iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_security iptable_raw bnep nls_utf8 hfsplus arc4 b43 mac80211 x86_pkg_temp_thermal coretemp kvm_intel cfg80211 uvcvideo kvm ssb videobuf2_vmalloc iTCO_wdt crct10dif_pclmul videobuf2_memops videobuf2_core iTCO_vendor_support crc32_pclmul v4l2_common crc32c_intel videodev btusb ghash_clmulni_intel applesmc sdhci_pci input_polldev bluetooth media sdhci hid_appleir microcode bcm5974 rfkill mmc_core i2c_i801 bcma
[  651.677785]  snd_hda_codec_cirrus lpc_ich snd_hda_codec_generic mfd_core snd_hda_codec_hdmi sbs sbshc snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm mei_me snd_timer apple_gmux snd mei apple_bl shpchp soundcore firewire_sbp2 btrfs xor raid6_pq i915 ttm i2c_algo_bit drm_kms_helper tg3 drm firewire_ohci ptp firewire_core pps_core i2c_core crc_itu_t video
[  651.680756] CPU: 0 PID: 1443 Comm: btrfs Not tainted 3.16.0-0.rc6.git0.1.fc21.1.x86_64 #1
[  651.681816] Hardware name: Apple Inc. MacBookPro8,2/Mac-94245A3940C91C80, BIOS    MBP81.88Z.0047.B27.1201241646 01/24/12
[  651.682913] task: ffff8802546b62c0 ti: ffff880087254000 task.ti: ffff880087254000
[  651.684030] RIP: 0010:[<ffffffffa03da551>]  [<ffffffffa03da551>] btrfs_kobj_rm_device+0x21/0x40 [btrfs]
[  651.685190] RSP: 0018:ffff880087257c80  EFLAGS: 00010286
[  651.686346] RAX: 0000000000000000 RBX: 0000000000000000 RCX: dfc8a37487c2b3b9
[  651.687517] RDX: ffff88026061f810 RSI: ffff88026061ce00 RDI: ffff88026130d0c0
[  651.688705] RBP: ffff880087257c88 R08: ffff88026061f810 R09: 000000000000052e
[  651.689881] R10: ffff88026fa1cdc0 R11: 0000000000000001 R12: ffff88025f981dc8
[  651.691059] R13: ffff88026061ce00 R14: ffff88026174d800 R15: ffff880262b31800
[  651.692239] FS:  00007f5b0225f880(0000) GS:ffff88026fa00000(0000) knlGS:0000000000000000
[  651.693439] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  651.694638] CR2: 0000000000000088 CR3: 000000003f2b5000 CR4: 00000000000407f0
[  651.695850] Stack:
[  651.697053]  ffff88025f981000 ffff880087257d08 ffffffffa043193d ffff88025f981100
[  651.698301]  ffff88025f981e38 0000000a3ea50000 00ff880200000000 ffff8802546b62c0
[  651.699556]  ffffffff810d7fa0 ffff880087257cc8 ffff880087257cc8 00000000547e2838
[  651.700824] Call Trace:
[  651.702099]  [<ffffffffa043193d>] btrfs_dev_replace_finishing+0x32d/0x5c0 [btrfs]
[  651.703397]  [<ffffffff810d7fa0>] ? abort_exclusive_wait+0xb0/0xb0
[  651.704714]  [<ffffffffa0431f52>] btrfs_dev_replace_start+0x382/0x450 [btrfs]
[  651.706048]  [<ffffffffa03faa8a>] btrfs_ioctl+0x1caa/0x28f0 [btrfs]
[  651.707379]  [<ffffffff811b4be6>] ? handle_mm_fault+0x8d6/0xfd0
[  651.708711]  [<ffffffff8105be2c>] ? __do_page_fault+0x29c/0x580
[  651.710038]  [<ffffffff81203187>] ? cp_new_stat+0x157/0x190
[  651.711361]  [<ffffffff81212100>] do_vfs_ioctl+0x2d0/0x4b0
[  651.712683]  [<ffffffff81212361>] SyS_ioctl+0x81/0xa0
[  651.714007]  [<ffffffff817225e9>] system_call_fastpath+0x16/0x1b
[  651.715332] Code: 5f 5d c3 0f 1f 80 00 00 00 00 66 66 66 66 90 55 48 89 e5 53 48 8b bf f0 09 00 00 48 85 ff 74 20 31 db 48 85 f6 74 14 48 8b 46 78 <48> 8b 80 88 00 00 00 48 8b 70 38 e8 2f 03 ea e0 89 d8 5b 5d c3 
[  651.718262] RIP  [<ffffffffa03da551>] btrfs_kobj_rm_device+0x21/0x40 [btrfs]
[  651.719725]  RSP <ffff880087257c80>
[  651.721180] CR2: 0000000000000088
[  651.722708] ---[ end trace 70672604d3ea5888 ]---


Chris Murphy

