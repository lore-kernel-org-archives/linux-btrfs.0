Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:37636 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752683AbeF2SkK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Jun 2018 14:40:10 -0400
Received: by mail-oi0-f65.google.com with SMTP id k81-v6so9312230oib.4
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Jun 2018 11:40:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+X5Wn5JdervhGob5MGWRtYLt+Av5nYhTkKdAUQFgcxPUdMAsA@mail.gmail.com>
References: <66d30a90-a571-a110-749d-8a3fd6ccb9d5@georgianit.com>
 <9bbde3a8-2498-a538-5744-c857f5a57947@oracle.com> <CAJCQCtSuKpcn2Or3LiCYqeFMFFoRU09BFQE_n8FAhQ2Vo+83PA@mail.gmail.com>
 <93a74ac2-c271-accd-d0c7-4822c0f75f80@libero.it> <CAJCQCtRUgoQPNwcM54hXnNSqcm5+0d9Ks1aWw_2VYChMxWWnEg@mail.gmail.com>
 <CA+X5Wn5JdervhGob5MGWRtYLt+Av5nYhTkKdAUQFgcxPUdMAsA@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Fri, 29 Jun 2018 12:40:08 -0600
Message-ID: <CAJCQCtSE4RVZZXk191+uB-cPnYw-7vT+temnwHM1kCMvxQTtRA@mail.gmail.com>
Subject: Re: Major design flaw with BTRFS Raid, temporary device drop will
 corrupt nodatacow files
To: james harvey <jamespharvey20@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Goffredo Baroncelli <kreijack@inwind.it>,
        Anand Jain <anand.jain@oracle.com>, Remi Gauvin <remi@georgianit.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 29, 2018 at 9:15 AM, james harvey <jamespharvey20@gmail.com> wrote:
> On Thu, Jun 28, 2018 at 6:27 PM, Chris Murphy <lists@colorremedies.com> wrote:
>> And an open question I have about scrub is weather it only ever is
>> checking csums, meaning nodatacow files are never scrubbed, or if the
>> copies are at least compared to each other?
>
> Scrub never looks at nodatacow files.  It does not compare the copies
> to each other.
>
> Qu submitted a patch to make check compare the copies:
> https://patchwork.kernel.org/patch/10434509/

Yeah online scrub needs to report any mismatches, even if it can't do
anything about it because it's ambiguous which copy is wrong.


> IMO, I think the offline check should look at nodatacow copies like
> this, but I still think this also needs to be added to scrub.  In the
> patch thread, I discuss my reasons why.  In brief: online scanning;
> this goes along with user's expectation of scrub ensuring mirrored
> data integrity; and recommendations to setup scrub on periodic basis
> to me means it's the place to put it.

I don't mind this being implemented in offline scrub first for testing
purposes. But the online scrub certainly should have this ability
eventually.



-- 
Chris Murphy
