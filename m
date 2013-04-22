Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35898 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754061Ab3DVPgh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Apr 2013 11:36:37 -0400
Date: Mon, 22 Apr 2013 17:36:35 +0200
From: David Sterba <dsterba@suse.cz>
To: Eric Sandeen <sandeen@redhat.com>
Cc: dsterba@suse.cz, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH V2] btrfs: move leak debug code to functions
Message-ID: <20130422153635.GR16427@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <517387F8.506@redhat.com>
 <5174C82D.1080901@redhat.com>
 <20130422152203.GQ16427@twin.jikos.cz>
 <517556CF.9090405@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <517556CF.9090405@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 22, 2013 at 10:27:11AM -0500, Eric Sandeen wrote:
> Yep I noticed that too, I'd be happy to elevate it to a CONFIG_ option if
> it's really something that will be kept around for a while.

We have (and will have) more code for debugging aid.

> Could maybe be lumped in to a CONFIG_BTRFS_DEBUG that catches other
> #define DEBUG behaviors as well?

Yes please, feel free to use this

https://patchwork.kernel.org/patch/846462/

If there are really heavy debug checks we may separate them, but a
single option should be fine for now.

thanks,
david
