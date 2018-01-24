Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:38923 "EHLO
        mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933288AbeAXL6C (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Jan 2018 06:58:02 -0500
Received: by mail-wm0-f51.google.com with SMTP id b21so8083417wme.4
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Jan 2018 03:58:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <a990d2db-a9ba-256b-1389-e9f350a94060@gmx.com>
References: <CAAxOLF8pwZ5jcZxB4=h-bPZBxsnCV7sB=LOghGfa0HhRqgJfSg@mail.gmail.com>
 <270851c6-7725-ec63-fa6d-6ff63e99c637@gmx.com> <CAAxOLF8GRV3ZX=cahf0szsvtyQO0Qv32PEKoMBzq+1R=imjzxw@mail.gmail.com>
 <c0f89fad-2c98-fd78-4bcb-7c19dd3c03b0@gmx.com> <08afcd3e-b365-b49f-55c6-770a2b560395@gmail.com>
 <a990d2db-a9ba-256b-1389-e9f350a94060@gmx.com>
From: "^m'e" <marcoep@gmail.com>
Date: Wed, 24 Jan 2018 11:57:40 +0000
Message-ID: <CAAxOLF9Hqnbc6g20dPasrtXW+Es562mOBujc7ve7Fc6LzG7tcQ@mail.gmail.com>
Subject: Re: btrfs check: backref lost, mismatch with its hash -- can't repair
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks Qu!

I did it (had to add 'progs_extra' to the 'static' make target...),
but it looks like there's something missing:

-------------------------------------------------------------
# ./btrfs-corrupt-block.static -X /dev/sdb3
./btrfs-corrupt-block.static: invalid option -- 'X'
usage: btrfs-corrupt-block [options] device
    -l Logical extent to be corrupted
    -c Copy of the extent to be corrupted (usually 1 or 2, default: 0)
    -b Number of bytes to be corrupted
    -e Extent to be corrupted
    -E The whole extent tree to be corrupted
    -u Given chunk item to be corrupted
    -U The whole chunk tree to be corrupted
    -i The inode item to corrupt (must also specify the field to corrupt)
    -x The file extent item to corrupt (must also specify -i for the
inode and -f for the field to corrupt)
    -m The metadata block to corrupt (must also specify -f for the
field to corrupt)
    -K The key to corrupt in the format <num>,<num>,<num> (must also
specify -f for the field)
    -f The field in the item to corrupt
    -I An item to corrupt (must also specify the field to corrupt and
a root+key for the item)
    -D Corrupt a dir item, must specify key and field
    -d Delete this item (must specify -K)
-------------------------------------------------------------

I cloned at --depth=1, if that matters... Didn't dare to play around
wiht the lowercase 'x' option... O_o


On Wed, Jan 24, 2018 at 10:14 AM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
> Here is the super dirty tricky fix (and less deadly now).
>
> https://github.com/adam900710/btrfs-progs/tree/dirty_fix
>
> Please compile the branch and run:
>
> # ./btrfs-corrupt-block -X <device>
>
> Where <device> must be unmounted, the original btrfs-corrupt-block tool
> doesn't have mount check, and I'm too lazy to add such check.
>
> The hack will remove the offending DIR_ITEM completely, and unlink the
> old "Manifest" file, and repair the link for newer "Manifest" file.
>
> And it shouldn't write anything to disk if any operation failed, so it's
> less deadly.
>
> Wish you good luck.
>
> Thanks,
> Qu
>
> On 2018年01月24日 17:18, Foo Bar wrote:
>> Qu Wenruo wrote on 2018-01-24 09:49:
>>> Sorry for the late reply, I was off yesterday.
>>>
>>
>> No problem :-)
>>
>> Booted normally today, system up, but see this (I forgot to stop the snapshot
>> cron task...)
>>
>>   [  115.127961] BTRFS error (device sdb3): Send: inconsistent snapshot, found
>> deleted reference for inode 30039323 without updated inode item, send root is
>> 1399, parent root is 1385
>>
>> So inode 30039323 looks definitely the bad one. Let's get rid of it and keep
>> the newest dups, if any, thanks!
>>
>> Cheers,
>>
>>   Marco
>>
>>> On 2018年01月22日 23:04, ^m'e wrote:
>>>> Thanks for the quick reply, Qu!
>>>>
>>>> I forgot to say that I see weird characters in the btrfs check repair
>>>> in lines "ERROR: DIR_ITEM... name ..." output. Although that can be
>>>> due to corruption, I seem to remember that a previous version of
>>>> btrfs-progs I used didn't show that...
>>>> I also see:
>>>>
>>>>    [19428.934684] init_special_inode: bogus i_mode (700) for inode
>>>> sdb3:18446744073709551361
>>>>
>>>> BTW, no sensible names in the debug output, and as far as I can see,
>>>> it might be all stuff in '[rootfs]/usr/portage': if that's the case,
>>>> corrupted inodes can be safely removed, as the portage package tree
>>>> can be easily rebuild. Here you are:
>>>>
>>>> ---------------------------------->8-------------------------------------
>>>> # cat btrfs-debug.30039322.log[snip]
>>>
>>> This where the dir starts.
>>>
>>>>     item 78 key (30039322 INODE_ITEM 0) itemoff 4203 itemsize 160
>>>>         generation 136248 transid 229515 size 152 nbytes 0
>>>>         block group 0 mode 40755 links 1 uid 250 gid 250 rdev 0
>>>>         sequence 0 flags 0xf(none)
>>>>         atime 1504685599.188061317 (2017-09-06 08:13:19)
>>>>         ctime 1516557882.551679697 (2018-01-21 18:04:42)
>>>>         mtime 1516557882.551679697 (2018-01-21 18:04:42)
>>>>         otime 1504685599.188061317 (2017-09-06 08:13:19)
>>>>     item 79 key (30039322 INODE_REF 30037720) itemoff 4161 itemsize 42
>>>>         index 242 namelen 32 name: obs-service-download_src_package
>>>>     item 80 key (30039322 DIR_ITEM 1076301169) itemoff 4083 itemsize 78
>>>>         location key (30039325 INODE_ITEM 0) type FILE
>>>>         transid 136248 data_len 0 name_len 48
>>>>         name: obs-service-download_src_package-20130318.ebuild
>>>>     item 81 key (30039322 DIR_ITEM 2438219243) itemoff 4041 itemsize 42
>>>>         location key (0 UNKNOWN.0 0) type FILE
>>>>         transid 136192 data_len 0 name_len 12
>>>>         name: metadata.xml
>>>>     item 82 key (30039322 DIR_ITEM 4007295565) itemoff 3927 itemsize 114
>>>>         location key (0 UNKNOWN.0 0) type DIR_ITEM.0
>>>>         transid 0 data_len 0 name_len 0
>>>>         name:
>>>>         location key (0 UNKNOWN.125 72057594038112709) type DIR_ITEM.0
>>>>         transid 0 data_len 32907 name_len 3
>>>>         name:
>>>>         data
>>>
>>> The whole item is corrupted.
>>> Seems to be a half-written item get flushed to disk.
>>>
>>> I assume this is the DIR_ITEM for *two* Manifest, but that's just
>>> insane, as we're going to have 2 files with the same name "Manifest"
>>>
>>>>     item 83 key (30039322 DIR_INDEX 2) itemoff 3889 itemsize 38
>>>>         location key (30039323 INODE_ITEM 0) type FILE
>>>>         transid 3377699720527872 data_len 0 name_len 8
>>>
>>> The transid seems corrupted too.
>>>
>>> Maybe I need to delete this item too?
>>>
>>>>     item 64 key (47302013 INODE_REF 30039322) itemoff 11278 itemsize 18
>>>>         index 5 namelen 8 name: Manifest
>>>
>>> Now we do have 2 "Manifest".
>>>
>>> Which one do you prefer to delete?
>>>
>>> The latter one, inode 47302013 seems newer, while previous one, inode
>>> 30039323 is pretty old.
>>>
>>> Despite that, I didn't see big problem in the dump.
>>>
>>> I'll just craft the dirty fix to delete one inode and the incorrect dir
>>> index/item.
>>>
>>> Thanks,
>>> Qu
>>>
>>
>



-- 
^m'e
