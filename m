Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:35057 "EHLO
	mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502AbcHLDv7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Aug 2016 23:51:59 -0400
Received: by mail-oi0-f45.google.com with SMTP id 4so20306237oih.2
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Aug 2016 20:51:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$c3b41$2e67dfec$a7a1eb57$b9518b50@cox.net>
References: <CAGdWbB5k_HmN2b4zzrnYN+ExiqeP_9Eu9mVBCHEtgZNKHfTARA@mail.gmail.com>
 <pan$d9b53$c31dc60$985cf806$b833643c@cox.net> <CAJCQCtTHH=q9cE-BHDYuDpUASQx4Rnzx_b3VR=v-3s_THf1f4w@mail.gmail.com>
 <CAGdWbB72DLAkV3EwO-7Sakc4gPHRT=GmU5ftxo0YfR0wjBefNQ@mail.gmail.com>
 <CAJCQCtS3c5u6hDjHdU92AdQvSECNT99vOMxLiM4tchv4nrwPmA@mail.gmail.com>
 <CAGdWbB7qNFfKy1C3Ldb8aSCxvphZeYcmrXtdiB_ECGXNLZ-K5w@mail.gmail.com>
 <CAD=QJKjZP3V3HE_iXYcLJvq65mXKiXp_aYgZuoHmQFd7mJ7j0Q@mail.gmail.com>
 <pan$912d3$2d5e3dbf$b96ae0e6$53dad290@cox.net> <CAJCQCtTM_RdLHdLLsYjw3AVseHWP__7JLARO02ohYGkjzbnkmg@mail.gmail.com>
 <pan$c3b41$2e67dfec$a7a1eb57$b9518b50@cox.net>
From: Chris Murphy <lists@colorremedies.com>
Date: Thu, 11 Aug 2016 21:51:56 -0600
Message-ID: <CAJCQCtTfEPkmbJ-XE23aK=YaX5nEvP7QSLx0y6zCvXMhdZC_ew@mail.gmail.com>
Subject: Re: checksum error in metadata node - best way to move root fs to new drive?
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 11, 2016 at 9:11 PM, Duncan <1i5t5.duncan@cox.net> wrote:
> Chris Murphy posted on Thu, 11 Aug 2016 14:43:56 -0600 as excerpted:
>
>> On Thu, Aug 11, 2016 at 1:07 PM, Duncan <1i5t5.duncan@cox.net> wrote:
>>> The compression-related problem is this:  Btrfs is considerably less
>>> tolerant of checksum-related errors on btrfs-compressed data,
>>
>> Why? The data is the data. And why would it matter if it's application
>> compressed data vs Btrfs compressed data? If there's an error, Btrfs is
>> intolerant. I don't see how there's a checksum error that Btrfs
>> tolerates.
>
> Apparently, the code path for compressed data is sufficiently different,
> that when there's a burst of checksum errors, even on raid1 where it
> should (and does with scrub) get the correct second copy, it will crash
> the system.

Ahh OK, gotcha.

>  This is my experience and that of others, and what I thought
> was standard btrfs behavior -- I didn't know it was a compression-
> specific bug since I use compress on all my btrfs, until someone told me.
>
> When the btrfs compression option hasn't been used on that filesystem, or
> presumably when none of that burst of checksum errors is from btrfs-
> compressed files, it will grab the second copy and use it as it should,
> and there will be no crash.  This is as reported by others, including
> people who have tested both with and without btrfs-compressed files and
> found that it only crashed if the files were btrfs-compressed, whereas it
> worked as expected, fetching the valid second copy, if they weren't btrfs-
> compressed.

OK so something's broken.


>
> As I'm not a coder I can't actually tell you from reading the code, but
> AFAIK, both the 128 KiB compression block size and the checksum are on
> the uncompressed data.  Compression takes place after checksumming.
>
> And I don't believe metadata, whether metadata itself or inline data, is
> compressed by btrfs' transparent compression.

Inline data is definitely compressed.

>From ls -li
263 -rw-r-----. 1 root root  3270 Aug 11 21:29 samsung840-256g-hdparm.txt


>From btrfs-debug-tree

    item 84 key (263 INODE_ITEM 0) itemoff 7618 itemsize 160
        inode generation 7 transid 7 size 3270 nbytes 3270
        block group 0 mode 100640 links 1 uid 0 gid 0
        rdev 0 flags 0x0
    item 85 key (263 INODE_REF 256) itemoff 7582 itemsize 36
        inode ref index 8 namelen 26 name: samsung840-256g-hdparm.txt
    item 86 key (263 XATTR_ITEM 3817753667) itemoff 7499 itemsize 83
        location key (0 UNKNOWN.0 0) type XATTR
        namelen 16 datalen 37 name: security.selinux
        data unconfined_u:object_r:unlabeled_t:s0
    item 87 key (263 EXTENT_DATA 0) itemoff 5860 itemsize 1639
        inline extent data size 1618 ram 3270 compress(zlib)


Curiously though, these same small text files once above a certain
size (?) are not compressed if they aren't inline extents.

278 -rw-r-----. 1 root root 11767 Aug 11 21:29 WDCblack-750g-smartctlx_2.txt


    item 48 key (278 INODE_ITEM 0) itemoff 7675 itemsize 160
        inode generation 7 transid 7 size 11767 nbytes 12288
        block group 0 mode 100640 links 1 uid 0 gid 0
        rdev 0 flags 0x0
    item 49 key (278 INODE_REF 256) itemoff 7636 itemsize 39
        inode ref index 23 namelen 29 name: WDCblack-750g-smartctlx_2.txt
    item 50 key (278 XATTR_ITEM 3817753667) itemoff 7553 itemsize 83
        location key (0 UNKNOWN.0 0) type XATTR
        namelen 16 datalen 37 name: security.selinux
        data unconfined_u:object_r:unlabeled_t:s0
    item 51 key (278 EXTENT_DATA 0) itemoff 7500 itemsize 53
        extent data disk byte 12939264 nr 4096
        extent data offset 0 nr 12288 ram 12288
        extent compression(zlib)


Hrrmm.


-- 
Chris Murphy
