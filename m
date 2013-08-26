Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:56182 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752103Ab3HZSr7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 26 Aug 2013 14:47:59 -0400
Date: Tue, 27 Aug 2013 02:47:48 +0800
From: Tomasz Chmielewski <tch@virtall.com>
To: Hugo Mills <hugo@carfax.org.uk>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: failed to read log tree, open_ctree failed
Message-ID: <20130827024748.0da8cb46@virtall.com>
In-Reply-To: <20130826183419.GM3115@carfax.org.uk>
References: <20130827022509.57de1ab2@virtall.com>
	<20130826183419.GM3115@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 26 Aug 2013 19:34:19 +0100
Hugo Mills <hugo@carfax.org.uk> wrote:

> > corrupt 0, gen 0 [   56.209412] parent transid verify failed on
> > 3321036099584 wanted 97967 found 97966 [   56.225990] parent
> > transid verify failed on 3321036099584 wanted 97967 found 97966
> > [   56.226128] btrfs: failed to read log tree [   56.344483] btrfs:
> > open_ctree failed
> > 
> > 
> > I've tried with 3.11-rc7, but it gives the same result.
> > 
> > Any hints how to recover from that?
> > I have backups, but it would be nice if the filesystem just mounted.
> 
>    Try mounting with both -orecovery and -oro,recovery.

Neither worked, same error.

Anything else I can try?

-- 
Tomasz Chmielewski
http://wpkg.org
