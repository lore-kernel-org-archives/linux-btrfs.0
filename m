Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:33758 "EHLO
        mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753256AbcIOTCo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Sep 2016 15:02:44 -0400
Received: by mail-oi0-f53.google.com with SMTP id r126so83440740oib.0
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Sep 2016 12:02:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <24d64f38-f036-3ae9-71fd-0c626cfbb52c@gmail.com>
References: <57D51BF9.2010907@online.no> <20160912142714.GE16983@twin.jikos.cz>
 <20160912162747.GF16983@twin.jikos.cz> <8df2691f-94c1-61de-881f-075682d4a28d@gmail.com>
 <CAJCQCtQUS-8F+pOtQ2VA9=j=-TGV=wOfj+3SnnMvY3HMTzd=9g@mail.gmail.com>
 <1ef8e6db-89a1-6639-cd9a-4e81590456c5@gmail.com> <CAJCQCtQq08bOpRbZq90wRLUGD62Rnqwx6vjJOv5hvPVwp=jz0w@mail.gmail.com>
 <24d64f38-f036-3ae9-71fd-0c626cfbb52c@gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Thu, 15 Sep 2016 13:02:43 -0600
Message-ID: <CAJCQCtR_hMPj8Nrf=U1L=WvDWq48Ns1K25p4JtKEJnVwb1231Q@mail.gmail.com>
Subject: Re: Is stability a joke? (wiki updated)
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>, David Sterba <dsterba@suse.cz>,
        Waxhead <waxhead@online.no>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 15, 2016 at 12:20 PM, Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:

> 2. We're developing new features without making sure that check can fix
> issues in any associated metadata.  Part of merging a new feature needs to
> be proving that fsck can handle fixing any issues in the metadata for that
> feature short of total data loss or complete corruption.
>
> 3. Fsck should be needed only for un-mountable filesystems.  Ideally, we
> should be handling things like Windows does.  Preform slightly better
> checking when reading data, and if we see an error, flag the filesystem for
> expensive repair on the next mount.

Right, well I'm vaguely curious why ZFS, as different as it is,
basically take the position that if the hardware went so batshit that
they can't unwind it on a normal mount, then an fsck probably can't
help either... they still don't have an fsck and don't appear to want
one.

I'm not sure if the brfsck is really all that helpful to user as much
as it is for developers to better learn about the failure vectors of
the file system.


> 4. Btrfs check should know itself if it can fix something or not, and that
> should be reported.  I have an otherwise perfectly fine filesystem that
> throws some (apparently harmless) errors in check, and check can't repair
> them.  Despite this, it gives zero indication that it can't repair them,
> zero indication that it didn't repair them, and doesn't even seem to give a
> non-zero exit status for this filesystem.

Yeah, it's really not a user tool in my view...



>
> As far as the other tools:
> - Self-repair at mount time: This isn't a repair tool, if the FS mounts,
> it's not broken, it's just a messy and the kernel is tidying things up.
> - btrfsck/btrfs check: I think I covered the issues here well.
> - Mount options: These are mostly just for expensive checks during mount,
> and most people should never need them except in very unusual circumstances.
> - btrfs rescue *: These are all fixes for very specific issues.  They should
> be folded into check with special aliases, and not be separate tools.  The
> first fixes an issue that's pretty much non-existent in any modern kernel,
> and the other two are for very low-level data recovery of horribly broken
> filesystems.
> - scrub: This is a very purpose specific tool which is supposed to be part
> of regular maintainence, and only works to fix things as a side effect of
> what it does.
> - balance: This is also a relatively purpose specific tool, and again only
> fixes things as a side effect of what it does.
>

Yeah I know, it's just much of this is non-obvious to users unfamiliar
with this file system. And even I'm often throwing spaghetti on a
wall.


-- 
Chris Murphy
