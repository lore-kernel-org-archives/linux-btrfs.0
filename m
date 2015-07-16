Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f172.google.com ([209.85.160.172]:36612 "EHLO
	mail-yk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502AbbGPGpF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 Jul 2015 02:45:05 -0400
Received: by ykay190 with SMTP id y190so56726985yka.3
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Jul 2015 23:45:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTYWQO+7yLLBb0_+Ku=xYxcpgDwk53Ki_mtArMtXuCBNA@mail.gmail.com>
References: <0CF53779-ED80-4311-864F-CEF960C45ABA@gmail.com>
 <CAJCQCtSTkt-NN3YMnTcdCr3vUy+EwG19VBUaHyaMi8uQiSquZg@mail.gmail.com>
 <CAB3_Qu+F-J3zyK7PgZbjww+Qwz532dG0gG=m3=2xJ_F32xektA@mail.gmail.com> <CAJCQCtTYWQO+7yLLBb0_+Ku=xYxcpgDwk53Ki_mtArMtXuCBNA@mail.gmail.com>
From: Paul Harvey <csirac2@gmail.com>
Date: Thu, 16 Jul 2015 16:44:44 +1000
Message-ID: <CAB3_Qu+rf7e1VAjUbAsRC4fZRW722k7ZPFTkFRV2ccaTy9xyHQ@mail.gmail.com>
Subject: Re: I'd like a -r flag on btrfs subvolume delete
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 16 July 2015 at 13:44, Chris Murphy <lists@colorremedies.com> wrote:
> The choice of "improper" wasn't ideal on my part. There's nothing
> directly wrong with nested subvolumes. But if you then combine them
> with snapshots and rollbacks, there are consequences that include more
> complication. If more than one things is doing snapshots and
> rollbacks, it requires some rules as to who can snapshot what and
> where those things go in order to avoid being snapshot again by some
> other tool, and then how things get reassembled. There are different
> kinds of rollbacks so that needs some rules or it'll just lead to
> confusion.

You do have good points, but you're mixing quite a few issues. One
that's not clearly addressed is the problem that consensus and
conventions are nice but we need stuff "now" :)

Having multiple snapshotting systems is of course suboptimal, that's
stating the obvious. But it's up to admins to decide how they deal
with it, I've seen environments clumsily mix puppet, ansible and salt
-  nobody got fired. So that can't be a *real* excuse for not
implementing recursive subvolume stuff - can it?

I already have to deal with inventing my own conventions on where
snapshots live and how they're named - the closest thing for guidance
I had was looking closely at OpenSuSE's snapper. Which I didn't like.
And I'm *still* finding tools I have to configure properly to deal
with ".shapshot/*" dirs: mlocate/updatedb and friends, AVs, file
integrity daemons...

> A couple of developers have suggested the folly of nested subvolumes
> several times. Discovering the consequences of organizing subvolumes

I've read these discussions (those that I could find - that's a
separate issue). It seems far from obvious that this is "folly". It's
worth pointing out that ZFS works fine with, and has support in its
tools for nested datasets, cf. "zfs destroy -r
/path/to/nested/dataset".

If it's folly, it really should be documented in something more formal
than a couple of meandering ML threads. And perhaps removed as a
feature from btrfs proper. If I was a contributor to btrfs itself, I'd
even dare to ask that if subvolumes or so broken, but there's still a
need for their functionality, perhaps they need reinventing.

I'd be happy to help create a wiki page that properly enumerate the
problems with nested subvolumes if we can collect everything in one
place.

> is a work in progress. I've mentioned a couple times over the years
> that distros are inevitably going to end up with fragmented and
> mutually incompatible approaches if they don't actively engage each
> other cooperatively. And that's turned out to be correct as Fedora,
> Ubuntu and SUSE all do things differently with their Btrfs
> organization.

I'm afraid you're absolutely correct, but in the meantime...

> At the moment, I like the idea of subvolumes pretty much only at the
> top level of the file system (subvolid 5), and I like the naming
> convention suggested here:
> http://0pointer.net/blog/revisiting-how-we-put-together-linux-systems.html
> under the section "What We Propose"

That proposal is indeed very nice but at 5000 words (literally 5000
words) it is still a speculative design document and wish-list of
stuff that is so far removed from the problems I have today and from
the operating systems and distributions I am actually using today that
I'm having trouble tying this back to how the proposal actually
answers the question: what about recursive subvolume operations....

... and I'm still wondering why if ZFS can deal with nested datasets,
OpenSuSE's snapper can deal with snapshots/rollbacks with nested
subvolumes - we can't deal with nested subvolumes in btrfs-progs.

I suspect the real reason is something along the lines of: "If we do
this, support for recursive or even multiple subvolume operations
should be implemented properly and atomically in the kernel, but
that's an enormous amount of work for now, so until then we don't want
to accidentally encourage  everyone to use a mediocre partial
implementation emulated in userland btrfs-progs - so we'll leave users
shoot themselves in that particular foot on their own if they insist".

I don't think that's quite the same as asserting that nested
subvolumes are somehow fundamentally folly.

> I don't really like the colons because those are special character so
> now I have to type three characters for each one of those. But anyway
> those then get assembled in FHS form via fstab using subvol= or
> subvolid= mount option, or whatever replaces fstab eventually.

I don't see how nested subvolumes stop you from doing this. In fact I
do this on servers I'm likely to do exploratory rollbacks on. That's
roughly how SuSE's snapper project already supports rollbacks
regardless of whether you're using nested subvolumes or not. Granted,
there's more default-subvolid shenanigans but scripting that out of
the way represents way fewer lines of my own code compared to the
tedium of working around the lack of a recursive subvolume support in
btrfs-progs.

> This way you can snapshot different subvolumes at different rates with
> different cleanup policies while keeping all of them out of the
> normally mounted FHS path. A side plus is that this also puts old
> libraries outside the FHS path, sort of like they're in a jail.

Finally, I've been shown something new in this thread. That's actually
a really good point.

If you don't beat me to it, I'll try to start documenting nested
subvolume issues on the wiki next week.

--
Paul
