Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f172.google.com ([209.85.220.172]:41785 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932657AbaFQSqi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Jun 2014 14:46:38 -0400
Received: by mail-vc0-f172.google.com with SMTP id hy10so6914981vcb.3
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Jun 2014 11:46:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAE5mzvj6yA3FhZ-bpR29XLuuk8BbuOfW4HP9BKnxuuYN8L8_kw@mail.gmail.com>
References: <1346098950.2730051402571606829.JavaMail.defaultUser@defaultHost>
	<539BFF47.8060006@libero.it>
	<20140615221307.GE24386@tango.0pointer.de>
	<1709025.rRUgx5gMp1@xev>
	<20140616101448.GB18016@tango.0pointer.de>
	<539F15DC.4010600@fb.com>
	<lnnht8$f3j$1@ger.gmane.org>
	<CAE5mzvj6yA3FhZ-bpR29XLuuk8BbuOfW4HP9BKnxuuYN8L8_kw@mail.gmail.com>
Date: Tue, 17 Jun 2014 11:46:37 -0700
Message-ID: <CADU+-uCQe+ThvH8EOW0tn+Oh4ZNnSP0P743mF7NXNDuD2yokCA@mail.gmail.com>
Subject: Re: [systemd-devel] Slow startup of systemd-journal on BTRFS
From: Filipe Brandenburger <filbranden@google.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>,
        systemd-devel@lists.freedesktop.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 16, 2014 at 6:13 PM, cwillu <cwillu@cwillu.com> wrote:
> For the case of sequential writes (via write or mmap), padding writes
> to page boundaries would help, if the wasted space isn't an issue.
> Another approach, again assuming all other writes are appends, would
> be to periodically (but frequently enough that the pages are still in
> cache) read a chunk of the file and write it back in-place, with or
> without an fsync. On the other hand, if you can afford to lose some
> logs on a crash, not fsyncing/msyncing after each write will also
> eliminate the fragmentation.

I was wondering if something could be done in btrfs to improve
performance under this workload... Something like a "defrag on demand"
for a case where mostly appends are happening.

When there are small appends with fsync/msync, they become new
fragments (as expected), but once the writes go past a block boundary,
btrfs could defragment the previous block in background, since it's
not really expected to change again.

That could potentially achieve performance close to chattr +C without
the drawbacks of disabling copy-on-write.

Cheers,
Filipe
