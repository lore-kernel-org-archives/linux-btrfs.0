Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:46996 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754310AbdLTNMK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Dec 2017 08:12:10 -0500
Received: by mail-io0-f196.google.com with SMTP id x129so17291046iod.13
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Dec 2017 05:12:10 -0800 (PST)
Subject: Re: Unexpected raid1 behaviour
To: Chris Murphy <lists@colorremedies.com>
Cc: Tomasz Pala <gotar@polanet.pl>,
        Linux fs Btrfs <linux-btrfs@vger.kernel.org>
References: <5A357909.8010206@yandex.ru>
 <pan$36ed4$200dd538$4324239e$ed0f9f4@cox.net>
 <23094.37316.66397.431081@tree.ty.sabi.co.uk>
 <91965e24-3b94-7334-c249-d8de5f585f29@gmail.com>
 <20171218194351.GA25245@polanet.pl>
 <7ff86029-5b0f-1d02-778a-af78c6f3e461@gmail.com>
 <20171219144644.GA9855@polanet.pl>
 <639c6928-4f27-5c33-738a-385e5b4f299f@gmail.com>
 <20171219175633.GA19477@polanet.pl>
 <4b132c07-62c7-e313-d454-b7414c737602@gmail.com>
 <CAJCQCtQ9c_W=EQXgvFQGMWzT5R8L4Yu1ELwrtTRBDJxLQw1+FA@mail.gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <4330f22d-8095-61c5-7d55-f6c0cc41feba@gmail.com>
Date: Wed, 20 Dec 2017 08:12:05 -0500
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQ9c_W=EQXgvFQGMWzT5R8L4Yu1ELwrtTRBDJxLQw1+FA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-12-19 18:53, Chris Murphy wrote:
> On Tue, Dec 19, 2017 at 1:11 PM, Austin S. Hemmelgarn
> <ahferroin7@gmail.com> wrote:
>> On 2017-12-19 12:56, Tomasz Pala wrote:
> 
>>> BTRFS lacks all of these - there are major functional changes in current
>>> kernels and it reaches far beyond LTS. All the knowledge YOU have here,
>>> on this maillist, should be 'engraved' into btrfs-progs, as there are
>>> people still using kernels with serious malfunctions. btrfs-progs could
>>> easily check kernel version and print appropriate warning - consider
>>> this a "software quirks".
>>
>> Except the systems running on those ancient kernel versions are not
>> necessarily using a recent version of btrfs-progs.
> 
> Indeed it is much more common to find old user space tools, for
> whatever reason, compared to the kernel version.
Most distros have infrastructure in place to handle quick updates to the 
kernel, and tend to keep the kernel up to date to fix hardware issues 
that affect people who may not be using BTRFS.

In contrast, btrfs-progs updates generally aren't high priority, because 
they benefit a much smaller user base (unless you're SuSE).

