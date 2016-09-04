Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:34749 "EHLO
        mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753217AbcIDWlR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 4 Sep 2016 18:41:17 -0400
Received: by mail-oi0-f51.google.com with SMTP id m11so100382289oif.1
        for <linux-btrfs@vger.kernel.org>; Sun, 04 Sep 2016 15:41:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1472964653.8683.17.camel@scientia.net>
References: <1472964653.8683.17.camel@scientia.net>
From: Chris Murphy <lists@colorremedies.com>
Date: Sun, 4 Sep 2016 16:41:01 -0600
Message-ID: <CAJCQCtR3fjnGXEJrw2PLJR+61mtnm88CgB9yOnQWgCt3oLkfvw@mail.gmail.com>
Subject: Re: gazillions of Incorrect local/global backref count
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Sep 3, 2016 at 10:50 PM, Christoph Anton Mitterer
<calestyo@scientia.net> wrote:
> Hey.
>
> I just did a btrfs check on my notebooks root fs, with:
> $ uname -a
> Linux heisenberg 4.7.0-1-amd64 #1 SMP Debian 4.7.2-1 (2016-08-28)
> x86_64 GNU/Linux
> $ btrfs --version
> btrfs-progs v4.7.1
>
>
>
> during:
> checking extents
>
> it found gazillions of these:
> Incorrect local backref count on 1107980288 root 257 owner 17807428
> offset 13568135168 found 2 wanted 3 back 0x2d69990
> Incorrect local backref count on 1107980288 root 257 owner 14055042
> offset 13568135168 found 2 wanted 3 back 0x2d69930
> Incorrect global backref count on 1107980288 found 4 wanted 6
> backpointer mismatch on [1107980288 61440]
> Incorrect local backref count on 1108049920 root 257 owner 17807428
> offset 13568262144 found 2 wanted 5 back 0x2d69ac0
> Incorrect local backref count on 1108049920 root 257 owner 14055042
> offset 13568262144 found 2 wanted 5 back 0x2d69b20
> Incorrect global backref count on 1108049920 found 4 wanted 10
> backpointer mismatch on [1108049920 77824]
>
> See stdout/err[0] logfiles from the check.
>
>
> What do they mean?

https://bugzilla.kernel.org/show_bug.cgi?id=155791
http://www.spinics.net/lists/linux-btrfs/msg58142.html


-- 
Chris Murphy
