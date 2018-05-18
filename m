Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pl0-f68.google.com ([209.85.160.68]:43963 "EHLO
        mail-pl0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751747AbeERWqh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 May 2018 18:46:37 -0400
Received: by mail-pl0-f68.google.com with SMTP id c41-v6so5357000plj.10
        for <linux-btrfs@vger.kernel.org>; Fri, 18 May 2018 15:46:37 -0700 (PDT)
Date: Fri, 18 May 2018 15:46:35 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        =?iso-8859-1?Q?Niccol=F2?= Belli <darkbasic@linuxsystems.it>,
        David Sterba <dsterba@suse.cz>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Any chance to get snapshot-aware defragmentation?
Message-ID: <20180518224635.GC1125@vader>
References: <4428b2eb-796a-4c1b-8527-a05532436da4@linuxsystems.it>
 <20180518162051.GS6649@twin.jikos.cz>
 <99d57070-a1df-45ef-8f7e-df832bd7ad92@linuxsystems.it>
 <de7adf73-ba0b-9154-e3d1-b4e468ad3c96@gmail.com>
 <161bea23-f1ea-4f01-b3ea-2c5e706102a7@linuxsystems.it>
 <07cf6f9b-7d67-93b9-2a6f-6d031ccf5468@gmail.com>
 <CAJCQCtQj=PYFF_Hi2M51-mZhY=swX46+YitgUX+95OvxUJ8n2w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <CAJCQCtQj=PYFF_Hi2M51-mZhY=swX46+YitgUX+95OvxUJ8n2w@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 18, 2018 at 04:26:16PM -0600, Chris Murphy wrote:
> On Fri, May 18, 2018 at 12:33 PM, Austin S. Hemmelgarn
> <ahferroin7@gmail.com> wrote:
> > On 2018-05-18 13:18, Niccolò Belli wrote:
> >>
> >> On venerdì 18 maggio 2018 19:10:02 CEST, Austin S. Hemmelgarn wrote:
> >>>
> >>> and also forces the people who have ridiculous numbers of snapshots to
> >>> deal with the memory usage or never defrag
> >>
> >>
> >> Whoever has at least one snapshot is never going to defrag anyway, unless
> >> he is willing to double the used space.
> >>
> > With a bit of work, it's possible to handle things sanely.  You can
> > deduplicate data from snapshots, even if they are read-only (you need to
> > pass the `-A` option to duperemove and run it as root), so it's perfectly
> > reasonable to only defrag the main subvolume, and then deduplicate the
> > snapshots against that (so that they end up all being reflinks to the main
> > subvolume).  Of course, this won't work if you're short on space, but if
> > you're dealing with snapshots, you should have enough space that this will
> > work (because even without defrag, it's fully possible for something to
> > cause the snapshots to suddenly take up a lot more space).
> 
> 
> Curiously, snapshot aware defragmentation is going to increase free
> space fragmentation. For busy in-use systems, it might be necessary to
> use space cache v2 to avoid performance problems.
> 
> I forget the exact reason why the free space tree is not the default,
> I think it has to do with missing repair support?

Yeah, Nikolay is working on that.
