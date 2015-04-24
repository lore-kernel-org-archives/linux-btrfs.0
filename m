Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp01.univ-lille1.fr ([193.49.225.19]:34463 "EHLO
	smtp01.univ-lille1.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946032AbbDXRpA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Apr 2015 13:45:00 -0400
Message-ID: <553A810F.6010907@gnieh.org>
Date: Fri, 24 Apr 2015 19:44:47 +0200
From: Martin Monperrus <martin.monperrus@gnieh.org>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: How to repair a BTRFS block?
References: <55320BAE.1030007@gnieh.org> <5539345C.1040905@gnieh.org>
In-Reply-To: <5539345C.1040905@gnieh.org>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Duncan,

> The kernel log (dmesg, also logged to syslog/journald on most systems)
> from during the scrub should capture more information on those errors. 
Thanks. The dmesg log indeed contains the file path (see below).

The error is in /home/martin/XXXXX. It is related to a low-level error
("failed command: READ DMA").

Beyond this corrupted file, is my disk dead?
Can I repair the file system or re-create a new one on the same disk?

Best,

--Martin

[ 7695.806090] BTRFS: i/o error at logical 167135232000 on dev
/dev/sda2, sector 213189792, root 5, inode 2963892, offset 7700480,
length 4096, links 1 (path: /home/martin/XXXXX)
[ 7695.806097] BTRFS: bdev /dev/sda2 errs: wr 0, rd 401, flush 0,
corrupt 0, gen 0
[ 7695.812770] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[ 7695.812774] ata1.00: irq_stat 0x40000001
[ 7695.812778] ata1.00: failed command: READ DMA
[ 7695.812783] ata1.00: cmd c8/00:08:a0:dc:91/00:00:00:00:00/ee tag 23
dma 4096 in
         res 51/40:00:00:00:00/00:00:00:00:00/ee Emask 0x9 (media error)
[ 7695.812785] ata1.00: status: { DRDY ERR }
[ 7695.812786] ata1.00: error: { UNC }
[ 7695.813013] ata1.00: supports DRM functions and may not be fully
accessible
[ 7695.813210] ata1.00: failed to get NCQ Send/Recv Log Emask 0x1
[ 7695.813770] ata1.00: supports DRM functions and may not be fully
accessible
[ 7695.813859] ata1.00: failed to get NCQ Send/Recv Log Emask 0x1
[ 7695.814164] ata1.00: configured for UDMA/133
[ 7695.814179] sd 0:0:0:0: [sda] Unhandled sense code
[ 7695.814181] sd 0:0:0:0: [sda] 
[ 7695.814182] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[ 7695.814183] sd 0:0:0:0: [sda] 
[ 7695.814185] Sense Key : Medium Error [current] [descriptor]
[ 7695.814187] Descriptor sense data with sense descriptors (in hex):
[ 7695.814188]         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00
[ 7695.814195]         0e 00 00 00
[ 7695.814198] sd 0:0:0:0: [sda] 
[ 7695.814199] Add. Sense: Unrecovered read error - auto reallocate failed
[ 7695.814201] sd 0:0:0:0: [sda] CDB:
[ 7695.814202] Read(10): 28 00 0e 91 dc a0 00 00 08 00
[ 7695.814208] end_request: I/O error, dev sda, sector 244440224
[ 7695.814222] ata1: EH complete
[ 7695.814227] BTRFS: unable to fixup (regular) error at logical
167135232000 on dev /dev/sda2



On 04/23/2015 08:05 PM, Martin Monperrus wrote:
> Hi,
>
> More on my issue, I have "uncorrectable errors"
>
> # btrfs scrub status /
> scrub status for e11013b3-b244-4d1a-a9c7-3956db1a699c
>     scrub started at Thu Apr 23 19:07:45 2015 and finished after 372 seconds
>     total bytes scrubbed: 167.13GiB with 13 errors
>     error details: read=13
>     corrected errors: 0, uncorrectable errors: 13, unverified errors: 0
>
> Before going to my backups, how can know the files impacted by those
> uncorrectable errors?
>
> Best regards,
>
> --Martin
>
>
>
> On 04/18/2015 09:45 AM, Martin Monperrus wrote:
>> Dear Btrfs developers,
>>
>> For some unknown reasons, my BTRFS filesystem is corrupted. dmesg prints
>>
>> |BTRFS critical (device sda2): corrupt leaf, slot offset bad:
>> block=43231330304,root=1, slot=47|
>>
>> (more than 1000x in the dmesg trace).
>>
>> btrfs check --repair fails with:
>>
>> read block failed check_tree_block
>> incorrect offset 12725 2298746482
>> items overlap, can't fix
>> cmds_check.c:2918: fix_item_offset: Assertion 'ret' failed
>>
>> How to list the files in block #43231330304 affected by the corruption?
>> How to repair block #43231330304?
>>
>> Best regards,
>>
>> --Martin
>>

