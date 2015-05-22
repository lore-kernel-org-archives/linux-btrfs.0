Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:34774 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756230AbbEVARu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 May 2015 20:17:50 -0400
Received: by wghq2 with SMTP id q2so2906430wgh.1
        for <linux-btrfs@vger.kernel.org>; Thu, 21 May 2015 17:17:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAMtihapBO=uZhD2k=LwJu_+uPa9LNz1fW-rrqwW0_spVzwMoXQ@mail.gmail.com>
References: <CAMtiharLjfjEvgJaSvOru=NrxGcX754t9oLbxTMSngnF47ZQvA@mail.gmail.com>
	<CAMtihapRHKH-+f3TChO5Feoo54AiSdJcoCXn+D9Ee+7kF4x90w@mail.gmail.com>
	<555D47A4.1080808@cn.fujitsu.com>
	<CAMtihaq1OOfqLPDWg6jP2T9yLshAHbCAfL_FofWZuhHZKjgEuw@mail.gmail.com>
	<CAMtihapBO=uZhD2k=LwJu_+uPa9LNz1fW-rrqwW0_spVzwMoXQ@mail.gmail.com>
Date: Fri, 22 May 2015 10:17:48 +1000
Message-ID: <CA+WRLO_TULioDi8KMrW=BhxEj6AdHuzfdH0J2togwoHK4VNJHw@mail.gmail.com>
Subject: Re: BTRFS crash after flac tag writing
From: Gareth Pye <gareth@cerberos.id.au>
To: =?UTF-8?Q?Dani=C3=ABl_Sonck?= <dsonck92@gmail.com>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Maybe try switching the script to not use the 0 byte file to indicate
the directory is finished. That might let you determine if that is the
issue.

On Fri, May 22, 2015 at 10:06 AM, Daniël Sonck <dsonck92@gmail.com> wrote:
> I just ran the script two times, yes I can still produce it. The file
> my script eventually stops at is not the same file. I did not take
> note of the last "done.txt" file though, which could very well be
> around the same location.
>
> I'll look forward to any further instructions. In the mean time, since
> I can successfully tag every file by just letting it resume where it
> stopped, I will keep on managing my collection.
>
> Daniel
>
> 2015-05-22 0:59 GMT+02:00 Daniël Sonck <dsonck92@gmail.com>:
>> There are no files smaller than 4k that I write to during tagging, I
>> do write out 0 byte files to indicate the folder has been done if that
>> gives any useful information.
>>
>> To specifically say what this script is doing. I had a large
>> collection of tta rip files which I wanted to convert to individual
>> flac files. I already did my splitting but the tagger to write the
>> tags out was incomplete. So, now I'm retagging all the flac files by
>> going over the collection of cue files again and tagging each
>> individual flac file. Perhaps worth mentioning: it is a converted
>> partition from ext4. I started out on ext4, on which I performed the
>> mass splitting. Afterwards, I discovered btrfs and it's ability to
>> convert from ext4 so I converted it into btrfs. Then to discover the
>> mass tagging fails after a while.
>>
>> Well, I do have a slight remark to make, I *did* have pregap files
>> left over from splitting. I found out during manual correction of the
>> tags, these did get tags written to them and I don't know how large
>> those files were. I deleted those files recently because they messed
>> with the proper tagging (file "0" got the tags of file "1", etc.). I
>> will run the non parallelized version of the script which fails as
>> soon as it can't write out it's "done.txt" file and see if it stops at
>> the same files.
>>
>> In any case, thanks for the reply and new directions.
>>
>> Daniel
>>
>> 2015-05-21 4:49 GMT+02:00 Qu Wenruo <quwenruo@cn.fujitsu.com>:
>>>
>>>
>>> -------- Original Message  --------
>>> Subject: Re: BTRFS crash after flac tag writing
>>> From: Daniël Sonck <dsonck92@gmail.com>
>>> To: <linux-btrfs@vger.kernel.org>
>>> Date: 2015年05月20日 21:54
>>>
>>>> Extra information:
>>>> While I was trying to work around this issue, I found that it rarely
>>>> triggers during the whole process. If I resume the process, it seems
>>>> like it just doesn't like a few particular files it needs to tag. As I
>>>> can currently live with this state, I have no intention to dive deeper
>>>> into this on my own. However, if any of you suggest any particular
>>>> strategy to find out why this happens, I'm more than willing to help
>>>> find and squash this bug.
>>>>
>>>> As I just found out:
>>>> If I do the regular mass tagging from cue files, it hits the bug
>>>> twice, so I need to start the process three times.
>>>> If I do the mass tagging but first sort the cue file list to use
>>>> alphabetically, it hits the bug only once.
>>>>
>>>> To me it seems like a particular order of file alterations trigger this
>>>> bug.
>>>>
>>>> Daniel
>>>>
>>>> 2015-05-20 0:01 GMT+02:00 Daniël Sonck <dsonck92@gmail.com>:
>>>>>
>>>>> Hi all,
>>>>>
>>>>> My server streams music and I recently found the need to tag a lot of
>>>>> flac
>>>>> files automatically, this tagging process now triggers something in btrfs
>>>>> (which I only recently started to use). Below is the system information.
>>>>>
>>>>> I've looked whether my 8 concurrent writes were causing the issues or the
>>>>> sheer amount of data, even if I run only one metaflac instance at a time,
>>>>> this will still trigger.
>>>>>
>>>>> Daniel
>>>>>
>>>>> # uname -a
>>>>> Linux sakuya 4.0.2-gentoo-2-default #1 SMP Thu May 14 02:50:16 CEST 2015
>>>>> x86_64 AMD FX(tm)-8320 Eight-Core Processor AuthenticAMD GNU/Linux
>>>>>
>>>>> # btrfs --version
>>>>> btrfs-progs v4.0
>>>>>
>>>>> # btrfs fi show
>>>>> Label: none  uuid: f956cfd2-e851-42be-8943-d924c6c6e4e4
>>>>>          Total devices 1 FS bytes used 2.73TiB
>>>>>          devid    1 size 3.64TiB used 2.73TiB path /dev/sdd
>>>>>
>>>>> # btrfs fi df /storage/media-files3
>>>>> Data, single: total=2.73TiB, used=2.73TiB
>>>>> System, single: total=32.00MiB, used=320.00KiB
>>>>> Metadata, single: total=4.00GiB, used=2.97GiB
>>>>> GlobalReserve, single: total=512.00MiB, used=0.00B
>>>>>
>>>>> # dmesg
>>>>> [372349.284091] BTRFS info (device sdd): disk space caching is enabled
>>>>> [372668.321999] ------------[ cut here ]------------
>>>>> [372668.322060] WARNING: CPU: 1 PID: 23395 at fs/btrfs/super.c:260
>>>>> __btrfs_abort_transaction+0x5f/0x130 [btrfs]()
>>>>> [372668.322147] BTRFS: Transaction aborted (error -95)
>>>>> [372668.322152] Modules linked in: btrfs xor raid6_pq binfmt_misc
>>>>> af_packet
>>>>> ipt_REJECT nf_reject_ipv4 xt_conntrack iptable_filter ipt_MASQUERADE
>>>>> nf_nat_masquerade_ipv4 xt_nat xt_tcpudp iptable_nat nf_conntrack_ipv4
>>>>> nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack bridge stp llc ip_tables
>>>>> x_tables joydev hid_generic usbhid xhci_pci xhci_hcd ohci_pci
>>>>> snd_hda_codec_via snd_hda_codec_generic ehci_pci snd_hda_codec_hdmi
>>>>> ohci_hcd
>>>>> ehci_hcd usbcore snd_hda_intel snd_hda_controller snd_hda_codec kvm_amd
>>>>> kvm
>>>>> snd_hwdep crct10dif_pclmul snd_pcm crc32_pclmul crc32c_intel ppdev
>>>>> ghash_clmulni_intel aesni_intel aes_x86_64 lrw snd_timer e1000 gf128mul
>>>>> glue_helper r8169 ablk_helper snd parport_pc mii cryptd serio_raw parport
>>>>> shpchp pcspkr edac_core sp5100_tco usb_common button fam15h_power wmi
>>>>> i2c_piix4 edac_mce_amd soundcore
>>>>> [372668.322610]  k10temp asus_atk0110 acpi_cpufreq processor sch_fq_codel
>>>>> [372668.322652] CPU: 1 PID: 23395 Comm: kworker/u16:3 Tainted: G        W
>>>>> 4.0.2-gentoo-2-default #1
>>>>> [372668.322721] Hardware name: System manufacturer System Product
>>>>> Name/M5A78L-M/USB3, BIOS 2001    09/11/2014
>>>>> [372668.322803] Workqueue: btrfs-endio-write btrfs_endio_write_helper
>>>>> [btrfs]
>>>>> [372668.322840]  ffffffffa04bfe32 ffff8801e8937c08 ffffffff816edc91
>>>>> 0000000000000007
>>>>> [372668.322911]  ffff8801e8937c58 ffff8801e8937c48 ffffffff81056675
>>>>> ffff8801e8937ce8
>>>>> [372668.322986]  ffff8803ad83fd28 00000000ffffffa1 ffff880147d2a800
>>>>> ffffffffa04bea60
>>>>> [372668.323058] Call Trace:
>>>>> [372668.323097]  [<ffffffff816edc91>] dump_stack+0x45/0x57
>>>>> [372668.323134]  [<ffffffff81056675>] warn_slowpath_common+0x95/0xe0
>>>>> [372668.323171]  [<ffffffff81056706>] warn_slowpath_fmt+0x46/0x50
>>>>> [372668.323219]  [<ffffffffa0454e65>] ? try_merge_map+0x45/0x150 [btrfs]
>>>>> [372668.323261]  [<ffffffffa040f46f>]
>>>>> __btrfs_abort_transaction+0x5f/0x130
>>>>> [btrfs]
>>>>> [372668.323339]  [<ffffffffa0447b82>] btrfs_finish_ordered_io+0x552/0x5e0
>>>>> [btrfs]
>>>>> [372668.323418]  [<ffffffffa0447e85>] finish_ordered_fn+0x15/0x20 [btrfs]
>>>>> [372668.323466]  [<ffffffffa046f168>] normal_work_helper+0xb8/0x2a0
>>>>> [btrfs]
>>>>> [372668.323515]  [<ffffffffa046f4e2>] btrfs_endio_write_helper+0x12/0x20
>>>>> [btrfs]
>>>>> [372668.323552]  [<ffffffff8106ed63>] process_one_work+0x153/0x410
>>>>> [372668.323589]  [<ffffffff8106f7bb>] worker_thread+0x6b/0x480
>>>>> [372668.323693]  [<ffffffff8106f750>] ? rescuer_thread+0x300/0x300
>>>>> [372668.323730]  [<ffffffff8107473b>] kthread+0xdb/0x100
>>>>> [372668.323767]  [<ffffffff81074660>] ?
>>>>> kthread_create_on_node+0x190/0x190
>>>>> [372668.323805]  [<ffffffff816f4218>] ret_from_fork+0x58/0x90
>>>>> [372668.323845]  [<ffffffff81074660>] ?
>>>>> kthread_create_on_node+0x190/0x190
>>>>> [372668.323885] ---[ end trace c0894b8b0ebe359e ]---
>>>>> [372668.323925] BTRFS: error (device sdd) in
>>>>> btrfs_finish_ordered_io:2896:
>>>>> errno=-95 unknown
>>>
>>> Abort transaction warning itself doesn't really help,
>>> but btrfs_finish_order_io and its errno seems interesting.
>>> Especially the errno, 95 is EOPNOTSUPP.
>>> A quick search leads me to inline extent -> regular extent change part.
>>>
>>> Also you mentioned cue tagging, I'm also curious about the size of your
>>> music files.
>>> Is there any files which is smaller or equal to 4K?
>>> If you only listen to loseless, then my guess would be wrong. :(
>>>
>>> BTW, it would be perfect if you find some consistent method to trigger
>>> the bug...
>>>
>>> Thanks,
>>> Qu
>>>>>
>>>>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>
>>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Gareth Pye
Level 2 MTG Judge, Melbourne, Australia
"Dear God, I would like to file a bug report"
