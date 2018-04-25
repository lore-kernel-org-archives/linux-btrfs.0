Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from newman.cs.utexas.edu ([128.83.139.110]:36206 "EHLO
        newman.cs.utexas.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751150AbeDYDQq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Apr 2018 23:16:46 -0400
Received: from mail-yw0-f171.google.com (mail-yw0-f171.google.com [209.85.161.171])
        (authenticated bits=0)
        by newman.cs.utexas.edu (8.14.4/8.14.4/Debian-4.1ubuntu1) with ESMTP id w3P3GjKH011965
        (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Apr 2018 22:16:46 -0500
Received: by mail-yw0-f171.google.com with SMTP id u10-v6so5898618ywl.11
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Apr 2018 20:16:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtT7S9Qb-m3-7EXJPwtMT9nuUJjDykHi915KU+fc4fB-aQ@mail.gmail.com>
References: <CA+EzBbC7rmYsKjy_+rkwJLK-bmU51q+a4rnezvOoZYyJ8kWGqg@mail.gmail.com>
 <CAJCQCtT7S9Qb-m3-7EXJPwtMT9nuUJjDykHi915KU+fc4fB-aQ@mail.gmail.com>
From: Vijaychidambaram Velayudhan Pillai <vijay@cs.utexas.edu>
Date: Tue, 24 Apr 2018 22:16:40 -0500
Message-ID: <CAHWVdUXeDs+M1HeyiPxLbQHhw8BCW2SXeOGf69Er4_EQP4tgDA@mail.gmail.com>
Subject: Re: Inconsistent behavior of fsync in btrfs
To: Chris Murphy <lists@colorremedies.com>
Cc: Jayashree Mohan <jayashree2912@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

On Tue, Apr 24, 2018 at 10:07 PM, Chris Murphy <lists@colorremedies.com> wrote:
> I don't have answer to your question, but I'm curious exactly how you
> simulate a crash? For my own really rudimentary testing I've been doing
> crazy things like:
>
> # grub-mkconfig -o /boot/efi && echo b > /proc/sysrq-trigger
>
> And seeing what makes it to disk - or not. And I'm finding a some
> non-determinstic results are possible even in a VM which is a bit confusing.
> I'm sure with real hardware I'd find even more inconsistency.

We are using software we developed called CrashMonkey [1]. It
simulates the state on storage after a crash (taking into accounts
FLUSH and FUA flags). Talk slides on how it works can be found here
[2].

It is similar to dm-log-writes if you have used that in the past.

[1] https://github.com/utsaslab/crashmonkey
[2] http://www.cs.utexas.edu/~vijay/papers/hotstorage17-crashmonkey-slides.pdf

Thanks,
Vijay Chidambaram
