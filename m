Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:36126 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132Ab2GSOTk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Jul 2012 10:19:40 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: Very slow samba file transfer speed... any ideas ?
Date: Thu, 19 Jul 2012 16:19:38 +0200
Cc: Shavi N <shavi64@gmail.com>, Bernhard Redl <bernhard@stinkt.kicks-ass.org>
References: <CALa9hx1ojpNEYOr8-pLbcm3Y80+GNaeJBtnEugh-BZF4OkpAHw@mail.gmail.com> <201207191304.03829.Martin@lichtvoll.de> <CALa9hx0C8-PpDRFr9fZMtDW95=56XGYHQMnPt5nXOS=2r=tQUA@mail.gmail.com> (sfid-20120719_154602_474303_FE97A31F)
In-Reply-To: <CALa9hx0C8-PpDRFr9fZMtDW95=56XGYHQMnPt5nXOS=2r=tQUA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1252"
Message-Id: <201207191619.39100.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Donnerstag, 19. Juli 2012 schrieb Shavi N:
> Hi,

Hi Shavi,

> Thanks.
> 
> This is the output:
> btrfs:
> $ dd if=/dev/zero of=/mnt/shared/misc/temp_file bs=1M count=1400
> 1400+0 records in
> 1400+0 records out
> 1468006400 bytes (1.5 GB) copied, 1.56841 s, 936 MB/s
>
> ext4:
> $ dd if=/dev/zero of=/mnt/500/VirutalBox_VMs/thor/thor-data/temp_file
> bs=1M count=1400
> 1400+0 records in
> 1400+0 records out
> 1468006400 bytes (1.5 GB) copied, 4.98993 s, 294 MB/s

Did you actually read and understand my mail?

Do you really think that your local disks is/are yielding that 
transferrate? (Unless you are using BTRFS RAID 0/10 on lots of disks.)

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
