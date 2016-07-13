Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58436 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750950AbcGMQi5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Jul 2016 12:38:57 -0400
Date: Wed, 13 Jul 2016 18:38:53 +0200
From: David Sterba <dsterba@suse.cz>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.com
Subject: Re: [PATCH] btrfs-progs: add option to run balance as daemon
Message-ID: <20160713163853.GO10595@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20160621151659.32157-1-ahferroin7@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160621151659.32157-1-ahferroin7@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 21, 2016 at 11:16:59AM -0400, Austin S. Hemmelgarn wrote:
> Currently, balance operations are run synchronously in the foreground.
> This is nice for interactive management, but is kind of crappy when you
> start looking at automation and similar things.

Yeah, people have been complaining about the lack of backgrounding
support over the time.

> This patch adds an option to `btrfs balance start` to tell it to
> daemonize prior to running the balance operation, thus allowing us to
> preform balances asynchronously.  The two biggest use cases I have for
> this are starting a balance on a remote server without establishing a
> full shell session, and being able to background the balance in a
> recovery shell (which usually has no job control) so I can still get
> progress information.
> 
> Because it simply daemonizes prior to calling the balance ioctl, this
> doesn't actually need any kernel support.

We could also add the kernel support, but this would need to extend the
ioctl flags. Unfortunatelly older kernels would ignore it and always let
balance run in foreground (due to lack of checks for the known flags).
So at the moment forking a process seems to be an option.

> Signed-off-by: Austin S. Hemmelgarn <ahferroin7@gmail.com>
> ---
> This works as is, but there are two specific things I would love to
> eventually fix but don't have the time to fix right now:
> * There is no way to get any feedback from the balance operation.

Does this mean that 'btrfs balance status' is not sufficient? Or I don't
understand what you mean.

> * Because of how everything works, trying to start a new balance with
>   --background while one iw already running won't return an error but
>   won't queue or start a new balance either.
> 
> The first one is more a utility item than anything else, and probably
> would not be hard to add.  Ideally, it should be output to a user
> specified file, and this should work even for a normal foreground balance.
> 
> The second is very much a UX issue, but can't be easily sovled without
> doing some creative process monitoring from the parrent processes.

Currently, starting a second balance will return immediatelly with "in
progress" message, this is returned by the balance iotctl itself. In
this case it would be the child process and communicating it back would
need a pipe or somesuch. But, the parent can check the balance status by
itself, before calling fork, right? Unless I'm missing something, this
should address your concerns.
