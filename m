Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ve0-f170.google.com ([209.85.128.170]:47836 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753940Ab3JXQT0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Oct 2013 12:19:26 -0400
Received: by mail-ve0-f170.google.com with SMTP id db12so1740943veb.15
        for <linux-btrfs@vger.kernel.org>; Thu, 24 Oct 2013 09:19:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAD_cGvHy1uVs_0AtE93LOWRcw0XhcD9+HEO+FdLNFt7cDeUaKA@mail.gmail.com>
References: <1380289020-2515-1-git-send-email-jbacik@fusionio.com>
	<20131004231948.0ee4e03c@datenkhaos.de>
	<CAD_cGvEtFnyVBoaEc13-gqX95Uv6njdEqji_PBS5iczQBYkGQg@mail.gmail.com>
	<CAD_cGvHy1uVs_0AtE93LOWRcw0XhcD9+HEO+FdLNFt7cDeUaKA@mail.gmail.com>
Date: Thu, 24 Oct 2013 18:19:22 +0200
Message-ID: <CAD_cGvEyk0xk+B8aDan9HRvs31B1QCn4_G1pF6-oEo_uZMNpGQ@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: relocate csums properly with prealloc extents
From: Hans-Kristian Bakke <hkbakke@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The result of the scrubbing came back today and it was not pretty:
...
scrub done for b64daec7-6c14-4996-94b3-80c6abfa26ce
        scrub started at Wed Oct 23 23:01:22 2013 and finished after
34990 seconds
        total bytes scrubbed: 12.55TB with 3859542 errors
        error details: csum=3859542
        corrected errors: 0, uncorrectable errors: 3859542, unverified errors: 0
---

Still only two folder structures affected, but seemingly unrecoverable.
I noticed the mail to include it in 3.12. Jippi!
Until this is included I will have to pospone rebalancing over the
four new drives.


Mvh

Hans-Kristian Bakke


On 23 October 2013 23:49, Hans-Kristian Bakke <hkbakke@gmail.com> wrote:
> OK. btrfs scrub and dmesg is hitting me with lots of unfixable errors.
> All in the same file. Example
>
> [13313.441091] btrfs: unable to fixup (regular) error at logical
> 560107954176 on dev /dev/sdn
> [13321.532223] scrub_handle_errored_block: 1510 callbacks suppressed
> [13321.532309] btrfs_dev_stat_print_on_error: 1510 callbacks suppressed
> [13321.532314] btrfs: bdev /dev/sdq errs: wr 0, rd 0, flush 0, corrupt
> 40016, gen 0
> [13321.532420] btrfs: bdev /dev/sdq errs: wr 0, rd 0, flush 0, corrupt
> 40017, gen 0
> [13321.532545] btrfs: bdev /dev/sdq errs: wr 0, rd 0, flush 0, corrupt
> 40018, gen 0
> [13321.532605] btrfs: bdev /dev/sdq errs: wr 0, rd 0, flush 0, corrupt
> 40019, gen 0
> [13321.533039] btrfs: bdev /dev/sdq errs: wr 0, rd 0, flush 0, corrupt
> 40020, gen 0
> [13321.537519] scrub_handle_errored_block: 1508 callbacks suppressed
> [13321.537525] btrfs: unable to fixup (regular) error at logical
> 560630136832 on dev /dev/sdq
> [13321.537821] btrfs: bdev /dev/sdq errs: wr 0, rd 0, flush 0, corrupt
> 40021, gen 0
> [13321.538081] btrfs: unable to fixup (regular) error at logical
> 560630140928 on dev /dev/sdq
> [13321.538438] btrfs: bdev /dev/sdq errs: wr 0, rd 0, flush 0, corrupt
> 40022, gen 0
> [13321.538715] btrfs: unable to fixup (regular) error at logical
> 560630145024 on dev /dev/sdq
> [13321.539016] btrfs: bdev /dev/sdq errs: wr 0, rd 0, flush 0, corrupt
> 40023, gen 0
> [13321.539234] btrfs: unable to fixup (regular) error at logical
> 560630149120 on dev /dev/sdq
> [13321.539522] btrfs: bdev /dev/sdq errs: wr 0, rd 0, flush 0, corrupt
> 40024, gen 0
> [13321.539739] btrfs: unable to fixup (regular) error at logical
> 560630153216 on dev /dev/sdq
> [13321.540027] btrfs: bdev /dev/sdq errs: wr 0, rd 0, flush 0, corrupt
> 40025, gen 0
> [13321.540242] btrfs: unable to fixup (regular) error at logical
> 560630157312 on dev /dev/sdq
> [13321.540620] btrfs: unable to fixup (regular) error at logical
> 560630161408 on dev /dev/sdq
> [13321.541140] btrfs: unable to fixup (regular) error at logical
> 560630165504 on dev /dev/sdq
> [13321.541571] btrfs: unable to fixup (regular) error at logical
> 560630169600 on dev /dev/sdq
> [13321.541931] btrfs: unable to fixup (regular) error at logical
> 560630173696 on dev /dev/sdq
>
> Luckily all the corruption seems to be in a single very large file,
> but on different part of it on different disks. The file was written
> by rtorrent which have the option "system.file_allocate.set = yes"
> configured.
> I also have samba configured with "strict allocate = yes" because it
> is recommended for best performance on extent based filesystems. Do
> that mean even samba files vulnerable to this corruption too?
> If so this could become very ugly very fast on certain systems.
>
> Mvh
>
> Hans-Kristian Bakke
>
>
> On 23 October 2013 23:24, Hans-Kristian Bakke <hkbakke@gmail.com> wrote:
>> I was hit by this when trying to rebalance a 16TB RAID10 to 32TB
>> RAID10 going from 4 to 8 WD SE 4TB drives today. I cannot finish a
>> rebalance because of failed csum.
>>
>> [10228.850910] BTRFS info (device sdq): csum failed ino 487 off 65536
>> csum 2566472073 private 151366068
>> [10228.850967] BTRFS info (device sdq): csum failed ino 487 off 69632
>> csum 2566472073 private 3056924305
>> [10228.850973] BTRFS info (device sdq): csum failed ino 487 off 593920
>> csum 2566472073 private 906093395
>> [10228.851004] BTRFS info (device sdq): csum failed ino 487 off 73728
>> csum 2566472073 private 2680502892
>> [10228.851014] BTRFS info (device sdq): csum failed ino 487 off 598016
>> csum 2566472073 private 1940162924
>> [10228.851029] BTRFS info (device sdq): csum failed ino 487 off 77824
>> csum 2566472073 private 2939385278
>> [10228.851051] BTRFS info (device sdq): csum failed ino 487 off 602112
>> csum 2566472073 private 645310077
>> [10228.851055] BTRFS info (device sdq): csum failed ino 487 off 81920
>> csum 2566472073 private 3600741549
>> [10228.851078] BTRFS info (device sdq): csum failed ino 487 off 86016
>> csum 2566472073 private 200201951
>> [10228.851091] BTRFS info (device sdq): csum failed ino 487 off 606208
>> csum 2566472073 private 1002916440
>>
>> The system is running a scrub now and I will return with some more
>> details later. I do not think systemd is logging to this volume, but
>> the scrub wil probably show which files are affected.
>>
>> As this is a very serious issue for those hit by the corruption (it
>> basically makes it impossible to run rebalance with all its
>> consequences) hopefully this wil go upstream soon.
>> I am on Kernel 3.11.6 by the way.
>> Mvh
>>
>> Hans-Kristian Bakke
>> Mob: 91 76 17 38
>>
>>
>> On 4 October 2013 23:19, Johannes Hirte <johannes.hirte@datenkhaos.de> wrote:
>>> On Fri, 27 Sep 2013 09:37:00 -0400
>>> Josef Bacik <jbacik@fusionio.com> wrote:
>>>
>>>> A user reported a problem where they were getting csum errors when
>>>> running a balance and running systemd's journal.  This is because
>>>> systemd is awesome and fallocate()'s its log space and writes into
>>>> it.  Unfortunately we assume that when we read in all the csums for
>>>> an extent that they are sequential starting at the bytenr we care
>>>> about.  This obviously isn't the case for prealloc extents, where we
>>>> could have written to the middle of the prealloc extent only, which
>>>> means the csum would be for the bytenr in the middle of our range and
>>>> not the front of our range.  Fix this by offsetting the new bytenr we
>>>> are logging to based on the original bytenr the csum was for.  With
>>>> this patch I no longer see the csum errors I was seeing.  Thanks,
>>>
>>> Any assessment when this goes upstream? Until it hit Linus tree it
>>> won't won't appear in stable. And this seems rather important.
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
