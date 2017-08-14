Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-34-i6.italiaonline.it ([212.48.14.168]:39896 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752294AbdHNU1N (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 Aug 2017 16:27:13 -0400
Reply-To: kreijack@inwind.it
Subject: Re: RedHat 7.4 Release Notes: "Btrfs has been deprecated" - wut?
To: Chris Murphy <lists@colorremedies.com>
Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>, Hugo Mills <hugo@carfax.org.uk>,
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
 <97904d09-60ef-6262-9cec-11f4ebd8af6c@inwind.it>
 <CAJCQCtT5hgvHqiUDuahdyVasppV=UZhks4rpXNfWC4XEa34ywA@mail.gmail.com>
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <13652e95-6264-1a86-7c4a-ec2fccdfe705@inwind.it>
Date: Mon, 14 Aug 2017 22:27:10 +0200
MIME-Version: 1.0
In-Reply-To: <CAJCQCtT5hgvHqiUDuahdyVasppV=UZhks4rpXNfWC4XEa34ywA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/14/2017 09:08 PM, Chris Murphy wrote:
> On Mon, Aug 14, 2017 at 8:23 AM, Goffredo Baroncelli <kreijack@inwind.it> wrote:
> 
>> Form a theoretical point of view, if you have a "PURE" COW file-system, you don't need a journal. Unfortunately a RAID5/6 stripe update is a RMW cycle, so you need a journal to keep it in sync. The same is true for the NOCOW file (and their checksums)
>>
> 
> I'm pretty sure the raid56 rmw is in memory only, I don't think we
> have a case where a stripe is getting partial writes (a block in a
> stripe is being overwritten). Partial stripe updates with rmw *on
> disk* would mean Btrfs raid56 is not CoW.
> 

I am not sure about that. Consider the following cases:
- what if we have to wrote less than a stripe ?
- supposing to remove a file with length of 4k. If you don't allow a RMW cycle, this means the space would be lost forever....

Pay attention that the size of a stripe (theoretically) could be quite big: suppose to have an (insanely) raid compose by 20disks, the stripe would be about 20*64k = ~1.2MB....)

BR
G.Baroncelli


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
