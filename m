Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f170.google.com ([209.85.220.170]:44507 "EHLO
        mail-qk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1762822AbdLSMyx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Dec 2017 07:54:53 -0500
Received: by mail-qk0-f170.google.com with SMTP id h19so22348100qkj.11
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Dec 2017 04:54:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSeLcpyWG1SKqqfgw2MFn7ugZu1Cby6BGd=cfSbEgUmRA@mail.gmail.com>
References: <5A357909.8010206@yandex.ru> <pan$36ed4$200dd538$4324239e$ed0f9f4@cox.net>
 <23094.37316.66397.431081@tree.ty.sabi.co.uk> <be7e5573-4247-89bd-00f0-7d84120ce582@oracle.com>
 <CAJCQCtSeLcpyWG1SKqqfgw2MFn7ugZu1Cby6BGd=cfSbEgUmRA@mail.gmail.com>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Date: Tue, 19 Dec 2017 15:54:52 +0300
Message-ID: <CAA91j0XCo+rmfq5CniVoxVtdPc=2UVXmutBb=hoTGkkCN=Wt1A@mail.gmail.com>
Subject: Re: Unexpected raid1 behaviour
To: Chris Murphy <lists@colorremedies.com>
Cc: Anand Jain <anand.jain@oracle.com>,
        Peter Grandi <pg@btrfs.list.sabi.co.uk>,
        Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 19, 2017 at 1:28 AM, Chris Murphy <lists@colorremedies.com> wrote:
> On Mon, Dec 18, 2017 at 1:49 AM, Anand Jain <anand.jain@oracle.com> wrote:
>
>>  Agreed. IMO degraded-raid1-single-chunk is an accidental feature
>>  caused by [1], which we should revert back, since..
>>    - balance (to raid1 chunk) may fail if FS is near full
>>    - recovery (to raid1 chunk) will take more writes as compared
>>      to recovery under degraded raid1 chunks
>
>
> The advantage of writing single chunks when degraded, is in the case
> where a missing device returns (is readded, intact). Catching up that
> device with the first drive, is a manual but simple invocation of
> 'btrfs balance start -dconvert=raid1,soft -mconvert=raid1,soft'   The
> alternative is a full balance or full scrub. It's pretty tedious for
> big arrays.
>

The alternative would be to introduce new "resilver" operation that
would allocate second copy for every degraded chunk. And it could even
be started automatically when enough redundacy is present again.

> mdadm uses bitmap=internal for any array larger than 100GB for this
> reason, avoiding full resync.
>

ZFS manages to avoid full sync in this case quite efficiently.
