Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37273 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751859Ab3AUQq3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Jan 2013 11:46:29 -0500
Date: Mon, 21 Jan 2013 17:46:28 +0100
From: David Sterba <dsterba@suse.cz>
To: Gene Czarcinski <gene@czarc.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 06/13] btrfs-show-super.c
Message-ID: <20130121164628.GK19967@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1358715858-4469-1-git-send-email-gene@czarc.net>
 <1358715858-4469-7-git-send-email-gene@czarc.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1358715858-4469-7-git-send-email-gene@czarc.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jan 20, 2013 at 04:04:11PM -0500, Gene Czarcinski wrote:
> remove extra blank line at EOF

The patch contents and description do not match.

> --- a/man/Makefile
> +++ b/man/Makefile
> @@ -1,4 +1,4 @@
> -GZIP=gzip
> +GZIPCMD=gzip

I'm not sure if this change is needed, does it stick to some well-known
or established style in makefiles?

david
