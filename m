Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:32028 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917Ab2LTFna (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Dec 2012 00:43:30 -0500
Date: Wed, 19 Dec 2012 22:43:28 -0700 (MST)
From: Steve Leung <sjleung@shaw.ca>
To: linux-btrfs@vger.kernel.org
Subject: btrfs warning in 3.7.0 with nfsd
Message-ID: <alpine.DEB.2.02.1212192204390.6456@cubia>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


I'm getting some kernel warnings from a btrfs raid1 filesystem that's 
serving up nfs4 to a couple of other computers on a small home network. 
I ran 3.6.x for several weeks before upgrading and didn't see any warnings 
like this.

[ 1712.223791] WARNING: at fs/btrfs/tree-log.c:3716 btrfs_log_inode_parent+0x291/0x2fd [btrfs]()
[ 1712.223793] Hardware name: System Product Name
[ 1712.223794] Modules linked in: lirc_dev xt_tcpudp iptable_filter ip_tables x_tables nfsd auth_rpcgss nfs_acl nfs lockd fscache sunrpc loop firewire_sbp2 snd_hda_codec_analog iTCO_wdt iTCO_vendor_support snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_page_alloc snd_seq coretemp kvm_intel acpi_cpufreq mperf snd_timer lpc_ich evdev asus_atk0110 kvm processor button psmouse serio_raw snd_seq_device mfd_core parport_pc pcspkr thermal_sys i2c_i801 snd microcode soundcore parport i2c_core btrfs crc32c libcrc32c zlib_deflate sg sd_mod crc_t10dif ata_generic uhci_hcd pata_jmicron ahci libahci firewire_ohci firewire_core crc_itu_t ata_piix libata r8169 mii scsi_mod ehci_hcd usbcore usb_common
[ 1712.223840] Pid: 2314, comm: nfsd Not tainted 3.7.0 #1
[ 1712.223842] Call Trace:
[ 1712.223849]  [<ffffffff8103cd4c>] ? warn_slowpath_common+0x76/0x8a
[ 1712.223864]  [<ffffffffa01bd099>] ? btrfs_log_inode_parent+0x291/0x2fd [btrfs]
[ 1712.223879]  [<ffffffffa01bd13a>] ? btrfs_log_dentry_safe+0x35/0x4e [btrfs]
[ 1712.223894]  [<ffffffffa019e298>] ? btrfs_sync_file+0x151/0x1e6 [btrfs]
[ 1712.223908]  [<ffffffffa019f59f>] ? btrfs_file_aio_write+0x374/0x3c5 [btrfs]
[ 1712.223913]  [<ffffffff812e9dbe>] ? tcp_release_cb+0x46/0x94
[ 1712.223917]  [<ffffffff8129f2b2>] ? release_sock+0xe9/0x11f
[ 1712.223922]  [<ffffffff812dee9c>] ? tcp_sendmsg+0x6ef/0x801
[ 1712.223936]  [<ffffffffa019f22b>] ? __btrfs_buffered_write+0x2e8/0x2e8 [btrfs]
[ 1712.223940]  [<ffffffff81102b8a>] ? do_sync_readv_writev+0x57/0x94
[ 1712.223943]  [<ffffffff81102dd3>] ? do_readv_writev+0x94/0x108
[ 1712.223947]  [<ffffffff8115b945>] ? exportfs_decode_fh+0xcc/0x257
[ 1712.223958]  [<ffffffffa034ba0b>] ? seconds_since_boot+0x11/0x1a [sunrpc]
[ 1712.223966]  [<ffffffffa034c94a>] ? cache_check+0x2c/0x24c [sunrpc]
[ 1712.223975]  [<ffffffffa03ad246>] ? nfsd_vfs_write.isra.8+0xc3/0x20e [nfsd]
[ 1712.223978]  [<ffffffff810fa789>] ? kmem_cache_alloc+0x8e/0xfd
[ 1712.223987]  [<ffffffffa03bd2bd>] ? renew_client_locked+0x76/0x7f [nfsd]
[ 1712.223995]  [<ffffffffa03bd2de>] ? renew_client+0x18/0x25 [nfsd]
[ 1712.224003]  [<ffffffffa03bd332>] ? find_confirmed_client+0x47/0x5c [nfsd]
[ 1712.224024]  [<ffffffffa03ae9ed>] ? nfsd_write+0x7f/0xf0 [nfsd]
[ 1712.224033]  [<ffffffff81060f4b>] ? should_resched+0x5/0x23
[ 1712.224040]  [<ffffffffa03b68fb>] ? nfsd4_write+0xcb/0xf3 [nfsd]
[ 1712.224049]  [<ffffffffa03b64b8>] ? nfsd4_proc_compound+0x224/0x3b2 [nfsd]
[ 1712.224057]  [<ffffffffa03aa7b2>] ? nfsd_dispatch+0x93/0x145 [nfsd]
[ 1712.224069]  [<ffffffffa034539f>] ? svc_process_common+0x289/0x439 [sunrpc]
[ 1712.224075]  [<ffffffffa03aa076>] ? nfsd_destroy.constprop.2+0x3c/0x3c [nfsd]
[ 1712.224086]  [<ffffffffa0345f26>] ? svc_process+0x111/0x12d [sunrpc]
[ 1712.224095]  [<ffffffffa03aa120>] ? nfsd+0xaa/0xfe [nfsd]
[ 1712.224100]  [<ffffffff81056d60>] ? kthread+0x81/0x89
[ 1712.224105]  [<ffffffff81056cdf>] ? __kthread_parkme+0x5c/0x5c
[ 1712.224109]  [<ffffffff813734fc>] ? ret_from_fork+0x7c/0xb0
[ 1712.224114]  [<ffffffff81056cdf>] ? __kthread_parkme+0x5c/0x5c
[ 1712.224116] ---[ end trace 58e10839083ba9da ]---

This is the first warning; subsequent ones look broadly similar to my 
eyes.

btrfs fi show:

Label: none  uuid: 9d4db9e3-b9c3-4f6d-8cb4-60ff55e96d82
         Total devices 3 FS bytes used 1.02TB
         devid    3 size 1.36TB used 1.22TB path /dev/sdb1
         devid    1 size 1.36TB used 1.18TB path /dev/sdc1
         devid    2 size 464.73GB used 318.03GB path /dev/sda1

This is a vanilla amd64 3.7.0 built using Debian's make-kpkg.  Userspace 
is a recent Debian testing.

I'm not sure exactly what triggers this but it seems to happen regularly 
with NFS activity.  I haven't observed any failures or bad performance 
from this.

I know 3.7 introduced some NFS changes too so I hope I'm directing this 
report correctly.

Should I be concerned about my data?  Can I provide any other information? 
I can try btrfs-next too if it'll help.

Thanks!

Steve
