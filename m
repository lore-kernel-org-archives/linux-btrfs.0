Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35551 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751981AbeCNTlL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Mar 2018 15:41:11 -0400
Date: Wed, 14 Mar 2018 20:38:47 +0100
From: David Sterba <dsterba@suse.cz>
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: zerofree btrfs support?
Message-ID: <20180314193847.GR32007@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1520650525.5641.47.camel@scientia.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1520650525.5641.47.camel@scientia.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Mar 10, 2018 at 03:55:25AM +0100, Christoph Anton Mitterer wrote:
> Hi.
> 
> Just wondered... was it ever planned (or is there some equivalent) to
> get support for btrfs in zerofree?

The zerofree was requested, eg. here
https://bugzilla.kernel.org/show_bug.cgi?id=69121

and there was a discussion under proposed patches on fsdevel 3 years
ago, message-id is 1422896713-25367-1-git-send-email-holler@ahsoftware.de

tl;dr there's nothing like zeofree now, because.

Because the security reasons are not considered good enough and giving
false sense of security. Clearing the qemu images sounds good but
there's another way to do that via trim.

I have a prototype code for that and after the years, seeing the request
again, I'm not against adding it as long as it's not advertised as a
security feature.

The zeroing simply builds on top of the trim code, so it's merely adding
the ioctl interface and passing down the desired operation.
