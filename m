Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f176.google.com ([209.85.223.176]:54435 "EHLO
        mail-io0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750713AbdISGwl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Sep 2017 02:52:41 -0400
Received: by mail-io0-f176.google.com with SMTP id h66so7671292ioh.11
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Sep 2017 23:52:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1fa167f4-a8ba-84c7-8e06-9c7e9f3d30e7@gmail.com>
References: <CAH=dxU7t=p8MVh1y2Tv7wPrP=1ntYcHCy7W6aBQGRtMp_gaaRA@mail.gmail.com>
 <1fa167f4-a8ba-84c7-8e06-9c7e9f3d30e7@gmail.com>
From: Dave <davestechshop@gmail.com>
Date: Tue, 19 Sep 2017 02:52:20 -0400
Message-ID: <CAH=dxU6cae36FhTir9rPZcBgoeOaMKDXqr0pgZSJGevz9fgX4Q@mail.gmail.com>
Subject: Re: ERROR: parent determination failed (btrfs send-receive)
To: Andrei Borzenkov <arvidjaar@gmail.com>, g.btrfs@cobb.uk.net
Cc: linux-btrfs@vger.kernel.org, 1i5t5.duncan@cox.net
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 18, 2017 at 12:23 AM, Andrei Borzenkov <arvidjaar@gmail.com> wrote:
>
> 18.09.2017 05:31, Dave пишет:
> > Sometimes when using btrfs send-receive, I get errors like this:
> >
> > ERROR: parent determination failed for <subvolume name>
> >
> > When this happens, btrfs send-receive backups fail. And all subsequent
> > backups fail too.
> >
> > The issue seems to stem from the fact that an automated cleanup
> > process removes certain earlier subvolumes. (I'm using Snapper.)
> >
> > I'd like to understand exactly what is happening so that my backups do
> > not unexpectedly fail.
> >
>
> You try to send incremental changes but you deleted subvolume to compute
> changes against. It is hard to tell more without seeing subvolume list
> with uuid/parent uuid.
>

Thanks to Duncan <1i5t5.duncan@cox.net> I have a bit better
understanding of -c and -p now.

My backup tool is using only the -c option. (The tool is GitHub -
wesbarnett/snap-sync https://github.com/wesbarnett/snap-sync .)

No subvolume at the destination had ever been deleted.

At the source, a number (about 30 in this case) preceding snapshots
(subvolumes) exist, but some others have been cleaned up with
Snapper's timeline algorithm.

I think I understand that with the -c option, it is **not** strictly
necessary that the specified snapshots exist on both the source and
destination. It seems I had sufficient subvolumes available for the
incremental send to work with the -c option.

Therefore, it still isn't clear why I got the error: ERROR: parent
determination failed.

Further general comments will be helpful.

I understand the limits in getting too specific in replies because I
cannot give subvolume lists with uuid's.

As mentioned, I cannot give that info because I tried to fix the above
error by sending a subvolume from the destination back to the target.
This resulted in my source volume having a "Received UUID" which
wrecked all subsequent backups.

I now understand that (for my use cases) a source subvolume for a
send-receive should **never** have a Received UUID. (If that is indeed
a general rule, it seems btrfs tools should check it. Or possibly
something about this the pitfalls of a "Received UUID" in a source
could be listed on the BTRFS incremental backup wiki page?)

I was previously referred to the FAQ here:
https://github.com/digint/btrbk/blob/master/doc/FAQ.md#im-getting-an-error-aborted-received-uuid-is-set

But in the end, I decided the safest strategy was to delete all prior
backup subvolumes so I could be sure my backups were valid going
forward.

I am asking these questions now to avoid getting into a situation like
this again (hopefully). Any general comments are appreciated.
