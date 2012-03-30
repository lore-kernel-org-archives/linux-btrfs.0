From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] Btrfs fixes and features
Date: Fri, 30 Mar 2012 12:50:26 -0700
Message-ID: <CA+55aFwFkeR8pNo7dF1gr0VPD9hr+9zB8zoc_byvMxSzr2WEZw@mail.gmail.com>
References: <20120330175106.GB755@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
To: Chris Mason <chris.mason@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120330175106.GB755@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 30, 2012 at 10:51 AM, Chris Mason <chris.mason@oracle.com> =
wrote:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git f=
or-linus

This causes a new warning for me:

  fs/btrfs/extent_io.c: In function =91repair_eb_io_failure=92:
  fs/btrfs/extent_io.c:1940:6: warning: =91ret=92 may be used
uninitialized in this function

Hmm?

                Linus
