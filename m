Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:36405 "EHLO
        mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S945947AbcJaTfU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 31 Oct 2016 15:35:20 -0400
MIME-Version: 1.0
In-Reply-To: <20161031185514.b22zvbxvga4xcinz@codemonkey.org.uk>
References: <ac6cd46c-d609-ef1f-019f-204248c26c12@fb.com> <CA+55aFwY5jNcUAJzDWERP2r9iZHEKzHSwMi5AJCJiaVd3Z0E-g@mail.gmail.com>
 <20161026224025.mou27kki4bslftli@codemonkey.org.uk> <CA+55aFyyP6VHOv6KbhVdMMtNfJLftbju_Ui2GNxXt0GgkKm0Jg@mail.gmail.com>
 <CA+55aFyiJGk-A_cJH41Ec8Xj0Zz9M3EU-igJ9bgusj=nm28tFQ@mail.gmail.com>
 <2bdc068d-afd5-7a78-f334-26970c91aaca@fb.com> <CA+55aFxqRCEVxocpZVDMqinP=EsmgzcnvWpOT6x8NMmcBpWb2Q@mail.gmail.com>
 <203e0319-bc9b-245c-e162-709267540d22@fb.com> <20161026233808.GC15247@clm-mbp.thefacebook.com>
 <20161026234751.e66xyzjiwifvbuha@codemonkey.org.uk> <20161031185514.b22zvbxvga4xcinz@codemonkey.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 31 Oct 2016 12:35:16 -0700
Message-ID: <CA+55aFwUBYzPcbecpHw9=f8h_JuX18x5bE=Kd_k9QkCcgoiBsA@mail.gmail.com>
Subject: Re: bio linked list corruption.
To: Dave Jones <davej@codemonkey.org.uk>, Chris Mason <clm@fb.com>,
        Jens Axboe <axboe@fb.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Andy Lutomirski <luto@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 31, 2016 at 11:55 AM, Dave Jones <davej@codemonkey.org.uk> wrote:
>
> BUG: Bad page state in process kworker/u8:12  pfn:4e0e39
> page:ffffea0013838e40 count:0 mapcount:0 mapping:ffff8804a20310e0 index:0x100c
> flags: 0x400000000000000c(referenced|uptodate)
> page dumped because: non-NULL mapping

Hmm. So this seems to be btrfs-specific, right?

I searched for all your "non-NULL mapping" cases, and they all seem to
have basically the same call trace, with some work thread doing
writeback and going through btrfs_writepages().

Sounds like it's a race with either fallocate hole-punching or
truncate. I'm not seeing it, but I suspect it's btrfs, since DaveJ
clearly ran other filesystems too but I am not seeing this backtrace
for anything else.

 Linus
