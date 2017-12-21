Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f171.google.com ([209.85.220.171]:33353 "EHLO
        mail-qk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752922AbdLULtC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 21 Dec 2017 06:49:02 -0500
Received: by mail-qk0-f171.google.com with SMTP id x7so13113555qkb.0
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Dec 2017 03:49:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTAbZ9Uf2pL_2KtHV3pSkpVhuo+DzwA9M2ZFL8=QUJxAg@mail.gmail.com>
References: <5A357909.8010206@yandex.ru> <pan$36ed4$200dd538$4324239e$ed0f9f4@cox.net>
 <23094.37316.66397.431081@tree.ty.sabi.co.uk> <91965e24-3b94-7334-c249-d8de5f585f29@gmail.com>
 <20171218194351.GA25245@polanet.pl> <7ff86029-5b0f-1d02-778a-af78c6f3e461@gmail.com>
 <20171219144644.GA9855@polanet.pl> <639c6928-4f27-5c33-738a-385e5b4f299f@gmail.com>
 <20171219175633.GA19477@polanet.pl> <CAJCQCtT+DjUDf3NBEQNxYm6SRhDL_FFXpz===fgub_k+AMmABg@mail.gmail.com>
 <2532cc1d-bbe4-a140-8c69-beecb2b73f79@gmail.com> <CAJCQCtR5HnDSOepiv4r4=kiL1P969oSyS1fr6UGUz23ksj-OYg@mail.gmail.com>
 <CAJCQCtTAbZ9Uf2pL_2KtHV3pSkpVhuo+DzwA9M2ZFL8=QUJxAg@mail.gmail.com>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Date: Thu, 21 Dec 2017 14:49:00 +0300
Message-ID: <CAA91j0U1Uoy_uxa7Zy+gh6qarceWnXiYTN6Dj=LR7jU4_sLv=Q@mail.gmail.com>
Subject: Re: Unexpected raid1 behaviour
To: Chris Murphy <lists@colorremedies.com>
Cc: Tomasz Pala <gotar@polanet.pl>,
        Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 20, 2017 at 11:07 PM, Chris Murphy <lists@colorremedies.com> wrote:
>
> YaST doesn't have Btrfs raid1 or raid10 options; and also won't do
> encrypted root with Btrfs either because YaST enforces LVM to do LUKS
> encryption for some weird reason; and it also enforces NOT putting
> Btrfs on LVM.
>

That's incorrect, btrfs on LVM is default on some SLES flavors and one
of the three standard proposals (where you do not need to go in expert
mode) - normal partitions, LVM, encrypted LVM - even on openSUSE.
