Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx-relay14-hz1.antispameurope.com ([94.100.132.214]:39249 "EHLO
        mx-relay14-hz1.antispameurope.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753564AbeAIKWa (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 9 Jan 2018 05:22:30 -0500
Date: Tue, 9 Jan 2018 11:15:56 +0100
From: Joerg Schilling <Joerg.Schilling@fokus.fraunhofer.de>
To: <praiskup@redhat.com>, <eggert@cs.ucla.edu>
CC: <mhw@netris.org>, <linux-btrfs@vger.kernel.org>, <bug-tar@gnu.org>
Subject: Re: [Bug-tar] [PATCH] Re: Detection of sparse files is broken on
 btrfs
Message-ID: <5a54965c.D6Hm4qlW4vP6gFVx%Joerg.Schilling@fokus.fraunhofer.de>
References: <87fu7hccci.fsf@netris.org>
 <5923534.bzxSDfjug7@nb.usersys.redhat.com>
 <ae4ec76e-7681-6338-cec5-c0be658df62d@cs.ucla.edu>
 <2685951.fM9P32U3bG@nb.usersys.redhat.com>
In-Reply-To: <2685951.fM9P32U3bG@nb.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Pavel Raiskup <praiskup@redhat.com> wrote:

> On Tuesday, January 9, 2018 8:59:06 AM CET Paul Eggert wrote:
> > Pavel Raiskup wrote:
> > > So what about special casing that filesystem, where we can lseek() for
> > > holes anyway?
> > 
> > If we can lseek for holes, then why not just do that?
>
> Checking whether lseek() actually works costs some additional syscalls _per
> sparse_ file;  checking for ST_NBLOCKS() is without this penalty.

Well, star does this since a long time and the penalty is a few microseconds.

"~A
