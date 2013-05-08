Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:42704 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750830Ab3EHHgY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 8 May 2013 03:36:24 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UZyvC-0002We-M5
	for linux-btrfs@vger.kernel.org; Wed, 08 May 2013 09:36:18 +0200
Received: from dyndsl-178-142-088-157.ewe-ip-backbone.de ([178.142.88.157])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 08 May 2013 09:36:18 +0200
Received: from hurikhan77+btrfs by dyndsl-178-142-088-157.ewe-ip-backbone.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 08 May 2013 09:36:18 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77+btrfs@gmail.com>
Subject: Re: Best Practice - Partition, or not?
Date: Wed, 08 May 2013 09:31:33 +0200
Message-ID: <njbp5a-7tq.ln1@hurikhan.ath.cx>
References: <loom.20130501T094600-451@post.gmane.org> <CW2IaniPCXB@helmut.hullen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Helmut Hullen <Hullen@t-online.de> schrieb:

>> If I want to manage a complete disk with btrfs, what's the "Best
>> Practice"? Would it be best to create the btrfs filesystem on
>> "/dev/sdb", or would it be better to create just one partition from
>> start to end and then do "mkfs.btrfs /dev/sdb1"?
> 
>> Would the same recomendation hold true, if we're talking about huge
>> disks, like 4TB or so?
> 
> I've tested both versions on a 3 disk bundle of 3 TByte disks (data
> raid0, meta raid1).
> 
>   mkfs.btrfs ... /dev/sdb /dev/sdc /dev/sdd
> 
> made some more problems, especially when recognizing or deleting the
> disk(s). Maybe that's a problem more related to "util-linux" (especially
> "wipefs" and "blkid").
> 
> Partitioning first with gdisk and then
> 
>   mkfs.btrfs ... /dev/sdb1 /dev/sdc1 /dev/sdd1
> 
> runs better (perhaps without problems).

I can only second that experience. Most apps and utilities do not expect 
filesystems on raw partitions, most expect partitions first. Some may even 
just destroy your filesystem because they only find what appears junk to 
them on the disk. OP is not going to dual-boot (which would raise such 
problems with the highest chance) but if you want to evade unexpected 
behavior use GPT partitioning - it supports huge disks and takes care on the 
block alignment.

I used formatting raw disks in a VM because adding new disks was a matter of 
adding a new VD image to the machine and I didn't need more than one 
partition on a disk. But that created more headache than I expected and I 
didn't want to persuade tools and scripts any longer to accept raw disks as 
filesystems and work around ugly quirks (like scripts expecting /dev/sd[a-z] 
to never be a filesystem but always raw device, and requiring /dev/sd[a-z]
[0-9]+ for partitions, and more such fun).

So I suggest: Go with partitions.

Regards,
Kai

