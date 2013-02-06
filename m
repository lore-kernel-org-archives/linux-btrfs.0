Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33165 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758026Ab3BFWJk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 6 Feb 2013 17:09:40 -0500
Date: Wed, 6 Feb 2013 23:09:37 +0100
From: David Sterba <dsterba@suse.cz>
To: Gene Czarcinski <gene@czarc.net>
Cc: linux-btrfs@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] Btrfs-progs print more informative error when we fail to
 open a device
Message-ID: <20130206220937.GC12339@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1359993477-18281-1-git-send-email-gene@czarc.net>
 <1359993477-18281-2-git-send-email-gene@czarc.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1359993477-18281-2-git-send-email-gene@czarc.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 04, 2013 at 10:57:57AM -0500, Gene Czarcinski wrote:
> From: Eric Sandeen <sandeen@redhat.com>
> 
> print more informative error when we fail to open a device
> 
> If open() fails, we should let the user know why it failed.

Thanks, added to next integration queue.
