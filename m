Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f52.google.com ([209.85.214.52]:35544 "EHLO
        mail-it0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755843AbcILNBL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Sep 2016 09:01:11 -0400
Received: by mail-it0-f52.google.com with SMTP id r192so7254648ita.0
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Sep 2016 06:01:11 -0700 (PDT)
Subject: Re: Small fs
To: Imran Geriskovan <imran.geriskovan@gmail.com>,
        Chris Murphy <lists@colorremedies.com>
References: <CAK5rZE49j5QYZJSriG70LVo-9JnRJRfwFA0qRZSEotXpCxJC6A@mail.gmail.com>
 <CAJCQCtT5T5M7a1vtaGZjGLiPs_6-MnMXc5qPoH0Hc7RJPz0HZw@mail.gmail.com>
 <CAK5rZE4xvyuBCKC+OC-cupfAeudgA3EwoOWUEaTer+3_ohH6xg@mail.gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <9d4c732d-bd0b-bd1d-2351-317ae3a38ebb@gmail.com>
Date: Mon, 12 Sep 2016 09:01:07 -0400
MIME-Version: 1.0
In-Reply-To: <CAK5rZE4xvyuBCKC+OC-cupfAeudgA3EwoOWUEaTer+3_ohH6xg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-09-12 08:54, Imran Geriskovan wrote:
> On 9/11/16, Chris Murphy <lists@colorremedies.com> wrote:
>> Something else that's screwy in that bug that I just realized, why is
>> it not defaulting to mixed-block groups on a 100MiB fallocated file? I
>> thought mixed-bg was the default below a certain size like 2GiB or
>> whatever?
>
>>> With an ordinary partition on a single disk,
>>> fs created with just "mkfs.btrfs /dev/sdxx":
>>> - 128MB works fine.
>>> - 127MB works but as if it is 64MB.
>>> Can we say size should be in multiples of 64MB?
>
>> Why should it be in multiples?  I think what you're describing is part
>> of the bug above that just needs to be fixed. Btrfs itself internally
>> uses bytes, so multiples of 64MiB is OK but I wouldn't  use the word
>> "should" with it.
>
> I'm not suggesting anything. I'm just describing the behaviour
> we've seen. If it is (or will be) something different its all ok for me.
>
> But, what is that "formal behaviour" at the low end?
> That is the discussion..
Formally, with mixed-bg and otherwise default options, you should be 
able to get to about 48-49% of the total size of the FS worth of data 
stored.  In practice, I see such filesystems start having issues at 
about 45% of the total size.  Note that this is not the percentages 
reported by regular df (which should say about 90% full in this case), b 
ut a comparison based on du -sh and the size of the partition.

