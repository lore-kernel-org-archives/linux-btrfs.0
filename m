Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:34261 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441AbcHJAI2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Aug 2016 20:08:28 -0400
Received: by mail-wm0-f65.google.com with SMTP id q128so6397917wma.1
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Aug 2016 17:08:27 -0700 (PDT)
MIME-Version: 1.0
From: Dave T <davestechshop@gmail.com>
Date: Tue, 9 Aug 2016 20:08:26 -0400
Message-ID: <CAGdWbB7YXZ1TAU=AbR2371a4x5=AgLCYagpYkuVNWgsPvsgJTQ@mail.gmail.com>
Subject: btrfs check --repair error: check_owner_ref: Assertion `rec->is_root` failed.
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

New problems keep happening...

Now btrfs check --repair is giving an error:

check_owner_ref: Assertion `rec->is_root` failed.

I do not know what that means, but I did run the command as root (as
shown in the images of the screen)

images of errors are here: http://imgur.com/a/ZwkUR


SUMMARY of the past 2 days:

* 2 days ago a computer which had not given any prior problems (and it
only a few months old) experienced the root fs going read-only under
light normal usage (browsing the web).
* I was able to run btrfs rescue zero-log to get the root fs to mount.
* immediately upon rebooting and mounting the fs, I ran btrfs check
--repair. However, that gave some messages that looked concerning and
I posted them here. (The full details are copied lower in this
message. Screen pictures are here: http://imgur.com/a/fT1RV)
* dmesg showed BTRFS error (device dm-0): qgroup generation
* I've been trying to research the issue for the last two days but I
have found absolutely zero information. (Maybe I'm asking in the wrong
places?)
* the system worked normally yesterday (as far as I could tell)
* this morning my system locked up with btrfs-transaction consuming
100% CPU and NMI watchdog reporting BUG: soft lockup with
btrfs-transaction:314.
* I ran btrfs rescue zero-log. It took two reboots to get the root fs to mount.
* the system appeared to be operating normally for about 30 minutes,
then the root fs went read-only again
* I ran btrfs rescue zero-log (again!)
* btrfs continues to report errors. I have linked to screen pictures (imgur.com)
* btrfs check --repair is giving an error (mentioned above and in the
screen pictures)

All previous information is copied below in this message for easy reference.

What do I do? Replace the disk? Stop using btrfs with dm-crypt? Look
elsewhere for help?


On Tue, Aug 9, 2016 at 6:54 PM, Dave T <davestechshop@gmail.com> wrote:
> The original problem from 2 days ago just happened again. I ran btrfs
> rescue zero-log (again) and the root filesystem mounted but it was
> read-only on first boot. I rebooted again and everything seems normal.
> But clearly there is a problem that needs to be resolved.
>
> Problem:
> The root file system becomes read-only during normal usage. See copied
> message below for more information about the error.
>
> I'm happy to provide more info upon request. I appreciate any help. Is
> this btrfs? A bad disk? Something else?
>
> Linux x99 4.6.4-1-ARCH #1 SMP PREEMPT Mon Jul 11 19:12:32 CEST 2016
> x86_64 GNU/Linux
>
> btrfs-progs v4.6.1
>
>
> On Tue, Aug 9, 2016 at 2:07 PM, Dave T <davestechshop@gmail.com> wrote:
>> My system locked up with btrfs-transaction consuming 100% CPU and NMI
>> watchdog reporting BUG: soft lockup with btrfs-transaction:314.
>>
>> This comes 2 days after a serious event involving BTRFS where my
>> system would not mount the root fs. (I gave details in an email to the
>> list two days ago and copied again below.)
>>
>> Here are full details of todays "bug" (or whatever it was).
>>
>> When i left work last night I left my system running and I locked the
>> session. The only things open were KDE Plasma, some terminal windows
>> and some plain text documents in Kate editor. No real work was running
>> on the local machine.
>>
>> This morning I came to work and noticed that my computer was slightly
>> warm and the fans were running at higher than normal RPM.
>>
>> I logged in and opened top in an existing terminal. I saw that
>> btrfs-transaction was consuming 100% of a CPU core and kworker was
>> consumer 100% of another CPU core.
>>
>> I tried to run a command (to view logs) in another terminal window,
>> but the system became unresponsive. I was able to switch to another
>> virtual console, but it was very slow. I took photos with my phone.
>> See link below for two images (top and virtual console):
>>
>> http://imgur.com/a/fT1RV
>>
>> These photos show what I reported above:
>> * btrfs-transaction consuming 100% CPU
>> * NMI watchdog reporting BUG: soft lockup with btrfs-transaction:314
>>
>> I hard reset my system, expecting the worst, but it rebooted normally.
>> journalctl -xb -p3 showed no entries.
>>
>> Obviously I have a serious problem. However, I have no clue about what
>> the problem might be (except that it seemingly involves btrfs). What
>> other information can I provide?
>>
>> On Sun, Aug 7, 2016 at 6:44 PM, Dave <davestechshop@gmail.com> wrote:
>>> I am running Arch Linux on a system with full disk encryption and the
>>> storage is a Samsung 950 Pro NVMe drive (512 GB). The computer is a
>>> couple months old. No bad behavior until now. (I'm only using 21 GB of
>>> the 512 space on the disk.)
>>>
>>>     btrfs-progs v4.5.1
>>>
>>> Today I was using my system normally and browsing the web. Firefox
>>> stopped responding suddenly and for no apparent reason. Then (KDE)
>>> Plasma stopped responding. I could not log out of KDE.
>>>
>>> I killed my user session (pkill -u me), then I tired to startx. At
>>> that point I noticed my root filesystem was read-only.
>>>
>>> As a first step, I rebooted. That didn't help anything. I tried
>>> rebooting several more times -- no change.
>>>
>>> The root filesystem (btrfs) would not mount. (See error below.) I
>>> booted into a LiveUSB environment and ran this command:
>>>
>>>     cryptsetup open --type luks /dev/xxx cryptroot
>>>
>>> It opens. Then I ran:
>>>
>>>     mount -t btrfs -o
>>> noatime,nodiratime,ssd,compress=lzo,defaults,space_cache,subvolid=257
>>> /dev/mapper/cryptroot /mnt
>>>
>>> The error message is shown here:
>>>
>>>     [ 2300.967048] BTRFS info (device dm-0): use ssd allocation scheme
>>>     [ 2300.967058] BTRFS info (device dm-0): use lzo compression
>>>     [ 2300.967066] BTRFS info (device dm-0): disk space caching is enabled
>>>     [ 2300.967069] BTRFS: has skinny extents
>>>     [ 2300.995393] BTRFS: error (device dm-0) in
>>> btrfs_replay_log:2413: errno=-22 unknown (Failed to recover log tree)
>>>     [ 2300.997617] BTRFS info (device dm-0): delayed_refs has NO entry
>>>     [ 2300.997673] BTRFS error (device dm-0): cleaner transaction
>>> attach returned -30
>>>     [ 2301.035405] BTRFS: open_ctree failed
>>>
>>> It is exactly the same error I saw when trying to boot normally as
>>> mentioned above.
>>>
>>> Based on these two links:
>>>
>>>> https://btrfs.wiki.kernel.org/index.php/Problem_FAQ
>>>> https://btrfs.wiki.kernel.org/index.php/Btrfs-zero-log
>>>
>>> I decided to take a chance on running this command:
>>>
>>>     btrfs rescue zero-log
>>>
>>> That worked and I can mount the filesystem.
>>>
>>> I ran btrfs check --repair. Here is the output:
>>>
>>>     root@broken / # umount /mnt
>>>     root@broken / # btrfs check --repair /dev/mapper/cryptroot
>>>     enabling repair mode
>>>     Checking filesystem on /dev/mapper/cryptroot
>>>     checking extents
>>>     bad metadata [292414476288, 292414492672) crossing stripe boundary
>>>     bad metadata [292414541824, 292414558208) crossing stripe boundary
>>>     bad metadata [292414672896, 292414689280) crossing stripe boundary
>>>     bad metadata [292414869504, 292414885888) crossing stripe boundary
>>>     bad metadata [292415000576, 292415016960) crossing stripe boundary
>>>     bad metadata [292415066112, 292415082496) crossing stripe boundary
>>>     bad metadata [292415131648, 292415148032) crossing stripe boundary
>>>     bad metadata [292415262720, 292415279104) crossing stripe boundary
>>>     bad metadata [292415328256, 292415344640) crossing stripe boundary
>>>     bad metadata [292415393792, 292415410176) crossing stripe boundary
>>>     repaired damaged extent references
>>>     Fixed 0 roots.
>>>     checking free space cache
>>>     cache and super generation don't match, space cache will be invalidated
>>>     checking fs roots
>>>     checking csums
>>>     checking root refs
>>>     checking quota groups
>>>     Ignoring qgroup relation key 258
>>>     Ignoring qgroup relation key 263
>>>     Ignoring qgroup relation key 71776119061217538
>>>     Ignoring qgroup relation key 71776119061217543
>>>     Counts for qgroup id: 257 are different
>>>     our:            referenced 10412273664 referenced compressed 10412273664
>>>     disk:           referenced 10411311104 referenced compressed 10411311104
>>>     diff:           referenced 962560 referenced compressed 962560
>>>     our:            exclusive 10412273664 exclusive compressed 10412273664
>>>     disk:           exclusive 10412273664 exclusive compressed 10412273664
>>>     found 21570773057 bytes used err is 0
>>>     total csum bytes: 19563456
>>>     total tree bytes: 403767296
>>>     total fs tree bytes: 349667328
>>>     total extent tree bytes: 27328512
>>>     btree space waste bytes: 66313360
>>>     file data blocks allocated: 39882014720
>>>     referenced 28043988992
>>>     extent buffer leak: start 20987904 len 16384
>>>     extent buffer leak: start 292688068608 len 16384
>>>     extent buffer leak: start 60915712 len 16384
>>>     extent buffer leak: start 29569581056 len 16384
>>>     extent buffer leak: start 29569597440 len 16384
>>>     extent buffer leak: start 292412063744 len 16384
>>>     extent buffer leak: start 292405870592 len 16384
>>>     extent buffer leak: start 292405936128 len 16384
>>>     extent buffer leak: start 292413964288 len 16384
>>>
>>> Then I check dmesg and I see this error information:
>>>
>>>     [ 4925.562422] BTRFS info (device dm-0): use ssd allocation scheme
>>>     [ 4925.562432] BTRFS info (device dm-0): use lzo compression
>>>     [ 4925.562440] BTRFS info (device dm-0): disk space caching is enabled
>>>     [ 4925.562444] BTRFS: has skinny extents
>>>     [ 4925.578705] BTRFS error (device dm-0): qgroup generation
>>> mismatch, marked as inconsistent
>>>     [ 4925.584033] BTRFS: checking UUID tree
>>>
>>> What should I do next? I'm a simple user.
>>>
>>> I already ran memtest86+ overnight using 8 CPU cores in parallel (so
>>> it was a very thorough memory test). There were 0 RAM errors.
>>>
>>> I previously used btrfs since 2012 with no issues. I am concerned
>>> about the present issue because I do not understand the cause.
