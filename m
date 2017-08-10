Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:53670 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752266AbdHJAgK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 9 Aug 2017 20:36:10 -0400
Subject: Re: RedHat 7.4 Release Notes: "Btrfs has been deprecated" - wut?
To: Chris Murphy <lists@colorremedies.com>
Cc: Brendan Hide <brendan@swiftspirit.co.za>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <84806456-eed9-00b9-b3f6-99e46cefba33@swiftspirit.co.za>
 <4c094049-f8c8-a0ea-674b-33c6905d744a@gmx.com>
 <CAJCQCtRGUBWD6Mw6pAiKGAPgGz+vqy3sgmbEBDETPYsxJw8G7w@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <b14a36dd-fcab-a38b-cbf9-adbd096da3a3@gmx.com>
Date: Thu, 10 Aug 2017 08:35:56 +0800
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRGUBWD6Mw6pAiKGAPgGz+vqy3sgmbEBDETPYsxJw8G7w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2017年08月07日 23:27, Chris Murphy wrote:
> On Fri, Aug 4, 2017 at 8:05 AM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>>
>>      For example, if one day there is some dm-csum to support verify csum of
>> given ranges (and skip unrelated ones specified by higher levels), btrfs
>> support for data csum is no longer an exclusive feature.
> 
> How would dm-csum differ from dm-integrity?
> https://www.kernel.org/doc/Documentation/device-mapper/dm-integrity.txt

Well, pretty much the same what I want.

While my idea is to do n-way buffered csum update. (n=2 should be most 
common case)
That's to say, for CRC32(4 bytes) of 4K write, the csum space will be 
reserved as 4bytes * n.
Even crash happened, one can verify all the csum slots if it's either 
old or new data.

That's just a degraded journal anyway, and may still cause data loss for 
power loss if data is still updated half way.

> 
> By that description it uses a journal to guarantee atomicity. If
> multiqueue maybe the performance implications are neutral. But
> certainly on spinning drives that would slow things down, especially
> if the file system is also journaling, and the workload is metadata
> heavy.

That's what btrfs is good at, better co-operation between different layers.
But this doesn't mean traditional dm solution can't figure out its way.

[No double-csum for metadata for btrfs]
Btrfs will not double calculate csum for metadata, which has its own 
csum at its header.
And nodatacow data will not cause csum calculation.

But if we have extra flag bits for bio to co-operate fs and dm/block 
driver, it can still be solved. (Maybe even easier)

For example, if there is extra bio flags to info dm-integrity or any 
supported block device driver not to calculate csum for specified bio, 
then we can avoid such useless double-csum for metadata or nodatacow write.

[Good solution on data cow and csum]
Despite of that possible performance improvement, btrfs also solves the 
problem of async data and csum write, by disabling csum completely for 
nocow contents, so there is no need to journal csum write and data. 
(Journaling data is super slow).

However nowadays, fs like XFS also has its own extent backref tree to 
know if given write is new (or CoWed) write or rewrite.

So following the method above, if we have another flag to info 
dm-integrity that a given bio is rewriting or not, then it can be 
handled much better.

For example, if a bio is rewriting data and dm-integrity is configured 
for better performance, then just let dm-integrity to mark that bio 
range to nocsum and ignore existing csum.
So that dm-integrity can avoid must of its data and csum journal. (New 
or CoWed write won't need to be journaled, just like what btrfs is doing)

In short, there is always method to do more or less the same thing btrfs 
can do.
So I will not be surprised if one day there is a solution to do 
everything current btrfs can do, with robust code base and less 
modification to current kernel.

Thanks,
Qu
