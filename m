Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout.teamix.de ([194.150.191.118]:32868 "EHLO
	mailout.teamix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755276AbaGIOyn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Jul 2014 10:54:43 -0400
From: Martin Steigerwald <ms@teamix.de>
To: Daniel Pocock <daniel@pocock.com.au>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs RAID with enterprise SATA or SAS drives
Date: Wed, 9 Jul 2014 16:48:05 +0200
Message-ID: <41327882.AW8TtKTnAV@merkaba>
In-Reply-To: <4FAAE94D.4010103@pocock.com.au>
References: <4FAAE94D.4010103@pocock.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

﻿Am Mittwoch, 9. Mai 2012, 22:01:49 schrieb Daniel Pocock:
> There is various information about
> - enterprise-class drives (either SAS or just enterprise SATA)
> - the SCSI/SAS protocols themselves vs SATA
> having more advanced features (e.g. for dealing with error conditions)
> than the average block device
> 
> For example, Adaptec recommends that such drives will work better with
> their hardware RAID cards:
[…]
> - for someone using SAS or enterprise SATA drives with Linux, I
> understand btrfs gives the extra benefit of checksums, are there any
> other specific benefits over using mdadm or dmraid?

I think I can answer this one.

Most important advantage I think is BTRFS is aware of which blocks of the 
RAID are in use and need to be synced:

- Instant initialization of RAID regardless of size (unless at some 
capacity mkfs.btrfs needs more time)

- Rebuild after disk failure or disk replace will only copy *used* blocks


Scrubbing can repair from good disk if RAID with redundancy, but SoftRAID 
should be able to do this as well. But also for scrubbing: BTRFS only 
check and repairs used blocks.


Another advantage in the future – not yet possible AFAIK:

- Different RAID levels on same filesystem yet different subvolumes, more 
flexibility as subvolumes are dynamically allocated, instead of statically 
sized

Ciao,
Martin

-- 
Martin Steigerwald
Consultant / Trainer

teamix GmbH
Südwestpark 43
90449 Nürnberg

fon:  +49 911 30999 55
fax:  +49 911 30999 99
mail: martin.steigerwald@teamix.de
web:  http://www.teamix.de
blog: http://blog.teamix.de

Amtsgericht Nürnberg, HRB 18320
Geschäftsführer: Oliver Kügow, Richard Müller

** JETZT ANMELDEN – teamix TechDemo - 23.07.2014 - http://www.teamix.de/techdemo **

