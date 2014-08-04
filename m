Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:64418 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912AbaHDM5m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Aug 2014 08:57:42 -0400
MIME-Version: 1.0
In-Reply-To: <53D97932.8010505@nuclearwinter.com>
References: <1368165877.1162129.1406757898943.JavaMail.ngmail@webmail06.arcor-online.net>
 <53D97932.8010505@nuclearwinter.com>
From: =?UTF-8?Q?F=C3=A1bio_Pfeifer?= <fmpfeifer@gmail.com>
Date: Mon, 4 Aug 2014 09:57:20 -0300
Message-ID: <CABtk0xSgojne-hsPGDveadSt7CORH7h1CYaFQWJnT2Z+Nh9qYw@mail.gmail.com>
Subject: Re: btrfs on bcache
To: Larkin Lowrey <llowrey@nuclearwinter.com>
Cc: dptrash@arcor.de,
        "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

After completely loosing my filesystem twice because of this bug, I gave
up using btrfs on top of bcache (also writeback). In my case, I used to
have some subvolumes and some snapshot of these subvolumes, but not many
of them. The btrfs mantra "backup, bakcup and backup" saved me.

Best regards,

Fábio Pfeifer

2014-07-30 20:01 GMT-03:00 Larkin Lowrey <llowrey@nuclearwinter.com>:
> I've been running two backup servers, with 25T and 20T of data, using
> btrfs on bcache (writeback) for about 7 months. I periodically run btrfs
> scrubs and backup verifies (SHA1 hashes) and have never had a corruption
> issue.
>
> My use of btrfs is simple, though, with no subvolumes and no btrfs level
> raid. My bcache backing devices are LVM volumes that span multiple md
> raid6 arrays. So, either the bug has been fixed or my configuration is
> not susceptible.
>
> I'm running kernel 3.15.5-200.fc20.x86_64.
>
> --Larkin
>
> On 7/30/2014 5:04 PM, dptrash@arcor.de wrote:
>> Concerning http://thread.gmane.org/gmane.comp.file-systems.btrfs/31018, does this "bug" still exists?
>>
>> Kernel 3.14
>> B: 2x HDD 1 TB
>> C: 1x SSD 256 GB
>>
>> # make-bcache -B /dev/sda /dev/sdb -C /dev/sdc --cache_replacement_policy=lru
>> # mkfs.btrfs -d raid1 -m raid1 -L "BTRFS_RAID" /dev/bcache0 /dev/bcache1
>>
>> I still have no "incomplete page write" messages in "dmesg | grep btrfs" and the checksums of some manually reviewed files are okay.
>>
>> Who has more experiences about this?
>>
>> Thanks,
>>
>> - dp
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
