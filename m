Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:51334 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090AbaFPL40 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Jun 2014 07:56:26 -0400
Received: by mail-we0-f171.google.com with SMTP id q58so5621481wes.16
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Jun 2014 04:56:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140616101448.GB18016@tango.0pointer.de>
References: <1346098950.2730051402571606829.JavaMail.defaultUser@defaultHost>
	<539BFF47.8060006@libero.it>
	<20140615221307.GE24386@tango.0pointer.de>
	<1709025.rRUgx5gMp1@xev>
	<20140616101448.GB18016@tango.0pointer.de>
Date: Mon, 16 Jun 2014 15:56:25 +0400
Message-ID: <CAA91j0VW+NWYGjAN9Nj-AoAv9xyKWkL5dDYNLfeso7xGLPHRjg@mail.gmail.com>
Subject: Re: [systemd-devel] Slow startup of systemd-journal on BTRFS
From: Andrey Borzenkov <arvidjaar@gmail.com>
To: Lennart Poettering <lennart@poettering.net>
Cc: Russell Coker <russell@coker.com.au>,
        SystemD Devel <systemd-devel@lists.freedesktop.org>,
        kreijack@inwind.it, Duncan <1i5t5.duncan@cox.net>,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 16, 2014 at 2:14 PM, Lennart Poettering
<lennart@poettering.net> wrote:
> On Mon, 16.06.14 10:17, Russell Coker (russell@coker.com.au) wrote:
>
>> > I am not really following though why this trips up btrfs though. I am
>> > not sure I understand why this breaks btrfs COW behaviour. I mean,
>> > fallocate() isn't necessarily supposed to write anything really, it's
>> > mostly about allocating disk space in advance. I would claim that
>> > journald's usage of it is very much within the entire reason why it
>> > exists...
>>
>> I don't believe that fallocate() makes any difference to fragmentation on
>> BTRFS.  Blocks will be allocated when writes occur so regardless of an
>> fallocate() call the usage pattern in systemd-journald will cause
>> fragmentation.
>
> journald's write pattern looks something like this: append something to
> the end, make sure it is written, then update a few offsets stored at
> the beginning of the file to point to the newly appended data. This is
> of course not easy to handle for COW file systems. But then again, it's
> probably not too different from access patterns of other database or
> database-like engines...
>

... which traditionally experienced severe sequential read performance
degradation in this case. As I understand this is exactly what happens
- readahead attempts to preload files which gives us heavy random read
access.

The only real remedy was to defragment files. It should work
relatively well for journal where files are mostly "write once" at the
expense of additional read/write activity.
