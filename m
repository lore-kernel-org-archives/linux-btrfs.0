Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44795 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S937649AbdDSPnE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Apr 2017 11:43:04 -0400
Date: Wed, 19 Apr 2017 17:43:00 +0200
From: David Sterba <dsterba@suse.cz>
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: docs: Fix newlines for man btrfstune
Message-ID: <20170419154300.GD22319@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170416172002.19261-1-hans.van.kranenburg@mendix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170416172002.19261-1-hans.van.kranenburg@mendix.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Apr 16, 2017 at 07:20:02PM +0200, Hans van Kranenburg wrote:
> A bunch of newlines were missing, which resulted in only -S and -r to
> show as option after xmlto is used to convert the documentation to a man
> page.
> 
> The rest of the options would end up being appended to the explanation
> of -r.
> 
> Signed-off-by: Hans van Kranenburg <hans.van.kranenburg@mendix.com>

Applied, thanks.

> ---
> 
> By the way, I have no idea why -r was showing up in the first place, because
> it also had no newline before it.
> 
> I'm no asciidoc expert, but with consistent newlines, at least for me the
> resulting man page does contain all options nicely listed.

IIRC if the :: section is one paragraph, then the newline does not need
to be there, while if there are more glued together with a +, then the
newline before next :: must be added.
