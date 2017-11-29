Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f46.google.com ([209.85.214.46]:33307 "EHLO
        mail-it0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752914AbdK2Wb0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 29 Nov 2017 17:31:26 -0500
MIME-Version: 1.0
In-Reply-To: <cover.1511980478.git.dsterba@suse.com>
References: <cover.1511980478.git.dsterba@suse.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 29 Nov 2017 14:31:24 -0800
Message-ID: <CA+55aFz8M-iy-wLCG9d0-+QCk_seLFWFfS9LJEpcmgqKK=9SFQ@mail.gmail.com>
Subject: Re: [GIT PULL] Btrfs fixes for 4.15-rc2
To: David Sterba <dsterba@suse.com>
Cc: Chris Mason <clm@fb.com>, linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 29, 2017 at 11:28 AM, David Sterba <dsterba@suse.com> wrote:
>
> With signed tag: for-4.15-rc2-tag
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-4.15-rc2

Oh, please actually ask me to pull the signed tag (exact same
pull-request, just point git request-pull at the tag), because now
what happened was that first I just pulled that branch you mentioned,
and only noticed that "With signed tag:" notice after I had already
pulled and was filling in the merge message.

Anyway, I redid the pull with the proper signed tag, but it was just
annoying extra work.

And I wonder how many times I _hadn't_ noticed that, because I didn't
have your key in my keyring either. Or maybe I caught it the first
time.

                    Linus
