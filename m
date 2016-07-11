Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 185-6-29-55-rev.logitus.pl ([185.6.29.55]:39334 "EHLO
	mother.pipebreaker.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753308AbcGKQ6Z (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Jul 2016 12:58:25 -0400
Date: Mon, 11 Jul 2016 18:58:22 +0200
From: Tomasz Torcz <tomek@pipebreaker.pl>
To: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: add option to run balance as daemon
Message-ID: <20160711165822.GB1417185@mother.pipebreaker.pl>
References: <20160621151659.32157-1-ahferroin7@gmail.com>
 <20160711072612.GA1417185@mother.pipebreaker.pl>
 <63dba99e-cf1c-63f5-bee6-548270b7a653@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <63dba99e-cf1c-63f5-bee6-548270b7a653@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 11, 2016 at 07:17:28AM -0400, Austin S. Hemmelgarn wrote:
> On 2016-07-11 03:26, Tomasz Torcz wrote:
> > On Tue, Jun 21, 2016 at 11:16:59AM -0400, Austin S. Hemmelgarn wrote:
> > > Currently, balance operations are run synchronously in the foreground.
> > > This is nice for interactive management, but is kind of crappy when you
> > > start looking at automation and similar things.
> > 
> >   It can be done with simplest systemd unit file:
> > btrfs-balance@.service:
> > ---
> > [Unit]
> > Description=btrfs balance for %I
> > 
> > [Service]
> > ExecStart=/usr/bin/btrfs balance start %I
> > ExecStop=/usr/bin/btrfs balance cancel %I
> > ---
> > 
> >   It automates quite nicely and needs no additional code.
> > 
> It's also entirely dependent on a couple of things:
> 1. You're running systemd (not everyone is, I'm certainly not).

  So instead of using widespread, tested code, you re-implement 
parts of it.  BTW, your patch for daemonizing does only 5 steps
out of 15 described in man 7 daemon.

> 2. You're only dealing with the local system.
> 
> The type of situation I'm thinking of is dealing with non-local systems.
> For example, running something like this:
> ssh user@remotehost btrfs balance start --background /
> Keeping the SSH connection open for the duration of the balance has issues
> for some people (may close without keep-alive set, uses network bandwidth
> with keep-alive set, many people who are hosted have bandwidth quotas
> still), and it's extremely useful to have the option to fire and forget.

  I don't get the local part.  Right now, when using above unit you can

ssh user@remotehost systemctl start btrfs-balance@-

(or even
systemctl -H user@remotehost start btrfs-balance@-)

 and balance for / runs in background on target host. With clean
environment, logs being captured, locking against multiple
startups and so on. Right now, without any additional code.

-- 
Tomasz   .. oo o.   oo o. .o   .o o. o. oo o.   ..
Torcz    .. .o .o   .o .o oo   oo .o .. .. oo   oo
o.o.o.   .o .. o.   o. o. o.   o. o. oo .. ..   o.

