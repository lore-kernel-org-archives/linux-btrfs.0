Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:48244 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964Ab3LSIOf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Dec 2013 03:14:35 -0500
Received: by mail-lb0-f169.google.com with SMTP id u14so308064lbd.28
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Dec 2013 00:14:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20131218112935.GA9705@pdb1.th.formicary.net>
References: <CAAeznTpG6A7ygKg1AUx_pAMs_SNwG4a4C5gHPeT+HcKRsD+TWA@mail.gmail.com>
	<20131215202456.GA11281@carfax.org.uk>
	<CAAeznTryb7kyuvEyBFniv-UtGCQwdNtZMhpxm=-2MtKZSOj9Tw@mail.gmail.com>
	<pan$138cb$448d68e$2d9dcb10$fc6a898a@cox.net>
	<CAAeznTpZ6p1_ZR6xy-YGynAJu88jZ_52AQURuxT4qTeEYLOjdg@mail.gmail.com>
	<20131218104442.GA28559@pdb1.th.formicary.net>
	<20131218110528.GK11281@carfax.org.uk>
	<20131218112935.GA9705@pdb1.th.formicary.net>
Date: Thu, 19 Dec 2013 08:14:33 +0000
Message-ID: <CAAeznTrqHP6Wmqun_-3OeNy+gcgXSPZCVmR5AX0zcifG-ju6+A@mail.gmail.com>
Subject: Re: btrfs balance on single device
From: Leonidas Spyropoulos <artafinde@gmail.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Cc: Hugo Mills <hugo@carfax.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 18, 2013 at 11:29 AM, Leonidas Spyropoulos
<artafinde@gmail.com> wrote:
> On Wed, Dec 18, 2013 at 11:05:29AM +0000, Hugo Mills wrote:
>> On Wed, Dec 18, 2013 at 10:44:43AM +0000, Leonidas Spyropoulos wrote:
>> > I'm using the same subject as it might be relevant, feel free to change it.#
>> >
>> > I'm trying to do some maintenance to the system running over a btrfs file system on root (/). I started a balance on the '/' partition and it failed with the below information:
>> > $ sudo btrfs balance start /
>> > [sudo] password for inglor:
>> > ERROR: error during balancing '/' - No space left on device
>> > There may be more info in syslog - try dmesg | tail
>> > $ dmesg | tail
>> > [93827.115887] btrfs: found 29461 extents
>> > [93827.481849] btrfs: relocating block group 29855055872 flags 1
>> > [93841.646011] btrfs: found 33171 extents
>> > [93851.421207] btrfs: found 33171 extents
>> > [93851.782054] btrfs: relocating block group 28781314048 flags 1
>> > [93866.815342] btrfs: found 52535 extents
>> > [93877.159354] btrfs: found 52534 extents
>> > [93877.356805] btrfs: relocating block group 28747759616 flags 34
>> > [93880.287185] btrfs: found 1 extents
>> > [93880.608798] btrfs: 1 enospc errors during balance
>>
>>    You don't specify your kernel version, but if it's older than 3.11
>> or so, you should probably upgrade -- 3.10 and earlier had occasional
>> bugs where the block reserve system never kept enough blocks free to
>> add a new metadata chunk when it was needed, which led to exactly this
>> kind of symptom.
>
> You are right, apologies. It is an up to date Archlinux box with a kernel:
> $ uname -a
> Linux tiamat 3.12.5-1-ARCH #1 SMP PREEMPT Thu Dec 12 12:57:31 CET 2013 x86_64 GNU/Linux
>
>>
>>    Alternatively, and this is a bit of a long shot given that the
>> error seems to have been while relocating your system chunk (which
>> argues against this particular diagnosis), but:
>>
>>    Do you have a large file on that filesystem (larger than 1 GiB)?
>
> Unlikely since the btrfs file system in question is '/' exluding /opt and /media directories (these are other partitions)
> $ sudo find / -type f -size +1048576k -and -not -path "/media*" -print
> /proc/kcore
> find: `/proc/27221/task/27221/fd/5': No such file or directory
> find: `/proc/27221/task/27221/fdinfo/5': No such file or directory
> find: `/proc/27221/fd/5': No such file or directory
> find: `/proc/27221/fdinfo/5': No such file or directory
> find: `/run/user/1000/gvfs': Permission denied
> inglor@tiamat ~$
>
>>
>>    If so, I would recommend switching to a 3.12 kernel, and running a
>> defrag on the file. There's a known and now-fixed bug where you can
>> get ENOSPC while balancing, if a file has an extent larger than 1 GiB
>> in size. (The bug being that there's an extent over 1 GiB in size in
>> the first place).
>
> I might try the defrag option anyway and restart the balance operation, see if this will help anyway.

Some progress on this. I managed to do a balance on data only. The
problem seems to be happening when doing a metadata balance

$ sudo btrfs balance start -m /
[sudo] password for inglor:
ERROR: error during balancing '/' - No space left on device
There may be more info in syslog - try dmesg | tail
$ dmesg | tail
[171492.384314] systemd-journald[183]: Deleted empty journal
/var/log/journal/64cfb6f6c9d1625e7fa463c200000475/user-120@8b61bc353813451babcaa25dfc82c64e-0000000000000000-0000000000000000.journal
(2924544 bytes).
[171492.384375] systemd-journald[183]: Vacuuming done, freed 2924544 bytes
[172242.011051] btrfs: relocating block group 109781712896 flags 36
[172242.075298] btrfs: relocating block group 109748158464 flags 34
[172242.286016] btrfs: found 1 extents
[172242.419286] btrfs: 1 enospc errors during balance

Is there a way to recreate the metadata? (I'm guessing the answer is balance..)

>
> Thanks,
> Leonidas
>
>>
>>    Hugo.
>>
>> --
>> === Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
>>   PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
>>          --- I'd make a joke about UDP,  but I don't know if ---
>>                      anyone's actually listening...



-- 
Caution: breathing may be hazardous to your health.

#include <stdio.h>
int main(){printf("%s","\x4c\x65\x6f\x6e\x69\x64\x61\x73");}
