Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:32870 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759089AbdENRzO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 14 May 2017 13:55:14 -0400
Received: from svh-gw.merlins.org ([173.11.111.145]:49164 helo=legolas.merlins.org)
        by mail1.merlins.org with esmtps
        (Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128) (Exim 4.87 #1)
        id 1d9xjZ-0007Ja-Ud
        for <linux-btrfs@vger.kernel.org>; Sun, 14 May 2017 10:55:13 -0700
Received: from merlin by legolas.merlins.org with local (Exim 4.80)
        (envelope-from <marc@merlins.org>)
        id 1d9xjZ-0006im-42
        for linux-btrfs@vger.kernel.org; Sun, 14 May 2017 10:55:09 -0700
Date: Sun, 14 May 2017 10:55:09 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Message-ID: <20170514175509.lsx5wl55o3juqygj@merlins.org>
References: <20170514152522.u5kejltr3nz4ogmz@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170514152522.u5kejltr3nz4ogmz@merlins.org>
Subject: Re: 4.11: da_remove called for id=16 which is not allocated.
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

My apologies, this was for the bcache list, sorry about this.

On Sun, May 14, 2017 at 08:25:22AM -0700, Marc MERLIN wrote:
> 
> gargamel:/sys/block/bcache16/bcache# echo 1 > stop
> 
> bcache: bcache_device_free() bcache16 stopped
> ------------[ cut here ]------------
> WARNING: CPU: 7 PID: 11051 at lib/idr.c:383 ida_remove+0xe8/0x10b
> ida_remove called for id=16 which is not allocated.
> Modules linked in: uas usb_storage veth ip6table_filter ip6_tables ebtable_nat ebtables ppdev lp xt_addrtype br_netfilter bridge stp llc tun autofs4 softdog binfmt_misc ftdi_sio nfsd auth_rpcgss nfs_acl nfs lockd grace fscache sunrpc ipt_REJECT nf_reject_ipv4 xt_conntrack xt_mark xt_nat xt_tcpudp nf_log_ipv4 nf_log_common xt_LOG iptable_mangle iptable_filter lm85 hwmon_vid pl2303 dm_snapshot dm_bufio iptable_nat ip_tables nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_conntrack_ftp ipt_MASQUERADE nf_nat_masquerade_ipv4 nf_nat nf_conntrack x_tables sg st snd_pcm_oss snd_mixer_oss bcache kvm_intel kvm irqbypass snd_hda_codec_realtek snd_hda_codec_generic snd_cmipci snd_hda_intel snd_mpu401_uart snd_opl3_lib snd_hda_codec snd_rawmidi snd_hda_core rc_ati_x10 snd_hwdep snd_seq_device ati_remote
>  snd_pcm eeepc_wmi asix snd_timer usbserial asus_wmi usbnet rc_core snd sparse_keymap libphy rfkill hwmon lpc_ich soundcore mei_me parport_pc wmi tpm_infineon parport tpm_tis i2c_i801 battery input_leds tpm_tis_core i915 tpm pcspkr evdev e1000e ptp pps_core fuse raid456 multipath mmc_block mmc_core lrw ablk_helper dm_crypt dm_mod async_raid6_recov async_pq async_xor async_memcpy async_tx crc32c_intel blowfish_x86_64 blowfish_common pcbc aesni_intel aes_x86_64 crypto_simd glue_helper cryptd xhci_pci ehci_pci xhci_hcd ehci_hcd r8169 sata_sil24 mii usbcore thermal mvsas fan libsas scsi_transport_sas [last unloaded: ftdi_sio]
> CPU: 7 PID: 11051 Comm: kworker/7:13 Tainted: G     U  W       4.11.0-amd64-preempt-sysrq-20170406 #2
> Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 3904 04/27/2013
> Workqueue: events cached_dev_free [bcache]
> Call Trace:
>  dump_stack+0x61/0x7d
>  __warn+0xc2/0xdd
>  warn_slowpath_fmt+0x5a/0x76
>  ida_remove+0xe8/0x10b
>  ida_simple_remove+0x2e/0x43
>  bcache_device_free+0x8c/0xc4 [bcache]
>  cached_dev_free+0x6b/0xe1 [bcache]
>  process_one_work+0x193/0x2b0
>  worker_thread+0x1e9/0x2c1
>  ? rescuer_thread+0x2b1/0x2b1
>  kthread+0xfb/0x100
>  ? init_completion+0x24/0x24
>  ret_from_fork+0x2c/0x40
> ---[ end trace 12586d8b165ff8f2 ]---
> 
> Prior to that: 
> cd /sys/fs/bcache/5bc072a8-ab17-446d-9744-e247949913c1
> echo 1 > stop
> 
> I needed to complete stop and remove all traces of a bcache before I could 
> mdadm --stop the underlying array.
> 
> Marc
> -- 
> "A mouse is a device used to point at the xterm you want to type in" - A.S.R.
> Microsoft is to operating systems ....
>                                       .... what McDonalds is to gourmet cooking
> Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901

-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
