Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:35013 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754543AbcJUGhK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 21 Oct 2016 02:37:10 -0400
Received: by mail-lf0-f68.google.com with SMTP id x79so3923541lff.2
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Oct 2016 23:37:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSLZibHtOA8e8qVYwmgoh-m7eUgR5BBft4dDrc6rT=Tjw@mail.gmail.com>
References: <CAMXnza15-UMtSugAzX_dYtLx1Rgi+OvASngQnqqTzW86tgDW8A@mail.gmail.com>
 <CAJCQCtSLZibHtOA8e8qVYwmgoh-m7eUgR5BBft4dDrc6rT=Tjw@mail.gmail.com>
From: Suvayu Ali <fatkasuvayu+linux@gmail.com>
Date: Fri, 21 Oct 2016 12:06:42 +0530
Message-ID: <CAMXnza2VriNZqRnRFttPbWHcDups95G6NV8E0LuUZ9PoaT4y7Q@mail.gmail.com>
Subject: Re: Help repairing a partition
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

Thanks for your response :).

On 21 October 2016 at 05:18, Chris Murphy <lists@colorremedies.com> wrote:
> On Thu, Oct 20, 2016 at 3:20 PM, Suvayu Ali <fatkasuvayu+linux@gmail.com> wrote:
>> Hi,
>>
>> (please CC me in replies, I'm not subscribed)
>>
>> I'm using kernel 4.7.7-100.fc23 with btrfs-progs v4.7.1.
>>
>> I had my /home, /var, and /opt as subvolumes in a btrfs partition.
>> Last night btrfs failed, and I was unable to mount it normally
>> (leading to boot failures).  The journal had messages like this:
>>
>>   BTRFS: open_ctree failed
>>   BTRFS error: super_total_bytes ... mismatch with fs_devices total_rw_bytes
>>   BTRFS error: failed to read chunk tree: -22
>>
>> Finally I managed to mount it manually like this (after making a dd
>> image of the partition):
>>
>>   # mount -t btrfs -o ro,recovery,nospace_cache /dev/sdb2 /mnt
>>
>> and managed to recover my data. Initially "btrfs check" yielded a few
>>
>>   parent transid verify failed on 101679726592 wanted 822619 found 822617
>>
>> and
>>
>>   checksum verify failed on 101756387328 found 78C8A0BC wanted B7C59D79
>>
>> however after backing up my data, I mounted without the "-o ro" (I got
>> a transid related message, but it did mount).  "btrfs check" now spits
>> out a whole bunch of:
>>
>>   Incorrect local backref count on 202118008832 root 259 owner 178928
>> offset 41181184 found 2 wanted 7 back 0x55713fbbf150
>>   Incorrect global backref count on 202118008832 found 2 wanted 7
>>   backpointer mismatch on [202118008832 376832]
>
>
> This is a known problem with btrfs-progs 4.7.1 it should not be used.
> https://btrfs.wiki.kernel.org/index.php/Changelog#btrfs-progs_4.7.1_.28Aug_2016.29
>
> Upgrade to 4.7.3 or 4.8.1 is advised.

I had upgraded to 4.7.3 to test this issue:

  https://bugzilla.redhat.com/show_bug.cgi?id=1372910

It hadn't helped, but I didn't have time to debug it any further.
Since the Fedora 23 repos have 4.4.1, I guess downgrading is easier
for me.

Thanks for the pointer to the changelog; under 4.7.2 it mentions not
to repair with 4.7.1, so I'll try `btrfs check --repair` after the
downgrade.

>> followed by this summary:
>>
>> checking csums
>> checking root refs
>> checking quota groups
>> Counts for qgroup id: 0/257 are different
>> our:            referenced 7746465792 referenced compressed 7746465792
>> disk:           referenced 7746461696 referenced compressed 7746461696
>> diff:           referenced 4096 referenced compressed 4096
>> our:            exclusive 7746465792 exclusive compressed 7746465792
>> disk:           exclusive 7746461696 exclusive compressed 7746461696
>> diff:           exclusive 4096 exclusive compressed 4096
>> Counts for qgroup id: 0/259 are different
>> our:            referenced 135641784320 referenced compressed 135641784320
>> disk:           referenced 135633862656 referenced compressed 135633862656
>> diff:           referenced 7921664 referenced compressed 7921664
>> our:            exclusive 135641784320 exclusive compressed 135641784320
>> disk:           exclusive 135633862656 exclusive compressed 135633862656
>> diff:           exclusive 7921664 exclusive compressed 7921664
>> found 167864082432 bytes used err is 0
>> total csum bytes: 161187492
>> total tree bytes: 2021015552
>> total fs tree bytes: 1725759488
>> total extent tree bytes: 86228992
>> btree space waste bytes: 386160897
>> file data blocks allocated: 1269363683328
>>  referenced 164438126592
>>
>> How do I repair this?
>
> Yeah good question. I can't tell from the message whether different
> counts is a bad thing, or if it's just a notification, or what. Yet
> again btrfs-progs does not help the user make informed decisions, it's
> really frustrating. I think that part can be ignored though for now,
> and see if btrfs check --repair can fix the problem now that you have
> a backup.

Indeed, I have never been this confused about a file system before.

I tried repairing after the downgrade to 4.4.1, it says "Couldn't open
file system"!  Mounting now works without errors, I can also r/w files
as normal; go figure!

Cheers,

-- 
Suvayu

Open source is the future. It sets us free.
