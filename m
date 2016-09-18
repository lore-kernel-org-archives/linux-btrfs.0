Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f43.google.com ([209.85.218.43]:35641 "EHLO
        mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751581AbcIRRec (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 18 Sep 2016 13:34:32 -0400
Received: by mail-oi0-f43.google.com with SMTP id w11so167471444oia.2
        for <linux-btrfs@vger.kernel.org>; Sun, 18 Sep 2016 10:34:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtStO0eO9CqLTW00mZHZd8jDJJV4V-ir4-OQzd2AfyXWSQ@mail.gmail.com>
References: <1473773990-3071-1-git-send-email-anand.jain@oracle.com>
 <20160916084958.GA933@twin.jikos.cz> <313b1db1-cf32-7103-e259-328517d1c81f@oracle.com>
 <20160917203519.GE933@twin.jikos.cz> <f1b74a5d-1fdf-2970-86fc-206a4bb26d78@oracle.com>
 <CAJCQCtStO0eO9CqLTW00mZHZd8jDJJV4V-ir4-OQzd2AfyXWSQ@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Sun, 18 Sep 2016 11:34:30 -0600
Message-ID: <CAJCQCtR-KtGS31nnGPqH1xNkJZWkHy48zBZTi5sTDFd67H4Nbg@mail.gmail.com>
Subject: Re: RAID1 availability issue[2], Hot-spare and auto-replace
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Sep 18, 2016 at 11:28 AM, Chris Murphy <lists@colorremedies.com> wrote:
> On Sun, Sep 18, 2016 at 2:34 AM, Anand Jain <anand.jain@oracle.com> wrote:
>>
>> (updated the subject, was [1])
>>
>>> IMO the hot-spare feature makes most sense with the raid56,
>>
>>
>>   Why. ?
>
> Raid56 is not scalable, has less redundancy in most all
> configurations, rebuild impacts the entire array performance, and in
> the case of raid6 two drives lost means incredibly slow rebuild. All
> of that adds up to more disk for raid56 to be mitigated with a hot
> spare being available for immediate rebuild.

s/disk/risk


-- 
Chris Murphy
