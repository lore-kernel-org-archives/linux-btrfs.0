Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:36186 "EHLO
        mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756357AbcJRXjY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Oct 2016 19:39:24 -0400
MIME-Version: 1.0
In-Reply-To: <20161018233148.GA93792@clm-mbp.masoncoding.com>
References: <20161011144507.okg6baqvodn2m2lh@codemonkey.org.uk>
 <20161018224205.bjgloslaxcej2td2@codemonkey.org.uk> <e9e28964-4540-6e95-b4b7-aafd509fd8bc@fb.com>
 <20161018233148.GA93792@clm-mbp.masoncoding.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 18 Oct 2016 16:39:22 -0700
Message-ID: <CA+55aFz37uBqo9LG6pwRCB1pU94o3yz1SXwj3xwzHRXtg5Cgyw@mail.gmail.com>
Subject: Re: bio linked list corruption.
To: Chris Mason <clm@fb.com>, Jens Axboe <axboe@fb.com>,
        Dave Jones <davej@codemonkey.org.uk>,
        Al Viro <viro@zeniv.linux.org.uk>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 18, 2016 at 4:31 PM, Chris Mason <clm@fb.com> wrote:
>
> Jens, not sure if you saw the whole thread.  This has triggered bad page
> state errors, and also corrupted a btrfs list.  It hurts me to say, but it
> might not actually be your fault.

Where is that thread, and what is the "this" that triggers problems?

Looking at the "->mq_list" users, I'm not seeing any changes there in
the last year or so. So I don't think it's the list itself.

              Linus
