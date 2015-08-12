Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f52.google.com ([209.85.213.52]:36262 "EHLO
	mail-vk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771AbbHLSK3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Aug 2015 14:10:29 -0400
Received: by vkbf67 with SMTP id f67so8977540vkb.3
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Aug 2015 11:10:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAK7bmU9SL7Fxqe+hAbe229Y7Fzegs2Dx42tLXyZ5Wttk+UeZDQ@mail.gmail.com>
References: <CAK7bmU97q-oz8aSTQijHJR1MQRgOs+F9nHx2hMuqgPO6G5et9g@mail.gmail.com>
	<CAJCQCtS=v+T-qGFLeaELn7Bt+Mb8ViK+8+YgontAE=1ucAnWZg@mail.gmail.com>
	<CAK7bmU_d3RTU4HZVHB9Z7ZAOpQ8C-wZn7WpvYsJaXiGDJki7fg@mail.gmail.com>
	<CAJCQCtQ9kxpuQD3k-rO84O+0jRpiWbCJAUdog+2_Da6EK5yGsQ@mail.gmail.com>
	<CAK7bmU9X8cvPs2sn3eZRaOowoT2H5jthpessWMQSVgvojjJ5EA@mail.gmail.com>
	<CAJCQCtQvkOr0WSOa_hUTCY72esF1euc_qz_FAEVEZ4c4cc+_dQ@mail.gmail.com>
	<CAK7bmU-KrAVoj_2gVGetAyVBNyTuipi2f+VU5SNzEDWxmnizDA@mail.gmail.com>
	<CAJCQCtSzYS=eDDLt_pMBbi8SY94wAXYnZCE_oppDtm8KEwqh1A@mail.gmail.com>
	<CAK7bmU9DVmXoEUBd2dmQPuVUb-iohacHqXvF73uOdaiL1GwtnA@mail.gmail.com>
	<CAJCQCtQLv83O2DD+J97Rw-i6FsLrANisSapjxydyx0kJT_vokA@mail.gmail.com>
	<CAK7bmU9SL7Fxqe+hAbe229Y7Fzegs2Dx42tLXyZ5Wttk+UeZDQ@mail.gmail.com>
Date: Wed, 12 Aug 2015 12:10:28 -0600
Message-ID: <CAJCQCtTmdwbLYbCQviNETy_w6Rv8=cu_hWtpVSeUMkGX_SX1Yg@mail.gmail.com>
Subject: Re: Damaged filesystem, can read, can't repair, error says to contact devs
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There are hardware problems here...

[112531.319224] ata4.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[112531.319231] ata4.00: failed command: WRITE DMA EXT
[112531.319240] ata4.00: cmd 35/00:00:00:8d:46/00:04:08:00:00/e0 tag 0
dma 524288 out
                         res 40/00:00:00:00:00/00:00:00:00:00/40 Emask
0x4 (timeout)

It's not ever good when a write command fails. It should take less
than 10 seconds for the drive to figure out if a sector is
persistently bad and to remap it. Yet it times out. I'm not sure why
though.

[112531.319243] ata4.00: status: { DRDY }
[112531.319252] ata4: hard resetting link
[112536.867209] ata4: link is slow to respond, please be patient (ready=0)
[112541.365663] ata4: SRST failed (errno=-16)
[112541.365672] ata4: hard resetting link
[112546.913747] ata4: link is slow to respond, please be patient (ready=0)
[112551.412202] ata4: SRST failed (errno=-16)
[112551.412211] ata4: hard resetting link
[112556.960286] ata4: link is slow to respond, please be patient (ready=0)
[112570.995495] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[112571.036455] ata4.00: configured for UDMA/133
[112571.036464] ata4.00: device reported invalid CHS sector 0
[112571.036474] ata4: EH complete
[112601.295099] ata4: lost interrupt (Status 0x51)

So it all gets reset...


[112601.295121] ata4.00: exception Emask 0x10 SAct 0x0 SErr 0x40d0002
action 0xe frozen
[112601.295126] ata4: SError: { RecovComm PHYRdyChg CommWake 10B8B DevExch }
[112601.295130] ata4.00: failed command: WRITE DMA EXT
[112601.295138] ata4.00: cmd 35/00:00:00:ff:4e/00:04:08:00:00/e0 tag 0
dma 524288 out
                         res 40/00:00:00:00:00/00:00:00:00:00/40 Emask
0x14 (ATA bus error)

But it has another write failure and this time it's associated with a
bus error. So I don't know if this is a misbehaving drive that's
pissing off the controller, or if it's a bad cable (typically it's the
connector not the cable itself that goes bad).

[112601.295141] ata4.00: status: { DRDY }
[112601.295150] ata4: hard resetting link
[112602.204775] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[112602.265984] ata4.00: configured for UDMA/133
[112602.265990] ata4.00: device reported invalid CHS sector 0

More resetting.

[112641.561198] INFO: task kworker/u8:5:8631 blocked for more than 120 seconds.
[112641.561203]       Not tainted 4.1.0-gentoo-r1 #1
[112641.561204] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[112641.561207] kworker/u8:5    D 0000000000015b40     0  8631      2 0x00000000
[112641.561222] Workqueue: writeback bdi_writeback_workfn (flush-btrfs-13)

and then hanging and more stuff...

Anyway it looks like it's hardware related, but I don't know what
device ata4.00 is, so maybe this helps:
http://superuser.com/questions/617192/mapping-ata-device-number-to-logical-device-name


---
Chris Murphy
