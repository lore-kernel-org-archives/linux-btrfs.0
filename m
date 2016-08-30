Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f44.google.com ([209.85.218.44]:35199 "EHLO
        mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751158AbcH3SE3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 Aug 2016 14:04:29 -0400
Received: by mail-oi0-f44.google.com with SMTP id p186so2178848oia.2
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Aug 2016 11:04:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+WRLO-1oJLZ56EivVTg=bycNhfpOt8ovLrLbgnNeCVKgvbxhQ@mail.gmail.com>
References: <CA+WRLO8KuP8LS77NUbZLAs3e120oFudES_R3tYQjjYiCXH4BOA@mail.gmail.com>
 <CAJCQCtSUVeXwuKn8rR_Rw24anzHNSLgVo_wYkot1mZYXiGkJ1w@mail.gmail.com>
 <CA+WRLO_6q2cZqPPkmtqjjkq7tfdh5DDyE_oHFswFoQVz8FguKw@mail.gmail.com>
 <CA+WRLO8XVaK5FK9VUt=pOgoyqYm30_yxTnCd+5zdYx5Xx6jAcw@mail.gmail.com>
 <CA+WRLO-cvepjj53xCoq=RiEmTV-6cqL+G6nQe+WnTPyWNDOUZA@mail.gmail.com> <CA+WRLO-1oJLZ56EivVTg=bycNhfpOt8ovLrLbgnNeCVKgvbxhQ@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 30 Aug 2016 12:04:27 -0600
Message-ID: <CAJCQCtQddXz26cjp=tGcO5d5E9N=Zmjdd=qwonjGdh+NJ7aLQQ@mail.gmail.com>
Subject: Re: Recommendation on raid5 drive error resolution
To: Gareth Pye <gareth@cerberos.id.au>
Cc: Chris Murphy <lists@colorremedies.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 30, 2016 at 3:58 AM, Gareth Pye <gareth@cerberos.id.au> wrote:
> Okay, things aren't looking good. The FS wont mount for me:
> http://pastebin.com/sEEdRxsN

Try to mount with -o ro,degraded. I have no idea which device it'll
end up dropping, but it might at least get you a read only mount so
you can get stuff off - if you want - without modifying the file
system.

One of us would have to go look in source to see what causes "[
163.612313] BTRFS: failed to read the system array on sdd" to appear
for each device. It's suspicious that every drive produces that
message, and there are no fixup messages at all ever. So it sounds
like it's not even getting far enough to figure out what's bad and
reconstruct from parity. And I don't even see csum errors either,
which is also suspicious. It's like the boot strapping itself is
failing which kinda implicates superblocks?

What do you get for

btrfs rescue super-recover -v /dev/sdX ?



-- 
Chris Murphy
