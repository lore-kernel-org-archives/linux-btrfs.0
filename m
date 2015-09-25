Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f46.google.com ([209.85.213.46]:35117 "EHLO
	mail-vk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932548AbbIYRRC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Sep 2015 13:17:02 -0400
Received: by vkao3 with SMTP id o3so60025355vka.2
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Sep 2015 10:17:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQ3aSfHE3o4nyaKOJjDbxiw87GHW6_JdBC1vnDgQXgGKA@mail.gmail.com>
References: <560409E7.5020500@mur.at>
	<CAJCQCtQ3aSfHE3o4nyaKOJjDbxiw87GHW6_JdBC1vnDgQXgGKA@mail.gmail.com>
Date: Fri, 25 Sep 2015 11:17:01 -0600
Message-ID: <CAJCQCtRMumq4=QqujuOxu6nC0W+6dv1tWzqe8fCzzEEa-D+1ZQ@mail.gmail.com>
Subject: Re: strange i/o errors with btrfs on raid/lvm
From: Chris Murphy <lists@colorremedies.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: =?UTF-8?Q?Jogi_Hofm=C3=BCller?= <jogi@mur.at>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>From offlist host logs (the Btrfs errors happen in a VM guest), I
think this is a hardware problem.

Aug 28 07:04:22 host kernel: [41367948.153031] sas:
sas_scsi_find_task: task 0xffff880e85c09c00 is done
Aug 28 07:04:22 host kernel: [41367948.153033] sas:
sas_eh_handle_sas_errors: task 0xffff880e85c09c00 is done
Aug 28 07:04:22 host kernel: [41367948.153036] sas: ata7:
end_device-0:0: cmd error handler
Aug 28 07:04:22 host kernel: [41367948.153085] sas: ata7:
end_device-0:0: dev error handler
Aug 28 07:04:22 host kernel: [41367948.153094] ata7.00: exception
Emask 0x0 SAct 0x7 SErr 0x0 action 0x6 frozen
Aug 28 07:04:22 host kernel: [41367948.153119] sas: ata8:
end_device-0:1: dev error handler
Aug 28 07:04:22 host kernel: [41367948.153130] sas: ata9:
end_device-0:2: dev error handler
Aug 28 07:04:22 host kernel: [41367948.153134] sas: ata10:
end_device-0:3: dev error handler
Aug 28 07:04:22 host kernel: [41367948.153181] ata7.00: failed
command: WRITE FPDMA QUEUED
Aug 28 07:04:22 host kernel: [41367948.153234] ata7.00: cmd
61/01:00:08:08:00/00:00:00:00:00/40 tag 0 ncq 512 out
Aug 28 07:04:22 host kernel: [41367948.153234]          res
40/00:00:01:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
Aug 28 07:04:22 host kernel: [41367948.153393] ata7.00: status: { DRDY }
Aug 28 07:04:22 host kernel: [41367948.153437] ata7.00: failed
command: READ FPDMA QUEUED
Aug 28 07:04:22 host kernel: [41367948.153490] ata7.00: cmd
60/08:00:80:ac:15/00:00:00:00:00/40 tag 1 ncq 4096 in
Aug 28 07:04:22 host kernel: [41367948.153490]          res
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Aug 28 07:04:22 host kernel: [41367948.153648] ata7.00: status: { DRDY }
Aug 28 07:04:22 host kernel: [41367948.153693] ata7.00: failed
command: READ FPDMA QUEUED
Aug 28 07:04:22 host kernel: [41367948.153744] ata7.00: cmd
60/30:00:90:ac:15/00:00:00:00:00/40 tag 2 ncq 24576 in
Aug 28 07:04:22 host kernel: [41367948.153744]          res
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Aug 28 07:04:22 host kernel: [41367948.153903] ata7.00: status: { DRDY }
Aug 28 07:04:22 host kernel: [41367948.153950] ata7: hard resetting link
Aug 28 07:04:22 host kernel: [41367948.320311] ata7.00: configured for
UDMA/133 (device error ignored)
Aug 28 07:04:22 host kernel: [41367948.320371] ata7.00: device
reported invalid CHS sector 0
Aug 28 07:04:22 host kernel: [41367948.320421] ata7.00: device
reported invalid CHS sector 0
Aug 28 07:04:22 host kernel: [41367948.320478] ata7: EH complete
Aug 28 07:04:22 host kernel: [41367948.320558] sas: --- Exit
sas_scsi_recover_host: busy: 0 failed: 0 tries: 1


So at the moment I don't think this is a Btrfs problem.

----
Chris Murphy
