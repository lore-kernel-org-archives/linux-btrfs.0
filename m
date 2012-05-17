Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:53075 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756049Ab2EQK0z (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 May 2012 06:26:55 -0400
Message-ID: <4FB4D262.8020407@brockmann-consult.de>
Date: Thu, 17 May 2012 12:26:42 +0200
From: Peter Maloney <peter.maloney@brockmann-consult.de>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: How can I create useful bug reports? Here are 50 lines of messages
 including Call Trace from a system crash.
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I am using btrfs at home on my root system because I want to be able to
send useful bug reports when things go wrong.

And I have 3 questions:

What kernel should I be using?

And how do I create good bug reports? Is a "Call Trace" that I find in
/var/log/messages enough, or do I need to install some debug packages
and run some tools?

Can someone also tell me how to find device error counts? (like what
ZFS's zpool status shows under the "read" and "write" columns, not
scrub/checksums on data, but the device errors)



I am using version 3.4.0-rc7-1-default which I got using openSUSE KOTD.
Is that a good choice? It would be convenient to use these openSUSE
repositories.

Someone in the #btrfs IRC channel told me to use this:
git://git.kernel.org/pub/scm/linux/kernel/git/josef/btrfs-next.git

I managed to crash my system today with a USB stick that is defective.
(dd to the direct device hangs and causes it to change device names, eg.
from sdb to sdc.) I would like to properly report this so it can be
fixed. A bad disk should not take down the system.

All I did was create a btrfs fs, dd a file onto the disk which caused an
Input/Output error, and then try to run "btrfs scrub start" and "btrfs
filesystem show" to try to find an error count like you would find in a
"zpool status" using the ZFS file system.

Here are 50 lines from /var/log/messages, starting with what I assume is
the first error.

May 17 10:30:01 peterlaptop kernel: [ 3119.537086] lost page write due
to I/O error on sdb1
May 17 10:30:01 peterlaptop kernel: [ 3119.537100] lost page write due
to I/O error on sdb1
May 17 10:30:01 peterlaptop kernel: [ 3119.537105] BTRFS error (device
sdb1) in write_all_supers:2890: IO failure (1 errors while writing supers)
May 17 10:30:01 peterlaptop kernel: [ 3119.537108] btrfs: commit super
ret -5
May 17 10:30:01 peterlaptop kernel: [ 3119.542081] ------------[ cut
here ]------------
May 17 10:30:01 peterlaptop kernel: [ 3119.542135] WARNING: at
/home/abuild/rpmbuild/BUILD/kernel-default-3.4.rc7/linux-3.4-rc7/fs/btrfs/extent-tree.c:124
btrfs_put_block_group+0x5a/0x60 [btrfs]()
May 17 10:30:01 peterlaptop kernel: [ 3119.542139] Hardware name: HP
Compaq nx8220 (PY522ET#ABD)
May 17 10:30:01 peterlaptop kernel: [ 3119.542141] Modules linked in:
loop nls_iso8859_1 nls_cp437 reiserfs minix hfs vfat fat usb_storage uas
xt_tcpudp xt_pkttype xt_LOG xt_limit af_packet ip6t_REJECT
nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_raw xt_NOTRACK ipt_REJECT
iptable_raw iptable_filter ip6table_mangle nf_conntrack_netbios_ns
nf_conntrack_broadcast nf_conntrack_ipv4 nf_defrag_ipv4 ip_tables
xt_conntrack nf_conntrack ip6table_filter ip6_tables x_tables
cpufreq_conservative cpufreq_userspace cpufreq_powersave acpi_cpufreq
mperf fuse snd_intel8x0m snd_intel8x0 snd_ac97_codec sr_mod sg ppdev
firewire_ohci iTCO_wdt iTCO_vendor_support ac97_bus snd_pcm ipw2200
snd_timer firewire_core cdrom hp_wmi tifm_7xx1 tifm_core parport_pc
parport joydev pcmcia snd sparse_keymap libipw tg3 pcspkr irda wmi
sdhci_pci serio_raw yenta_socket pcmcia_rsrc pcmcia_core sdhci microcode
mmc_core video cfg80211 rfkill button ac soundcore crc_ccitt container
battery snd_page_alloc lib80211 crc_itu_t autofs4 btrfs zlib_deflate
usbhid hid a
May 17 10:30:01 peterlaptop kernel: ta_generic uhci_hcd ehci_hcd
ata_piix ahci libahci radeon ttm drm_kms_helper libata rtc_cmos fan
thermal drm i2c_algo_bit i2c_core processor thermal_sys hwmon usbcore
usb_common
May 17 10:30:01 peterlaptop kernel: [ 3119.542221] Pid: 7558, comm:
umount Tainted: G        W    3.4.0-rc7-1-default #1
May 17 10:30:01 peterlaptop kernel: [ 3119.542224] Call Trace:
May 17 10:30:01 peterlaptop kernel: [ 3119.542239]  [<c0205359>]
try_stack_unwind+0x199/0x1b0
May 17 10:30:01 peterlaptop kernel: [ 3119.542248]  [<c02041d7>]
dump_trace+0x47/0xf0
May 17 10:30:01 peterlaptop kernel: [ 3119.542253]  [<c02053bb>]
show_trace_log_lvl+0x4b/0x60
May 17 10:30:01 peterlaptop kernel: [ 3119.542258]  [<c02053e8>]
show_trace+0x18/0x20
May 17 10:30:01 peterlaptop kernel: [ 3119.542264]  [<c06952f1>]
dump_stack+0x6d/0x72
May 17 10:30:01 peterlaptop kernel: [ 3119.542271]  [<c0231058>]
warn_slowpath_common+0x78/0xb0
May 17 10:30:01 peterlaptop kernel: [ 3119.542276]  [<c02310ab>]
warn_slowpath_null+0x1b/0x20
May 17 10:30:01 peterlaptop kernel: [ 3119.542295]  [<f82ab0ba>]
btrfs_put_block_group+0x5a/0x60 [btrfs]
May 17 10:30:01 peterlaptop kernel: [ 3119.542350]  [<f82b4dbe>]
btrfs_free_block_groups+0x7e/0x2f0 [btrfs]
May 17 10:30:01 peterlaptop kernel: [ 3119.542412]  [<f82c02a4>]
close_ctree+0x184/0x390 [btrfs]
May 17 10:30:01 peterlaptop kernel: [ 3119.542475]  [<c03236aa>]
generic_shutdown_super+0x4a/0xc0
May 17 10:30:01 peterlaptop kernel: [ 3119.542481]  [<c0323799>]
kill_anon_super+0x9/0x20
May 17 10:30:01 peterlaptop kernel: [ 3119.542498]  [<f829d3ac>]
btrfs_kill_super+0xc/0x70 [btrfs]
May 17 10:30:01 peterlaptop kernel: [ 3119.542516]  [<c0323214>]
deactivate_locked_super+0x44/0x70
May 17 10:30:01 peterlaptop kernel: [ 3119.542522]  [<c033abd9>]
sys_umount+0x69/0x360
May 17 10:30:01 peterlaptop kernel: [ 3119.542526]  [<c033aee7>]
sys_oldumount+0x17/0x20
May 17 10:30:01 peterlaptop kernel: [ 3119.542532]  [<c069fd65>]
syscall_call+0x7/0xb
May 17 10:30:01 peterlaptop kernel: [ 3119.542540]  [<b7678bbd>] 0xb7678bbc
May 17 10:30:01 peterlaptop kernel: [ 3119.542542] ---[ end trace
9be3c75618b69fe7 ]---
May 17 10:30:01 peterlaptop kernel: [ 3119.542547] ------------[ cut
here ]------------
May 17 10:30:01 peterlaptop kernel: [ 3119.542564] WARNING: at
/home/abuild/rpmbuild/BUILD/kernel-default-3.4.rc7/linux-3.4-rc7/fs/btrfs/extent-tree.c:124
btrfs_put_block_group+0x5a/0x60 [btrfs]()
May 17 10:30:01 peterlaptop kernel: [ 3119.542567] Hardware name: HP
Compaq nx8220 (PY522ET#ABD)
May 17 10:30:01 peterlaptop kernel: [ 3119.542569] Modules linked in:
loop nls_iso8859_1 nls_cp437 reiserfs minix hfs vfat fat usb_storage uas
xt_tcpudp xt_pkttype xt_LOG xt_limit af_packet ip6t_REJECT
nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_raw xt_NOTRACK ipt_REJECT
iptable_raw iptable_filter ip6table_mangle nf_conntrack_netbios_ns
nf_conntrack_broadcast nf_conntrack_ipv4 nf_defrag_ipv4 ip_tables
xt_conntrack nf_conntrack ip6table_filter ip6_tables x_tables
cpufreq_conservative cpufreq_userspace cpufreq_powersave acpi_cpufreq
mperf fuse snd_intel8x0m snd_intel8x0 snd_ac97_codec sr_mod sg ppdev
firewire_ohci iTCO_wdt iTCO_vendor_support ac97_bus snd_pcm ipw2200
snd_timer firewire_core cdrom hp_wmi tifm_7xx1 tifm_core parport_pc
parport joydev pcmcia snd sparse_keymap libipw tg3 pcspkr irda wmi
sdhci_pci serio_raw yenta_socket pcmcia_rsrc pcmcia_core sdhci microcode
mmc_core video cfg80211 rfkill button ac soundcore crc_ccitt container
battery snd_page_alloc lib80211 crc_itu_t autofs4 btrfs zlib_deflate
usbhid hid a
May 17 10:30:01 peterlaptop kernel: ta_generic uhci_hcd ehci_hcd
ata_piix ahci libahci radeon ttm drm_kms_helper libata rtc_cmos fan
thermal drm i2c_algo_bit i2c_core processor thermal_sys hwmon usbcore
usb_common
May 17 10:30:01 peterlaptop kernel: [ 3119.542644] Pid: 7558, comm:
umount Tainted: G        W    3.4.0-rc7-1-default #1
May 17 10:30:01 peterlaptop kernel: [ 3119.542646] Call Trace:
May 17 10:30:01 peterlaptop kernel: [ 3119.542650]  [<c0205359>]
try_stack_unwind+0x199/0x1b0
May 17 10:30:01 peterlaptop kernel: [ 3119.542657]  [<c02041d7>]
dump_trace+0x47/0xf0
May 17 10:30:01 peterlaptop kernel: [ 3119.542661]  [<c02053bb>]
show_trace_log_lvl+0x4b/0x60
May 17 10:30:01 peterlaptop kernel: [ 3119.542666]  [<c02053e8>]
show_trace+0x18/0x20
May 17 10:30:01 peterlaptop kernel: [ 3119.542670]  [<c06952f1>]
dump_stack+0x6d/0x72
May 17 10:30:01 peterlaptop kernel: [ 3119.542675]  [<c0231058>]
warn_slowpath_common+0x78/0xb0
May 17 10:30:01 peterlaptop kernel: [ 3119.542679]  [<c02310ab>]
warn_slowpath_null+0x1b/0x20
May 17 10:30:01 peterlaptop kernel: [ 3119.542698]  [<f82ab0ba>]
btrfs_put_block_group+0x5a/0x60 [btrfs]
May 17 10:30:01 peterlaptop kernel: [ 3119.542748]  [<f82b4dbe>]
btrfs_free_block_groups+0x7e/0x2f0 [btrfs]
May 17 10:30:01 peterlaptop kernel: [ 3119.542809]  [<f82c02a4>]
close_ctree+0x184/0x390 [btrfs]
May 17 10:30:01 peterlaptop kernel: [ 3119.542871]  [<c03236aa>]
generic_shutdown_super+0x4a/0xc0
May 17 10:30:01 peterlaptop kernel: [ 3119.542876]  [<c0323799>]
kill_anon_super+0x9/0x20
May 17 10:30:01 peterlaptop kernel: [ 3119.542893]  [<f829d3ac>]
btrfs_kill_super+0xc/0x70 [btrfs]
May 17 10:30:01 peterlaptop kernel: [ 3119.542910]  [<c0323214>]
deactivate_locked_super+0x44/0x70


Thanks,
Peter
