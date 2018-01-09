Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33144 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756721AbeAIIZn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 9 Jan 2018 03:25:43 -0500
From: Pavel Raiskup <praiskup@redhat.com>
To: Paul Eggert <eggert@cs.ucla.edu>
Cc: bug-tar@gnu.org, Mark H Weaver <mhw@netris.org>,
        linux btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [Bug-tar] [PATCH] Re: Detection of sparse files is broken on btrfs
Date: Tue, 09 Jan 2018 09:25:40 +0100
Message-ID: <2685951.fM9P32U3bG@nb.usersys.redhat.com>
In-Reply-To: <ae4ec76e-7681-6338-cec5-c0be658df62d@cs.ucla.edu>
References: <87fu7hccci.fsf@netris.org> <5923534.bzxSDfjug7@nb.usersys.redhat.com> <ae4ec76e-7681-6338-cec5-c0be658df62d@cs.ucla.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tuesday, January 9, 2018 8:59:06 AM CET Paul Eggert wrote:
> Pavel Raiskup wrote:
> > So what about special casing that filesystem, where we can lseek() for
> > holes anyway?
> 
> If we can lseek for holes, then why not just do that?

Checking whether lseek() actually works costs some additional syscalls _per
sparse_ file;  checking for ST_NBLOCKS() is without this penalty.

> We shouldn't need special-case code for btrfs per se. Any filesystem
> where we can lseek for holes should take advantage of that optimization.

It is done so actually, the 'wholesparse' is another optimization on top
of that (but usable also in cases where SEEK_HOLE isn't defined at all).

Pavel



