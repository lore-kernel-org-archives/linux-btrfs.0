Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41960 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752886AbdGLWfY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Jul 2017 18:35:24 -0400
Date: Thu, 13 Jul 2017 00:34:10 +0200
From: David Sterba <dsterba@suse.cz>
To: Justin Maggard <jmaggard10@gmail.com>
Cc: linux-btrfs@vger.kernel.org, Justin Maggard <jmaggard@netgear.com>
Subject: Re: [PATCH] btrfs-progs: Fix an infinite loop in btrfs_next_bg
Message-ID: <20170712223410.GT2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170609180935.9554-1-jmaggard@netgear.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170609180935.9554-1-jmaggard@netgear.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 09, 2017 at 11:09:35AM -0700, Justin Maggard wrote:
> I've run into a couple filesystems where btrfs-find-root would spin
> indefinitely.
> 
> If the first cache extent start location is 0, we end up in an infinite
> loop in btrfs_next_bg().  Fix it by checking for that situation, and
> jumping to the next bg if necessary.
> 
> Fixes: e2e0dae9 (btrfs-progs: volume: Fix a bug causing btrfs-find-root to skip first chunk)
> Signed-off-by: Justin Maggard <jmaggard@netgear.com>

Applied, thanks.  Do you have a minimal image for testing?
