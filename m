Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:35037 "EHLO
        mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751804AbcH3G5j (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 Aug 2016 02:57:39 -0400
Received: by mail-wm0-f52.google.com with SMTP id f65so106563050wmi.0
        for <linux-btrfs@vger.kernel.org>; Mon, 29 Aug 2016 23:57:38 -0700 (PDT)
MIME-Version: 1.0
Reply-To: h.gersen@gmail.com
In-Reply-To: <CANhjow9n6FqHpK8y2zvfwq8-ptVHJMs4=+tP1qy1hNu-5veF3g@mail.gmail.com>
References: <CAGf6y9gUcEqMDnuhnE77edUja-LdkaEGpoY3pNL5+vrmq3K7tA@mail.gmail.com>
 <CANhjow9n6FqHpK8y2zvfwq8-ptVHJMs4=+tP1qy1hNu-5veF3g@mail.gmail.com>
From: henkjan gersen <h.gersen@gmail.com>
Date: Tue, 30 Aug 2016 07:57:35 +0100
Message-ID: <CAGf6y9jQvi5Ev1KJ3Ksci8bnm6EneDW30FbdDgXSNjDM7gVTww@mail.gmail.com>
Subject: Re: Raid 5 to raid 1: balance hangs and scrub aborts. Is this salvageable?
To: Justin Kilpatrick <jkilpatr@redhat.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks for the response Justin. This is exactly what I tried before
posting to the list, but it doesn't seem to get me anywhere. The
moment I hit the logical address that is flagged up in btrfs check as
problematic the balancing operation just sits there and does nothing,
but the operation also can't be canceled. (scrub aborts at that same
logical address)

For example:

root@quasar:~] # btrfs balance start -mconvert=raid1,soft /storage/

The corresponding output in dmegs is below. Note that the line with
455 extends doesn't repeat, which is where the process gets stuck.

[  534.686123] BTRFS info (device sde): relocating block group
135393234714624 flags 257
[  536.387826] BTRFS info (device sde): found 65 extents
[  537.871757] BTRFS info (device sde): found 65 extents
[  538.790607] BTRFS info (device sde): relocating block group
95050853777408 flags 257
[  557.759729] BTRFS warning (device sde): sde checksum verify failed
on 99586523447296 wanted D883E9B found DF677297 level 0
[  557.759851] BTRFS warning (device sde): sde checksum verify failed
on 99586523447296 wanted D883E9B found DF677297 level 0
[  557.760084] BTRFS warning (device sde): sde checksum verify failed
on 99586523447296 wanted D883E9B found DF677297 level 0
[  557.760200] BTRFS warning (device sde): sde checksum verify failed
on 99586523447296 wanted D883E9B found DF677297 level 0
[  557.760391] BTRFS warning (device sde): sde checksum verify failed
on 99586523447296 wanted D883E9B found DF677297 level 0
[  557.760483] BTRFS warning (device sde): sde checksum verify failed
on 99586523447296 wanted D883E9B found DF677297 level 0
[  557.760662] BTRFS warning (device sde): sde checksum verify failed
on 99586523447296 wanted D883E9B found DF677297 level 0
[  557.760738] BTRFS warning (device sde): sde checksum verify failed
on 99586523447296 wanted D883E9B found DF677297 level 0
[  557.760951] BTRFS warning (device sde): sde checksum verify failed
on 99586523447296 wanted D883E9B found DF677297 level 0
[  557.761028] BTRFS warning (device sde): sde checksum verify failed
on 99586523447296 wanted D883E9B found DF677297 level 0
[  566.281448] BTRFS info (device sde): found 455 extents
[  566.837080] csum_tree_block: 8104 callbacks suppressed
[  566.837087] BTRFS warning (device sde): sde checksum verify failed
on 99586523447296 wanted D883E9B found DF677297 level 0
[  566.837228] BTRFS warning (device sde): sde checksum verify failed
on 99586523447296 wanted D883E9B found DF677297 level 0
[  584.440088] BTRFS info (device sde): relocating block group
99586147418112 flags 132

I can request to cancel the operation, which gets picked up. However
the balancing doesn't actually stop, probably because it is in the
process of relocating a block

[root@quasar:~] # btrfs balance status /storage/
Balance on '/storage/' is running, cancel requested
0 out of about 4 chunks balanced (9738 considered), 100% left

This happens for both metadata and actual data and the only way out is
forcing a hard reboot (=reset switch). My hope would be that I could
delete the file corresponding to the offending logical address, but I
can't find out what that logical address corresponds to.


On 29 August 2016 at 12:41, Justin Kilpatrick <jkilpatr@redhat.com> wrote:
> I converted my significantly smaller raid 5 array to raid 1 a little
> less than a year ago now and I encountered some similar issues.
>
> What i ended up doing was starting balance again and again with
> slightly different arguments (usually thresholds for what blocks to
> move) and eventually (a week or two, even with a small array) I
> managed a full conversion with only some data loss, which I was able
> to find and correct from backups with scrub.
>
> On Mon, Aug 29, 2016 at 5:57 AM, henkjan gersen <h.gersen@gmail.com> wrote:
>> Following the recent posts on the mailing list I'm trying to convert a
>> running raid5 system to raid1. This conversion  fails to complete with
>> checksum verify failures. Running a scrub does not fix these checksum
>> failures and moreover scrub itself aborts after ~9TB (despite repeated
>> tries).
>>
>> All disks in the array complete a long smartctl test without any
>> errors. Running a scrub after remounting the array with the
>> recovery-option also makes no difference, it still aborts. For
>> clarity:  I can mount the array without issues and copying all files
>> and directories to /dev/zero completes without any errors in the logs.
>>
>> Any suggestions on how to salvage the array would be highly
>> appreciated as I'm out of options/ideas for this. I do have a backup
>> of the important bits, but still restoring it will take time.
>>
>> The information of the system:
>>
>> --
>>
>> Linux-kernel: 4.4.6 (Slackware)
>> btrfs-progs v4.5.3
>>
>> [root@quasar:~] # btrfs fi show
>> Label: 'btr_pool2'  uuid: 7c9b2b91-1e89-45fe-8726-91a97663bb5c
>>     Total devices 7 FS bytes used 9.97TiB
>>     devid    3 size 3.64TiB used 3.34TiB path /dev/sdh
>>     devid    4 size 3.64TiB used 3.34TiB path /dev/sdd
>>     devid    5 size 1.82TiB used 1.53TiB path /dev/sdb
>>     devid    6 size 1.82TiB used 1.53TiB path /dev/sdc
>>     devid    7 size 3.64TiB used 3.34TiB path /dev/sdg
>>     devid   10 size 3.64TiB used 3.34TiB path /dev/sde
>>     devid   11 size 3.64TiB used 3.34TiB path /dev/sdf
>>
>> [root@quasar:~] # btrfs fi df /storage
>> Data, RAID1: total=9.50TiB, used=9.48TiB
>> Data, RAID5: total=1.72GiB, used=1.72GiB
>> Data, RAID6: total=496.76GiB, used=490.45GiB
>> System, RAID1: total=32.00MiB, used=1.44MiB
>> Metadata, RAID1: total=10.00GiB, used=7.68GiB
>> Metadata, RAID5: total=4.09GiB, used=3.22GiB
>> GlobalReserve, single: total=512.00MiB, used=0.00B
>>
>> --
>>
>> The mixture of raid1 and raid5 is the result of the balancing
>> operation stopping. If I try to restart the balance with the
>> soft-option it aborts when balancing only meta-data. For the
>> datablocks it hangs with no IO-activity in iostat for many hours once
>> hitting the logical address that fails checksum verify
>>
>> The output from the scrub operation shows that it almost fully
>> completes. Note how the errors are on a different devices than flagged
>> up in dmesg when given per device.
>>
>> --
>>
>> [root@quasar:~] # btrfs scrub status /storage/
>> scrub status for 7c9b2b91-1e89-45fe-8726-91a97663bb5c
>>     scrub started at Sun Aug 28 14:58:27 2016 and was aborted after 08:15:15
>>     total bytes scrubbed: 8.91TiB with 33 errors
>>     error details: read=32 csum=1
>>     corrected errors: 0, uncorrectable errors: 33, unverified errors: 0
>>
>> [root@quasar:~] # btrfs scrub status -d /storage/
>> scrub status for 7c9b2b91-1e89-45fe-8726-91a97663bb5c
>> scrub device /dev/sdh (id 3) history
>>     scrub started at Sun Aug 28 14:58:27 2016 and was aborted after 01:04:54
>>     total bytes scrubbed: 429.36GiB with 0 errors
>> scrub device /dev/sdd (id 4) history
>>     scrub started at Sun Aug 28 14:58:27 2016 and was aborted after 01:04:24
>>     total bytes scrubbed: 425.46GiB with 16 errors
>>     error details: read=16
>>     corrected errors: 0, uncorrectable errors: 16, unverified errors: 0
>> scrub device /dev/sdb (id 5) history
>>     scrub started at Sun Aug 28 14:58:27 2016 and finished after 08:15:15
>>     total bytes scrubbed: 1.52TiB with 0 errors
>> scrub device /dev/sdc (id 6) history
>>     scrub started at Sun Aug 28 14:58:27 2016 and finished after 08:02:51
>>     total bytes scrubbed: 1.52TiB with 1 errors
>>     error details: csum=1
>>     corrected errors: 0, uncorrectable errors: 1, unverified errors: 0
>> scrub device /dev/sdg (id 7) history
>>     scrub started at Sun Aug 28 14:58:27 2016 and was aborted after 03:07:32
>>     total bytes scrubbed: 1.16TiB with 0 errors
>> scrub device /dev/sde (id 10) history
>>     scrub started at Sun Aug 28 14:58:27 2016 and was aborted after 06:51:31
>>     total bytes scrubbed: 1.94TiB with 0 errors
>> scrub device /dev/sdf (id 11) history
>>     scrub started at Sun Aug 28 14:58:27 2016 and was aborted after 06:03:00
>>     total bytes scrubbed: 1.94TiB with 16 errors
>>     error details: read=16
>>     corrected errors: 0, uncorrectable errors: 16, unverified errors: 0
>>
>> --
>>
>> The relevant chunk from dmesg when mounting the array itself. I'm not
>> sure what the corrupt errs for device sdb and sdc are as there seems
>> no documentation for it. Both drives pass a smartctl -t long without
>> errors as said.
>>
>> I needed to reboot when the balancing hanged, but errors in dmesg
>> looked similar to these.
>>
>> --
>>
>> [ 1067.179062] BTRFS info (device sde): disk space caching is enabled
>> [ 1067.414416] BTRFS info (device sde): bdev /dev/sdc errs: wr 0, rd
>> 0, flush 0, corrupt 47, gen 0
>> [ 1067.414423] BTRFS info (device sde): bdev /dev/sdb errs: wr 0, rd
>> 0, flush 0, corrupt 337, gen 0
>> [ 1111.375181] BTRFS: checking UUID tree
>> [ 1111.375206] BTRFS info (device sde): continuing balance
>> [ 1116.413445] BTRFS info (device sde): relocating block group
>> 95050853777408 flags 257
>> [ 1134.882061] BTRFS warning (device sde): sde checksum verify failed
>> on 99586523447296 wanted D883E9B found DF677297 level 0
>> [ 1135.032077] BTRFS warning (device sde): sde checksum verify failed
>> on 99586523447296 wanted D883E9B found DF677297 level 0
>> [ 1135.032318] BTRFS warning (device sde): sde checksum verify failed
>> on 99586523447296 wanted D883E9B found DF677297 level 0
>> [ 1135.032455] BTRFS warning (device sde): sde checksum verify failed
>> on 99586523447296 wanted D883E9B found DF677297 level 0
>> [ 1135.032646] BTRFS warning (device sde): sde checksum verify failed
>> on 99586523447296 wanted D883E9B found DF677297 level 0
>> [ 1135.032742] BTRFS warning (device sde): sde checksum verify failed
>> on 99586523447296 wanted D883E9B found DF677297 level 0
>> [ 1135.032907] BTRFS warning (device sde): sde checksum verify failed
>> on 99586523447296 wanted D883E9B found DF677297 level 0
>> [ 1135.033035] BTRFS warning (device sde): sde checksum verify failed
>> on 99586523447296 wanted D883E9B found DF677297 level 0
>> [ 1135.033227] BTRFS warning (device sde): sde checksum verify failed
>> on 99586523447296 wanted D883E9B found DF677297 level 0
>> [ 1135.033330] BTRFS warning (device sde): sde checksum verify failed
>> on 99586523447296 wanted D883E9B found DF677297 level 0
>> [ 1143.682132] BTRFS info (device sde): found 455 extents
>> [ 1143.823628] csum_tree_block: 8106 callbacks suppressed
>> [ 1143.823635] BTRFS warning (device sde): sde checksum verify failed
>> on 99586523447296 wanted D883E9B found DF677297 level 0
>> [ 1143.823754] BTRFS warning (device sde): sde checksum verify failed
>> on 99586523447296 wanted D883E9B found DF677297 level 0
>>
>> --
>>
>> The output of btrfs check shows checksum failures all relating to the
>> same logical address:
>>
>> --
>> [root@quasar:~] # btrfs check -p /dev/sdc
>> Checking filesystem on /dev/sdc
>> UUID: 7c9b2b91-1e89-45fe-8726-91a97663bb5c
>> checksum verify failed on 99586523447296 found DF677297 wanted 0D883E9B
>> checksum verify failed on 99586523447296 found DF677297 wanted 0D883E9B
>> checksum verify failed on 99586523447296 found 87B38132 wanted B1BF7088
>> checksum verify failed on 99586523447296 found 87B38132 wanted B1BF7088
>> bytenr mismatch, want=99586523447296, have=458752
>> owner ref check failed [99586523447296 16384]
>>
>> cache and super generation don't match, space cache will be invalidated
>> checksum verify failed on 99586523447296 found DF677297 wanted 0D883E9B
>> checksum verify failed on 99586523447296 found DF677297 wanted 0D883E9B
>> checksum verify failed on 99586523447296 found 87B38132 wanted B1BF7088
>> checksum verify failed on 99586523447296 found 87B38132 wanted B1BF7088
>> bytenr mismatch, want=99586523447296, have=458752
>> checking fs roots [O]
>> checking csums
>> checksum verify failed on 99586523447296 found DF677297 wanted 0D883E9B
>> checksum verify failed on 99586523447296 found DF677297 wanted 0D883E9B
>> checksum verify failed on 99586523447296 found 87B38132 wanted B1BF7088
>> checksum verify failed on 99586523447296 found 87B38132 wanted B1BF7088
>> bytenr mismatch, want=99586523447296, have=458752
>> Error going to next leaf -5
>> checking root refs
>> found 10966788235264 bytes used err is 0
>> total csum bytes: 10698166420
>> total tree bytes: 11712806912
>> total fs tree bytes: 405241856
>> total extent tree bytes: 265453568
>> btree space waste bytes: 347751364
>> file data blocks allocated: 10955252420608
>>  referenced 10992993153024
>>
>> --
>>
>> Trying to relate that logical address to any real file or directory
>> fail. I've seen messages on this mailing list that I would need to
>> give in subvolumes, but that doesn't seem to make any difference. That
>> gives me the same error
>>
>> --
>> [root@quasar:~] # btrfs inspect-internal logical-resolve
>> 99586523447296 /storage/
>> ERROR: logical ino ioctl: No such file or directory
>> --
>>
>> With the above things completed I've tried running btrfs check with
>> the repair enabled, but that crashes with an assertion failure. So
>> that doesn't help either.
>>
>> --
>>
>> [root@quasar:~] # btrfs check -p --repair /dev/sdc
>> enabling repair mode
>> Checking filesystem on /dev/sdc
>> UUID: 7c9b2b91-1e89-45fe-8726-91a97663bb5c
>> checksum verify failed on 99586523447296 found DF677297 wanted 0D883E9B
>> checksum verify failed on 99586523447296 found DF677297 wanted 0D883E9B
>> checksum verify failed on 99586523447296 found 87B38132 wanted B1BF7088
>> checksum verify failed on 99586523447296 found 87B38132 wanted B1BF7088
>> bytenr mismatch, want=99586523447296, have=458752
>> owner ref check failed [99586523447296 16384]
>> Unable to find block group for 0
>> extent-tree.c:289: find_search_start: Assertion `1` failed.
>> btrfs(btrfs_reserve_extent+0x993)[0x44ef37]
>> btrfs(btrfs_alloc_free_block+0x50)[0x44f2c7]
>> btrfs(__btrfs_cow_block+0x19d)[0x43eca8]
>> btrfs(btrfs_cow_block+0xec)[0x43f6ff]
>> btrfs(btrfs_search_slot+0x1b9)[0x442004]
>> btrfs[0x42080b]
>> btrfs[0x42a1e9]
>> btrfs(cmd_check+0x156e)[0x42c461]
>> btrfs(main+0x155)[0x40a75d]
>> /lib64/libc.so.6(__libc_start_main+0xf0)[0x7fb45d9b17d0]
>> btrfs(_start+0x29)[0x40a2e9]
>>
>> --
>> Any suggestion would be much appreciated. Thanks for getting this far
>> in reading!
>>
>> Best wishes,
>> Henkjan Gersen
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
