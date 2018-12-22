Return-Path: <SRS0=C3Cz=O7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76DD2C43387
	for <linux-btrfs@archiver.kernel.org>; Sat, 22 Dec 2018 17:22:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A70421974
	for <linux-btrfs@archiver.kernel.org>; Sat, 22 Dec 2018 17:22:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=petezilla.co.uk header.i=@petezilla.co.uk header.b="nRkcV6xZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392485AbeLVRWs (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 22 Dec 2018 12:22:48 -0500
Received: from phi.wiserhosting.co.uk ([77.245.66.218]:44358 "EHLO
        phi.wiserhosting.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727680AbeLVRWs (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 22 Dec 2018 12:22:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=petezilla.co.uk; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:To:References:Subject:Sender:
        Reply-To:Cc:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=xcnfOxLgoTOwoGfX+gK3Y5tmblSHL7KxkRD/U+XBKaQ=; b=nRkcV6xZ+Ja/L4DyhMxL5m2EQy
        I8LNiq4EL3GU1tJAETEaovcp3jR2gf8GMW3dvf5RXbkISwk0ngdbCQBznjgthh6BpIzY+FGkG52m5
        aabkug1tKqK7Wy95rjkuhle2N3t7RHFiLMEFBgCBB88b0TXmaywFIlKrxeOSbLGyV2sOTWlx50hcB
        1mvJrKvWKe17Evw6o0CdqoiOSHFTcJd4RcHr9hUXxsAnF9n1iBywhb6EmLB3sSDHTySyhGwfp+4xe
        lx7MTtRPRpwVz/4cOFXVrgpgMmCqJghwPXSAOcV7YQ+G+hlKLJtOYpIR6rx+gge4Wzcu+NJEMCUv7
        ltrK9Iiw==;
Received: from cpc75874-ando7-2-0-cust841.15-1.cable.virginm.net ([86.12.75.74]:53968 helo=[172.16.100.108])
        by phi.wiserhosting.co.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.91)
        (envelope-from <pete@petezilla.co.uk>)
        id 1gagRr-00EUE2-4r; Sat, 22 Dec 2018 12:32:07 +0000
Subject: Re: Mount issue, mount /dev/sdc2: can't read superblock
References: <1aa82e28-3331-bc64-071c-6cf87b08ad94@petezilla.co.uk>
 <CAJCQCtRY-=AoHDxu--YOWfrs774QzrYj-AwvwD3H_YpTzDKfZw@mail.gmail.com>
To:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From:   Peter Chant <pete@petezilla.co.uk>
Message-ID: <3b4d0ed3-4151-50b9-b1da-6be240bb58b3@petezilla.co.uk>
Date:   Sat, 22 Dec 2018 12:34:17 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRY-=AoHDxu--YOWfrs774QzrYj-AwvwD3H_YpTzDKfZw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-OutGoing-Spam-Status: No, score=-0.1
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - phi.wiserhosting.co.uk
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - petezilla.co.uk
X-Get-Message-Sender-Via: phi.wiserhosting.co.uk: authenticated_id: pete@petezilla.co.uk
X-Authenticated-Sender: phi.wiserhosting.co.uk: pete@petezilla.co.uk
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 12/21/2018 10:25 PM, Chris Murphy wrote:
> On Thu, Dec 20, 2018 at 3:23 PM Peter Chant <pete@petezilla.co.uk> wrote:
>>
>> I managed to break my root partition today.  Playing with GPU
>> passthrough to a second graphics card, unsuccessfully, I suspect lead to
>> some lockups and/or unclean mounts.
> 
> Should not matter, in theory.

Up until now it has seemed to be rather robust in this respect.  Any I
don't know if it was an unclean shutdown or something else.

I think lesson learned is to have a 'doing' system which I leave alone
and a 'play'  system that does not cause inconvenience if it breaks.
However, that take up extra space and gives two PCs to update...

> What do you get for ' btrfs rescue super -v <dev>'? That's a read only
> command, I wonder if all the supers are really valid. And if they are,
> then I'd like to see 'btrfs insp dump-s -f <dev>' and see if there's a
> log tree. And then also the output from 'btrfs check --mode=lowmem
> <dev>' which is also read-only, don't use --repair unless a dev
> recommends it.
> 
> 

Had to put the disk into another machine to do this.  Results below:


btrfs rescue super -v /dev/sdb2

All Devices:
	Device: id = 2, name = /dev/sdb2

Before Recovering:
	[All good supers]:
		device name = /dev/sdb2
		superblock bytenr = 65536

		device name = /dev/sdb2
		superblock bytenr = 67108864

		device name = /dev/sdb2
		superblock bytenr = 274877906944

	[All bad supers]:

All supers are valid, no need to recover


btrfs insp dump-s -f <dev>

superblock: bytenr=65536, device=/dev/sdb2
---------------------------------------------------------
csum_type		0 (crc32c)
csum_size		4
csum			0x939edd8c [match]
bytenr			65536
flags			0x1
			( WRITTEN )
magic			_BHRfS_M [match]
fsid			6496aabd-d6aa-49e0-96ca-e49c316edd8e
label			desk-system
generation		7937947
root			1113905790976
sys_array_size		97
chunk_root_generation	7743856
root_level		1
chunk_root		1066627579904
chunk_root_level	1
log_root		0
log_root_transid	0
log_root_level		0
total_bytes		375809638400
bytes_used		352796758016
sectorsize		4096
nodesize		16384
leafsize (deprecated)		16384
stripesize		4096
root_dir		6
num_devices		1
compat_flags		0x0
compat_ro_flags		0x0
incompat_flags		0x6b
			( MIXED_BACKREF |
			  DEFAULT_SUBVOL |
			  COMPRESS_LZO |
			  BIG_METADATA |
			  EXTENDED_IREF )
cache_generation	7937937
uuid_tree_generation	7937937
dev_item.uuid		d10d601a-54d6-4dce-9e2b-bb90f37c9b84
dev_item.fsid		6496aabd-d6aa-49e0-96ca-e49c316edd8e [match]
dev_item.type		0
dev_item.total_bytes	375809638400
dev_item.bytes_used	375808589824
dev_item.io_align	4096
dev_item.io_width	4096
dev_item.sector_size	4096
dev_item.devid		2
dev_item.dev_group	0
dev_item.seek_speed	0
dev_item.bandwidth	0
dev_item.generation	0
sys_chunk_array[2048]:
	item 0 key (FIRST_CHUNK_TREE CHUNK_ITEM 1066627563520)
		length 33554432 owner 2 stripe_len 65536 type SYSTEM
		io_align 65536 io_width 65536 sector_size 4096
		num_stripes 1 sub_stripes 1
			stripe 0 devid 2 offset 106301489152
			dev_uuid d10d601a-54d6-4dce-9e2b-bb90f37c9b84
backup_roots[4]:
	backup 0:
		backup_tree_root:	1113909100544	gen: 7937935	level: 1
		backup_chunk_root:	1066627579904	gen: 7743856	level: 1
		backup_extent_root:	1113909166080	gen: 7937935	level: 2
		backup_fs_root:		1113906577408	gen: 7762749	level: 0
		backup_dev_root:	1113911820288	gen: 7937933	level: 1
		backup_csum_root:	1113909755904	gen: 7937935	level: 2
		backup_total_bytes:	375809638400
		backup_bytes_used:	352796151808
		backup_num_devices:	1

	backup 1:
		backup_tree_root:	1113907347456	gen: 7937936	level: 1
		backup_chunk_root:	1066627579904	gen: 7743856	level: 1
		backup_extent_root:	1113906987008	gen: 7937936	level: 2
		backup_fs_root:		1113906921472	gen: 7937936	level: 0
		backup_dev_root:	1113907412992	gen: 7937936	level: 1
		backup_csum_root:	1113907658752	gen: 7937936	level: 2
		backup_total_bytes:	375809638400
		backup_bytes_used:	352796151808
		backup_num_devices:	1

	backup 2:
		backup_tree_root:	1113911951360	gen: 7937937	level: 1
		backup_chunk_root:	1066627579904	gen: 7743856	level: 1
		backup_extent_root:	1113911967744	gen: 7937937	level: 2
		backup_fs_root:		1113906921472	gen: 7937936	level: 0
		backup_dev_root:	1113907412992	gen: 7937936	level: 1
		backup_csum_root:	1113912492032	gen: 7937937	level: 2
		backup_total_bytes:	375809638400
		backup_bytes_used:	352796151808
		backup_num_devices:	1

	backup 3:
		backup_tree_root:	1113907494912	gen: 7937934	level: 1
		backup_chunk_root:	1066627579904	gen: 7743856	level: 1
		backup_extent_root:	1113907544064	gen: 7937934	level: 2
		backup_fs_root:		1113906577408	gen: 7762749	level: 0
		backup_dev_root:	1113911820288	gen: 7937933	level: 1
		backup_csum_root:	1113907855360	gen: 7937934	level: 2
		backup_total_bytes:	375809638400
		backup_bytes_used:	352796151808
		backup_num_devices:	1


btrfs check --mode=lowmem > <dev>

OK, this one threw an error:
[1/7] checking root items
Error: could not find extent items for root 290
ERROR: failed to repair root items: No such file or directory

And then gave this output:
Opening filesystem to check...
Checking filesystem on /dev/sdb2
UUID: 6496aabd-d6aa-49e0-96ca-e49c316edd8e


I'm getting suspicious of the drive as when I was trying the various
btrfs rescue * tools I saw a 'bad block', or similar, error displayed.
I also have a separate basic install on ext4 on the same disk.  Though
e2fsck shows no errors and mounts fine I cannot log into that install.
Maybe a coincidence, but too many bad things thrown up make me
suspicious.  Whatever is happening this seems to be really fighting me.



