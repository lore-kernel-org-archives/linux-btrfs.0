Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f53.google.com ([209.85.215.53]:35261 "EHLO
        mail-lf0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752775AbdA2BHG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 28 Jan 2017 20:07:06 -0500
Received: by mail-lf0-f53.google.com with SMTP id n124so178634257lfd.2
        for <linux-btrfs@vger.kernel.org>; Sat, 28 Jan 2017 17:07:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <36efd437-2b6a-0ee8-7aba-c4892d892d82@richgannon.net>
References: <36efd437-2b6a-0ee8-7aba-c4892d892d82@richgannon.net>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Sun, 29 Jan 2017 03:57:46 +0300
Message-ID: <CAGqmi75KxS5cerC3O+7gVr+t-4ya4vE2fetiBc4LxhbG4QGaAw@mail.gmail.com>
Subject: Re: Questions about drive sector sizes
To: Rich Gannon <rich@richgannon.net>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2017-01-28 11:03 GMT+03:00 Rich Gannon <rich@richgannon.net>:
> Hello Btrfs users and devs,
>
>
> I've gone searching through the mailing list dating back to 2014 or so and
> never found a positive answer - mostly "guesses" about as to the answer,
> albeit with good theories.  I have two separate questions I'm looking to
> have answered with the latest known facts, benchmarks, and anecdotes.
>
>
> 1. If a "raw" drive (no partitions) is formatted with Btrfs, will it
> correctly be aligned to 512 or 4k sectors with no additional flags?

AFAIK,
btrfs internally use memory page size as a base unit (4kb for x86), so
yes, it will be correctly aligned.

> 2. If question 1's answer is true, will drives of varying sector sizes (512
> and 4k) in the same array still be aligned correctly in single, raid0,
> raid1, raid5, etc. modes?

Same logic

> Thanks for your input,
>
> Rich
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Have a nice day,
Timofey.
