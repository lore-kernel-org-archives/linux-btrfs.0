Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:54148 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752355AbdKMSSl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Nov 2017 13:18:41 -0500
Received: by mail-oi0-f66.google.com with SMTP id h6so11869390oia.10
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Nov 2017 10:18:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <55071ffd-e80e-4b0f-15a3-2381b928d0f8@siedziba.pl>
References: <CAJCQCtTJXpoSExk7aVKCZKk5YCpV6V31zUpLgQSxa+k4V8+x+w@mail.gmail.com>
 <20171112004230.GJ27985@carfax.org.uk> <CAJCQCtR5oqOT2JdO_-gSgVCnBpYz_53eBOeF32G6+ZfX6RK7Kw@mail.gmail.com>
 <4bc2caf5-6f4c-4012-2bab-4daaa766d202@siedziba.pl> <CAJCQCtSG+pVM95G-vwnDX=aqGK6_LJ_D0H=5W_VYMsrdH_=XJw@mail.gmail.com>
 <55071ffd-e80e-4b0f-15a3-2381b928d0f8@siedziba.pl>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 13 Nov 2017 11:18:40 -0700
Message-ID: <CAJCQCtTXN7eK9qz7PM6N15aVDQ9+yDyOr0fiQdeAE1k1EGWJmw@mail.gmail.com>
Subject: Re: btrfs-image hash collision option, super slow
To: =?UTF-8?Q?Piotr_Paw=C5=82ow?= <pp@siedziba.pl>
Cc: Chris Murphy <lists@colorremedies.com>, Hugo Mills <hugo@carfax.org.uk>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 13, 2017 at 1:02 AM, Piotr Pawłow <pp@siedziba.pl> wrote:
> W dniu 13.11.2017 o 04:42, Chris Murphy pisze:
>> Strange. I was using 4.3.3 and it had been running for over 9 hours at
>> the time I finally cancelled it.
>
> If you're compiling from source, the usual advice would be to "make clean" and make sure you're using the correct executable.

Interesting, using btrfs-progs-4.13.3-1.fc28.x86_64, it goes super
fast with -ss (minutes). But when using 4.3.3 built myself (nothing
special, autogen, configure, make) it's super slow, hours.




-- 
Chris Murphy
