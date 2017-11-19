Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f169.google.com ([74.125.82.169]:37494 "EHLO
        mail-ot0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750732AbdKSEkX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 18 Nov 2017 23:40:23 -0500
Received: by mail-ot0-f169.google.com with SMTP id s4so5174259ote.4
        for <linux-btrfs@vger.kernel.org>; Sat, 18 Nov 2017 20:40:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <f73a2482-e82d-e658-02aa-a2e2988a0012@mokrynskyi.com>
References: <0d0062da-6310-7662-a7ec-edc6591b4542@mokrynskyi.com>
 <CAJCQCtSBxDP7ZyCnQuZZLQXXURrKLT+1Ja61pD_uR0oGH0piDA@mail.gmail.com>
 <20171118033335.2ha45mvia5edu6p6@angband.pl> <277c8155-8651-f593-0f3f-e36add09d943@mokrynskyi.com>
 <CAJCQCtTAvVKUmMdTaD=S-34anDghHWmQcjn76i+Q3wYc58+gTA@mail.gmail.com> <f73a2482-e82d-e658-02aa-a2e2988a0012@mokrynskyi.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Sat, 18 Nov 2017 21:40:22 -0700
Message-ID: <CAJCQCtTNWzS2XvAm+cLWkzPxfzSDMkkGeBHN=dG4XRXZtrD0bA@mail.gmail.com>
Subject: Re: Unrecoverable scrub errors
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Nov 18, 2017 at 8:45 PM, Nazar Mokrynskyi <nazar@mokrynskyi.com> wrote:
> 19.11.17 05:19, Chris Murphy пише:
>> On Sat, Nov 18, 2017 at 1:15 AM, Nazar Mokrynskyi <nazar@mokrynskyi.com> wrote:
>>> I can assure you that drive (it is HDD) is perfectly functional with 0 SMART errors or warnings and doesn't have any problems. dmesg is clean in that regard too, HDD itself can be excluded from potential causes.
>>>
>>> There were however some memory-related issues on my machine a few months ago, so there is a chance that data might have being written incorrectly to the drive back then (I didn't run scrub on backup drive for a long time).
>>>
>>> How can I identify to which files these metadata belong to replace or just remove them (files)?
>> You might look through the archives about bad ram and btrfs check
>> --repair and include Hugo Mills in the search, I'm pretty sure there
>> is code in repair that can fix certain kinds of memory induced
>> corruption in metadata. But I have no idea if this is that type or if
>> repair can make things worse in this case. So I'd say you get
>> everything off this file system that you want, and then go ahead and
>> try --repair and see what happens.
>
> In this case I'm not sure if data were written incorrectly or checksum or both. So I'd like to first identify the files affected, check them manually and then decide what to do with it. Especially there not many errors yet.
>
>> One alternative is to just leave it alone. If you're not hitting these
>> leaves in day to day operation, they won't hurt anything.
> It was working for some time, but I have suspicion that occasionally it causes spikes of disk activity because of this errors (which is why I run scrub initially).
>> Another alternative is to umount, and use btrfs-debug-tree -b  on one
>> of the leaf/node addresses and see what you get (probably an error),
>> but it might still also show the node content so we have some idea
>> what's affected by the error. If it flat out refuses to show the node,
>> might be a feature request to get a flag that forces display of the
>> node such as it is...
>
> Here is what I've got:
>
>> nazar-pc@nazar-pc ~> sudo btrfs-debug-tree -b 470069460992 /dev/mapper/luks-bd5dd3e7-ad80-405f-8dfd-752f2b870f93-part1
>> btrfs-progs v4.13.3
>> checksum verify failed on 470069460992 found FD171FBB wanted 54C49539
>> checksum verify failed on 470069460992 found FD171FBB wanted 54C49539
>> checksum verify failed on 470069460992 found FD171FBB wanted 54C49539
>> checksum verify failed on 470069460992 found FD171FBB wanted 54C49539
>> Csum didn't match
>> ERROR: failed to read 470069460992
> Looks like I indeed need a --force here.
>

Huh, seems overdue. But what do I know?

You can use btrfs-map-logical -l to get a physical address for this
leaf, and then plug that into dd

# dd if=/dev/ skip=<physicaladress> bs=1 count=16384 2>/dev/null | hexdump -C

Gotcha of course is this is not translated into the more plain
language output by btrfs-debug-tree. And you're in the weeds with the
on disk format documentation. But maybe you'll see filenames on the
right hand side of the hexdump output and maybe that's enough... Or
maybe it's worth computing a csum on that leaf to check against the
csum for that leaf which is found in the first field of the leaf. I'd
expect the csum itself is what's wrong, because if you get memory
corruption in creating the node, the resulting csum will be *correct*
for that malformed node and there'd be no csum error, you'd just see
some other crazy faceplant.


Example.

I need a metadata leaf, so ask debug tree to show the files tree for
an empty subvolume. In your case, you've got a bad leaf address
already, so you just plug that into btrfs-map-logical as shown below:

# btrfs-debug-tree -t 340 /dev/nvme0n1p8
btrfs-progs v4.13.3
file tree key (340 ROOT_ITEM 0)
leaf 155375550464 items 3 free space 15942 generation 249992 owner 340
leaf 155375550464 flags 0x1(WRITTEN) backref revision 1
fs uuid 2662057f-e6c7-47fa-8af9-ad933a22f6ec
chunk uuid 1df72dcf-f515-404a-894a-f7345f988793
    item 0 key (256 INODE_ITEM 0) itemoff 16123 itemsize 160
        generation 50968 transid 249992 size 0 nbytes 0
        block group 0 mode 40700 links 1 uid 0 gid 0 rdev 0
        sequence 0 flags 0x124(none)
        atime 1510866942.430740536 (2017-11-16 14:15:42)
        ctime 1511053088.58606103 (2017-11-18 17:58:08)
        mtime 1494741970.844618722 (2017-05-14 00:06:10)
        otime 1494741970.844618722 (2017-05-14 00:06:10)
    item 1 key (256 INODE_REF 256) itemoff 16111 itemsize 12
        index 0 namelen 2 name: ..
    item 2 key (256 XATTR_ITEM 3817753667) itemoff 16017 itemsize 94
        location key (0 UNKNOWN.0 0) type XATTR
        transid 50969 data_len 48 name_len 16
        name: security.selinux
        data system_u:object_r:systemd_machined_var_lib_t:s0
total bytes 75161927680
bytes used 23639638016
uuid 2662057f-e6c7-47fa-8af9-ad933a22f6ec

Get a physical address from the Btrfs internal logical address:

# btrfs-map-logical -l 155375550464 /dev/nvme0n1p8
mirror 1 logical 155375550464 physical 1609220096 device /dev/nvme0n1p8


Read that physical address using dd. I want bs=1 because all Btrfs
addresses are bytes, dd defaults to 512 byte blocks. And I need a
count of 16KiB which is the default leaf size.

# dd if=/dev/nvme0n1p8 skip=1609220096 bs=1 count=16384 2>/dev/null | hexdump -C



-- 
Chris Murphy
