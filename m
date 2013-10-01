Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from detritus.pyropus.ca ([64.5.53.58]:35051 "HELO
	detritus.pyropus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751834Ab3JAXrZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Oct 2013 19:47:25 -0400
Date: Tue, 1 Oct 2013 17:46:55 -0600
From: Charles Cazabon <charlesc-lists-btrfs@pyropus.ca>
To: btrfs list <linux-btrfs@vger.kernel.org>
Subject: Re: Is `btrfsck --repair` supposed to actually repair problems?
Message-ID: <20131001234655.GA7937@pyropus.ca>
References: <20131001211255.GA5946@pyropus.ca>
 <13617928-CDCE-439D-B887-ED42F0E43F12@colorremedies.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="bp/iNruPH9dso1Pn"
In-Reply-To: <13617928-CDCE-439D-B887-ED42F0E43F12@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--bp/iNruPH9dso1Pn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi, Chris,

Chris Murphy <lists@colorremedies.com> wrote:
> On Oct 1, 2013, at 3:12 PM, Charles Cazabon
> <charlesc-lists-btrfs@pyropus.ca> wrote:
> 
> > Running btrfsck with the --repair option, however, does not appear to fix
> > these [checksum verify] problems.  I'll attach the complete output of
> > running with the --repair option; running btrfsck in check-only mode
> > afterwards reports largely the same checksum errors as it did originally,
> > prior to "repair".  something wrong?
> 
> It looks like the file system thinks the file has changed and isn't matching
> checksum. That's not obviously fixable unless both data and metadata are
> raid1.i

Perhaps this wasn't clear from my original message, but I'm not using btrfs'
RAID or lvm-like capabilities.  The filesystem is on an LVM logical volume,
with the actual underlying storage being an 8-disk RAID-6 array (mdadm array).
So the stack is:

    vanilla btrfs filesystem (not using subvolumes, btrfs' multiple device
       support or any other advanced features)

    LVM logical volume

    LVM volume group

    LVM physical volume

    md_crypt / LUKS encrypted volume

    mdadm RAID-6 array

    8 x SATA disks

> More information is needed:

Okay:

  # btrfs fi df /media/bigbackup/
  Data: total=4.53TB, used=4.22TB
  System, DUP: total=8.00MB, used=508.00KB
  System: total=4.00MB, used=0.00
  Metadata, DUP: total=18.00GB, used=17.13GB
  Metadata: total=8.00MB, used=0.00

> btrfs show

This fails with `btrfs: unknown token 'show'`.

> dmesg | grep -i btrfs

After mounting the filesystem read-only, the following ends up in the syslog:

  [13333.117462] Btrfs loaded
  [13333.157078] device label bigbackup devid 1 transid 5249
      /dev/mapper/extbackup-bigbackup
  [13333.158445] btrfs: disk space caching is enabled

That's the only btrfs-related info that gets logged.

> dmesg | grep ata<port#>
> 
> I'm assuming it's a SATA drive,

As I say, it's 8 disks (yes, SATA).  What info exactly do you want about the
disks and ports?  The log is quite noisy because these are behind SATA port
multipliers, and there are a bunch of other SATA drives in the system.  But if
I filter out all the extra stuff, then when I power up the port-multiplier
boxes that the disks are in, what's logged is 126 lines (much of it garbage
from not all possible multiplier ports being in use), log attached.

The 8 disks are, as you can see, all identical Seagate units:

  ATA-8: ST3000DM001-1E6166, CC45, max UDMA/133

> And report the version of btrfs-progs.

Btrfs v0.20-rc1-358-g194aa4a-dirty

That's what I get when I build from the git repository at
git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git

git insists I'm fully up to date, though the last time I pulled before today
was over a month ago.

Charles

-- 
-----------------------------------------------------------------------
Charles Cazabon
GPL'ed software available at:               http://pyropus.ca/software/
-----------------------------------------------------------------------
--bp/iNruPH9dso1Pn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="sata.log"

[    1.927026] ata11: SATA max UDMA/100 host m128@0xfd8ff000 port 0xfd8f8000 irq 19
[    1.927065] ata12: SATA max UDMA/100 host m128@0xfd8ff000 port 0xfd8fa000 irq 19
[    4.008746] ata11: SATA link down (SStatus 0 SControl 0)
[    6.091302] ata12: SATA link down (SStatus 0 SControl 0)
[  372.741259] ata11: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0xe frozen
[  372.741270] ata11: irq_stat 0x00b40090, PHY RDY changed
[  372.741284] ata11: hard resetting link
[  374.710712] ata12: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0xe frozen
[  374.710724] ata12: irq_stat 0x00b40090, PHY RDY changed
[  374.710738] ata12: hard resetting link
[  382.758711] ata11: softreset failed (timeout)
[  382.758724] ata11: hard resetting link
[  384.729193] ata12: softreset failed (timeout)
[  384.729206] ata12: hard resetting link
[  387.941314] ata11: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
[  387.941715] ata11.15: Port Multiplier 1.2, 0x197b:0x0325 r0, 15 ports, feat 0x5/0xf
[  387.946096] ata11.00: hard resetting link
[  388.314054] ata11.00: SATA link up 3.0 Gbps (SStatus 123 SControl 320)
[  388.314105] ata11.01: hard resetting link
[  388.682496] ata11.01: SATA link up 3.0 Gbps (SStatus 123 SControl 320)
[  388.682548] ata11.02: hard resetting link
[  389.051042] ata11.02: SATA link up 3.0 Gbps (SStatus 123 SControl 320)
[  389.051095] ata11.03: hard resetting link
[  389.419480] ata11.03: SATA link up 3.0 Gbps (SStatus 123 SControl 320)
[  389.419535] ata11.04: hard resetting link
[  389.927921] ata12: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
[  389.928310] ata12.15: Port Multiplier 1.2, 0x197b:0x0325 r0, 15 ports, feat 0x5/0xf
[  389.939731] ata12.00: hard resetting link
[  390.308622] ata12.00: SATA link up 3.0 Gbps (SStatus 123 SControl 320)
[  390.308677] ata12.01: hard resetting link
[  390.448517] ata11.04: failed to resume link (SControl 0)
[  390.448851] ata11.04: SATA link down (SStatus 0 SControl 0)
[  390.448932] ata11.05: hard resetting link
[  390.677099] ata12.01: SATA link up 3.0 Gbps (SStatus 123 SControl 320)
[  390.677155] ata12.02: hard resetting link
[  391.045600] ata12.02: SATA link up 3.0 Gbps (SStatus 123 SControl 320)
[  391.045654] ata12.03: hard resetting link
[  391.414090] ata12.03: SATA link up 3.0 Gbps (SStatus 123 SControl 320)
[  391.414143] ata12.04: hard resetting link
[  391.477925] ata11.05: failed to resume link (SControl 0)
[  391.478259] ata11.05: SATA link down (SStatus 0 SControl 0)
[  391.478339] ata11.06: hard resetting link
[  392.443117] ata12.04: failed to resume link (SControl 0)
[  392.443458] ata12.04: SATA link down (SStatus 0 SControl 0)
[  392.443540] ata12.05: hard resetting link
[  392.507226] ata11.06: failed to resume link (SControl 0)
[  392.507563] ata11.06: SATA link down (SStatus 0 SControl 0)
[  392.507644] ata11.07: hard resetting link
[  393.472419] ata12.05: failed to resume link (SControl 0)
[  393.472758] ata12.05: SATA link down (SStatus 0 SControl 0)
[  393.472842] ata12.06: hard resetting link
[  393.536548] ata11.07: failed to resume link (SControl 0)
[  393.536884] ata11.07: SATA link down (SStatus 0 SControl 0)
[  393.536964] ata11.08: hard resetting link
[  394.501715] ata12.06: failed to resume link (SControl 0)
[  394.502072] ata12.06: SATA link down (SStatus 0 SControl 0)
[  394.502154] ata12.07: hard resetting link
[  394.565850] ata11.08: failed to resume link (SControl 0)
[  394.566187] ata11.08: SATA link down (SStatus 0 SControl 0)
[  394.566319] ata11.09: hard resetting link
[  395.531029] ata12.07: failed to resume link (SControl 0)
[  395.531363] ata12.07: SATA link down (SStatus 0 SControl 0)
[  395.531446] ata12.08: hard resetting link
[  395.595131] ata11.09: failed to resume link (SControl 0)
[  395.595469] ata11.09: SATA link down (SStatus 0 SControl 0)
[  395.595550] ata11.10: hard resetting link
[  396.560399] ata12.08: failed to resume link (SControl 0)
[  396.560736] ata12.08: SATA link down (SStatus 0 SControl 0)
[  396.560818] ata12.09: hard resetting link
[  396.624462] ata11.10: failed to resume link (SControl 0)
[  396.624855] ata11.10: SATA link down (SStatus 0 SControl 0)
[  396.624963] ata11.11: hard resetting link
[  397.589718] ata12.09: failed to resume link (SControl 0)
[  397.590056] ata12.09: SATA link down (SStatus 0 SControl 0)
[  397.590137] ata12.10: hard resetting link
[  397.653780] ata11.11: failed to resume link (SControl 0)
[  397.654112] ata11.11: SATA link down (SStatus 0 SControl 0)
[  397.654193] ata11.12: hard resetting link
[  398.619001] ata12.10: failed to resume link (SControl 0)
[  398.619338] ata12.10: SATA link down (SStatus 0 SControl 0)
[  398.619420] ata12.11: hard resetting link
[  398.683119] ata11.12: failed to resume link (SControl 0)
[  398.683451] ata11.12: SATA link down (SStatus 0 SControl 0)
[  398.683530] ata11.13: hard resetting link
[  399.648291] ata12.11: failed to resume link (SControl 0)
[  399.648655] ata12.11: SATA link down (SStatus 0 SControl 0)
[  399.648744] ata12.12: hard resetting link
[  399.712480] ata11.13: failed to resume link (SControl 0)
[  399.712817] ata11.13: SATA link down (SStatus 0 SControl 0)
[  399.712897] ata11.14: hard resetting link
[  400.677675] ata12.12: failed to resume link (SControl 0)
[  400.678012] ata12.12: SATA link down (SStatus 0 SControl 0)
[  400.678097] ata12.13: hard resetting link
[  400.741762] ata11.14: failed to resume link (SControl 0)
[  400.742101] ata11.14: SATA link down (SStatus 0 SControl 0)
[  400.742911] ata11.00: ATA-8: ST3000DM001-1E6166, CC45, max UDMA/133
[  400.742921] ata11.00: 5860533168 sectors, multi 0: LBA48 
[  400.743635] ata11.00: configured for UDMA/100
[  400.744397] ata11.01: ATA-8: ST3000DM001-1E6166, CC45, max UDMA/133
[  400.744409] ata11.01: 5860533168 sectors, multi 0: LBA48 
[  400.765387] ata11.01: configured for UDMA/100
[  400.766129] ata11.02: ATA-8: ST3000DM001-1E6166, CC45, max UDMA/133
[  400.766140] ata11.02: 5860533168 sectors, multi 0: LBA48 
[  400.787661] ata11.02: configured for UDMA/100
[  400.788424] ata11.03: ATA-8: ST3000DM001-1E6166, CC45, max UDMA/133
[  400.788434] ata11.03: 5860533168 sectors, multi 0: LBA48 
[  400.808638] ata11.03: configured for UDMA/100
[  400.808738] ata11: EH complete
[  401.706984] ata12.13: failed to resume link (SControl 0)
[  401.707321] ata12.13: SATA link down (SStatus 0 SControl 0)
[  401.707405] ata12.14: hard resetting link
[  402.736244] ata12.14: failed to resume link (SControl 0)
[  402.736603] ata12.14: SATA link down (SStatus 0 SControl 0)
[  402.737449] ata12.00: ATA-8: ST3000DM001-1E6166, CC45, max UDMA/133
[  402.737460] ata12.00: 5860533168 sectors, multi 0: LBA48 
[  402.760315] ata12.00: configured for UDMA/100
[  402.761058] ata12.01: ATA-8: ST3000DM001-1E6166, CC45, max UDMA/133
[  402.761068] ata12.01: 5860533168 sectors, multi 0: LBA48 
[  402.761803] ata12.01: configured for UDMA/100
[  402.762551] ata12.02: ATA-8: ST3000DM001-1E6166, CC45, max UDMA/133
[  402.762560] ata12.02: 5860533168 sectors, multi 0: LBA48 
[  402.763284] ata12.02: configured for UDMA/100
[  402.764008] ata12.03: ATA-8: ST3000DM001-1E6166, CC45, max UDMA/133
[  402.764014] ata12.03: 5860533168 sectors, multi 0: LBA48 
[  402.764778] ata12.03: configured for UDMA/100
[  402.764876] ata12: EH complete


--bp/iNruPH9dso1Pn--
