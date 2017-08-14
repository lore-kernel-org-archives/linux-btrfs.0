Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-32-i6.italiaonline.it ([212.48.14.166]:44154 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752360AbdHNOMq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 Aug 2017 10:12:46 -0400
Reply-To: kreijack@inwind.it
Subject: Re: [RFC] Checksum of the parity
To: Chris Murphy <lists@colorremedies.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <5d703b4c-e8ac-21dc-e327-ff1d8e232ee9@inwind.it>
 <CAJCQCtToFj4BowawgYPT-GiUnZPAXsjtuZO2=imcoyOZmaQzug@mail.gmail.com>
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <e4506812-53a8-7a95-61e6-279af20c8303@inwind.it>
Date: Mon, 14 Aug 2017 16:12:42 +0200
MIME-Version: 1.0
In-Reply-To: <CAJCQCtToFj4BowawgYPT-GiUnZPAXsjtuZO2=imcoyOZmaQzug@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/13/2017 08:45 PM, Chris Murphy wrote:
> [2]
> Is Btrfs subject to the write hole problem manifesting on disk? I'm
> not sure, sadly I don't read the code well enough. But if all Btrfs
> raid56 writes are full stripe CoW writes, and if the prescribed order
> guarantees still happen: data CoW to disk > metadata CoW to disk >
> superblock update, then I don't see how the write hole happens. Write
> hole requires: RMW of a stripe, which is a partial stripe overwrite,
> and a crash during the modification of the stripe making that stripe
> inconsistent as well as still pointed to by metadata.


RAID5 is *single* failure prof. And in order to have the write hole bug we need two failure:
1) a transaction is aborted (e.g. due to a power failure) and the results is that data and parity are mis-aligned
2) a disk disappears

These two events may happen even in different moment.

The key is that when a disk disappear, all remaining ones are used to rebuild the missing one. So if data and parity are mis-aligned the rebuild disk is wrong.

Let me to show an example

Disk 1            Disk 2         Disk 3  (parity)
AAAAAA            BBBBBB         CCCCCC

where CCCCCC = AAAAA ^ BBBBB

Note1: AAAAA is a valid data

Supposing to update B and due to a power failure you can't update parity, you have:


Disk 1            Disk 2         Disk 3  (parity)
AAAAAA            DDDDDDD        CCCCCC

Of course CCCCCC != AAAAA ^ DDDDD  (data and parity are misaligned).


Pay attention that AAAAAA is still valid data.

Now suppose to loose disk1. If you want to read from it, you have to perform a read of disk2 and disk3 to compute disk1. 

However Disk2 and disk3 are misaligned, so doing a DDDDD ^ CCCCC you don't got AAAAA anymore.


Note that it is not important if DDDDDD or BBBBB are valid or invalid data.


Moreover I have to point out that a simple scrub process between 1 and 2, is able to rebuild a correct parity. This would reduce the likelihood of the "write hole" bug. 
The only case which would still exists is when 1) and 2) happen at the same time (which is not impossible: i.e. if a disk die, it is not infrequent that the user shutdown the machine without waiting a clean shutdown).

BR
G.Baroncelli



-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
