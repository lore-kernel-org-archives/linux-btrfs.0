Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46906 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752601AbbKLKW7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Nov 2015 05:22:59 -0500
Date: Thu, 12 Nov 2015 11:21:23 +0100
From: David Sterba <dsterba@suse.cz>
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Cc: dsterba@suse.cz,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Regression in btrfs: properly set the termination value of
 ctx->pos in readdir
Message-ID: <20151112102123.GH6445@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <56432D2A.5040506@profihost.ag>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <56432D2A.5040506@profihost.ag>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 11, 2015 at 12:57:30PM +0100, Stefan Priebe - Profihost AG wrote:
> the patch btrfs: properly set the termination value of ctx->pos in
> readdir introduces a regression to me.
> 
> A lot of stuff runs in "endless" or long running loops.

This might be related to the readdir fix but I don't see it anywhere in
the strace log. There don't seem to be any connection (fd, other
structures) to the syscalls in the strace log. I'll investigate further.
