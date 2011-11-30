From: 810d4rk <810d4rk@gmail.com>
Subject: Re: btrfs encryption problems
Date: Wed, 30 Nov 2011 22:15:25 +0000
Message-ID: <CAAVfQjk+O_3uLb=DShFwV2gVnLeDzQ45ebpMidDGFXZtqXJBbQ@mail.gmail.com>
References: <CAAVfQj=O5nDAcgsiNHz3dNXHDerNrq2Jw01WFLJr5q563oZToA@mail.gmail.com>
 <20111123110956.GB31800@attic.humilis.net> <CAAVfQj=r-Op2ZUrq8YOchVV=0_LzNmdxjYd03nDHn+t=120YQw@mail.gmail.com>
 <20111124160617.680b676f@zougloub.eu> <CAAVfQj=gM7ikTzdFmi=yNpo9guukQwFyKfdu7jD=z-J2PwrZEg@mail.gmail.com>
 <20111124165429.10496040@Bidule> <CAAVfQjmmXnyCmXerCyymEQm-DhDxi0YSSo9sVSvkHE1WvJ4wYA@mail.gmail.com>
 <20111130134814.GW24338@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Chris Mason <chris.mason@oracle.com>, 810d4rk <810d4rk@gmail.com>,
	=?UTF-8?B?SsOpcsO0bWUgQ2FycmV0ZXJv?= <cJ-ko@zougloub.eu>,
	sander@humilis.net, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111130134814.GW24338@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

I plugged it directly by sata and this is what I get from the 3.1 kerne=
l:

[  577.850429] ata3: exception Emask 0x10 SAct 0x0 SErr 0x4050000
action 0xe frozen
[  577.850433] ata3: irq_stat 0x00000040, connection status changed
[  577.850436] ata3: SError: { PHYRdyChg CommWake DevExch }
[  577.850443] ata3: hard resetting link
[  581.768015] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[  581.829148] ata3.00: ATA-8: WDC WD7500BPVT-22HXZT1, 01.01A01, max UD=
MA/133
[  581.829151] ata3.00: 1465149168 sectors, multi 0: LBA48 NCQ (depth 3=
1/32), AA
[  581.833146] ata3.00: configured for UDMA/133
[  581.848043] ata3: EH complete
[  581.848134] scsi 2:0:0:0: Direct-Access     ATA      WDC
WD7500BPVT-2 01.0 PQ: 0 ANSI: 5
[  581.848250] sd 2:0:0:0: [sdb] 1465149168 512-byte logical blocks:
(750 GB/698 GiB)
[  581.848253] sd 2:0:0:0: [sdb] 4096-byte physical blocks
[  581.848300] sd 2:0:0:0: [sdb] Write Protect is off
[  581.848302] sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[  581.848323] sd 2:0:0:0: [sdb] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[  581.921417]  sdb: sdb1
[  581.921642] sd 2:0:0:0: [sdb] Attached SCSI disk
[  660.040263] EXT4-fs (dm-4): VFS: Can't find ext4 filesystem

> If you plug it in directly with esata, do the IO errors go away? =C2=A0=
If so,
> please post the kernel messages from that.
>
> -chris


--=20
Thanks
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
