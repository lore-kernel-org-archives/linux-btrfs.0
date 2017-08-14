Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-32-i6.italiaonline.it ([212.48.14.166]:50829 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751098AbdHNOXN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 Aug 2017 10:23:13 -0400
Reply-To: kreijack@inwind.it
Subject: Re: RedHat 7.4 Release Notes: "Btrfs has been deprecated" - wut?
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, Hugo Mills <hugo@carfax.org.uk>,
        Christoph Anton Mitterer <calestyo@scientia.net>,
        Christoph Hellwig <hch@infradead.org>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Liu Bo <bo.li.liu@oracle.com>
References: <84806456-eed9-00b9-b3f6-99e46cefba33@swiftspirit.co.za>
 <4c094049-f8c8-a0ea-674b-33c6905d744a@gmx.com>
 <CAJCQCtRGUBWD6Mw6pAiKGAPgGz+vqy3sgmbEBDETPYsxJw8G7w@mail.gmail.com>
 <b14a36dd-fcab-a38b-cbf9-adbd096da3a3@gmx.com>
 <1502496618.6092.6.camel@scientia.net> <20170812074248.GA3352@infradead.org>
 <1502538706.3996.1.camel@scientia.net> <20170812121257.GZ7140@carfax.org.uk>
 <1219eff6-7020-444c-efd7-6afb5ef551d9@libero.it>
 <86a8d523-8dc3-8406-af4c-8bb93e7859c5@gmx.com>
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <97904d09-60ef-6262-9cec-11f4ebd8af6c@inwind.it>
Date: Mon, 14 Aug 2017 16:23:11 +0200
MIME-Version: 1.0
In-Reply-To: <86a8d523-8dc3-8406-af4c-8bb93e7859c5@gmx.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/14/2017 09:08 AM, Qu Wenruo wrote:
> 
>>
>> Supposing to log for each transaction BTRFS which "data NOCOW blocks" will be updated and their checksum, in case a transaction is interrupted you know which blocks have to be checked and are able to verify if the checksum matches and correct the mismatch. Logging also the checksum could help to identify if:
>> - the data is old
>> - the data is updated
>> - the updated data is correct
>>
>> The same approach could be used also to solving also the issue related to the infamous RAID5/6 hole: logging which block are updated, in case of transaction aborted you can check the parity which have to be rebuild.
> Indeed Liu is using journal to solve RAID5/6 write hole.
> 
> But to address the lack-of-journal nature of btrfs, he introduced a journal device to handle it, since btrfs metadata is either written or trashed, we can't rely existing btrfs metadata to handle journal.

The Liu's solution is a lot heavier. With the Liu's solution, you need to write both the data and parity 2 times. I am only suggest to track the block to update. And it would be only need for the stripes involved by a RMW cycle. This is a lot less data to write (8 byte vs 4Kbyte)

> 
> PS: This reminds me why ZFS is still using journal (called ZFS intent log) but not mandatory metadata CoW of btrfs.

Form a theoretical point of view, if you have a "PURE" COW file-system, you don't need a journal. Unfortunately a RAID5/6 stripe update is a RMW cycle, so you need a journal to keep it in sync. The same is true for the NOCOW file (and their checksums)


> 
> Thanks,
> Qu


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
