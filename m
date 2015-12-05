Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from static.68.134.40.188.clients.your-server.de ([188.40.134.68]:43393
	"EHLO mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753103AbbLEJ6q (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 5 Dec 2015 04:58:46 -0500
Subject: Re: btrfs balance: Kernel BUG
To: Wolfgang Rohdewald <wolfgang.kde@rohdewald.de>,
        linux-btrfs@vger.kernel.org
References: <1795110.jZOk3ROKzF@i5>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?=
	<holger.hoffstaette@googlemail.com>
Message-ID: <5662B554.3010604@googlemail.com>
Date: Sat, 5 Dec 2015 10:58:44 +0100
MIME-Version: 1.0
In-Reply-To: <1795110.jZOk3ROKzF@i5>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/05/15 10:09, Wolfgang Rohdewald wrote:
> Unmodified Linux 4.3 tainted with nvidia
> 
> after adding disk #4 to RAID1, I did
> 
> btrfs filesystem balance /t4
> 
> Dec  5 08:07:26 s5 kernel: [55868.756847] BTRFS info (device sdc): relocating block group 10768619667456 flags 17
> Dec  5 08:07:35 s5 kernel: [55878.297200] BTRFS info (device sdc): found 10 extents
> Dec  5 08:07:40 s5 kernel: [55882.713437] BTRFS info (device sdc): found 10 extents
> Dec  5 08:07:40 s5 kernel: [55883.219850] BTRFS info (device sdc): relocating block group 10767545925632 flags 17
> Dec  5 08:07:57 s5 kernel: [55899.736052] BTRFS info (device sdc): found 11 extents
> Dec  5 08:07:58 s5 kernel: [55901.082464] ------------[ cut here ]------------
> Dec  5 08:07:58 s5 kernel: [55901.082468] Kernel BUG at ffffffffa012ef06 [verbose debug info unavailable]
> Dec  5 08:07:58 s5 kernel: [55901.082470] invalid opcode: 0000 [#1] PREEMPT SMP 
> Dec  5 08:07:58 s5 kernel: [55901.082472] Modules linked in: snd_hda_codec_hdmi(E) joydev(E) rc_tt_1500(E) stb6100(E) lnbp22(E) x86_pkg_temp_thermal(E) intel_powercl
> amp(E) coretemp(E) nvidia(POE) stb0899(E) kvm_intel(E) kvm(E) dvb_usb_pctv452e(E) snd_hda_codec_realtek(E) ttpci_eeprom(E) snd_hda_codec_generic(E) crct10dif_pclmul(
> E) dvb_usb(E) crc32_pclmul(E) dvb_core(E) rc_core(E) ftdi_sio(E) snd_hda_intel(E) hid_logitech_hidpp(E) usbserial(E) snd_hda_codec(E) snd_hda_core(E) aesni_intel(E) 
> snd_hwdep(E) aes_x86_64(E) lrw(E) gf128mul(E) glue_helper(E) snd_pcm(E) ablk_helper(E) cryptd(E) bnep(E) rfcomm(E) snd_seq_midi(E) snd_seq_midi_event(E) bluetooth(E)
>  snd_rawmidi(E) microcode(E) snd_seq(E) snd_seq_device(E) snd_timer(E) serio_raw(E) snd(E) soundcore(E) lpc_ich(E) tpm_tis(E) mei_me(E) mei(E) shpchp(E) nfsd(E) auth
> _rpcgss(E) nfs_acl(E) nfs(E) lockd(E) grace(E) sunrpc(E) fscache(E) btrfs(E) xor(E) raid6_pq(E) hid_logitech_dj(E) hid_generic(E) usbhid(E) hid(E) sd_mod(E) psmouse(
> E) ahci(E) libahci(E) e1000e(E) ptp(E) pps_core(E) video(E)
> Dec  5 08:07:58 s5 kernel: [55901.082502] CPU: 2 PID: 8553 Comm: btrfs Tainted: P           OE   4.3.0+55 #1
> Dec  5 08:07:58 s5 kernel: [55901.082503] Hardware name:                  /DH87RL, BIOS RLH8710H.86A.0323.2013.1204.1726 12/04/2013
> Dec  5 08:07:58 s5 kernel: [55901.082504] task: ffff8800d5e08000 ti: ffff8800305e8000 task.ti: ffff8800305e8000
> Dec  5 08:07:58 s5 kernel: [55901.082505] RIP: 0010:[<ffffffffa012ef06>]  [<ffffffffa012ef06>] insert_inline_extent_backref+0xc6/0xd0 [btrfs]

[..]

Please see: http://www.spinics.net/lists/linux-btrfs/msg49766.html

You should be able to apply those patches manually (assuming you can/want to rebuild).

-h

