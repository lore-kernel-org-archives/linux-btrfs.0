Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f176.google.com ([209.85.217.176]:44337 "EHLO
        mail-ua0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755508AbdKNOLI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Nov 2017 09:11:08 -0500
Received: by mail-ua0-f176.google.com with SMTP id u18so3784274uau.1
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Nov 2017 06:11:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <49ad80b3-2138-632d-3ea9-6de31c56ad7f@gmail.com>
References: <CAFTHvW9OmWApkzJ=s51Saq=cwv24hBqe0bzhR55Yv2+fAANH-Q@mail.gmail.com>
 <49ad80b3-2138-632d-3ea9-6de31c56ad7f@gmail.com>
From: Klaus Agnoletti <klaus@agnoletti.dk>
Date: Tue, 14 Nov 2017 15:10:46 +0100
Message-ID: <CAFTHvW_zZeWUphuC-qvZsNtvSzvYtkB6Yr3LGBvSxAhpOF00AA@mail.gmail.com>
Subject: Re: A partially failing disk in raid0 needs replacement
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Austin

Good points. Thanks a lot.

/klaus

On Tue, Nov 14, 2017 at 2:14 PM, Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:
> On 2017-11-14 03:36, Klaus Agnoletti wrote:
>>
>> Hi list
>>
>> I used to have 3x2TB in a btrfs in raid0. A few weeks ago, one of the
>> 2TB disks started giving me I/O errors in dmesg like this:
>>
>> [388659.173819] ata5.00: exception Emask 0x0 SAct 0x7fffffff SErr 0x0
>> action 0x0
>> [388659.175589] ata5.00: irq_stat 0x40000008
>> [388659.177312] ata5.00: failed command: READ FPDMA QUEUED
>> [388659.179045] ata5.00: cmd 60/20:60:80:96:95/00:00:c4:00:00/40 tag
>> 12 ncq 1638
>>                   4 in
>>           res 51/40:1c:84:96:95/00:00:c4:00:00/40 Emask 0x409 (media
>> error) <F>
>> [388659.182552] ata5.00: status: { DRDY ERR }
>> [388659.184303] ata5.00: error: { UNC }
>> [388659.188899] ata5.00: configured for UDMA/133
>> [388659.188956] sd 4:0:0:0: [sdd] Unhandled sense code
>> [388659.188960] sd 4:0:0:0: [sdd]
>> [388659.188962] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
>> [388659.188965] sd 4:0:0:0: [sdd]
>> [388659.188967] Sense Key : Medium Error [current] [descriptor]
>> [388659.188970] Descriptor sense data with sense descriptors (in hex):
>> [388659.188972]         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00
>> [388659.188981]         c4 95 96 84
>> [388659.188985] sd 4:0:0:0: [sdd]
>> [388659.188988] Add. Sense: Unrecovered read error - auto reallocate
>> failed
>> [388659.188991] sd 4:0:0:0: [sdd] CDB:
>> [388659.188992] Read(10): 28 00 c4 95 96 80 00 00 20 00
>> [388659.189000] end_request: I/O error, dev sdd, sector 3298137732
>> [388659.190740] BTRFS: bdev /dev/sdd errs: wr 0, rd 3120, flush 0,
>> corrupt 0, ge
>>                     n 0
>> [388659.192556] ata5: EH complete
>
> Just some background, but this error is usually indicative of either media
> degradation from long-term usage, or a head crash.
>>
>>
>> At the same time, I started getting mails from smartd:
>>
>> Device: /dev/sdd [SAT], 2 Currently unreadable (pending) sectors
>> Device info:
>> Hitachi HDS723020BLA642, S/N:MN1220F30MNHUD, WWN:5-000cca-369c8f00b,
>> FW:MN6OA580, 2.00 TB
>>
>> For details see host's SYSLOG.
>
> And this correlates with the above errors (although the current pending
> sectors being non-zero is less specific than the above).
>>
>>
>> To fix it, it ended up with me adding a new 6TB disk and trying to
>> delete the failing 2TB disks.
>>
>> That didn't go so well; apparently, the delete command aborts when
>> ever it encounters I/O errors. So now my raid0 looks like this:
>
> I'm not going to comment on how to fix the current situation, as what has
> been stated in other people's replies pretty well covers that.
>
> I would however like to mention two things for future reference:
>
> 1. The delete command handles I/O errors just fine, provided that there is
> some form of redundancy in the filesystem.  In your case, if this had been a
> raid1 array instead of raid0, then the delete command would have just fallen
> back to the other copy of the data when it hit an I/O error instead of
> dying.  Just like a regular RAID0 array (be it LVM, MD, or hardware), you
> can't lose a device in a BTRFS raid0 array without losing the array.
>
> 2. While it would not have helped in this case, the preferred method when
> replacing a device is to use the `btrfs replace` command.  It's a lot more
> efficient than add+delete (and exponentially more efficient than
> delete+add), and also a bit safer (in both cases because it needs to move
> less data).  The only down-side to it is that you may need a couple of
> resize commands around it.
>
>>
>> klaus@box:~$ sudo btrfs fi show
>> [sudo] password for klaus:
>> Label: none  uuid: 5db5f82c-2571-4e62-a6da-50da0867888a
>>          Total devices 4 FS bytes used 5.14TiB
>>          devid    1 size 1.82TiB used 1.78TiB path /dev/sde
>>          devid    2 size 1.82TiB used 1.78TiB path /dev/sdf
>>          devid    3 size 0.00B used 1.49TiB path /dev/sdd
>>          devid    4 size 5.46TiB used 305.21GiB path /dev/sdb
>>
>> Btrfs v3.17
>>
>> Obviously, I want /dev/sdd emptied and deleted from the raid.
>>
>> So how do I do that?
>>
>> I thought of three possibilities myself. I am sure there are more,
>> given that I am in no way a btrfs expert:
>>
>> 1)Try to force a deletion of /dev/sdd where btrfs copies all intact
>> data to the other disks
>> 2) Somehow re-balances the raid so that sdd is emptied, and then deleted
>> 3) converting into a raid1, physically removing the failing disk,
>> simulating a hard error, starting the raid degraded, and converting it
>> back to raid0 again.
>>
>> How do you guys think I should go about this? Given that it's a raid0
>> for a reason, it's not the end of the world losing all data, but I'd
>> really prefer losing as little as possible, obviously.
>>
>> FYI, I tried doing some scrubbing and balancing. There's traces of
>> that in the syslog and dmesg I've attached. It's being used as
>> firewall too, so there's a lof of Shorewall block messages smapping
>> the log I'm afraid.
>>
>> Additional info:
>> klaus@box:~$ uname -a
>> Linux box 3.16.0-4-amd64 #1 SMP Debian 3.16.43-2+deb8u5 (2017-09-19)
>> x86_64 GNU/Linux
>> klaus@box:~$ sudo btrfs --version
>> Btrfs v3.17
>> klaus@box:~$ sudo btrfs fi df /mnt
>> Data, RAID0: total=5.34TiB, used=5.14TiB
>> System, RAID0: total=96.00MiB, used=384.00KiB
>> Metadata, RAID0: total=7.22GiB, used=5.82GiB
>> GlobalReserve, single: total=512.00MiB, used=0.00B
>>
>> Thanks a lot for any help you guys can give me. Btrfs is so incredibly
>> cool, compared to md :-) I love it!
>>
>



-- 
Klaus Agnoletti
