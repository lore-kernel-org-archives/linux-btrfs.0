Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:57583 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750855AbbC1On0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 28 Mar 2015 10:43:26 -0400
Received: from [192.168.178.24] ([78.54.135.81]) by mail.gmx.com (mrgmx103)
 with ESMTPSA (Nemesis) id 0LZiQy-1ZKmYx3v7k-00lRtJ for
 <linux-btrfs@vger.kernel.org>; Sat, 28 Mar 2015 15:43:24 +0100
Message-ID: <5516BE0B.1020305@gmx.de>
Date: Sat, 28 Mar 2015 15:43:23 +0100
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: trintiy fuzzer forces the warning: fs/btrfs/delayed-inode.c:655 btrfs_delayed_update_inode+0x52f/0x6e0
 [btrfs]()
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I do run latest trinity at a 32 bit x86 KVM guest with guest kernel 4.0.ß0-rc5 (host is a 64 bit hardened Gentoo FWIW). Within KVM I prepared a victim file system via :

$ mkdir /mnt/ramdisk/btrfs; truncate -s 497M /mnt/ramdisk/btrfs.fs; /sbin/mkfs.btrfs /mnt/ramdisk/btrfs.fs; sudo su -c "mount -o loop,compress=lzo /mnt/ramdisk/btrfs.fs /mnt/ramdisk/btrfs; chmod 777 /mnt/ramdisk/btrfs" 

$ D=/mnt/ramdisk/btrfs; while [[ : ]]; do cd ~; sudo rm -rf $D/t3 && mkdir $D/t3 || break; cd $D/t3; mkdir -p v1/v2; for i in $(seq 0 99); do touch v1/v2/f$i; mkdir v1/v2/d$i; done; trinity -C 2 -N 100000 -V $D/t3/v1/v2 -q; echo; echo " done"; echo; sleep 4; done


and got after a while this :


Mar 28 15:37:37 n22kvm-clone kernel: ------------[ cut here ]------------                  
Mar 28 15:37:37 n22kvm-clone kernel: WARNING: CPU: 1 PID: 17 at fs/btrfs/delayed-inode.c:655 btrfs_delayed_update_inode+0x52f/0x6e0 [btrfs]()                                           
Mar 28 15:37:37 n22kvm-clone kernel: Modules linked in: af_alg btrfs xor raid6_pq auth_rpcgss oid_registry nfsv4 nfs lockd grace sunrpc nf_log_ipv4 nf_log_common xt_LOG xt_limit ipt_REJECT nf_reject_ipv4 nf_conntrack_ipv4 nf_defrag_ipv4 xt_recent xt_conntrack nf_conntrack iptable_filter ip_tables af_packet dm_crypt dm_mod mousedev uhci_hcd aesni_intel aes_i586 ablk_helper cryptd ehci_pci microcode ehci_hcd evdev usbcore psmouse virtio_console atkbd usb_common acpi_cpufreq processor button                                                                                                                                                                                            
Mar 28 15:37:37 n22kvm-clone kernel: CPU: 1 PID: 17 Comm: kworker/u4:1 Not tainted 4.0.0-rc5 #5                                                                                                                                              
Mar 28 15:37:37 n22kvm-clone kernel: Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.7.5.1-0-g8936dbb-20141113_115728-nilsson.home.kraxel.org 04/01/2014                                                                   
Mar 28 15:37:37 n22kvm-clone kernel: Workqueue: btrfs-endio-write btrfs_endio_write_helper [btrfs]                                                                                                                                           
Mar 28 15:37:37 n22kvm-clone kernel:  00000000 00000000 f596dd48 d2a65005 00000000 f596dd78 d264b5e7 d2bb7410                                                                                                                                
Mar 28 15:37:37 n22kvm-clone kernel:  00000001 00000011 f8aa6e81 0000028f f8a7498f f8a7498f c0c30a48 f5bbc258                                                                                                                                
Mar 28 15:37:37 n22kvm-clone kernel:  e5690000 f596dd88 d264b6c2 00000009 00000000 f596dde0 f8a7498f 00010000
Mar 28 15:37:37 n22kvm-clone kernel: Call Trace:
Mar 28 15:37:37 n22kvm-clone kernel:  [<d2a65005>] dump_stack+0x41/0x52
Mar 28 15:37:37 n22kvm-clone kernel:  [<d264b5e7>] warn_slowpath_common+0x87/0xc0
Mar 28 15:37:37 n22kvm-clone kernel:  [<f8a7498f>] ? btrfs_delayed_update_inode+0x52f/0x6e0 [btrfs]
Mar 28 15:37:37 n22kvm-clone kernel:  [<f8a7498f>] ? btrfs_delayed_update_inode+0x52f/0x6e0 [btrfs]
Mar 28 15:37:37 n22kvm-clone kernel:  [<d264b6c2>] warn_slowpath_null+0x22/0x30
Mar 28 15:37:37 n22kvm-clone kernel:  [<f8a7498f>] btrfs_delayed_update_inode+0x52f/0x6e0 [btrfs]
Mar 28 15:37:37 n22kvm-clone kernel:  [<f8a067ed>] ? btrfs_update_root_times+0x5d/0x70 [btrfs]
Mar 28 15:37:37 n22kvm-clone kernel:  [<f8a067ed>] ? btrfs_update_root_times+0x5d/0x70 [btrfs]
Mar 28 15:37:37 n22kvm-clone kernel:  [<f8a1b3a4>] btrfs_update_inode+0x94/0x110 [btrfs]
Mar 28 15:37:37 n22kvm-clone kernel:  [<f8a1eb76>] btrfs_update_inode_fallback+0x16/0x30 [btrfs]
Mar 28 15:37:37 n22kvm-clone kernel:  [<f8a1ef23>] btrfs_finish_ordered_io+0x393/0x730 [btrfs]
Mar 28 15:37:37 n22kvm-clone kernel:  [<f8a1f2d2>] finish_ordered_fn+0x12/0x20 [btrfs]
Mar 28 15:37:37 n22kvm-clone kernel:  [<f8a4ba75>] normal_work_helper+0xc5/0x240 [btrfs]
Mar 28 15:37:37 n22kvm-clone kernel:  [<d2660549>] ? process_one_work+0x119/0x450
Mar 28 15:37:37 n22kvm-clone kernel:  [<f8a4bd80>] btrfs_endio_write_helper+0x10/0x20 [btrfs]
Mar 28 15:37:37 n22kvm-clone kernel:  [<d26605c3>] process_one_work+0x193/0x450
Mar 28 15:37:37 n22kvm-clone kernel:  [<d2660549>] ? process_one_work+0x119/0x450
Mar 28 15:37:37 n22kvm-clone kernel:  [<d2660975>] worker_thread+0xf5/0x410
Mar 28 15:37:37 n22kvm-clone kernel:  [<d2660880>] ? process_one_work+0x450/0x450
Mar 28 15:37:37 n22kvm-clone kernel:  [<d26655c6>] kthread+0xa6/0xc0
Mar 28 15:37:37 n22kvm-clone kernel:  [<d2660000>] ? numa_pwq_tbl_install+0x20/0x60
Mar 28 15:37:37 n22kvm-clone kernel:  [<d2a6d541>] ret_from_kernel_thread+0x21/0x30
Mar 28 15:37:37 n22kvm-clone kernel:  [<d2665520>] ? kthread_create_on_node+0x180/0x180
Mar 28 15:37:37 n22kvm-clone kernel: ---[ end trace cde5b250b95d8826 ]---


-- 
Toralf
pgp key: 7B1A 07F4 EC82 0F90 D4C2  8936 872A E508 0076 E94E
--
; the past is all dirty and cruel in the modern popular imagination, with the exception of the Romans, who are just cruel
--
Ian Mortimer "The Time Traveller's Guide to Medieval England"
