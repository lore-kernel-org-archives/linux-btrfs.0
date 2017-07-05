Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:33009 "EHLO
        mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752545AbdGEXpu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 5 Jul 2017 19:45:50 -0400
MIME-Version: 1.0
In-Reply-To: <cover.1499176138.git.dsterba@suse.com>
References: <cover.1499176138.git.dsterba@suse.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 5 Jul 2017 16:45:49 -0700
Message-ID: <CA+55aFwFWYtivrNgayV2nhpjv780eWMGRyJA=YwRia6-zvZb_A@mail.gmail.com>
Subject: Re: [GIT PULL] Btrfs for 4.13
To: David Sterba <dsterba@suse.com>, Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@lst.de>
Cc: Chris Mason <clm@fb.com>, linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 4, 2017 at 8:19 AM, David Sterba <dsterba@suse.com> wrote:
>
> There are conflicts with the recently merged block layer branch, the
> resolutions are a bit tedious but still straightforward. Stephen sent a mail
> about that [1]. You can find my merge at for-4.13-part1-merged, there might be
> some whitespace formatting differences but the result is the same.

Ouch, yeah, that was annoying. And yes, I ended up with several
whitespace differences but other than that it looks the same. Oh well.

Jens, Christoph, let's not do that stupid thing with status-vs-error
ever again, ok?

               Linus
