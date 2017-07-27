Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f54.google.com ([209.85.214.54]:38608 "EHLO
        mail-it0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751788AbdG0Tnm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Jul 2017 15:43:42 -0400
Received: by mail-it0-f54.google.com with SMTP id h199so87658659ith.1
        for <linux-btrfs@vger.kernel.org>; Thu, 27 Jul 2017 12:43:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170727151038.GT7140@carfax.org.uk>
References: <CAFcRpx4q7N1zG4gz-g6MgkU6c-F_gQ6+2-4ibgm+nyRCp5pTXQ@mail.gmail.com>
 <20170727151038.GT7140@carfax.org.uk>
From: Alan Brand <alan@georgiabrands.com>
Date: Thu, 27 Jul 2017 15:43:37 -0400
Message-ID: <CAFcRpx7d=RPdt7iWY7bVeRdX8K7vV7=JYMRg8MVHveC=3qdfqg@mail.gmail.com>
Subject: Re: Raid0 rescue
To: Hugo Mills <hugo@carfax.org.uk>, Alan Brand <alan@georgiabrands.com>,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Correct, I should have said 'superblock'.
It is/was raid0.  Funny thing is that this all happened when I was
prepping to convert to raid1.

running a btrfs-find-root shows this (which gives me hope)
Well block 4871870791680(gen: 73257 level: 1) seems good, but
generation/level doesn't match, want gen: 73258 level: 1
Well block 4639933562880(gen: 73256 level: 1) seems good, but
generation/level doesn't match, want gen: 73258 level: 1
Well block 4639935168512(gen: 73255 level: 1) seems good, but
generation/level doesn't match, want gen: 73258 level: 1
Well block 4639926239232(gen: 73242 level: 0) seems good, but
generation/level doesn't match, want gen: 73258 level: 1

but when I run btrfs
inspect-internal dump-tree -r /dev/sdc1

checksum verify failed on 874856448 found 5A85B5D9 wanted 17E3CB7D
checksum verify failed on 874856448 found 5A85B5D9 wanted 17E3CB7D
checksum verify failed on 874856448 found 2204C752 wanted C6ADDF7E
checksum verify failed on 874856448 found 2204C752 wanted C6ADDF7E
bytenr mismatch, want=874856448, have=8568478783891655077
root tree: 4871875543040 level 1
chunk tree: 20971520 level 1
extent tree key (EXTENT_TREE ROOT_ITEM 0) 4871875559424 level 2
device tree key (DEV_TREE ROOT_ITEM 0) 4635801976832 level 1
fs tree key (FS_TREE ROOT_ITEM 0) 4871870414848 level 3
checksum tree key (CSUM_TREE ROOT_ITEM 0) 4871876034560 level 3
uuid tree key (UUID_TREE ROOT_ITEM 0) 29376512 level 0
checksum verify failed on 728891392 found 75E2752C wanted D6CA4FB4
checksum verify failed on 728891392 found 75E2752C wanted D6CA4FB4
checksum verify failed on 728891392 found F4F3A4AD wanted E6D063C7
checksum verify failed on 728891392 found 75E2752C wanted D6CA4FB4
bytenr mismatch, want=728891392, have=269659807399918462
total bytes 5000989728768
bytes used 3400345264128



On Thu, Jul 27, 2017 at 11:10 AM, Hugo Mills <hugo@carfax.org.uk> wrote:
> On Thu, Jul 27, 2017 at 10:49:37AM -0400, Alan Brand wrote:
>> I know I am screwed but hope someone here can point at a possible solution.
>>
>> I had a pair of btrfs drives in a raid0 configuration.  One of the
>> drives was pulled by mistake, put in a windows box, and a quick NTFS
>> format was done.  Then much screaming occurred.
>>
>> I know the data is still there.
>
>    Well, except for all the parts overwritten by a blank NTFS metadata
> structure.
>
>>   Is there anyway to rebuild the raid
>> bringing in the bad disk?  I know some info is still good, for example
>> metadata0 is corrupt but 1 and 2 are good.
>
>    I assume you mean superblock there.
>
>> The trees look bad which is probably the killer.
>
>    We really should improve the error messages at some point. Whatever
> you're inferring from the kernel logs is probably not quite right. :)
>
>    What's the metadata configuration on this FS? Also RAID-0? or RAID-1?
>
>> I can't run a normal recovery as only half of each file is there.
>
>    Welcome to RAID-0...
>
>    Hugo.
>
> --
> Hugo Mills             | We don't just borrow words; on occasion, English has
> hugo@... carfax.org.uk | pursued other languages down alleyways to beat them
> http://carfax.org.uk/  | unconscious and rifle their pockets for new
> PGP: E2AB1DE4          | vocabulary.                           James D. Nicoll
