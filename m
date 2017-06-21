Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f179.google.com ([209.85.128.179]:36840 "EHLO
        mail-wr0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751083AbdFUSn3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Jun 2017 14:43:29 -0400
Received: by mail-wr0-f179.google.com with SMTP id c11so91218368wrc.3
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Jun 2017 11:43:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <a88f7896-5693-ad90-383e-a24c61110e8a@rqc.ru>
References: <1f5a4702-d264-51c6-aadd-d2cf521a45eb@dirtcellar.net>
 <20170620232525.GF7140@carfax.org.uk> <CAJCQCtSMGjsrZ7N0gWQE744w_au7g1nUMXb1wL2nTa9kgmzYrA@mail.gmail.com>
 <a88f7896-5693-ad90-383e-a24c61110e8a@rqc.ru>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 21 Jun 2017 12:43:26 -0600
Message-ID: <CAJCQCtSJNi3sGJci8xbjgoMOVjc92howEZ5PfJBThWAbm0AVMg@mail.gmail.com>
Subject: Re: Exactly what is wrong with RAID5/6
To: Marat Khalili <mkh@rqc.ru>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 21, 2017 at 12:51 AM, Marat Khalili <mkh@rqc.ru> wrote:
> On 21/06/17 06:48, Chris Murphy wrote:
>>
>> Another possibility is to ensure a new write is written to a new*not*
>> full stripe, i.e. dynamic stripe size. So if the modification is a 50K
>> file on a 4 disk raid5; instead of writing 3 64K data strips + 1 64K
>> parity strip (a full stripe write); write out 1 64K data strip + 1 64K
>> parity strip. In effect, a 4 disk raid5 would quickly get not just 3
>> data + 1 parity strip Btrfs block groups; but 1 data + 1 parity, and 2
>> data + 1 parity chunks, and direct those write to the proper chunk
>> based on size. Anyway that's beyond my ability to assess how much
>> allocator work that is. Balance I'd expect to rewrite everything to
>> max data strips possible; the optimization would only apply to normal
>> operation COW..

> This will make some filesystems mostly RAID1, negating all space savings of
> RAID5, won't it?

No. It'd only apply to partial stripe writes, typically small files.
But small file, metadata centric workloads suck for raid5 anyway, and
should use raid1. So making the implementation more like raid1 than
raid5 for the RMW case I think is still better than Btrfs raid56 RMW
writes in effect being no-COW.


> Isn't it easier to recalculate parity block based using previous state of
> two rewritten strips, parity and data? I don't understand all performance
> implications, but it might scale better with number of devices.

The problem is atomicity. Either the data strip or parity strip is
overwritten first, and before the other is committed, the file system
is not merely inconsistent, it's basically lying, there's no way to
know for sure after the fact whether the data or parity were properly
written. And even the metadata is inconsistent too because it can only
describe the unmodified state and the successfully modified state,
whereas a 3rd state "partially modified" is possible and no way to
really fix it.


-- 
Chris Murphy
