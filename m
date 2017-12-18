Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f172.google.com ([74.125.82.172]:40881 "EHLO
        mail-ot0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934404AbdLRW3Y (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Dec 2017 17:29:24 -0500
Received: by mail-ot0-f172.google.com with SMTP id e74so14735409ote.7
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Dec 2017 14:29:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSeLcpyWG1SKqqfgw2MFn7ugZu1Cby6BGd=cfSbEgUmRA@mail.gmail.com>
References: <5A357909.8010206@yandex.ru> <pan$36ed4$200dd538$4324239e$ed0f9f4@cox.net>
 <23094.37316.66397.431081@tree.ty.sabi.co.uk> <be7e5573-4247-89bd-00f0-7d84120ce582@oracle.com>
 <CAJCQCtSeLcpyWG1SKqqfgw2MFn7ugZu1Cby6BGd=cfSbEgUmRA@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 18 Dec 2017 15:29:23 -0700
Message-ID: <CAJCQCtTnvH=0r9VpJT5c3Eu8Us1wYs5xwuX+h7kJaS6URR+iXA@mail.gmail.com>
Subject: Re: Unexpected raid1 behaviour
To: Chris Murphy <lists@colorremedies.com>
Cc: Anand Jain <anand.jain@oracle.com>,
        Peter Grandi <pg@btrfs.list.sabi.co.uk>,
        Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 18, 2017 at 3:28 PM, Chris Murphy <lists@colorremedies.com> wrote:
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
> mdadm uses bitmap=internal for any array larger than 100GB for this
> reason, avoiding full resync.
>
> 'btrfs sub find' will list all *added* files since an arbitrarily
> specified generation; but not deletions.

Looks like LVM raid types (the non-legacy ones that use md driver)
also use a bitmap by default.

-- 
Chris Murphy
