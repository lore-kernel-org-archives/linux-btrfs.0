From: Daniel Pocock <daniel@pocock.com.au>
Subject: btrfs RAID with enterprise SATA or SAS drives
Date: Wed, 09 May 2012 22:01:49 +0000
Message-ID: <4FAAE94D.4010103@pocock.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>



There is various information about
- enterprise-class drives (either SAS or just enterprise SATA)
- the SCSI/SAS protocols themselves vs SATA
having more advanced features (e.g. for dealing with error conditions)
than the average block device

For example, Adaptec recommends that such drives will work better with
their hardware RAID cards:

http://ask.adaptec.com/cgi-bin/adaptec_tic.cfg/php/enduser/std_adp.php?p_faqid=14596
"Desktop class disk drives have an error recovery feature that will
result in a continuous retry of the drive (read or write) when an error
is encountered, such as a bad sector. In a RAID array this can cause the
RAID controller to time-out while waiting for the drive to respond."

and this blog:
http://www.adaptec.com/blog/?p=901
"major advantages to enterprise drives (TLER for one) ... opt for the
enterprise drives in a RAID environment no matter what the cost of the
drive over the desktop drive"

My question..

- does btrfs RAID1 actively use the more advanced features of these
drives, e.g. to work around errors without getting stuck on a bad block?

- if a non-RAID SAS card is used, does it matter which card is chosen?
Does btrfs work equally well with all of them?

- ignoring the better MTBF and seek times of these drives, do any of the
other features passively contribute to a better RAID experience when
using btrfs?

- for someone using SAS or enterprise SATA drives with Linux, I
understand btrfs gives the extra benefit of checksums, are there any
other specific benefits over using mdadm or dmraid?

