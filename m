Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f51.google.com ([209.85.215.51]:33912 "EHLO
        mail-lf0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932945AbcILMy5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Sep 2016 08:54:57 -0400
Received: by mail-lf0-f51.google.com with SMTP id u14so86257697lfd.1
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Sep 2016 05:54:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtT5T5M7a1vtaGZjGLiPs_6-MnMXc5qPoH0Hc7RJPz0HZw@mail.gmail.com>
References: <CAK5rZE49j5QYZJSriG70LVo-9JnRJRfwFA0qRZSEotXpCxJC6A@mail.gmail.com>
 <CAJCQCtT5T5M7a1vtaGZjGLiPs_6-MnMXc5qPoH0Hc7RJPz0HZw@mail.gmail.com>
From: Imran Geriskovan <imran.geriskovan@gmail.com>
Date: Mon, 12 Sep 2016 15:54:54 +0300
Message-ID: <CAK5rZE4xvyuBCKC+OC-cupfAeudgA3EwoOWUEaTer+3_ohH6xg@mail.gmail.com>
Subject: Re: Small fs
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 9/11/16, Chris Murphy <lists@colorremedies.com> wrote:
> Something else that's screwy in that bug that I just realized, why is
> it not defaulting to mixed-block groups on a 100MiB fallocated file? I
> thought mixed-bg was the default below a certain size like 2GiB or
> whatever?

>> With an ordinary partition on a single disk,
>> fs created with just "mkfs.btrfs /dev/sdxx":
>> - 128MB works fine.
>> - 127MB works but as if it is 64MB.
>> Can we say size should be in multiples of 64MB?

> Why should it be in multiples?  I think what you're describing is part
> of the bug above that just needs to be fixed. Btrfs itself internally
> uses bytes, so multiples of 64MiB is OK but I wouldn't  use the word
> "should" with it.

I'm not suggesting anything. I'm just describing the behaviour
we've seen. If it is (or will be) something different its all ok for me.

But, what is that "formal behaviour" at the low end?
That is the discussion..
