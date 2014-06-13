Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f50.google.com ([209.85.216.50]:48212 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754331AbaFMX7A (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Jun 2014 19:59:00 -0400
Received: by mail-qa0-f50.google.com with SMTP id m5so4540949qaj.23
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Jun 2014 16:58:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALb+jKqYiQYsHdfOBbOhd4bkR1Y_+Qjv4mvyqq8ZBuLoJkyeag@mail.gmail.com>
References: <1402613853-14956-1-git-send-email-abuchbinder@google.com>
	<CALb+jKqYiQYsHdfOBbOhd4bkR1Y_+Qjv4mvyqq8ZBuLoJkyeag@mail.gmail.com>
Date: Fri, 13 Jun 2014 16:58:59 -0700
Message-ID: <CALb+jKoLOWVfMiBC9rPoNKi-y03d+=b1UcfDGwT4HALD7p5hLQ@mail.gmail.com>
Subject: Re: [PATCH] Properly size the leafsize field in the mdrestore_struct struct.
From: Adam Buchbinder <abuchbinder@google.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'd like to follow up on this a bit, because the way I found it was *weird*.

MSan found an uninitialized write. Reproducing the issue through GDB
showed that there's a struct mdrestore_struct type with a member of
type u64 called 'leafsize' which was... half-initialized? Four bytes
were uninitialized, four were initialized. Looking further, it was
being set by a call to a getter function defined in ctree.h, which
pulls a particular member from a superblock struct... which is of type
u32. Aha! So the struct member was missized. Easy enough to fix.
Except that the mdrestore_struct is initialized using calloc, so the
part that wasn't getting written to was
actually initialized, and the part that *was* was showing up as
uninitialized. And actually contained a sane value, reliably. What was
going on?

Turns out that btrfs's use of zlib, which was the uninstrumented
system version, caused anything allocated by uncompress() to show up
as uninitialized. (Trying to use __msan_unpoison did not work, as I
have an iffy install of the
sanitizer in the first place (it's whatever happened to come with
clang-3.3), and MSanDR (the dynamic-instrumentation tool which marks
all uninstrumented libraries as good) is apparently not trivial to
install. I may just build zlib.) But the point is, it would have been
annoying and sad if this had been a false positive through and
through, but I *did* find an actual issue here using MSan, even though
MSan was pointing in the exact wrong place.

Adam Buchbinder
