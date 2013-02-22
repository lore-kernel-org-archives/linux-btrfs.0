Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49468 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756826Ab3BVWfh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Feb 2013 17:35:37 -0500
Date: Fri, 22 Feb 2013 23:35:35 +0100
From: David Sterba <dsterba@suse.cz>
To: Shilong Wang <wangshilong1991@gmail.com>
Cc: Arne Jansen <sensille@gmx.net>, linux-btrfs@vger.kernel.org
Subject: Re: [RESEND RFC PATCH 2/2] Btrfs: disable the qgroup level 0 for
 userspace use
Message-ID: <20130222223535.GO27541@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1361534990-2627-1-git-send-email-wangshilong1991@gmail.com>
 <51277409.6040007@gmx.net>
 <CAP9B-Q=UW7=P7RuvwGFMmU7AaE0nQ0R5CKq+MW379+Wvx7oS_A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAP9B-Q=UW7=P7RuvwGFMmU7AaE0nQ0R5CKq+MW379+Wvx7oS_A@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Feb 23, 2013 at 12:39:24AM +0800, Shilong Wang wrote:
> Hello,
> 
> 2013/2/22 Arne Jansen <sensille@gmx.net>:
> > On 02/22/13 13:09, Wang Shilong wrote:
> >> From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
> >>
> >> This patch tries to stop users to create/destroy qgroup level 0,
> >> users can only create/destroy qgroup level more than 0.
> >>
> >> See the fact:
> >>       a subvolume/snapshot qgroup was created automatically
> >> when creating subvolume/snapshot, so creating a qgroup level 0 can't
> >> be a subvolume/snapshot qgroup, the only way to use it is that assigning
> >> subvolume/snapshot qgroup to it, the point is that we don't want to have a
> >> parent qgroup whose level is 0.
> >>
> >>       So we want to force users to use qgroup with clear relations
> >> which means a parent qgroup's level > child qgroup's level.For example:
> >>
> >>                           2/0
> >>                          /    \
> >>                         /      \
> >>                        /        \
> >>                       1/0       1/1
> >>                     /     \        \
> >>                    /       \        \
> >>                   /         \        \
> >>               0/256     0/257    0/258
> >>
> >> This pattern of quota is nature and easy for users to understand, otherwise it will
> >> make the quota configuration confusing and difficult to maintain.
> >
> > I agree that a strict hierarchy of the levels should be enforced.
> > Currently the kernel has no idea of 'level', it's just an artificial
> > concept that lives in userspace. This patch would be the first place
> > to add that magic shift '48' to the kernel.
> > In my opinion it would be sufficient to do the enforcement in user
> > space, as it is of no technical nature.
> >
> 
> ...i have made some patches about these work in btrfs-prog, but it has
> been not merged...
> I will pick up thoses patches and do the other necessary work..

This one?

https://patchwork.kernel.org/patch/2008591/

went through integration branch into progs' master.

david
