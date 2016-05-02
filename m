Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fallback1.mail.ru ([94.100.181.184]:34903 "EHLO
	fallback1.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755061AbcEBWEU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 May 2016 18:04:20 -0400
Received: from smtp22.mail.ru (smtp22.mail.ru [94.100.181.177])
	by fallback1.mail.ru (mPOP.Fallback_MX) with ESMTP id 24E90707171A
	for <linux-btrfs@vger.kernel.org>; Mon,  2 May 2016 23:51:21 +0300 (MSK)
Received: from 77-173-215-182.ip.telfort.nl ([77.173.215.182]:37082 helo=centurion)
	by smtp22.mail.ru with esmtpa (envelope-from <dma_k@mail.ru>)
	id 1axKoI-0007JQ-G4
	for linux-btrfs@vger.kernel.org; Mon, 02 May 2016 23:51:19 +0300
Received: from [192.168.1.85] (Furia.home [192.168.1.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by centurion (Postfix) with ESMTPSA id 4ADB199570
	for <linux-btrfs@vger.kernel.org>; Mon,  2 May 2016 22:51:16 +0200 (CEST)
Subject: Re: Kernel crash if both devices in raid1 are failing
To: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <570FFDFE.3050305@gmail.com> <571419C7.6070709@gmail.com>
 <20160421034524.GA26182@localhost.localdomain> <571DC34A.50509@gmail.com>
 <57202777.3010402@gmail.com>
From: Dmitry Katsubo <dma_k@mail.ru>
Message-ID: <5727BDC8.7060605@mail.ru>
Date: Mon, 2 May 2016 22:51:20 +0200
MIME-Version: 1.0
In-Reply-To: <57202777.3010402@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

If somebody is interested in digging into the problem, I would be happy to provide
more information and/or do the testing.

On 2016-04-27 04:44, Dmitry Katsubo wrote:
> # cat /mnt/tmp/file > /dev/null
> [   11.432059] ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
> [   11.436665] ata3.00: BMDMA stat 0x25
> [   11.441301] ata3.00: failed command: READ DMA
> [   11.479570] ata3.00: cmd c8/00:20:40:ec:f3/00:00:00:00:00/e3 tag 0 dma 16384 in
> [   11.479664]          res 51/40:1e:42:ec:f3/00:00:00:00:00/e3 Emask 0x9 (media error)
> [   11.619086] ata3.00: status: { DRDY ERR }
> [   11.619126] ata3.00: error: { UNC }
> [   11.625750] blk_update_request: I/O error, dev sda, sector 66317378
> [   11.625779] NOHZ: local_softirq_pending 40
> [   70.969876] ------------[ cut here ]------------
> [   70.969879] kernel BUG at /build/linux-SBJFwR/linux-4.4.6/debian/build/source_rt/fs/btrfs/volumes.c:5509!
> [   70.969885] invalid opcode: 0000 [#1] PREEMPT SMP 
> [   70.969954] Modules linked in: netconsole configfs bridge stp llc arc4 iTCO_wdt iTCO_vendor_support ppdev coretemp pcspkr serio_raw i2c_i801 ath5k ath mac80211 cfg80211 sr9700 evdev rfkill dm9601 usbnet lpc_ich mfd_core mii option usb_wwan usbserial rng_core sg snd_hda_codec_realtek snd_hda_codec_generic i915 snd_hda_intel snd_hda_codec snd_hda_core snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm acpi_cpufreq snd_timer video 8250_fintek snd drm_kms_helper soundcore tpm_tis drm tpm parport_pc i2c_algo_bit parport shpchp button processor binfmt_misc w83627hf hwmon_vid autofs4 xfs libcrc32c hid_generic usbhid hid crc32c_generic btrfs xor raid6_pq uas usb_storage sd_mod sr_mod cdrom ata_generic firewire_ohci ata_piix libata scsi_mod firewire_core crc_itu_t ehci_pci uhci_hcd ehci_hcd usbcore usb_common e1000e ptp pps_core
> [   70.969965] CPU: 0 PID: 114 Comm: kworker/u4:3 Tainted: G        W       4.4.0-1-rt-686-pae #1 Debian 4.4.6-1
> [   70.969968] Hardware name: AOpen i945GMx-IF/i945GMx-IF, BIOS i945GMx-IF R1.01 Mar.02.2007 AOpen Inc. 03/02/2007
> [   70.970029] Workqueue: btrfs-endio btrfs_endio_helper [btrfs]
> [   70.970032] task: f3eec0c0 ti: f6a76000 task.ti: f6a76000
> [   70.970036] EIP: 0060:[<f87506be>] EFLAGS: 00010217 CPU: 0
> [   70.970076] EIP is at __btrfs_map_block+0x11be/0x15a0 [btrfs]


-- 
With best regards,
Dmitry
