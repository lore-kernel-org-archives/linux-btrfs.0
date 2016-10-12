Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f43.google.com ([209.85.218.43]:36456 "EHLO
        mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932876AbcJLWpa (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Oct 2016 18:45:30 -0400
Received: by mail-oi0-f43.google.com with SMTP id m72so77914996oik.3
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Oct 2016 15:45:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20161012222955.GB2412@fox.home>
References: <20161012222955.GB2412@fox.home>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 12 Oct 2016 16:45:27 -0600
Message-ID: <CAJCQCtQxnu3kc-iPV4kJjoCnU2EQtCZesGzfAkiE=ZfxWbg8Og@mail.gmail.com>
Subject: Re: Incremental send robustness question
To: Sean Greenslade <sean@seangreenslade.com>
Cc: Btrfs List <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 12, 2016 at 4:29 PM, Sean Greenslade
<sean@seangreenslade.com> wrote:
> Hi, all. I have a question about a backup plan I have involving
> send/receive. As far as I can tell, there's no way to to resume a send
> that has been interrupted. In this case, my interruption comes from an
> overbearing firewall that doesn't like long-lived connections. I'm
> trying to do the initial (non-incremental) sync of the first snapshot
> from my main server to my backup endpoint. The snapshot is ~900 GiB, and
> the internet link is 25 Mbps, so this'll be going for quite a long time.
>
> What I would like to do is "fake" the first snapshot transfer by
> rsync-ing the files over. So my question is this: if I rsync a subvolume
> (with the -a option to make all file times, permissions, ownerships,
> etc. the same), is that good enough to then be used as a parent for
> future incremental sends?

No. There will be allocation differences in inode and number of
extents, and whether they're shared. But even before that, incremental
receive will fail immediately because it will see the parent isn't
really on the receive side.


> And while we're at it, what are the failure modes for incremental sends?
> Will it throw an error if the parents don't match, or will there just be
> silent failures?

It will give you an error that it can't find the parent.


>I would imagine receive would barf if it was told to
> reference a file that didn't exist, but what if the referenced file is
> there but contains different data? Are there checks for this sort of
> thing, or is it always assumed that the parent subvols are identical and
> if they're not, you're in undefined behavior land?

I haven't tried to break this too much so I'm not sure.

https://btrfs.wiki.kernel.org/index.php/Design_notes_on_Send/Receive

-- 
Chris Murphy
