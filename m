Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f171.google.com ([209.85.216.171]:41320 "EHLO
        mail-qt0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752054AbeBHTfI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Feb 2018 14:35:08 -0500
Received: by mail-qt0-f171.google.com with SMTP id a9so1078207qtj.8
        for <linux-btrfs@vger.kernel.org>; Thu, 08 Feb 2018 11:35:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAH-drozv-pgkrreOduoDUvS8ct0_BjHEwLBvQ9be3atnRpfZTw@mail.gmail.com>
References: <CAH-droxO-K9RM9uCLie=6bg3cgC5uqo_wcscc0BmB9HyKM5gQQ@mail.gmail.com>
 <CAJCQCtTqJQkLmsowxun7YuRsy4MkN9A4iO5LVwp3tO_6G=LqNQ@mail.gmail.com>
 <ea8e5fd1-25f4-0f26-14eb-8aeb9de2fb86@gmail.com> <CAH-drozv-pgkrreOduoDUvS8ct0_BjHEwLBvQ9be3atnRpfZTw@mail.gmail.com>
From: Nick Gilmour <nickeforos@gmail.com>
Date: Thu, 8 Feb 2018 20:34:26 +0100
Message-ID: <CAH-droxBmahy4+APtOQ-O9fTWF42X2BLvXLkS5nVhu9PokVqpQ@mail.gmail.com>
Subject: Re: IO Error (.snapshots is not a btrfs subvolume)
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Cc: Andrei Borzenkov <arvidjaar@gmail.com>,
        Chris Murphy <lists@colorremedies.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've installed openSUSE Tumbleweed on a VM and checked how the disk is
with btrfs partioned, how fstab looks like, how snapper works and also
what are the differences to my system. I've decided to leave it like
it is for now and next time use the guide from the link provided by
@Andrei.

Thanks!

Regards,
Nick

On Thu, Feb 8, 2018 at 4:43 PM, Nick Gilmour <nickeforos@gmail.com> wrote:
> On Thu, Feb 8, 2018 at 5:32 AM, Andrei Borzenkov <arvidjaar@gmail.com> wrote:
>> 08.02.2018 06:03, Chris Murphy пишет:
>>> On Wed, Feb 7, 2018 at 6:26 PM, Nick Gilmour <nickeforos@gmail.com> wrote:
>>>> Hi all,
>>>>
>>>> I have successfully restored a snapshot of root but now when I try to
>>
>> How exactly was it done?
>>
>>>> make a new snapshot I get this error:
>>>> IO Error (.snapshots is not a btrfs subvolume).
>>>> My snapshots were within @ which I renamed to @_old.
>>>> What can I do now? How can I move the snapshots from @_old/ into @ and
>>>> be able to make snapshots again?
>>>>
>>>> This is an excerpt of my subvolumes list:
>>>>
>>>> # btrfs subvolume list /
>>>> ID 257 gen 175397 top level 5 path @_old
>>>> ID 258 gen 175392 top level 5 path @pkg
>>>> ID 260 gen 175447 top level 5 path @tmp
>>>> ID 262 gen 19 top level 257 path @_old/var/lib/machines
>>>> ID 268 gen 175441 top level 5 path @test
>>>> ID 291 gen 175394 top level 257 path @_old/.snapshots
>>>> ID 292 gen 1705 top level 291 path @_old/.snapshots/1/snapshot
>>>> ...
>>>>
>>>> ID 3538 gen 175398 top level 291 path @_old/.snapshots/1594/snapshot
>>>> ID 3540 gen 175447 top level 5 path @
>>>>
>>>
>>>
>>> This is a snapper behavior. It creates .snapshots as a subvolume and
>>> then puts snapshots into that subvolume. If you snapshot a subvolume
>>> that contains another subvolume, the nested subvolume is not snapshot,
>>> instead a plain directory placeholder is created instead. So your
>>> restored snapshot contains a .snapshot directory rather than a
>>> .snapshot subvolume. Possibly if you delete the directory and create a
>>> new subvolume .snapshot, the problem will be fixed.
>>>
>>
>> No, you should create subvolume @/.snapshots and mount it as /.snapshots
>> (and have it in /etc/fstab). Snapshots should always be available in
>> running system under fixed path and this only possible when it is
>> mounted, otherwise after rollback /.snapshots will be lost just like it
>> happened now.
>>
>> Exact subvolume name probably not matters that much, but better stick
>> with what installer does by default. It may matter for grub2 snapshots
>> handling.
>>
>> Also openSUSE expects that actual root is subvolume under /.snapshots
>> which is valid snapper snapshot (i.e. it has valid metadata). Again, not
>> having this may confuse snapper.
>>
>> It may be possible to move @_old/.snapshots into @/.snapshots, although
>> this breaks parent-child relationships those old snapshots cannot be
>> cleaned up without removing old root completely.
>>
>>> I can't tell you how this will confuse snapper though, or how to
>>> unconfuse it. It pretty much expects to be in control of all
>>> snapshots, creation, deletion, and rollbacks. So if you do it manually
>>> for whatever reason, I think it can confuse snapper.
>>>
>>>
>>
>> There was blog post recently outlining how to restore openSUSE root. You
>> may want to search opensuse or opensuse-factory mailing list. Ah found:
>>
>> https://rootco.de/2018-01-19-opensuse-btrfs-subvolumes/
>
>
> Thanks both for the quick responses!
>
>> How exactly was it done?
> 1. # mount /dev/sde6 /mnt
> 2. # cd /mnt
> 3. # mv @ @_old
> 4. # btrfs subvol snapshot /mnt/@_old/.snapshots/1594/snapshot /mnt/@
>
>> No, you should create subvolume @/.snapshots and mount it as /.snapshots
>> (and have it in /etc/fstab). Snapshots should always be available in
>> running system under fixed path and this only possible when it is
>> mounted, otherwise after rollback /.snapshots will be lost just like it
>> happened now.
>
> When I run this command I get an error:
> # btrfs subvolume create @/.snapshots
> ERROR: cannot access '@': No such file or directory
>
> but when I'm doing this:
> # btrfs subvolume create /.snapshots
> Create subvolume '//.snapshots'
> it works
>
> and this is what I see in the subvolumes list:
> ID 3541 gen 175955 parent 3540 top level 3540 path .snapshots
>
> and then I can create a snapshot with snapper:
> # snapper -c root create --description "test"
>
> but snapper starts numbering from 1 again which I don't really like. I
> would like to keep the previous snapshots and continue the numbering
> after the last restored snapshot (1594).
>
> This is how my fstab looks like now:
>
> # /etc/fstab: static file system information
> #
> # <file system>                                 <dir>           <type>
>          <options>
>                                   <dump>  <pas$
> # /dev/sdd6 LABEL=ROOT
> UUID=...567940c58ea6       /                       btrfs
> noatime,nodiratime,compress=lzo,ssd,space_cache,subvolid=257,subvol=/@
>                  0       1
>
> # /dev/sdd5 LABEL=BOOT
> UUID=...bfb2cdbaf627       /boot                   ext4
> relatime,data=ordered,errors=remount-ro
>                  0       1
>
> # /dev/sdc1 LABEL=home
> UUID=...f1e163883d2b       /home                   ext4
> relatime,stripe=32750,data=ordered,errors=remount-ro
>                  0       2
>
> # /dev/sdd6 LABEL=ROOT
> UUID=...567940c58ea6       /var/cache/pacman/pkg   btrfs
> noatime,nodiratime,compress=lzo,ssd,space_cache,subvolid=258,subvol=/@pkg
>               0       0
>
> # /dev/sdd6 LABEL=ROOT
> UUID=...567940c58ea6       /tmp                    btrfs
> noatime,nodiratime,compress=lzo,ssd,space_cache,subvolid=260,subvol=/@tmp
>               0       0
>
> # /dev/sdd6 LABEL=ROOT
> #UUID=...567940c58ea6      /.snapshots             btrfs
> noatime,nodiratime,compress=lzo,ssd,space_cache,subvolid=259,subvol=/@snapshots,subvol=@snapshots
>       0       0
>
> # /dev/sdd6 LABEL=ROOT
> UUID=...567940c58ea6       /btrfs                  btrfs
> noatime,nodiratime,compress=lzo,ssd,space_cache,subvolid=5,subvol=/
>                  0       0
>
> Apparently both fstab and btrfs are misconfigured. How can I configure
> them correctly?
>
>> It may be possible to move @_old/.snapshots into @/.snapshots, although
>> this breaks parent-child relationships those old snapshots cannot be
>> cleaned up without removing old root completely.
>
> How? Do you mean with send / receive?
