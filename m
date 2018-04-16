Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:44244 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751205AbeDPFwv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Apr 2018 01:52:51 -0400
Date: Mon, 16 Apr 2018 01:52:31 -0400
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Vijay Chidambaram <vijay@cs.utexas.edu>
Cc: Dave Chinner <david@fromorbit.com>,
        Jayashree Mohan <jayashree2912@gmail.com>,
        Amir Goldstein <amir73il@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Subject: Re: Symlink not persisted even after fsync
Message-ID: <20180416055231.GB22870@thunk.org>
References: <CAPaz=E+-baGSWhL3nD-8X4jn6rKdn2AVGLeqWh3EY5Nh-RodRA@mail.gmail.com>
 <CAOQ4uxhRoAnxr36Cy1pov+ExnNJ8Y+inmUc7chD77ONPt=u9qw@mail.gmail.com>
 <CA+EzBbCFURDs77xiL3ECf7+4irrywbmD1HdsUSUYE_oeonbo8A@mail.gmail.com>
 <20180414012017.GF5572@dastard>
 <CAPaz=EJrOc7dBE+gBf=Gx0W-4_q0GwTrRhchquPveWs-m-Djeg@mail.gmail.com>
 <20180414215529.GG5572@dastard>
 <20180415011735.GB21830@thunk.org>
 <CAHWVdUXAyyeTGNXrtTTc+tUbA3t9TUjJPSF=M4Cetj4+d1w3eQ@mail.gmail.com>
 <20180415141338.GA22870@thunk.org>
 <CAPaz=ELkYavvWYuMg=t+L_nSZ7fZ8CkaZr-qfGVN3QfydbOh7w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAPaz=ELkYavvWYuMg=t+L_nSZ7fZ8CkaZr-qfGVN3QfydbOh7w@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Apr 15, 2018 at 07:10:52PM -0500, Vijay Chidambaram wrote:
> 
> I don't think this is what the paper's ext3-fast does. All the paper
> says is if you have a file system where the fsync of a file persisted
> only data related to that file, it would increase performance.
> ext3-fast is the name given to such a file system. Note that we do not
> present a design of ext3-fast or analyze it in any detail. In fact, we
> explicitly say "The ext3-fast file system (derived from inferences
> provided by ALICE) seems interesting for application safety, though
> further investigation is required into the validity of its design."

Well, says that it's based on ext3's data=journal "Abstract Persistent
Model".  It's true that a design was not proposed --- but if you
don't propose a design, how do you know what the performance is or
whether it's even practical?  That's one of those things I find
extremely distasteful in the paper.  Sure, I can model a faster than
light interstellar engine ala Star Trek's Warp Drive --- and I can
talk about it having, say, better performance than a reaction drive.
But it doesn't tell us anything useful about whether it can be built,
or whether it's even useful to dream about it.

To me, that part of the paper, really read as, "watch as I wave my
hands around widely, that they never leave the ends of my arms!"

> Thanks! As I mentioned before, this is useful. I have a follow-up
> question. Consider the following workload:
> 
>  creat foo
>  link (foo, A/bar)
>  fsync(foo)
>  crash
> 
> In this case, after the file system recovers, do we expect foo's link
> count to be 2 or 1? I would say 2, but POSIX is silent on this, so
> thought I would confirm. The tricky part here is we are not calling
> fsync() on directory A.
> 
> In this case, its not a symlink; its a hard link, so I would say the
> link count for foo should be 2. But btrfs and F2FS show link count of
> 1 after a crash.

Well, is the link count accurate?  That is to say, does A/bar exist?
I would think that the requirement that the file system be self
consistent is the most important consideration.

Cheers,

							- Ted
