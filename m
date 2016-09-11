Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:33601 "EHLO
        mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751623AbcIKUdV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 11 Sep 2016 16:33:21 -0400
Received: by mail-oi0-f45.google.com with SMTP id y2so268338006oie.0
        for <linux-btrfs@vger.kernel.org>; Sun, 11 Sep 2016 13:33:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAK5rZE49j5QYZJSriG70LVo-9JnRJRfwFA0qRZSEotXpCxJC6A@mail.gmail.com>
References: <CAK5rZE49j5QYZJSriG70LVo-9JnRJRfwFA0qRZSEotXpCxJC6A@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Sun, 11 Sep 2016 14:33:18 -0600
Message-ID: <CAJCQCtT5T5M7a1vtaGZjGLiPs_6-MnMXc5qPoH0Hc7RJPz0HZw@mail.gmail.com>
Subject: Re: Small fs
To: Imran Geriskovan <imran.geriskovan@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Sep 11, 2016 at 9:27 AM, Imran Geriskovan
<imran.geriskovan@gmail.com> wrote:
> What is the smallest recommended fs size for btrfs?

It depends on the layout. And there is some confusion about the mkfs
command message it returns when it doesn't work out.

https://bugzilla.kernel.org/show_bug.cgi?id=112461

Something else that's screwy in that bug that I just realized, why is
it not defaulting to mixed-block groups on a 100MiB fallocated file? I
thought mixed-bg was the default below a certain size like 2GiB or
whatever?


>
> - There are mentions of 256MB around the net.
> - Gparted reserves minimum of 256MB for btrfs.
>
> With an ordinary partition on a single disk,
> fs created with just "mkfs.btrfs /dev/sdxx":
> - 128MB works fine.
> - 127MB works but as if it is 64MB.
>
> Can we say size should be in multiples of 64MB?

Why should it be in multiples?  I think what you're describing is part
of the bug above that just needs to be fixed. Btrfs itself internally
uses bytes, so multiples of 64MiB is OK but I wouldn't  use the word
"should" with it.

-- 
Chris Murphy
