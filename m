Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32800 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932218AbeAJMAX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Jan 2018 07:00:23 -0500
From: Pavel Raiskup <praiskup@redhat.com>
To: bug-tar@gnu.org
Cc: Joerg Schilling <Joerg.Schilling@fokus.fraunhofer.de>, eggert@cs.ucla.edu,
        mhw@netris.org, linux-btrfs@vger.kernel.org
Subject: Re: [Bug-tar] [PATCH] Re: Detection of sparse files is broken on btrfs
Date: Wed, 10 Jan 2018 13:00:19 +0100
Message-ID: <3363772.gnJ4KdsmPr@nb.usersys.redhat.com>
In-Reply-To: <5a54965c.D6Hm4qlW4vP6gFVx%Joerg.Schilling@fokus.fraunhofer.de>
References: <87fu7hccci.fsf@netris.org> <2685951.fM9P32U3bG@nb.usersys.redhat.com> <5a54965c.D6Hm4qlW4vP6gFVx%Joerg.Schilling@fokus.fraunhofer.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tuesday, January 9, 2018 11:15:56 AM CET Joerg Schilling wrote:
> Pavel Raiskup <praiskup@redhat.com> wrote:
> 
> > On Tuesday, January 9, 2018 8:59:06 AM CET Paul Eggert wrote:
> > > Pavel Raiskup wrote:
> > > > So what about special casing that filesystem, where we can lseek() for
> > > > holes anyway?
> > > 
> > > If we can lseek for holes, then why not just do that?
> >
> > Checking whether lseek() actually works costs some additional syscalls _per
> > sparse_ file;  checking for ST_NBLOCKS() is without this penalty.
> 
> Well, star does this since a long time and the penalty is a few microseconds.

It would be interesting to see how network filesystems are affected.

Pavel



