From: Alex Elder <aelder@sgi.com>
Subject: Re: [PATCH] xfstests: add new getdents test
Date: Fri, 23 Sep 2011 08:56:22 -0500
Message-ID: <1316786182.2879.8.camel@doink>
References: <1315786747-12109-1-git-send-email-notasas@gmail.com>
	 <1316722702.2009.59.camel@doink>
	 <CANOLnOPm+BEQ0QOYnYRkJqpGPwyUD9D+23dJe2OwgrHXqYFyVA@mail.gmail.com>
Reply-To: <aelder@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: <xfs@oss.sgi.com>, <linux-btrfs@vger.kernel.org>
To: Grazvydas Ignotas <notasas@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CANOLnOPm+BEQ0QOYnYRkJqpGPwyUD9D+23dJe2OwgrHXqYFyVA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 2011-09-23 at 16:03 +0300, Grazvydas Ignotas wrote:
> On Thu, Sep 22, 2011 at 11:18 PM, Alex Elder <aelder@sgi.com> wrote:
> > On Mon, 2011-09-12 at 03:19 +0300, Grazvydas Ignotas wrote:
> >> The test checks if no duplicate d_off values are returned and that
> >> those values are seekable to the right inodes.
> >>
> >> Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>
> >
> > I have two minor comments on the C program below,
> > but even if you don't want to address them this
> > looks good.
> >
> > Reviewed-by: Alex Elder <aelder@sgi.com>
> >

. . .

> >> +static uint64_t d_off_histoty[HISTORY_LEN];
> >> +static uint64_t d_ino_histoty[HISTORY_LEN];
> >
> > Is "histoty" intentional or a typo?
> 
> whoops, it's a typo. I might send a patch for this later.

I will change this for you before committing.

> >
> >> +int
> >> +main(int argc, char *argv[])

. . .

> >> +             nread = syscall(SYS_getdents64, fd, buf, BUF_SIZE);
> >
> > You could just use sizeof (struct linux_dirent_64) rather than
> > BUF_SIZE here.  I suppose it doesn't hurt but there's no real
> > sense in reading more than the one you're going to look at.
> 
> I'm not sure if reading partial entry is allowed, manpage says it may
> fail with EINVAL if buffer size is too small..

I will keep this as-is.  I was wrong about the size you should
pass, but my point still stands...  For a single entry you need
to pass a buffer big enough to hold a linux_dirent64 structure
*plus* the maximum-sized name that entry could contain.  That
appears to be 256 bytes, though POSIX allows more.

Anyway, if you or anyone else wants to try to change this
in the future to read in a smaller amount here, that's fine
but it's not necessary now.

Bottom line, I'll make the change I mentioned above and
will commit the result.

					-Alex


