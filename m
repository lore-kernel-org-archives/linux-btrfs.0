Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 9.mo173.mail-out.ovh.net ([46.105.72.44]:40295 "EHLO
        9.mo173.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727412AbeGUKsO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 21 Jul 2018 06:48:14 -0400
Received: from player792.ha.ovh.net (unknown [10.109.160.226])
        by mo173.mail-out.ovh.net (Postfix) with ESMTP id 044ECC8363
        for <linux-btrfs@vger.kernel.org>; Sat, 21 Jul 2018 08:16:52 +0200 (CEST)
Subject: Re: btrfs filesystem corruptions with 4.18. git kernels
To: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
References: <50997dd6-6e60-af55-1aff-993b7cc3b801@web.de>
 <20180720231221.GE21293@carfax.org.uk>
From: Alexander Wetzel <alexander.wetzel@web.de>
Message-ID: <cd28fb92-61ef-45a5-fd18-200b7153eecf@web.de>
Date: Sat, 21 Jul 2018 08:16:40 +0200
MIME-Version: 1.0
In-Reply-To: <20180720231221.GE21293@carfax.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>> I'm running my normal workstation with git kernels from git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-testing.git
>> and just got the second file system corruption in three weeks. I do
>> not have issues with stable kernels, and just want to give you a
>> heads up that there might be something seriously broken in current
>> development kernels.
>>
>> The first corruption was with a kernel based on 4.18.0-rc1
>> (wt-2018-06-20) and the second one today based on 4.18.0-rc4
>> (wt-2018-07-09).
>> The first corruption definitely destroyed data, the second one has
>> not been looked at all, yet.
>>
>> After the reinstall I did run some scrubs, the last working one one
>> week ago.
>>
>> Of course this could be unrelated to the development kernels or even
>> btrfs, but two corruptions within weeks after years without problems
>> is very suspect.
>> And since btrfs also allowed to read corrupted data (with a stable
>> ubuntu kernel, see below for more details) it looks like this is
>> indeed an issue in btrfs, correct?
>>
>> A btrfs subvolume is used as the rootfs on a "Samsung SSD 850 EVO
>> mSATA 1TB" and I'm running Gentoo ~amd64 on a Thinkpad W530. Discard
>> is enabled as mount option and there were roughly 5 other
>> subvolumes.
>>
>> I'm currently backing up the full btrfs partition after the second
>> corruption which announced itself with the following log entries:
>>
>> [  979.223767] BTRFS critical (device sdc2): corrupt leaf: root=2
>> block=1029783552 slot=1, unexpected item end, have 16161 expect
>> 16250
> 
>     This means that the metadata block matches the checksum in its
> header, but is internally inconsistent. This means that the error in
> the block was made before the csum was computed -- i.e., it was that
> way in RAM. This can happen in a couple of different ways, but the
> most likely cause is bad RAM.
> 
>     In this case, it's not a single bitflip in the metadata page
> itself, so it's more likely to be something writing spurious data on
> the page in RAM that was holding this metadata block. This is either a
> bug in the kernel, or a hardware problem.
> 
>     I would strongly recommend checking your RAM (memtest86 for a
> minimum of 8 hours, preferably 24).

The system has 24G of ram but since the reinstalled was compiling the 
complete OS from scratch (with a stable kernel) I would have expected to 
hit the bad ram there also and kind of ignored that possibility. I'll 
run the tests and also report back on that.

>> [  979.223808] BTRFS: error (device sdc2) in __btrfs_cow_block:1080:
>> errno=-5 IO failure
>> [  979.223810] BTRFS info (device sdc2): forced readonly
>> [  979.224599] BTRFS warning (device sdc2): Skipping commit of
>> aborted transaction.
>> [  979.224603] BTRFS: error (device sdc2) in
>> cleanup_transaction:1847: errno=-5 IO failure
>>
>> I'll restore the system from a backup - and stick to stable kernels
>> for now - after that, but if needed I can of course also restore the
>> partition backup to another disk for testing.
> 
>     It may be a kernel issue, but it's not necessarily in btrfs. It
> could be a bug in some other kernel component where it does some
> pointer arithmetic wrong, or uses some uninitialised data as a
> pointer. My money's is on bad RAM, though (by a small margin).
> 

I also had two out of tree kernel modules:
https://github.com/hhfeuer/nvhda and the gentoo packaged version of 
https://github.com/mkottman/acpi_call

Alexander
