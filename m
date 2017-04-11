Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from edanaher.xen.prgmr.com ([71.19.155.118]:45002 "EHLO
        gahlpo.edanaher.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752214AbdDKNtF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Apr 2017 09:49:05 -0400
Date: Tue, 11 Apr 2017 09:49:02 -0400
From: Evan Danaher <github@edanaher.net>
To: Noah Massey <noah.massey@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs-progs: send-dump: always print a space after path
Message-ID: <20170411134902.GG2455@edanaher.net>
References: <20170411000904.GF2455@edanaher.net>
 <CADfjVrg793+_eb21OpX0ps5Fat6a=2SxED87meuMabXQjSyT=A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CADfjVrg793+_eb21OpX0ps5Fat6a=2SxED87meuMabXQjSyT=A@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks for catching that!  I overthought this and managed to convince
myself that it was correct as it stood.

Should I re-send the whole patch with that change?  This is my first
attempt at contributing to a project managed in the Linux kernel style,
so I'm not sure about the process; documentation that I've found around
responding to feedback seems to be more about social issues than the
mechanics of what to actually do...

On Tue, Apr 11, 2017 at 09:24:56AM -0400, Noah Massey wrote:
> On Mon, Apr 10, 2017 at 8:09 PM, Evan Danaher <github@edanaher.net> wrote:
> > I was shocked to discover that 'btrfs receive --dump' doesn't print a
> > space after long filenames, so it runs together into the metadata; for
> > example:
> >
> > truncate        ./20-00-03/this-name-is-32-characters-longsize=0
> >
> > This is a trivial patch to add a single space unconditionally, so the
> > result is the following:
> >
> > truncate        ./20-00-03/this-name-is-32-characters-long size=0
> >
> > I suppose this is technically a breaking change, but it seems unlikely
> > to me that anyone would depend on the existing behavior given how
> > unfriendly it is.
> >
> >
> > Signed-off-by: Evan Danaher <github@edanaher.net>
> > ---
> > diff --git a/send-dump.c b/send-dump.c
> > index 67f7977..493389f 100644
> > --- a/send-dump.c
> > +++ b/send-dump.c
> > @@ -116,9 +116,10 @@ static int __print_dump(int subvol, void *user, const char *path,
> >                 putchar('\n');
> >                 return 0;
> >         }
> > -       /* Short paths ale aligned to 32 chars */
> > -       while (ret++ < 32)
> > +       /* Short paths are aligned to 32 chars; longer paths get a single space */
> > +       do {
> >                 putchar(' ');
> > +       } while (ret++ < 32);
> 
> while (++ret < 32);
> 
> Since we're performing the check after the put, we need to
> pre-increment to count the space already added.
> 
> >         va_start(args, fmt);
> >         /* Operation specified ones */
> >         vprintf(fmt, args);
> > ---
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
