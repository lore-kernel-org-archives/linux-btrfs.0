Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f196.google.com ([74.125.82.196]:33165 "EHLO
        mail-ot0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753349AbdLSXxq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Dec 2017 18:53:46 -0500
Received: by mail-ot0-f196.google.com with SMTP id h9so18263255oti.0
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Dec 2017 15:53:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4b132c07-62c7-e313-d454-b7414c737602@gmail.com>
References: <5A357909.8010206@yandex.ru> <pan$36ed4$200dd538$4324239e$ed0f9f4@cox.net>
 <23094.37316.66397.431081@tree.ty.sabi.co.uk> <91965e24-3b94-7334-c249-d8de5f585f29@gmail.com>
 <20171218194351.GA25245@polanet.pl> <7ff86029-5b0f-1d02-778a-af78c6f3e461@gmail.com>
 <20171219144644.GA9855@polanet.pl> <639c6928-4f27-5c33-738a-385e5b4f299f@gmail.com>
 <20171219175633.GA19477@polanet.pl> <4b132c07-62c7-e313-d454-b7414c737602@gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 19 Dec 2017 16:53:44 -0700
Message-ID: <CAJCQCtQ9c_W=EQXgvFQGMWzT5R8L4Yu1ELwrtTRBDJxLQw1+FA@mail.gmail.com>
Subject: Re: Unexpected raid1 behaviour
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Tomasz Pala <gotar@polanet.pl>,
        Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 19, 2017 at 1:11 PM, Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:
> On 2017-12-19 12:56, Tomasz Pala wrote:

>> BTRFS lacks all of these - there are major functional changes in current
>> kernels and it reaches far beyond LTS. All the knowledge YOU have here,
>> on this maillist, should be 'engraved' into btrfs-progs, as there are
>> people still using kernels with serious malfunctions. btrfs-progs could
>> easily check kernel version and print appropriate warning - consider
>> this a "software quirks".
>
> Except the systems running on those ancient kernel versions are not
> necessarily using a recent version of btrfs-progs.

Indeed it is much more common to find old user space tools, for
whatever reason, compared to the kernel version.


-- 
Chris Murphy
