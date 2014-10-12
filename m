Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:34375 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795AbaJLKGG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 12 Oct 2014 06:06:06 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Chris Murphy <lists@colorremedies.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Cc: Eric Sandeen <sandeen@redhat.com>
Subject: Re: What is the vision for btrfs fs repair?
Date: Sun, 12 Oct 2014 12:06:03 +0200
Message-ID: <2306356.WVkN6F5DCn@merkaba>
In-Reply-To: <9251D9EB-5B12-4885-8C6B-FFA10B1CDA24@colorremedies.com>
References: <54358C77.2070808@redhat.com> <9251D9EB-5B12-4885-8C6B-FFA10B1CDA24@colorremedies.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Donnerstag, 9. Oktober 2014, 21:58:53 schrieben Sie:
> > * btrfs-zero-log
> >       "remove the log tree if log tree is corrupt"
> > * btrfs rescue
> >       "Recover a damaged btrfs filesystem"
> >       chunk-recover
> >       super-recover
> >       How does this relate to btrfs check?
> > * btrfs check
> >       "repair a btrfs filesystem"
> >       --repair
> >       --init-csum-tree
> >       --init-extent-tree
> >       How does this relate to btrfs rescue?
> 
> These three translate into eight combinations of repairs, adding -o recovery
> there are 9 combinations. I think this is the main source of confusion,
> there are just too many options, but also it's completely non-obvious which
> one to use in which situation.
> 
> My expectation is that eventually these get consolidated into just check and
> check --repair. As the repair code matures, it'd go into kernel
> autorecovery code. That's a guess on my part, but it's consistent with
> design goals.

Also I think these should at least all be unter the btrfs command.

So include btrfs-zero-log in btrfs command.

And well how about "btrfs repair" or "btrfs check" as upper category and at 
least add the various options as commands below it? So there is at least one
command and one place in manpage to learn about the various options.

But maybe some can be made automatic as well. Or folded into btrfs check --
repair. Ideally it would auto-detect which path to take on filesystem 
recovery.

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
