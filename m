Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:60679 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbaEABxr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Apr 2014 21:53:47 -0400
From: Russell Coker <russell@coker.com.au>
To: Chris Mason <clm@fb.com>
Reply-To: russell@coker.com.au
Cc: linux-btrfs@vger.kernel.org
Subject: Re: GPF in 3.13.4 Debian kernel
Date: Thu, 01 May 2014 11:53:42 +1000
Message-ID: <3376675.LutzFkB4bs@xev>
In-Reply-To: <5313EA72.1010000@fb.com>
References: <201403031123.53133.russell@coker.com.au> <5313EA72.1010000@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 2 Mar 2014 21:35:30 Chris Mason wrote:
> On 03/02/2014 07:23 PM, Russell Coker wrote:
> > I've attached the kernel message log from a GPF that occurred running the
> > Debian kernel package of kernel 3.13.4.  This happens repeatedly and
> > started doing so with Debian kernel 3.12.8.
> > 
> > This is not the first time I've seen a filesystem corruption occur related
> > to Kmail files that causes a kernel panic.  I wonder if Kmail has some
> > file access pattern that triggers a BTRFS bug.
> 
> Looks like this one:
> 
> https://git.kernel.org/cgit/linux/kernel/git/mason/linux-btrfs.git/commit/?h
> =for-linus&id=514ac8ad8793a097c0c9d89202c642479d6dfa34
> 
> It's in a batch that needed extra attention for a stable backport, which
> I've finally got finished off here.

The Debian 3.14.1 kernel fixes this bug.  On a filesystem which gets a GPF on 
a 3.13 kernel 3.14.1 will allow reading the files in question without error.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/

