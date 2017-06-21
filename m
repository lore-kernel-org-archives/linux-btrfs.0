Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f49.google.com ([209.85.215.49]:35262 "EHLO
        mail-lf0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751106AbdFURNn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Jun 2017 13:13:43 -0400
Received: by mail-lf0-f49.google.com with SMTP id p189so101225384lfe.2
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Jun 2017 10:13:43 -0700 (PDT)
Subject: Re: Exactly what is wrong with RAID5/6
To: Marat Khalili <mkh@rqc.ru>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <1f5a4702-d264-51c6-aadd-d2cf521a45eb@dirtcellar.net>
 <20170620232525.GF7140@carfax.org.uk>
 <CAJCQCtSMGjsrZ7N0gWQE744w_au7g1nUMXb1wL2nTa9kgmzYrA@mail.gmail.com>
 <a88f7896-5693-ad90-383e-a24c61110e8a@rqc.ru>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <cce2a097-e1bc-5597-5f14-b720f73576be@gmail.com>
Date: Wed, 21 Jun 2017 20:13:40 +0300
MIME-Version: 1.0
In-Reply-To: <a88f7896-5693-ad90-383e-a24c61110e8a@rqc.ru>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

21.06.2017 09:51, Marat Khalili пишет:
> On 21/06/17 06:48, Chris Murphy wrote:
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
>> operation COW.
> This will make some filesystems mostly RAID1, negating all space savings
> of RAID5, won't it?
> 
> Isn't it easier to recalculate parity block based using previous state
> of two rewritten strips, parity and data? I don't understand all
> performance implications, but it might scale better with number of devices.
> 

That's what it effectively does today; the problem is, RAID[56] layer is
below btrfs allocator so same stripe may be shared by different
transactions. This defeats the very idea of redirect on write where data
on disk is assumed to never be changed by subsequent modifications.
