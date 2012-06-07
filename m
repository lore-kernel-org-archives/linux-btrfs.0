Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:40636 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112Ab2FGT7G (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Jun 2012 15:59:06 -0400
Received: by eaak11 with SMTP id k11so444146eaa.19
        for <linux-btrfs@vger.kernel.org>; Thu, 07 Jun 2012 12:59:05 -0700 (PDT)
MIME-Version: 1.0
From: Catalin Iacob <iacobcatalin@gmail.com>
Date: Thu, 7 Jun 2012 21:58:44 +0200
Message-ID: <CAHg_5gpyMpa2HcRc+tSrbbEyWCcyrFOHfzK5w0N-TXABgCenYA@mail.gmail.com>
Subject: New WARNING at fs/btrfs/extent_map.c:226 unpin_extent_cache with
 kernel 3.5-rc1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I just booted into a current git kernel and got 6 of these in about
1h30min of usage

[  559.556879] ------------[ cut here ]------------
[  559.556913] WARNING: at fs/btrfs/extent_map.c:226
unpin_extent_cache+0x5f/0xb0 [btrfs]()
[  559.556915] Hardware name: K53E
[  559.556956] Modules linked in: fuse xt_limit af_packet ip6t_REJECT
nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_raw xt_NOTRACK ipt_REJECT
iptable_raw iptable_filter ip6table_mangle nf_conntrack_netbios_ns
nf_conntrack_broadcast nf_conntrack_ipv4 nf_defrag_ipv4 ip_tables
xt_conntrack nf_conntrack ip6table_filter ip6_tables x_tables
cpufreq_conservative cpufreq_userspace cpufreq_powersave acpi_cpufreq
mperf arc4 rtl8192ce rtl8192c_common rtlwifi mac80211
snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec
snd_hwdep snd_pcm snd_timer cfg80211 asus_nb_wmi asus_wmi snd sr_mod
soundcore cdrom uvcvideo snd_page_alloc sparse_keymap pci_hotplug
videobuf2_core sg rfkill serio_raw videodev videobuf2_vmalloc
videobuf2_memops coretemp atl1c joydev pcspkr battery lpc_ich
microcode wmi ac mei i2c_i801 xhci_hcd autofs4 btrfs zlib_deflate i915
drm_kms_helper drm i2c_algo_bit thermal video processor button
thermal_sys
[  559.556961] Pid: 2589, comm: btrfs-endio-wri Not tainted
3.5.0-rc1-catalin-00110-g71fae7e #20
[  559.556962] Call Trace:
[  559.556971]  [<ffffffff8103e11f>] warn_slowpath_common+0x7f/0xc0
[  559.556974]  [<ffffffff8103e17a>] warn_slowpath_null+0x1a/0x20
[  559.556991]  [<ffffffffa016970f>] unpin_extent_cache+0x5f/0xb0 [btrfs]
[  559.557006]  [<ffffffffa015eb82>] btrfs_finish_ordered_io+0x362/0x3c0 [btrfs]
[  559.557022]  [<ffffffffa015ebf5>] finish_ordered_fn+0x15/0x20 [btrfs]
[  559.557038]  [<ffffffffa0189200>] worker_loop+0xa0/0x300 [btrfs]
[  559.557053]  [<ffffffffa0189160>] ?
check_pending_worker_creates.isra.1+0xe0/0xe0 [btrfs]
[  559.557058]  [<ffffffff81061433>] kthread+0x93/0xa0
[  559.557063]  [<ffffffff815b08e4>] kernel_thread_helper+0x4/0x10
[  559.557066]  [<ffffffff810613a0>] ? kthread_freezable_should_stop+0x70/0x70
[  559.557069]  [<ffffffff815b08e0>] ? gs_change+0x13/0x13
[  559.557071] ---[ end trace ced3cc4ce35eb913 ]---

I didn't see these in 3.4 or previous kernels. However, despite of
these, it seems to me that the latency of the desktop has improved,
with previous kernels it was quite bad during IO. With 3.5 I got
*some* seconds when other windows barely worked during a big git pull
but I'm quite sure this kernel is smoother than older ones so thanks
for your work!
