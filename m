Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:50031 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372AbaJORI3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Oct 2014 13:08:29 -0400
Received: by mail-wi0-f182.google.com with SMTP id n3so2487603wiv.15
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Oct 2014 10:08:28 -0700 (PDT)
Date: Wed, 15 Oct 2014 10:08:23 -0700
From: Zach Brown <zab@zabbo.net>
To: Fabian Frederick <fabf@skynet.be>
Cc: Josef Bacik <jbacik@fb.com>, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>
Subject: Re: [RFC 1/1 linux-next] btrfs: don't opencode zero_user_segment
Message-ID: <20141015170823.GA18941@lenny.home.zabbo.net>
References: <1413308774-9985-1-git-send-email-fabf@skynet.be>
 <20141014191542.GB6838@lenny.home.zabbo.net>
 <468850260.110326.1413317889395.open-xchange@webmail.nmp.skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <468850260.110326.1413317889395.open-xchange@webmail.nmp.skynet.be>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 14, 2014 at 10:18:09PM +0200, Fabian Frederick wrote:
> 
> 
> > On 14 October 2014 at 21:15 Zach Brown <zab@zabbo.net> wrote:
> >
> >
> > On Tue, Oct 14, 2014 at 07:46:14PM +0200, Fabian Frederick wrote:
> > > use function defined in include/linux/highmem.h
> > > Note that this reverts 2 last function call order
> >
> > And adds a BUG_ON(PAGE_CACHE_SIZE > PAGE_SIZE).  We can take bets on
> > whether that will ever trigger.
> 
> There are 36 zero_user_segment with PAGE_CACHE_SIZE callsites.
> Maybe we could add some specific function to avoid BUG_ON tests ?

Nah, I wouldn't bother.

A lot of us have long rolled our eyes at the distinction between
PAGE_SIZE and PAGE_CACHE_SIZE given how much will break if they're ever
actually different.  That's what I was referencing there :).

- z 
