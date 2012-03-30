From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] Btrfs fixes and features
Date: Fri, 30 Mar 2012 12:54:03 -0700
Message-ID: <CA+55aFyn0TL6vJZrGVQkgAscT33nf9_7rH-DRVJbcG3K7d7QKA@mail.gmail.com>
References: <20120330175106.GB755@shiny> <CA+55aFwFkeR8pNo7dF1gr0VPD9hr+9zB8zoc_byvMxSzr2WEZw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
To: Chris Mason <chris.mason@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFwFkeR8pNo7dF1gr0VPD9hr+9zB8zoc_byvMxSzr2WEZw@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 30, 2012 at 12:50 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> This causes a new warning for me:
>
> =A0fs/btrfs/extent_io.c: In function =91repair_eb_io_failure=92:
> =A0fs/btrfs/extent_io.c:1940:6: warning: =91ret=92 may be used
> uninitialized in this function
>
> Hmm?

Ok, so presumably num_pages (which is "num_extent_pages(eb->start,
eb->len)") cannot be zero, so I guess the code is ok. But gcc can't
know that, and it's an annoying warning.

So please fix, but it's not urgent. In the meantime I've pulled and pus=
hed out.

                    Linus
