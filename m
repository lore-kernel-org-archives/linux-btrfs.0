Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:34213 "EHLO
	mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759050AbcHDXFo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Aug 2016 19:05:44 -0400
Received: by mail-lf0-f65.google.com with SMTP id l69so16046813lfg.1
        for <linux-btrfs@vger.kernel.org>; Thu, 04 Aug 2016 16:05:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+xOVSMP_ZXCoyRWL5KaDvkdPJHYtLd9f9GgD-y55=cppENLhA@mail.gmail.com>
References: <CA+xOVSOx56oc5kF+oj18B3m23wcpy2OqbKbH9j13se+s98YvdQ@mail.gmail.com>
 <pan$5fb1f$7ade4380$d83d2847$ba15621a@cox.net> <CA+xOVSMP_ZXCoyRWL5KaDvkdPJHYtLd9f9GgD-y55=cppENLhA@mail.gmail.com>
From: Mordechay Kaganer <mkaganer@gmail.com>
Date: Fri, 5 Aug 2016 02:05:40 +0300
Message-ID: <CA+xOVSN7xEnX9pNynptE5zP9DpgZmEWHur2zNd+eU-kMKyeLWw@mail.gmail.com>
Subject: Re: BTRFS: Transaction aborted (error -28)
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

B.H.

> On Fri, Jul 29, 2016 at 8:23 PM, Duncan <1i5t5.duncan@cox.net> wrote:
>> So I'd recommend upgrading to the latest kernel 4.4 if you want to stay
>> with the stable series, or 4.6 or 4.7 if you want current, and then (less
>> important) upgrading the btrfs userspace as well.  It's possible the
>> newer kernel will handle the combined rsync and send stresses better, and
>> if not, you're on a better base to provide bug reports, etc.
>
> OK, upgraded to 4.4 (Ubuntu 16.04 stock kernel) and the fresh
> btrfs-progs 4.7. I'm assuming the error was due to some kind of bug or
> race condition and the FS is clean. Let's see how it behaves. Thanks!

Hello, i'm still getting ENOSPC errors. The latest time the log looks like this:

Aug  4 21:55:06 yemot-4u kernel: [304090.288927] ------------[ cut
here ]------------
Aug  4 21:55:06 yemot-4u kernel: [304090.288961] WARNING: CPU: 1 PID:
4531 at /build/linux-dcxD3m/linux-4.4.0/fs/btrfs/extent-tree.c:2927
btrfs_run_delayed_refs+0x26b/0
x2a0 [btrfs]()
Aug  4 21:55:06 yemot-4u kernel: [304090.288965] BTRFS: error (device
md1) in btrfs_run_delayed_refs:2927: errno=-28 No space left
Aug  4 21:55:06 yemot-4u kernel: [304090.288968] BTRFS info (device
md1): forced readonly
Aug  4 21:55:06 yemot-4u kernel: [304090.288972] BTRFS: error (device
md1) in btrfs_run_delayed_refs:2927: errno=-28 No space left
Aug  4 21:55:06 yemot-4u kernel: [304090.289129] BTRFS: Transaction
aborted (error -28)
Aug  4 21:55:06 yemot-4u kernel: [304090.289131] Modules linked in:
binfmt_misc ipmi_ssif btrfs x86_pkg_temp_thermal intel_powerclamp
coretemp kvm_intel kvm irqbypass c
rct10dif_pclmul crc32_pclmul aesni_intel aes_x86_64 lrw gf128mul
glue_helper ablk_helper cryptd input_leds sb_edac serio_raw joydev
edac_core lpc_ich snd_hda_codec_real
tek snd_hda_codec_generic snd_hda_intel snd_hda_codec snd_hda_core
snd_hwdep snd_pcm mei_me snd_timer mei snd soundcore shpchp ipmi_si
8250_fintek ipmi_msghandler mac_h
id nfsd auth_rpcgss nfs_acl lockd grace sunrpc lp parport autofs4
raid0 multipath linear raid456 async_raid6_recov async_memcpy async_pq
async_xor async_tx xor raid6_pq
 libcrc32c raid10 raid1 ses enclosure igb dca ast ttm drm_kms_helper
syscopyarea hid_generic sysfillrect firewire_ohci sysimgblt
fb_sys_fops ahci usbhid firewire_core p
tp psmouse libahci isci hid drm crc_itu_t libsas pps_core i2c_algo_bit
aacraid scsi_transport_sas wmi fjes
Aug  4 21:55:06 yemot-4u kernel: [304090.289201] CPU: 1 PID: 4531
Comm: kworker/u16:28 Not tainted 4.4.0-31-generic #50-Ubuntu
Aug  4 21:55:06 yemot-4u kernel: [304090.289203] Hardware name: To Be
Filled By O.E.M. To Be Filled By O.E.M./EPC602D8A, BIOS P1.20
04/16/2014
Aug  4 21:55:06 yemot-4u kernel: [304090.289226] Workqueue:
btrfs-extent-refs btrfs_extent_refs_helper [btrfs]
Aug  4 21:55:06 yemot-4u kernel: [304090.289229]  0000000000000286
00000000b56c494e ffff880744f4bc98 ffffffff813f1143
Aug  4 21:55:06 yemot-4u kernel: [304090.289232]  ffff880744f4bce0
ffffffffc06d8468 ffff880744f4bcd0 ffffffff81081102
Aug  4 21:55:06 yemot-4u kernel: [304090.289234]  ffff8807fbff3000
ffff880859b13000 ffff880729f30b90 0000000000000000
Aug  4 21:55:06 yemot-4u kernel: [304090.289237] Call Trace:
Aug  4 21:55:06 yemot-4u kernel: [304090.289244]  [<ffffffff813f1143>]
dump_stack+0x63/0x90
Aug  4 21:55:06 yemot-4u kernel: [304090.289249]  [<ffffffff81081102>]
warn_slowpath_common+0x82/0xc0
Aug  4 21:55:06 yemot-4u kernel: [304090.289252]  [<ffffffff8108119c>]
warn_slowpath_fmt+0x5c/0x80
Aug  4 21:55:06 yemot-4u kernel: [304090.289268]  [<ffffffffc063fbeb>]
btrfs_run_delayed_refs+0x26b/0x2a0 [btrfs]
Aug  4 21:55:06 yemot-4u kernel: [304090.289284]  [<ffffffffc063fc57>]
delayed_ref_async_start+0x37/0x90 [btrfs]
Aug  4 21:55:06 yemot-4u kernel: [304090.289303]  [<ffffffffc0686eaa>]
btrfs_scrubparity_helper+0xca/0x2f0 [btrfs]
Aug  4 21:55:06 yemot-4u kernel: [304090.289307]  [<ffffffff814f1906>]
? tty_ldisc_deref+0x16/0x20
Aug  4 21:55:06 yemot-4u kernel: [304090.289326]  [<ffffffffc068710e>]
btrfs_extent_refs_helper+0xe/0x10 [btrfs]
Aug  4 21:55:06 yemot-4u kernel: [304090.289330]  [<ffffffff8109a2c5>]
process_one_work+0x165/0x480
Aug  4 21:55:06 yemot-4u kernel: [304090.289333]  [<ffffffff8109a62b>]
worker_thread+0x4b/0x4c0
Aug  4 21:55:06 yemot-4u kernel: [304090.289336]  [<ffffffff8109a5e0>]
? process_one_work+0x480/0x480
Aug  4 21:55:06 yemot-4u kernel: [304090.289339]  [<ffffffff810a0808>]
kthread+0xd8/0xf0
Aug  4 21:55:06 yemot-4u kernel: [304090.289341]  [<ffffffff810a0730>]
? kthread_create_on_node+0x1e0/0x1e0
Aug  4 21:55:06 yemot-4u kernel: [304090.289345]  [<ffffffff8182decf>]
ret_from_fork+0x3f/0x70
Aug  4 21:55:06 yemot-4u kernel: [304090.289348]  [<ffffffff810a0730>]
? kthread_create_on_node+0x1e0/0x1e0
Aug  4 21:55:06 yemot-4u kernel: [304090.289350] ---[ end trace
90c37e7522254f86 ]---
Aug  4 21:55:06 yemot-4u kernel: [304090.289353] BTRFS: error (device
md1) in btrfs_run_delayed_refs:2927: errno=-28 No space left
Aug  4 21:55:06 yemot-4u kernel: [304090.328312] BTRFS: error (device
md1) in __btrfs_free_extent:6552: errno=-28 No space left
Aug  4 21:55:06 yemot-4u kernel: [304090.328344] BTRFS: error (device
md1) in btrfs_run_delayed_refs:2927: errno=-28 No space left

root@yemot-4u:~# uname -a
Linux yemot-4u 4.4.0-31-generic #50-Ubuntu SMP Wed Jul 13 00:07:12 UTC
2016 x86_64 x86_64 x86_64 GNU/Linux

root@yemot-4u:~# btrfs --version
btrfs-progs v4.7


-- 
משיח NOW!
Moshiach is coming very soon, prepare yourself!
יחי אדוננו מורינו ורבינו מלך המשיח לעולם ועד!
