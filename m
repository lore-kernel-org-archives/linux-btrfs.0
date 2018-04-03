Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-18-i6.italiaonline.it ([213.209.14.18]:52671 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752693AbeDCRDK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 3 Apr 2018 13:03:10 -0400
Reply-To: kreijack@inwind.it
Subject: Re: Status of RAID5/6
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
        "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Christoph Anton Mitterer <calestyo@scientia.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <20180331050345.GE2446@hungrycats.org>
 <b4d5bb24-e8d0-dc1b-94d2-4e7f9a292630@inwind.it>
 <CAJCQCtRpWj45Ja_isnR=aV+iqDObZdKDNHH-g7+33Edz3Cq4=Q@mail.gmail.com>
 <20180401034544.GA28769@hungrycats.org>
 <CAJCQCtSrcFD7jTbrqsWZFWrKUrMp4wW0QhkPApB-pgA-O3WksA@mail.gmail.com>
 <CAJCQCtTXQGbVjRLegC25DDokcv4Wph6O04s=C_rzp8n5jRpt5Q@mail.gmail.com>
 <20180402054521.GC28769@hungrycats.org>
 <df74c8a6-b748-20c5-8bef-eb261b645b29@inwind.it>
 <7c76dae7-b38c-d514-4284-1cd093f5bcac@gmail.com>
 <20180402222250.GH2446@hungrycats.org> <20180403003102.GI2446@hungrycats.org>
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <242e2515-fad2-e98d-3e59-c0838362afdc@inwind.it>
Date: Tue, 3 Apr 2018 19:03:06 +0200
MIME-Version: 1.0
In-Reply-To: <20180403003102.GI2446@hungrycats.org>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/03/2018 02:31 AM, Zygo Blaxell wrote:
> On Mon, Apr 02, 2018 at 06:23:34PM -0400, Zygo Blaxell wrote:
>> On Mon, Apr 02, 2018 at 11:49:42AM -0400, Austin S. Hemmelgarn wrote:
>>> On 2018-04-02 11:18, Goffredo Baroncelli wrote:
>>>> I thought that a possible solution is to create BG with different
>>> number of data disks. E.g. supposing to have a raid 6 system with 6
>>> disks, where 2 are parity disk; we should allocate 3 BG
>>>> BG #1: 1 data disk, 2 parity disks
>>>> BG #2: 2 data disks, 2 parity disks,
>>>> BG #3: 4 data disks, 2 parity disks
>>>>
>>>> For simplicity, the disk-stripe length is assumed = 4K.
>>>>
>>>> So If you have a write with a length of 4 KB, this should be placed
>>> in BG#1; if you have a write with a length of 4*3KB, the first 8KB,
>>> should be placed in in BG#2, then in BG#1.
>>>> This would avoid space wasting, even if the fragmentation will
>>> increase (but shall the fragmentation matters with the modern solid
>>> state disks ?).
>> I don't really see why this would increase fragmentation or waste space.

> Oh, wait, yes I do.  If there's a write of 6 blocks, we would have
> to split an extent between BG #3 (the first 4 blocks) and BG #2 (the
> remaining 2 blocks).  It also flips the usual order of "determine size
> of extent, then allocate space for it" which might require major surgery
> on the btrfs allocator to implement.

I have to point out that in any case the extent is physically interrupted at the disk-stripe size. Assuming disk-stripe=64KB, if you want to write 128KB, the first half is written in the first disk, the other in the 2nd disk.  If you want to write 96kb, the first 64 are written in the first disk, the last part in the 2nd, only on a different BG.
So yes there is a fragmentation from a logical point of view; from a physical point of view the data is spread on the disks in any case.

In any case, you are right, we should gather some data, because the performance impact are no so clear.

I am not worried abut having different BG; we have problem with these because we never developed tool to handle this issue properly (i.e. a daemon which starts a balance when needed). But I hope that this will be solved in future.

In any case, the all solutions proposed have their trade off:

- a) as is: write hole bug
- b) variable stripe size (like ZFS): big impact on how btrfs handle the extent. limited waste of space
- c) logging data before writing: we wrote the data two times in a short time window. Moreover the log area is written several order of magnitude more than the other area; there was some patch around
- d) rounding the writing to the stripe size: waste of space; simple to implement;
- e) different BG with different stripe size: limited waste of space; logical fragmentation.


* c),d),e) are applied only for the tail of the extent, in case the size is less than the stripe size.
* for b),d), e), the wasting of space may be reduced with a balance 

-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
