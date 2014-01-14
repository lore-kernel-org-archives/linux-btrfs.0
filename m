Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f41.google.com ([209.85.160.41]:47227 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810AbaANTra (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jan 2014 14:47:30 -0500
Received: by mail-pb0-f41.google.com with SMTP id jt11so75286pbb.28
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Jan 2014 11:47:30 -0800 (PST)
Received: from mitchelh-linux.qualcomm.com (i-global252.qualcomm.com. [199.106.103.252])
        by mx.google.com with ESMTPSA id gv10sm3050435pbd.0.2014.01.14.11.47.28
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 14 Jan 2014 11:47:29 -0800 (PST)
From: Mitchel Humpherys <mitch.special@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: Hitting error after failed balance
Date: Tue, 14 Jan 2014 11:47:18 -0800
Message-ID: <vnkwfvoq73cp.fsf@mitchelh-linux.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I have a btrfs volume with two disks in it. Inspired by the recent LWN
series on btrfs, I set it up last week and things seemed to be going
quite well. However, I tried to balance the disks the other day since
they were quite out-of-balance, but the balance job failed to complete,
error'ing out with -ENOSPC (even though there was still space left on
both disks). Things seemed okay for a day or so after that, but now I've
been hitting the following WARN()'ing, pretty much constantly:

    [346628.037252] ------------[ cut here ]------------
    [346628.037258] WARNING: CPU: 2 PID: 404 at fs/btrfs/super.c:255 __btrfs_abort_transaction+0x11d/0x130 [btrfs]()
    [346628.037260] btrfs: Transaction aborted (error -5)
    [346628.037261] Modules linked in: arc4 ecb md4 md5 hmac nls_utf8 cifs fuse nfsv3 rpcsec_gss_krb5 nfsv4 nfsd auth_rpcgss oid_registry nfs_acl snd_hda_codec_hdmi qmi_wwan cdc_wdm usbnet mii cdc_acm snd_hda_codec_realtek ftdi_sio usbserial snd_hda_intel snd_hda_codec x86_pkg_temp_thermal intel_powerclamp coretemp nouveau kvm_intel kvm mxm_wmi video ttm drm_kms_helper drm snd_hwdep snd_pcm snd_page_alloc snd_timer snd psmouse crct10dif_pclmul crct10dif_common crc32_pclmul ghash_clmulni_intel aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper iTCO_wdt hp_wmi i2c_algo_bit soundcore sparse_keymap e1000e serio_raw cryptd iTCO_vendor_support rfkill gpio_ich ptp evdev pps_core wmi e1000 shpchp i2c_i801 i2c_core microcode processor mei_me mei lpc_ich button pcspkr vboxdrv(O) nfs lockd sunrpc fscache ext4
    [346628.037296]  crc16 mbcache jbd2 usb_storage btrfs libcrc32c hid_generic usbhid hid xor raid6_pq sr_mod cdrom sd_mod ata_generic crc32c_intel ahci libahci pata_acpi ehci_pci ehci_hcd libata usbcore usb_common scsi_mod
    [346628.037307] CPU: 2 PID: 404 Comm: btrfs-transacti Tainted: G        W  O 3.12.6-1-ARCH #1
    [346628.037309] Hardware name: Hewlett-Packard HP Z210 Workstation/1587h, BIOS J51 v01.35 01/10/2012
    [346628.037309]  0000000000000009 ffff8800caed3ca8 ffffffff814ee4fb ffff8800caed3cf0
    [346628.037312]  ffff8800caed3ce0 ffffffff81062bcd 00000000fffffffb ffff880416b13000
    [346628.037314]  ffff8803d82ce500 ffffffffa02dc280 0000000000000a9b ffff8800caed3d40
    [346628.037317] Call Trace:
    [346628.037320]  [<ffffffff814ee4fb>] dump_stack+0x54/0x8d
    [346628.037323]  [<ffffffff81062bcd>] warn_slowpath_common+0x7d/0xa0
    [346628.037326]  [<ffffffff81062c3c>] warn_slowpath_fmt+0x4c/0x50
    [346628.037334]  [<ffffffffa023fbdd>] __btrfs_abort_transaction+0x11d/0x130 [btrfs]
    [346628.037342]  [<ffffffffa025a263>] btrfs_run_delayed_refs+0x443/0x550 [btrfs]
    [346628.037351]  [<ffffffffa026a1ae>] btrfs_commit_transaction+0x4e/0x9d0 [btrfs]
    [346628.037359]  [<ffffffffa02619ad>] transaction_kthread+0x19d/0x220 [btrfs]
    [346628.037367]  [<ffffffffa0261810>] ? free_fs_root+0xc0/0xc0 [btrfs]
    [346628.037370]  [<ffffffff81084fe0>] kthread+0xc0/0xd0
    [346628.037373]  [<ffffffff81084f20>] ? kthread_create_on_node+0x120/0x120
    [346628.037375]  [<ffffffff814fcffc>] ret_from_fork+0x7c/0xb0
    [346628.037378]  [<ffffffff81084f20>] ? kthread_create_on_node+0x120/0x120
    [346628.037379] ---[ end trace fe83d0a80efc9fc0 ]---


Larger kernel log (including the part where the balance job failed)
here: https://gist.github.com/mgalgs/8423964

Rebooting didn't clear things up. I also tried mounting with
skip_balance, but still get the same error. I'm not sure if the balance
is actually related, but something is very unhappy here.

Any ideas what's going on here? Is this salvageable?


Other possibly relevant information:

    $ sudo btrfs filesystem show /local
    Label: none  uuid: 03a83a42-0bc7-42a2-bed6-df19c825897c
            Total devices 2 FS bytes used 380.83GiB
            devid    1 size 410.18GiB used 164.03GiB path /dev/sda6
            devid    2 size 465.76GiB used 220.00GiB path /dev/sdc
    
    Btrfs v3.12

    $ uname -a
    Linux mitchelh-linux 3.12.6-1-ARCH #1 SMP PREEMPT Fri Dec 20 19:39:00 CET 2013 x86_64 GNU/Linux

/dev/sda6 started out as an ext4 partition that I converted with
btrfs-convert. /dev/sdc was fresh. I've been using /dev/sda for over 1.5
years without issues, /dev/sdc is new so it could be a wildcard.


Let me know if you need any more information.

Please Cc me on replies since I'm not subscribed to this list.

Cool filesystem, by the way :). I can't say I've been excited about a
filesystem since playing around with ZFS on FreeBSD, but btrfs is pretty
awesome. The user interface is great.

Thanks!



-- 
Mitch
