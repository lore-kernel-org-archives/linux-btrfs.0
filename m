Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57970 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251Ab2IARYG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 1 Sep 2012 13:24:06 -0400
Received: by iahk25 with SMTP id k25so2665130iah.19
        for <linux-btrfs@vger.kernel.org>; Sat, 01 Sep 2012 10:24:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGJTRciVqG=CqP4gR4gpz2bmFYORS6ExAT_nDbau2NuCJyipeg@mail.gmail.com>
References: <CAGDaZ_oFzakgBC+NzK4X3J9yL0Q5YfZVKk671QKN0xHAMgPN7g@mail.gmail.com>
 <CAGDaZ_p2dXLr6rOZewXUEWYKV4b=dW9OZj4yXG4qPoUax2a8CA@mail.gmail.com> <CAGJTRciVqG=CqP4gR4gpz2bmFYORS6ExAT_nDbau2NuCJyipeg@mail.gmail.com>
From: Shentino <shentino@gmail.com>
Date: Sat, 1 Sep 2012 10:23:25 -0700
Message-ID: <CAGDaZ_qm+Z7ptRdp-kJx_AJgcJ+bjWX7OZ5O1ang7sbJ_Y_f-w@mail.gmail.com>
Subject: Re: rfc: fuzz testing by direct writes to device
To: Michael <mike@draftx.net>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Sep 1, 2012 at 8:41 AM, Michael <mike@draftx.net> wrote:
> Please make sure you are running a very recent kernel. Btrfs is VERY
> active and fixes for things like this are going in all the time. Any
> related crash errors, kernel oopses, and exact methodology so we can
> reproduce would be useful.
> dmesg and uname -a would help us triage this and see what we need to fix.
> Mike

I did save debug information like this, on a separate filesystem no
less...unfortunately I was unable to sync and it disappeared when I
was forced to cold boot.  I don't have a spare machine available.

To reproduce:

1.  lvcreate vg --name lv --size 1G
2.  mkbtrfs -M /dev/vg/lv
3.  mkdir /mnt/test
4.  mount /dev/vg/lv /mnt/test
5.  dd bs=1024 count=1 < /dev/urandom > /tmp/foo
6.  sha1sum /tmp/foo > /mnt/test/scrubme
7.  sync (get /mnt/test/scrubme written to disk)
8.  sed -e "s/the_sha1_sum/something_else_of_same_length/" <
/dev/vg/lv > /dev/vg/lv
9.  cat /mnt/test/scrubme (returns I/O error as expected, probably
from a failed checksum)
9. btrfs scrub /mnt/test

This is when all hell breaks loose.

Will this be enough information to at least allow it to be reproduced
or check if the bug still exists?

> On Sat, Sep 1, 2012 at 3:10 AM, Shentino <shentino@gmail.com> wrote:
>>
>> Also, since the problem prevented me from syncing my other filesystmes
>> I couldn't capture the debug info.
>>
>> It vanished during the cold boot still sitting in dirty page cache.
>>
>> On Fri, Aug 31, 2012 at 11:44 PM, Shentino <shentino@gmail.com> wrote:
>> > How effective would it be to directly write to the underlying device
>> > and then running tests to see if the corruption is properly detected?
>> >
>> > I just ran a fuzz test by syncing, and then manually corrupting a file
>> > with the help of a surgical sed (yes, the before and after patterns
>> > had fixed equal lengths).  First I got an I/O error (expected), then I
>> > ran scrub and got more problems (not ok), the system froze (not good),
>> > a reboot failed to mount the system again (worse), and then the fsck
>> > program dumped core.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
