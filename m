Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35972 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754191Ab2IAU7m (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 1 Sep 2012 16:59:42 -0400
Received: by pbbrr13 with SMTP id rr13so6466474pbb.19
        for <linux-btrfs@vger.kernel.org>; Sat, 01 Sep 2012 13:59:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGDaZ_qm+Z7ptRdp-kJx_AJgcJ+bjWX7OZ5O1ang7sbJ_Y_f-w@mail.gmail.com>
References: <CAGDaZ_oFzakgBC+NzK4X3J9yL0Q5YfZVKk671QKN0xHAMgPN7g@mail.gmail.com>
	<CAGDaZ_p2dXLr6rOZewXUEWYKV4b=dW9OZj4yXG4qPoUax2a8CA@mail.gmail.com>
	<CAGJTRciVqG=CqP4gR4gpz2bmFYORS6ExAT_nDbau2NuCJyipeg@mail.gmail.com>
	<CAGDaZ_qm+Z7ptRdp-kJx_AJgcJ+bjWX7OZ5O1ang7sbJ_Y_f-w@mail.gmail.com>
Date: Sat, 1 Sep 2012 14:59:42 -0600
Message-ID: <CAE5mzvgp1LAaYrMyjbAKZVRyKcaoWAZwQVBfGQQUZh+6+w9Rvw@mail.gmail.com>
Subject: Re: rfc: fuzz testing by direct writes to device
From: cwillu <cwillu@cwillu.com>
To: Shentino <shentino@gmail.com>
Cc: Michael <mike@draftx.net>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Sep 1, 2012 at 11:23 AM, Shentino <shentino@gmail.com> wrote:
> On Sat, Sep 1, 2012 at 8:41 AM, Michael <mike@draftx.net> wrote:
>> Please make sure you are running a very recent kernel. Btrfs is VERY
>> active and fixes for things like this are going in all the time. Any
>> related crash errors, kernel oopses, and exact methodology so we can
>> reproduce would be useful.
>> dmesg and uname -a would help us triage this and see what we need to fix.
>> Mike
>
> I did save debug information like this, on a separate filesystem no
> less...unfortunately I was unable to sync and it disappeared when I
> was forced to cold boot.  I don't have a spare machine available.
>
> To reproduce:
>
> 1.  lvcreate vg --name lv --size 1G
> 2.  mkbtrfs -M /dev/vg/lv
> 3.  mkdir /mnt/test
> 4.  mount /dev/vg/lv /mnt/test
> 5.  dd bs=1024 count=1 < /dev/urandom > /tmp/foo
> 6.  sha1sum /tmp/foo > /mnt/test/scrubme
> 7.  sync (get /mnt/test/scrubme written to disk)
> 8.  sed -e "s/the_sha1_sum/something_else_of_same_length/" <
> /dev/vg/lv > /dev/vg/lv
> 9.  cat /mnt/test/scrubme (returns I/O error as expected, probably
> from a failed checksum)
> 9. btrfs scrub /mnt/test
>
> This is when all hell breaks loose.
>
> Will this be enough information to at least allow it to be reproduced
> or check if the bug still exists?

You still haven't said which kernel you were running; the thing to do
is try the very latest rc (if not btrfs-next).
