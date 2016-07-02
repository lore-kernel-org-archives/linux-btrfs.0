Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:35916 "EHLO
	mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469AbcGBTEU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 2 Jul 2016 15:04:20 -0400
Received: by mail-oi0-f68.google.com with SMTP id x6so17786824oif.3
        for <linux-btrfs@vger.kernel.org>; Sat, 02 Jul 2016 12:03:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5785a25d-0bf4-53c9-0b85-eb50be140062@mendix.com>
References: <CAKzrAgRQOvpy3ZVrLHHaRQt-JcjiFSFz6HPGr1vnvBK0xy5xGg@mail.gmail.com>
 <CAPmG0jZUx+V+1eyw1cDpHDkudXqfLQFL9+53Lzb3f0_PGXw+Xw@mail.gmail.com>
 <CAKzrAgTngBtK+eRGFh75GZ3MmuBKYyjbQXjD_LBhE8J-TuN0yg@mail.gmail.com>
 <575B378E.8050304@mendix.com> <CAKzrAgTSnSyNV7KO4ERkH1BohdPEzzwbqGVSx3UhET+5PwUH2g@mail.gmail.com>
 <575B4198.4050803@mendix.com> <57d127c6-8362-8d47-79c2-19f60d930858@gmail.com>
 <5785a25d-0bf4-53c9-0b85-eb50be140062@mendix.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Sat, 2 Jul 2016 13:03:24 -0600
Message-ID: <CAJCQCtS_yjnqQwMk+8RooVkmAAkiv+2jt=xEeVz4OkvAThubwg@mail.gmail.com>
Subject: Re: Cannot balance FS (No space left on device)
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>, "ojab //" <ojab@ojab.ru>,
        Henk Slager <eye1tm@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jul 2, 2016 at 9:07 AM, Hans van Kranenburg
<hans.van.kranenburg@mendix.com> wrote:

>
> Also, the behaviour of *always* creating a new empty block group before
> starting to work (which makes it impossible to free up space on a fully
> allocated filesystem with balance) got reverted in:
>
> https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/commit/?id=cf25ce518e8ef9d59b292e51193bed2b023a32da
>
> This patch is in 4.5 and 4.7-rc, but *not* in 4.6.

Upstream it first appears in 4.5.7.

-- 
Chris Murphy
