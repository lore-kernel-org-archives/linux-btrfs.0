Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39891 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752782Ab3AURkz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Jan 2013 12:40:55 -0500
Date: Mon, 21 Jan 2013 18:40:54 +0100
From: David Sterba <dsterba@suse.cz>
To: Gene Czarcinski <gene@czarc.net>
Cc: linux-btrfs@vger.kernel.org, Arvin Schnell <aschnell@suse.de>
Subject: Re: [PATCH 13/13] trivial patch for btrfs-progs
Message-ID: <20130121174054.GA7971@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1358715858-4469-1-git-send-email-gene@czarc.net>
 <1358715858-4469-14-git-send-email-gene@czarc.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1358715858-4469-14-git-send-email-gene@czarc.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jan 20, 2013 at 04:04:18PM -0500, Gene Czarcinski wrote:
> From: Arvin Schnell <aschnell@suse.de>
> 
> Hi,
> 
> please find attached a trivial patch for btrfs-progs. Likely not
> strictly needed but I noticed valgrind complaining about
> uninitialised memory in the ioctl call.
> 
> Regards,
>   Arvin
> 
> Signed-off-by: Gene Czarcinski <gene@czarc.net>

I've updated the changelog to say
---
    btrfs-progs: initialize data before send ioctl

    Likely not strictly needed but I noticed valgrind complaining about
    uninitialised memory in the ioctl call.

    Signed-off-by: Arvin Schnell <aschnell@suse.de>
---

is it ok for both of you?

david
