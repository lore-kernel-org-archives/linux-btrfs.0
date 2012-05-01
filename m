From: Martin <m_btrfs@ml1.co.uk>
Subject: btrfs on low end and high end FLASH
Date: Wed, 02 May 2012 00:18:32 +0100
Message-ID: <jnpr08$shq$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

How well suited is btrfs to low-end and high-end FLASH devices?


Paraphrasing from a thread elsewhere:

FLASH can be categorised into two classes, which have extremely
different characteristics:

(a) the low-end (USB, SDHC, CF, cheap ATA SSD);

and (b) the high-end (SAS, PCIe, NAS, expensive ATA SSD).


My own experience is that the low end (a) can have erase blocks as large
as 4MBytes or more and they are easily worn out to failure. I've no idea
what their page sizes might be nor what boundaries their wear levelling
(if any) operate on.

Their normal mode of operation is to use a "FAT32" filesystem and to be
filled up linearly with large files. I guess the more scattered layout
of extN is non-too sympathetic to their normal operation.


The high-end (b) may well have 4kByte pages or smaller but they will
typically operate with multiple page chunks that are much larger, where
16kBytes appear to be the optimum performance size for the devices I've
seen so far.


How well does btrfs fit in with the features for those two categories?

Regards,
Martin

