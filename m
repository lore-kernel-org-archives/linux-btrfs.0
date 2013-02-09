Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.vapor.com ([83.220.149.2]:38823 "EHLO nitrogen.vapor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760818Ab3BISvw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 9 Feb 2013 13:51:52 -0500
Date: Sat, 9 Feb 2013 19:51:44 +0100
From: Ian Kumlien <pomac@vapor.com>
To: Sergei Trofimovich <slyich@gmail.com>
Cc: Ian Kumlien <pomac@demius.net>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs-progs: add static compile target
Message-ID: <20130209185144.GQ15780@pomac.netswarm.net>
References: <1360365569-18996-1-git-send-email-pomac@demius.net>
 <20130209205742.00907573@sf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130209205742.00907573@sf>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Feb 09, 2013 at 08:57:42PM +0300, Sergei Trofimovich wrote:
> On Sat,  9 Feb 2013 00:19:29 +0100
> Ian Kumlien <pomac@demius.net> wrote:
> 
> > Sometimes, when you least expect it, a static binary is what you need to
> > rescue your data... Or just get a good enough handle on things to make
> > it work again ;)
> > 
> > "make static" is a gift to you, dear user with filesystem problems!
> 
> What's wrong with conventional LDFLAGS=-static make?

That doesn't work for me, does it actually work for you?

I'd say it wouldn't without adding LDFLAGS so that the compiler gets it
for all object compilations.

> > Anyway, on a more serious note, changed the cflags and ldflags so that
> > we create a smaller binary, 1.1MB stripped on my 64 bit system
> > (2.7MB with debug data)
> > 
> 
> -- 
> 
>   Sergei


