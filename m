Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f181.google.com ([209.85.161.181]:32881 "EHLO
	mail-yw0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbcECHhq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 May 2016 03:37:46 -0400
Received: by mail-yw0-f181.google.com with SMTP id t10so12207466ywa.0
        for <linux-btrfs@vger.kernel.org>; Tue, 03 May 2016 00:37:45 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 3 May 2016 15:37:45 +0800
Message-ID: <CALq5X_jrf9n304CRzX+X8iUEHPpVqkQTz4WVniEkT-XoZjO-nw@mail.gmail.com>
Subject: Debian BTRFS/UEFI Documentation
From: David Alcorn <nroclaed@gmail.com>
To: Nicholas D Steeves <nsteeves@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

"Honestly, did you read the Debian wiki pages for btrfs and EFI?  If
you read them, could you please let me know where they were deficient
so I can fix them?"

I did not use the Debian wiki pages for BTRFS and UEFI as a resource
in my attempts to answer my questions because I read them in the past
and they did not address my specific needs.  Technically, I lack the
skill set required for my perspectives to merit credulity but I am
willing to give it a shot.  I do not want to take the list off focus:
if this discussion belongs elsewhere, let me know.

My question about how to recover/replace a failed boot where "/" is
located in a BTRFS subvolume located on a BTRFS RAID56 array presents
challenges but it is reasonable to provide sufficient infrastructure
in the wiki's to let a portion of the readers answer this question
themselves rather than bother this list.  Am I correct that (i) there
is no reasonable tool to permit a screen shot of the Grub menu being
edited using the "e" key as the O/S has not yet loaded?, and (ii) do
USB flash drive (unlike some SSD's) respect the "dup" data profile?

It is easy to answer my question whether "/boot" may be located on a
BTRFS RAID56 array somewhere in the UEFI wiki.  I am more comfortable
with a more comprehensive revision to the wiki as suggested in the
below draft.  If the editorial comments are excessive or offend
community standards, scrap em.

Replace the "RAID for the EFI System Partition" section with:

"DRAFT: RAID and LVM for the EFI and /Boot Partitions".  The UEFI
firmware specification supports several alternative boot strategies
including PXE boot and boot from an EFI System Partition ("ESP") which
might be located on a MBR, GPT or El Torito volume on an optical disk.
The ESP must be partitioned using a supported FAT partition (such as
FAT32).  A mdadm RAID array (other than perhaps a RAID 1 array
formatted as FAT32), a LVM partition and a BTRFS RAID array are not
FAT and can not hold a functional ESP.  Once Grub loads the ESP
payload, Grub has enhanced abilities to recognize file systems which
it uses to acquire required information from "/boot".  The Grub
Manual, which may be viewed with the command "info grub", reports Grub
(unlike grub-legacy stage 1.5) has some ability to use advanced file
systems such as LVM and RAID once the ESP payload is loaded.  This
support appears to exclude BTRFS RAID 56.  Other than the possible
mdadm RAID 1 exception noted above, ESP always goes in a separate, non
array, non LVM FAT partition.  For BTRFS RAID56 arrays,  "/boot" also
requires a separate, non array partition.

Because LVM does not favor a whole disk Physical Volume ("PV") over a
partition based PV, it is trivial to create a petite ESP on a disk and
assign the balance of the disk to a LVM PV.  Array capacity of both
MDADM and BTRFS RAID 56 arrays may be disproportionately reduced when
the size of a single disk is reduced by, say an ESP.  For
administrative simplicity and to maximize array capacity, equal sized
whole disk arrays are favored.

Both the ESP and "/boot" partitions present limited, read dominated
workloads.  USB flash drives are cheap and tolerate light, read
dominated workloads well.  For a stand alone server, it is common to
locate the ESP on a USB flash device.  If you use a BTRFS RAID56
array, "/boot" and perhaps "/swap" may also go to separate partitions
on the flash drive.  This permits assignment of whole disks to the
array.  If you are working with a large number of servers, it may be
cheaper, more energy efficient, and more reliable to replace whatever
is on the flash drive with PXE boot.  Frequently, SATA (or IDE) drives
that are not wholly allocated to the RAID array are scarce.  If you
have one, the ESP (and "/boot") partitions may be located there.
Similar concerns affect LILO.
