Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f49.google.com ([209.85.213.49]:55227 "EHLO
        mail-vk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751892AbdJYDnr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Oct 2017 23:43:47 -0400
Received: by mail-vk0-f49.google.com with SMTP id n70so14737475vkf.11
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Oct 2017 20:43:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAD8FQQ3boTj97yu-F8CiFBvR-EfD+1chcSo=VzyAxwO7GpomEg@mail.gmail.com>
References: <CAD8FQQ0tO3AZDDh89hczwZ1pL70uom5EBY2fbZWm_LDJAQE2UQ@mail.gmail.com>
 <CAD8FQQ3kBfy8kLFzSm-OVbsYsQ7-LzH0faD09__4S5_q0bM7pA@mail.gmail.com>
 <CAKuJGC-aRt_NKboYa9ZK6ApWDJ_knM-UazPxEUq7sHiNXEqA6w@mail.gmail.com>
 <CAD8FQQ20m3sgLKc_utf2xb-J6bhf1W58mAkEFc2jyJy7-bH3+w@mail.gmail.com> <CAD8FQQ3boTj97yu-F8CiFBvR-EfD+1chcSo=VzyAxwO7GpomEg@mail.gmail.com>
From: "Lakshmipathi.G" <lakshmipathi.g@gmail.com>
Date: Wed, 25 Oct 2017 09:13:06 +0530
Message-ID: <CAKuJGC8omM8TMg7DqncuoM6e0jdUOdiwNLU6q29z__U=2NQHvg@mail.gmail.com>
Subject: Re: btrfs send yields "ERROR: send ioctl failed with -5: Input/output error"
To: Zak Kohler <y2k@y2kbugger.com>
Cc: btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

1. I guess you should be able to dump tree details via
'btrfs-debug-tree' and then map the extent/data (from scrub
offline output) and track it back to inode-object. Store output of
both btrfs-debug-tree and scrub-offline in different files and then
play around with grep to extract required data.

2. I think normal scrub(online) fails to detect these csum errors for
some reason,I don't have much idea about online scrub.

3. I assume, the issue is not related to hardware. Since the offline
scrub able to get available (corrupted) csum.

Yes, offline scrub will try to fix corruption whenever it is possible.
And also you have quite lot of "all mirror(s) corrupted, can't be repaired",
which will be hard to recovery.

I suggest running offline scrub on all devices. Then online scrub
and finally track those corrupted files with the help of extent info.
----
Cheers,
Lakshmipathi.G
http://www.giis.co.in http://www.webminal.org


On Wed, Oct 25, 2017 at 7:22 AM, Zak Kohler <y2k@y2kbugger.com> wrote:
> I apologize for the bad line wrapping on the last post...will be
> setting up mutt soon.
>
> This is the final result for the offline scrub:
> Doing offline scrub [O] [681/683]
> Scrub result:
> Tree bytes scrubbed: 5234491392
> Tree extents scrubbed: 638975
> Data bytes scrubbed: 4353723572224
> Data extents scrubbed: 374300
> Data bytes without csum: 533200896
> Read error: 0
> Verify error: 0
> Csum error: 175
>
> The offline scrub apparently corrected some metadata extents while
> scanning /dev/sdn
>
>
> I also ran the online scrub directly on the /dev/sdn, "0 errors":
>
> $ btrfs scrub status /dev/sdn
> scrub status for 88406942-e3e1-42c6-ad71-e23bb315caa7
>         scrub started at Tue Oct 24 06:55:12 2017 and finished after 01:52:44
>         total bytes scrubbed: 677.35GiB with 0 errors
>
> The csum mismatches are still missed by the online scrub when choosing
> a single <device>. Now I am doing offline scrub on the other devices
> to see if they are clean.
>
> $ lsblk -o +SERIAL
> NAME      MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT SERIAL
> sdh         8:112  0  1.8T  0 disk             WD-WMAZA370XXXX
> sdi         8:128  0  1.8T  0 disk             WD-WCAZA569XXXX
> sdn         8:208  0  1.8T  0 disk             WD-WCAZA580XXXX
>
> $ btrfs scrub start --offline --progress /dev/sdh
> ERROR: data at bytenr 5365456896 ...
> ERROR: extent 5341712384 ...
> ...
>
> One thing to note is that a /dev/sdh is also having csum errors
> detected despite it having never been mentioned dmesg. I understand
> that you may have the ability to run two offline checks at once but
> the error message I get is slightly misleading.
>
> $ btrfs scrub start --offline --progress /dev/sdi
> ERROR: cannot open device '/dev/sdn': Device or resource busy
> ERROR: cannot open file system
>
> I get an error about sdn when the device I am trying to scan is sdi,
> and the device that is currently being scanned is sdh.
>
> On Tue, Oct 24, 2017 at 2:00 AM, Zak Kohler <y2k@y2kbugger.com> wrote:
>> Yes, it is finding much more than just one error.
>>
>> From dmesg
>> [89520.441354] BTRFS warning (device sdn): csum failed ino 4708 off
>> 27529216 csum 2615801759 expected csum 874979996
>>
>> $ sudo btrfs scrub start --offline --progress /dev/sdn
>> ERROR: data at bytenr 68431499264 mirror 1 csum mismatch, have
>> 0x5aa0d40f expect 0xd4a15873
>> ERROR: extent 68431474688 len 14467072 CORRUPTED, all mirror(s)
>> corrupted, can't be repaired
>> ERROR: data at bytenr 83646357504 mirror 1 csum mismatch, have
>> 0xfc0baabe expect 0x7f9cb681
>> ERROR: extent 83519741952 len 134217728 CORRUPTED, all mirror(s)
>> corrupted, can't be repaired
>> ERROR: data at bytenr 121936633856 mirror 1 csum mismatch, have
>> 0x507016a5 expect 0x50609afe
>> ERROR: extent 121858334720 len 134217728 CORRUPTED, all mirror(s)
>> corrupted, can't be repaired
>> ERROR: data at bytenr 144872591360 mirror 1 csum mismatch, have
>> 0x33964d73 expect 0xf9937032
>> ERROR: extent 144822386688 len 61231104 CORRUPTED, all mirror(s)
>> corrupted, can't be repaired
>> ERROR: data at bytenr 167961075712 mirror 1 csum mismatch, have
>> 0xf43bd0e3 expect 0x5be589bb
>> ERROR: extent 167950999552 len 27537408 CORRUPTED, all mirror(s)
>> corrupted, can't be repaired
>> ERROR: data at bytenr 175643619328 mirror 1 csum mismatch, have
>> 0x1e168ca1 expect 0xd413b1e0
>> ERROR: data at bytenr 175643754496 mirror 1 csum mismatch, have
>> 0x6cfdc8ae expect 0xa6f8f5ef
>> ERROR: extent 175640539136 len 6381568 CORRUPTED, all mirror(s)
>> corrupted, can't be repaired
>> ERROR: data at bytenr 183316750336 mirror 1 csum mismatch, have
>> 0x145bdf76 expect 0x7390565e
>> .....
>> and the list goes on.
>>
>>
>> Questions:
>> 1. Using "find /mnt -inum 4708" I can link the dmesg to a specific
>> file. Is there a
>> way link the the --offline ERRORs above to the inode?
>>
>> 2. How could do "btrfs device stats /mnt" and normal full scrub fail
>> to detect the csum errors?
>>
>> 3. Do these errors appear to be hardware failure (despite pristine
>> SMART), user error on
>> volume creation/mounting, or an actual btrfs issue? I feel that the
>> need for question #1
>> indicates a problem with btrfs regardless of whether there is a real
>> hardware failure or not.
>>
>>
>> Next I will try an online scrub of only the sdn device, as before I
>> was running the full filesystem scrub.
>>
>> On Tue, Oct 24, 2017 at 12:52 AM, Lakshmipathi.G
>> <lakshmipathi.g@gmail.com> wrote:
>>>> Does anyone know why scrub did not catch these errors that show up in dmesg?
>>>
>>> Can you try offline scrub from this repo
>>> https://github.com/gujx2017/btrfs-progs/tree/offline_scrub and see
>>> whether it
>>> detects the issue?  "btrfs scrub start --offline <dev>"
>>>
>>>
>>> ----
>>> Cheers,
>>> Lakshmipathi.G
>>> http://www.giis.co.in http://www.webminal.org
