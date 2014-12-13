Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.216]:27198 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031073AbaLMOZA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 13 Dec 2014 09:25:00 -0500
To: linux-btrfs@vger.kernel.org
Received: from patina.store (com4.strato.de [81.169.145.237])
	by smtp-ox.front (RZmta 36.3 AUTH)
	with ESMTPSA id j00362qBDEOuNtU
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA (128/128 bits))
	(Client did not present a certificate)
	for <linux-btrfs@vger.kernel.org>;
	Sat, 13 Dec 2014 15:24:56 +0100 (CET)
Date: Sat, 13 Dec 2014 15:24:56 +0100 (CET)
From: Florian Uekermann <florian@uekermann.me>
Reply-To: Florian Uekermann <florian@uekermann.me>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <932711394.78334.1418480696257.JavaMail.open-xchange@patina.store>
In-Reply-To: <5487B3FB.4070109@oracle.com>
References: <708100218.650154.1418123709778.JavaMail.open-xchange@omgreatgod.store> <5487B3FB.4070109@oracle.com>
Subject: Re: Device only missing if unmounted
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dear Anand,
thank you for your help.

> On December 10, 2014 at 3:46 AM Anand Jain <anand.jain@oracle.com> wrote:
> It depends on the disk that is read first, you could read super block
> using btrfs-show-super and check if num_device.

I checked this for all three devices and num_devices is 4 for all of them.
The full output is below.

> It may fail if you are mounting more than one subvol during boot and if
> you don't have this patch.
>
> commit 0f23ae74f589304bf33233f85737f4fd368549eb
> Author: Chris Mason <clm@fb.com>
> Date: Thu Sep 18 07:49:05 2014 -0700
>
> Revert "Btrfs: device_list_add() should not update list when mounted"
>
> This reverts commit b96de000bc8bc9688b3a2abea4332bd57648a49f.

I am running 3.18-rc5+ from linus tree. If I am not mistaken,
 that commit is his tree in since 3.17-rc6.

So I guess the question is: Why does the superblock say
num_devices=4 (and how do I fix it)?
Or am I misunderstanding the problem?

Best regards,
Florian

root@oot:/home/shared# btrfs-show-super /dev/sdb
superblock: bytenr=65536, device=/dev/sdb
---------------------------------------------------------
csum			0x55a3eb1d [match]
bytenr			65536
flags			0x1
magic			_BHRfS_M [match]
fsid			be2b3499-7452-4b91-b664-4ec4d7ff62b9
label			
generation		3003
root			441395970048
sys_array_size		129
chunk_root_generation	3001
root_level		1
chunk_root		442469761024
chunk_root_level	1
log_root		0
log_root_transid	0
log_root_level		0
total_bytes		109927469in the first place8752
bytes_used		160703954944
sectorsize		4096
nodesize		16384
leafsize		16384
stripesize		4096
root_dir		6
num_devices		4
compat_flags		0x0
compat_ro_flags		0x0
incompat_flags		0x61
			( MIXED_BACKREF |
			  BIG_METADATA |
			  EXTENDED_IREF )
csum_type		0
csum_size		4
cache_generation	3003
uuid_tree_generation	3003
dev_item.uuid		5b8c8d20-c330-48a2-814c-c6986b787d52
dev_item.fsid		be2b3499-7452-4b91-b664-4ec4d7ff62b9 [match]
dev_item.type		0
dev_item.total_bytes	500107862016
dev_item.bytes_used	162168569856
dev_item.io_align	4096
dev_item.io_width	4096
dev_item.sector_size	4096
dev_item.devid		2
dev_item.dev_group	0
dev_item.seek_speed	0
dev_item.bandwidth	0
dev_item.generation	0
