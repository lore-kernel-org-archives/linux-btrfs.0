Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f172.google.com ([209.85.128.172]:33189 "EHLO
        mail-wr0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751085AbdFUSYw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Jun 2017 14:24:52 -0400
Received: by mail-wr0-f172.google.com with SMTP id r103so146023824wrb.0
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Jun 2017 11:24:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <60421001-5d74-2fb4-d916-7a397f246f20@cn.fujitsu.com>
References: <1f5a4702-d264-51c6-aadd-d2cf521a45eb@dirtcellar.net> <60421001-5d74-2fb4-d916-7a397f246f20@cn.fujitsu.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 21 Jun 2017 12:24:45 -0600
Message-ID: <CAJCQCtRM4L1DSbWU7okANdimoO6F-KgSV=y2KEovj0zMW7h6bA@mail.gmail.com>
Subject: Re: Exactly what is wrong with RAID5/6
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: waxhead <waxhead@dirtcellar.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 21, 2017 at 2:45 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:

> Unlike pure stripe method, one fully functional RAID5/6 should be written in
> full stripe behavior, which is made up by N data stripes and correct P/Q.
>
> Given one example to show how write sequence affects the usability of
> RAID5/6.
>
> Existing full stripe:
> X = Used space (Extent allocated)
> O = Unused space
> Data 1   |XXXXXX|OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO|
> Data 2   |OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO|
> Parity   |WWWWWW|ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ|
>
> When some new extent is allocated to data 1 stripe, if we write
> data directly into that region, and crashed.
> The result will be:
>
> Data 1   |XXXXXX|XXXXXX|OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO|
> Data 2   |OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO|
> Parity   |WWWWWW|ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ|
>
> Parity stripe is not updated, although it's fine since data is still
> correct, this reduces the usability, as in this case, if we lost device
> containing data 2 stripe, we can't recover correct data of data 2.
>
> Although personally I don't think it's a big problem yet.
>
> Someone has idea to modify extent allocator to handle it, but anyway I don't
> consider it's worthy.


If there is parity corruption and there is a lost device (or bad
sector causing lost data strip), that is in effect two failures and no
raid5 recovers, you have to have raid6. However, I don't know whether
Btrfs raid6 can even recover from it? If there is a single device
failure, with a missing data strip, you have both P&Q. Typically raid6
implementations use P first, and only use Q if P is not available. Is
Btrfs raid6 the same? And if reconstruction from P fails to match data
csum, does Btrfs retry using Q? Probably not is my guess.

I think that is a valid problem calling for a solution on Btrfs, given
its mandate. It is no worse than other raid6 implementations though
which would reconstruct from bad P, and give no warning, leaving it up
to application layers to deal with the problem.

I have no idea how ZFS RAIDZ2 and RAIDZ3 handle this same scenario.



>
>>
>> 2. Parity data is not checksummed
>> Why is this a problem? Does it have to do with the design of BTRFS
>> somehow?
>> Parity is after all just data, BTRFS does checksum data so what is the
>> reason this is a problem?
>
>
> Because that's one solution to solve above problem.
>
> And no, parity is not data.

Parity strip is differentiated from data strip, and by itself parity
is meaningless. But parity plus n-1 data strips is an encoded form of
the missing data strip, and is therefore an encoded copy of the data.
We kinda have to treat the parity as fractionally important compared
to data; just like each mirror copy has some fractional value. You
don't have to have both of them, but you do have to have at least one
of them.


-- 
Chris Murphy
