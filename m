Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f52.google.com ([209.85.218.52]:34829 "EHLO
        mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754962AbcJZXIL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 26 Oct 2016 19:08:11 -0400
MIME-Version: 1.0
In-Reply-To: <2bdc068d-afd5-7a78-f334-26970c91aaca@fb.com>
References: <20161026002752.qvrm6yxqb54fiqnd@codemonkey.org.uk>
 <CA+55aFyv0k9e6bBqGm-LL3CUwimS4+rSu341P7SOV5ezYrrW_g@mail.gmail.com>
 <CA+55aFydo5oxo+ihUfGffMK6cAZnbZ8WyEiF7xgEx1Bh_aOMww@mail.gmail.com>
 <20161026163018.wx57yy554576s6e2@codemonkey.org.uk> <CA+55aFzsrRenu3NsDYr3qqO=fC9FUxkLc3M2wzeLBpN7ghwvwA@mail.gmail.com>
 <20161026184201.6ofblkd3j5uxystq@codemonkey.org.uk> <CA+55aFwD9McVapb0svQrrvP1k6iSkqz5ENNGXY6b+Yo-k7wOsg@mail.gmail.com>
 <488f9edc-6a1c-2c68-0d33-d3aa32ece9a4@fb.com> <ac6cd46c-d609-ef1f-019f-204248c26c12@fb.com>
 <CA+55aFwY5jNcUAJzDWERP2r9iZHEKzHSwMi5AJCJiaVd3Z0E-g@mail.gmail.com>
 <20161026224025.mou27kki4bslftli@codemonkey.org.uk> <CA+55aFyyP6VHOv6KbhVdMMtNfJLftbju_Ui2GNxXt0GgkKm0Jg@mail.gmail.com>
 <CA+55aFyiJGk-A_cJH41Ec8Xj0Zz9M3EU-igJ9bgusj=nm28tFQ@mail.gmail.com> <2bdc068d-afd5-7a78-f334-26970c91aaca@fb.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 26 Oct 2016 16:08:08 -0700
Message-ID: <CA+55aFxqRCEVxocpZVDMqinP=EsmgzcnvWpOT6x8NMmcBpWb2Q@mail.gmail.com>
Subject: Re: bio linked list corruption.
To: Jens Axboe <axboe@fb.com>
Cc: Dave Jones <davej@codemonkey.org.uk>, Chris Mason <clm@fb.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Andy Lutomirski <luto@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 26, 2016 at 4:03 PM, Jens Axboe <axboe@fb.com> wrote:
>
> Actually, I think I see what might trigger it. You are on nvme, iirc,
> and that has a deep queue.

Yes. I have long since moved on from slow disks, so all my systems are
not just flash, but m.2 nvme ssd's.

So at least that could explain why Dave sees it at bootup but I don't.

            Linus
