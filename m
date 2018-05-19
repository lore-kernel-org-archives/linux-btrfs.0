Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f68.google.com ([209.85.213.68]:44540 "EHLO
        mail-vk0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752174AbeESLnS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 19 May 2018 07:43:18 -0400
Received: by mail-vk0-f68.google.com with SMTP id x66-v6so6354633vka.11
        for <linux-btrfs@vger.kernel.org>; Sat, 19 May 2018 04:43:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <31f77b2f-4110-9868-2c6b-abf40ccef316@gmx.com>
References: <CAB+znrFyimDnOZt46CqterRJ6MvwD4TSWagQvv-oQxjPvG-m2w@mail.gmail.com>
 <54d2f70a-adae-98cc-581f-2e4786783b26@gmx.com> <CAB+znrHYrhBB4cstUaS3KcOfEHhOTPUsfAJKj3Cj62HJ-05FrQ@mail.gmail.com>
 <d32f3fdc-5ba0-2b62-ce79-5e5665d4c960@gmx.com> <CAB+znrF_d+Hg_A9AMvWEB=S5eVAtYrvr2jUPcvR4FfB4hnCMWA@mail.gmail.com>
 <bff1c7b3-5bac-9806-a376-3612057865cf@gmx.com> <CAB+znrHPF7963-MAXtgu8s3+vLEA7ENE0=uCCJ6sWCF6KUWToQ@mail.gmail.com>
 <bb0df6b1-3780-8ea5-b48e-e82f65a68f60@gmx.com> <CAB+znrEcW3+++ZBrB_ZGRFncssO-zffbJ6ug8_z0DJOhbp+vGA@mail.gmail.com>
 <f9694e69-ca47-57cd-3afb-2279bb79467a@gmx.com> <CAB+znrHAKZ8TOTBtd3AtUJCZqcC77+m41sq+zMB12w=oWY0trw@mail.gmail.com>
 <df3b2ffd-2188-0f14-1ff0-afb98ffb70a9@gmx.com> <CAB+znrEfAA4FSspB8-ACUXXuFp8wOCDr_mH9Xth_snkvUmHQYw@mail.gmail.com>
 <CAB+znrEEO+-L-Fn2u=tNSXXEhLLS1_a1aFTzG_AeA5tYinsUOg@mail.gmail.com> <31f77b2f-4110-9868-2c6b-abf40ccef316@gmx.com>
From: Michael Wade <spikewade@gmail.com>
Date: Sat, 19 May 2018 12:43:16 +0100
Message-ID: <CAB+znrHU5ca73AMFEBVD5OkJSgPE=7Eyk8wQdzYM9UrdAfEVug@mail.gmail.com>
Subject: Re: BTRFS RAID filesystem unmountable
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I have let the find root command run for 14+ days, its produced a
pretty huge log file 1.6 GB but still hasn't completed. I think I will
start the process of reformatting my drives and starting over.

Thanks for your help anyway.

Kind regards
Michael

On 5 May 2018 at 01:43, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>
>
> On 2018年05月05日 00:18, Michael Wade wrote:
>> Hi Qu,
>>
>> The tool is still running and the log file is now ~300mb. I guess it
>> shouldn't normally take this long.. Is there anything else worth
>> trying?
>
> I'm afraid not much.
>
> Although there is a possibility to modify btrfs-find-root to do much
> faster but limited search.
>
> But from the result, it looks like underlying device corruption, and not
> much we can do right now.
>
> Thanks,
> Qu
>
>>
>> Kind regards
>> Michael
>>
>> On 2 May 2018 at 06:29, Michael Wade <spikewade@gmail.com> wrote:
>>> Thanks Qu,
>>>
>>> I actually aborted the run with the old btrfs tools once I saw its
>>> output. The new btrfs tools is still running and has produced a log
>>> file of ~85mb filled with that content so far.
>>>
>>> Kind regards
>>> Michael
>>>
>>> On 2 May 2018 at 02:31, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>>>>
>>>>
>>>> On 2018年05月01日 23:50, Michael Wade wrote:
>>>>> Hi Qu,
>>>>>
>>>>> Oh dear that is not good news!
>>>>>
>>>>> I have been running the find root command since yesterday but it only
>>>>> seems to be only be outputting the following message:
>>>>>
>>>>> ERROR: tree block bytenr 0 is not aligned to sectorsize 4096
>>>>
>>>> It's mostly fine, as find-root will go through all tree blocks and try
>>>> to read them as tree blocks.
>>>> Although btrfs-find-root will suppress csum error output, but such basic
>>>> tree validation check is not suppressed, thus you get such message.
>>>>
>>>>> ERROR: tree block bytenr 0 is not aligned to sectorsize 4096
>>>>> ERROR: tree block bytenr 0 is not aligned to sectorsize 4096
>>>>> ERROR: tree block bytenr 0 is not aligned to sectorsize 4096
>>>>> ERROR: tree block bytenr 0 is not aligned to sectorsize 4096
>>>>> ERROR: tree block bytenr 0 is not aligned to sectorsize 4096
>>>>> ERROR: tree block bytenr 0 is not aligned to sectorsize 4096
>>>>> ERROR: tree block bytenr 0 is not aligned to sectorsize 4096
>>>>> ERROR: tree block bytenr 0 is not aligned to sectorsize 4096
>>>>> ERROR: tree block bytenr 0 is not aligned to sectorsize 4096
>>>>>
>>>>> I tried with the latest btrfs tools compiled from source and the ones
>>>>> I have installed with the same result. Is there a CLI utility I could
>>>>> use to determine if the log contains any other content?
>>>>
>>>> Did it report any useful info at the end?
>>>>
>>>> Thanks,
>>>> Qu
>>>>
>>>>>
>>>>> Kind regards
>>>>> Michael
>>>>>
>>>>>
>>>>> On 30 April 2018 at 04:02, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>>>>>>
>>>>>>
>>>>>> On 2018年04月29日 22:08, Michael Wade wrote:
>>>>>>> Hi Qu,
>>>>>>>
>>>>>>> Got this error message:
>>>>>>>
>>>>>>> ./btrfs inspect dump-tree -b 20800943685632 /dev/md127
>>>>>>> btrfs-progs v4.16.1
>>>>>>> bytenr mismatch, want=20800943685632, have=3118598835113619663
>>>>>>> ERROR: cannot read chunk root
>>>>>>> ERROR: unable to open /dev/md127
>>>>>>>
>>>>>>> I have attached the dumps for:
>>>>>>>
>>>>>>> dd if=/dev/md127 of=/tmp/chunk_root.copy1 bs=1 count=32K skip=266325721088
>>>>>>> dd if=/dev/md127 of=/tmp/chunk_root.copy2 bs=1 count=32K skip=266359275520
>>>>>>
>>>>>> Unfortunately, both dumps are corrupted and contain mostly garbage.
>>>>>> I think it's the underlying stack (mdraid) has something wrong or failed
>>>>>> to recover its data.
>>>>>>
>>>>>> This means your last chance will be btrfs-find-root.
>>>>>>
>>>>>> Please try:
>>>>>> # btrfs-find-root -o 3 <device>
>>>>>>
>>>>>> And provide all the output.
>>>>>>
>>>>>> But please keep in mind, chunk root is a critical tree, and so far it's
>>>>>> already heavily damaged.
>>>>>> Although I could still continue try to recover, there is pretty low
>>>>>> chance now.
>>>>>>
>>>>>> Thanks,
>>>>>> Qu
>>>>>>>
>>>>>>> Kind regards
>>>>>>> Michael
>>>>>>>
>>>>>>>
>>>>>>> On 29 April 2018 at 10:33, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>>>>>>>>
>>>>>>>>
>>>>>>>> On 2018年04月29日 16:59, Michael Wade wrote:
>>>>>>>>> Ok, will it be possible for me to install the new version of the tools
>>>>>>>>> on my current kernel without overriding the existing install? Hesitant
>>>>>>>>> to update kernel/btrfs as it might break the ReadyNAS interface /
>>>>>>>>> future firmware upgrades.
>>>>>>>>>
>>>>>>>>> Perhaps I could grab this:
>>>>>>>>> https://github.com/kdave/btrfs-progs/releases/tag/v4.16.1 and
>>>>>>>>> hopefully build from source and then run the binaries directly?
>>>>>>>>
>>>>>>>> Of course, that's how most of us test btrfs-progs builds.
>>>>>>>>
>>>>>>>> Thanks,
>>>>>>>> Qu
>>>>>>>>
>>>>>>>>>
>>>>>>>>> Kind regards
>>>>>>>>>
>>>>>>>>> On 29 April 2018 at 09:33, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>> On 2018年04月29日 16:11, Michael Wade wrote:
>>>>>>>>>>> Thanks Qu,
>>>>>>>>>>>
>>>>>>>>>>> Please find attached the log file for the chunk recover command.
>>>>>>>>>>
>>>>>>>>>> Strangely, btrfs chunk recovery found no extra chunk beyond current
>>>>>>>>>> system chunk range.
>>>>>>>>>>
>>>>>>>>>> Which means, it's chunk tree corrupted.
>>>>>>>>>>
>>>>>>>>>> Please dump the chunk tree with latest btrfs-progs (which provides the
>>>>>>>>>> new --follow option).
>>>>>>>>>>
>>>>>>>>>> # btrfs inspect dump-tree -b 20800943685632 <device>
>>>>>>>>>>
>>>>>>>>>> If it doesn't work, please provide the following binary dump:
>>>>>>>>>>
>>>>>>>>>> # dd if=<dev> of=/tmp/chunk_root.copy1 bs=1 count=32K skip=266325721088
>>>>>>>>>> # dd if=<dev> of=/tmp/chunk_root.copy2 bs=1 count=32K skip=266359275520
>>>>>>>>>> (And will need to repeat similar dump for several times according to
>>>>>>>>>> above dump)
>>>>>>>>>>
>>>>>>>>>> Thanks,
>>>>>>>>>> Qu
>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>>>
>>>>>>>>>>> Kind regards
>>>>>>>>>>> Michael
>>>>>>>>>>>
>>>>>>>>>>> On 28 April 2018 at 12:38, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>>>>>>>>>>>>
>>>>>>>>>>>>
>>>>>>>>>>>> On 2018年04月28日 17:37, Michael Wade wrote:
>>>>>>>>>>>>> Hi Qu,
>>>>>>>>>>>>>
>>>>>>>>>>>>> Thanks for your reply. I will investigate upgrading the kernel,
>>>>>>>>>>>>> however I worry that future ReadyNAS firmware upgrades would fail on a
>>>>>>>>>>>>> newer kernel version (I don't have much linux experience so maybe my
>>>>>>>>>>>>> concerns are unfounded!?).
>>>>>>>>>>>>>
>>>>>>>>>>>>> I have attached the output of the dump super command.
>>>>>>>>>>>>>
>>>>>>>>>>>>> I did actually run chunk recover before, without the verbose option,
>>>>>>>>>>>>> it took around 24 hours to finish but did not resolve my issue. Happy
>>>>>>>>>>>>> to start that again if you need its output.
>>>>>>>>>>>>
>>>>>>>>>>>> The system chunk only contains the following chunks:
>>>>>>>>>>>> [0, 4194304]:           Initial temporary chunk, not used at all
>>>>>>>>>>>> [20971520, 29360128]:   System chunk created by mkfs, should be full
>>>>>>>>>>>>                         used up
>>>>>>>>>>>> [20800943685632, 20800977240064]:
>>>>>>>>>>>>                         The newly created large system chunk.
>>>>>>>>>>>>
>>>>>>>>>>>> The chunk root is still in 2nd chunk thus valid, but some of its leaf is
>>>>>>>>>>>> out of the range.
>>>>>>>>>>>>
>>>>>>>>>>>> If you can't wait 24h for chunk recovery to run, my advice would be move
>>>>>>>>>>>> the disk to some other computer, and use latest btrfs-progs to execute
>>>>>>>>>>>> the following command:
>>>>>>>>>>>>
>>>>>>>>>>>> # btrfs inpsect dump-tree -b 20800943685632 --follow
>>>>>>>>>>>>
>>>>>>>>>>>> If we're lucky enough, we may read out the tree leaf containing the new
>>>>>>>>>>>> system chunk and save a day.
>>>>>>>>>>>>
>>>>>>>>>>>> Thanks,
>>>>>>>>>>>> Qu
>>>>>>>>>>>>
>>>>>>>>>>>>>
>>>>>>>>>>>>> Thanks so much for your help.
>>>>>>>>>>>>>
>>>>>>>>>>>>> Kind regards
>>>>>>>>>>>>> Michael
>>>>>>>>>>>>>
>>>>>>>>>>>>> On 28 April 2018 at 09:45, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>>>>>>>>>>>>>>
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> On 2018年04月28日 16:30, Michael Wade wrote:
>>>>>>>>>>>>>>> Hi all,
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> I was hoping that someone would be able to help me resolve the issues
>>>>>>>>>>>>>>> I am having with my ReadyNAS BTRFS volume. Basically my trouble
>>>>>>>>>>>>>>> started after a power cut, subsequently the volume would not mount.
>>>>>>>>>>>>>>> Here are the details of my setup as it is at the moment:
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> uname -a
>>>>>>>>>>>>>>> Linux QAI 4.4.116.alpine.1 #1 SMP Mon Feb 19 21:58:38 PST 2018 armv7l GNU/Linux
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> The kernel is pretty old for btrfs.
>>>>>>>>>>>>>> Strongly recommended to upgrade.
>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> btrfs --version
>>>>>>>>>>>>>>> btrfs-progs v4.12
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> So is the user tools.
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> Although I think it won't be a big problem, as needed tool should be there.
>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> btrfs fi show
>>>>>>>>>>>>>>> Label: '11baed92:data'  uuid: 20628cda-d98f-4f85-955c-932a367f8821
>>>>>>>>>>>>>>> Total devices 1 FS bytes used 5.12TiB
>>>>>>>>>>>>>>> devid    1 size 7.27TiB used 6.24TiB path /dev/md127
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> So, it's btrfs on mdraid.
>>>>>>>>>>>>>> It would normally make things harder to debug, so I could only provide
>>>>>>>>>>>>>> advice from the respect of btrfs.
>>>>>>>>>>>>>> For mdraid part, I can't ensure anything.
>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> Here are the relevant dmesg logs for the current state of the device:
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> [   19.119391] md: md127 stopped.
>>>>>>>>>>>>>>> [   19.120841] md: bind<sdb3>
>>>>>>>>>>>>>>> [   19.121120] md: bind<sdc3>
>>>>>>>>>>>>>>> [   19.121380] md: bind<sda3>
>>>>>>>>>>>>>>> [   19.125535] md/raid:md127: device sda3 operational as raid disk 0
>>>>>>>>>>>>>>> [   19.125547] md/raid:md127: device sdc3 operational as raid disk 2
>>>>>>>>>>>>>>> [   19.125554] md/raid:md127: device sdb3 operational as raid disk 1
>>>>>>>>>>>>>>> [   19.126712] md/raid:md127: allocated 3240kB
>>>>>>>>>>>>>>> [   19.126778] md/raid:md127: raid level 5 active with 3 out of 3
>>>>>>>>>>>>>>> devices, algorithm 2
>>>>>>>>>>>>>>> [   19.126784] RAID conf printout:
>>>>>>>>>>>>>>> [   19.126789]  --- level:5 rd:3 wd:3
>>>>>>>>>>>>>>> [   19.126794]  disk 0, o:1, dev:sda3
>>>>>>>>>>>>>>> [   19.126799]  disk 1, o:1, dev:sdb3
>>>>>>>>>>>>>>> [   19.126804]  disk 2, o:1, dev:sdc3
>>>>>>>>>>>>>>> [   19.128118] md127: detected capacity change from 0 to 7991637573632
>>>>>>>>>>>>>>> [   19.395112] Adding 523708k swap on /dev/md1.  Priority:-1 extents:1
>>>>>>>>>>>>>>> across:523708k
>>>>>>>>>>>>>>> [   19.434956] BTRFS: device label 11baed92:data devid 1 transid
>>>>>>>>>>>>>>> 151800 /dev/md127
>>>>>>>>>>>>>>> [   19.739276] BTRFS info (device md127): setting nodatasum
>>>>>>>>>>>>>>> [   19.740440] BTRFS critical (device md127): unable to find logical
>>>>>>>>>>>>>>> 3208757641216 len 4096
>>>>>>>>>>>>>>> [   19.740450] BTRFS critical (device md127): unable to find logical
>>>>>>>>>>>>>>> 3208757641216 len 4096
>>>>>>>>>>>>>>> [   19.740498] BTRFS critical (device md127): unable to find logical
>>>>>>>>>>>>>>> 3208757641216 len 4096
>>>>>>>>>>>>>>> [   19.740512] BTRFS critical (device md127): unable to find logical
>>>>>>>>>>>>>>> 3208757641216 len 4096
>>>>>>>>>>>>>>> [   19.740552] BTRFS critical (device md127): unable to find logical
>>>>>>>>>>>>>>> 3208757641216 len 4096
>>>>>>>>>>>>>>> [   19.740560] BTRFS critical (device md127): unable to find logical
>>>>>>>>>>>>>>> 3208757641216 len 4096
>>>>>>>>>>>>>>> [   19.740576] BTRFS error (device md127): failed to read chunk root
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> This shows it pretty clear, btrfs fails to read chunk root.
>>>>>>>>>>>>>> And according your above "len 4096" it's pretty old fs, as it's still
>>>>>>>>>>>>>> using 4K nodesize other than 16K nodesize.
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> According to above output, it means your superblock by somehow lacks the
>>>>>>>>>>>>>> needed system chunk mapping, which is used to initialize chunk mapping.
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> Please provide the following command output:
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> # btrfs inspect dump-super -fFa /dev/md127
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> Also, please consider run the following command and dump all its output:
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> # btrfs rescue chunk-recover -v /dev/md127.
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> Please note that, above command can take a long time to finish, and if
>>>>>>>>>>>>>> it works without problem, it may solve your problem.
>>>>>>>>>>>>>> But if it doesn't work, the output could help me to manually craft a fix
>>>>>>>>>>>>>> to your super block.
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> Thanks,
>>>>>>>>>>>>>> Qu
>>>>>>>>>>>>>>
>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> [   19.783975] BTRFS error (device md127): open_ctree failed
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> In an attempt to recover the volume myself I run a few BTRFS commands
>>>>>>>>>>>>>>> mostly using advice from here:
>>>>>>>>>>>>>>> https://lists.opensuse.org/opensuse/2017-02/msg00930.html. However
>>>>>>>>>>>>>>> that actually seems to have made things worse as I can no longer mount
>>>>>>>>>>>>>>> the file system, not even in readonly mode.
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> So starting from the beginning here is a list of things I have done so
>>>>>>>>>>>>>>> far (hopefully I remembered the order in which I ran them!)
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> 1. Noticed that my backups to the NAS were not running (didn't get
>>>>>>>>>>>>>>> notified that the volume had basically "died")
>>>>>>>>>>>>>>> 2. ReadyNAS UI indicated that the volume was inactive.
>>>>>>>>>>>>>>> 3. SSHed onto the box and found that the first drive was not marked as
>>>>>>>>>>>>>>> operational (log showed I/O errors / UNKOWN (0x2003))  so I replaced
>>>>>>>>>>>>>>> the disk and let the array resync.
>>>>>>>>>>>>>>> 4. After resync the volume still was unaccessible so I looked at the
>>>>>>>>>>>>>>> logs once more and saw something like the following which seemed to
>>>>>>>>>>>>>>> indicate that the replay log had been corrupted when the power went
>>>>>>>>>>>>>>> out:
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> BTRFS critical (device md127): corrupt leaf, non-root leaf's nritems
>>>>>>>>>>>>>>> is 0: block=232292352, root=7, slot=0
>>>>>>>>>>>>>>> BTRFS critical (device md127): corrupt leaf, non-root leaf's nritems
>>>>>>>>>>>>>>> is 0: block=232292352, root=7, slot=0
>>>>>>>>>>>>>>> BTRFS: error (device md127) in btrfs_replay_log:2524: errno=-5 IO
>>>>>>>>>>>>>>> failure (Failed to recover log tree)
>>>>>>>>>>>>>>> BTRFS error (device md127): pending csums is 155648
>>>>>>>>>>>>>>> BTRFS error (device md127): cleaner transaction attach returned -30
>>>>>>>>>>>>>>> BTRFS critical (device md127): corrupt leaf, non-root leaf's nritems
>>>>>>>>>>>>>>> is 0: block=232292352, root=7, slot=0
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> 5. Then:
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> btrfs rescue zero-log
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> 6. Was then able to mount the volume in readonly mode.
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> btrfs scrub start
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> Which fixed some errors but not all:
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> scrub status for 20628cda-d98f-4f85-955c-932a367f8821
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> scrub started at Tue Apr 24 17:27:44 2018, running for 04:00:34
>>>>>>>>>>>>>>> total bytes scrubbed: 224.26GiB with 6 errors
>>>>>>>>>>>>>>> error details: csum=6
>>>>>>>>>>>>>>> corrected errors: 0, uncorrectable errors: 6, unverified errors: 0
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> scrub status for 20628cda-d98f-4f85-955c-932a367f8821
>>>>>>>>>>>>>>> scrub started at Tue Apr 24 17:27:44 2018, running for 04:34:43
>>>>>>>>>>>>>>> total bytes scrubbed: 224.26GiB with 6 errors
>>>>>>>>>>>>>>> error details: csum=6
>>>>>>>>>>>>>>> corrected errors: 0, uncorrectable errors: 6, unverified errors: 0
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> 6. Seeing this hanging I rebooted the NAS
>>>>>>>>>>>>>>> 7. Think this is when the volume would not mount at all.
>>>>>>>>>>>>>>> 8. Seeing log entries like these:
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> BTRFS warning (device md127): checksum error at logical 20800943685632
>>>>>>>>>>>>>>> on dev /dev/md127, sector 520167424: metadata node (level 1) in tree 3
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> I ran
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> btrfs check --fix-crc
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> And that brings us to where I am now: Some seemly corrupted BTRFS
>>>>>>>>>>>>>>> metadata and unable to mount the drive even with the recovery option.
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> Any help you can give is much appreciated!
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> Kind regards
>>>>>>>>>>>>>>> Michael
>>>>>>>>>>>>>>> --
>>>>>>>>>>>>>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>>>>>>>>>>>>>> the body of a message to majordomo@vger.kernel.org
>>>>>>>>>>>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>
>>>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>> --
>>>>>>>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>>>>>>>> the body of a message to majordomo@vger.kernel.org
>>>>>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>>>>>>
>>>>>>>>
>>>>>>
>>>>
>
