Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36940 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964779Ab3HIP1R (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 9 Aug 2013 11:27:17 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 43356A538E
	for <linux-btrfs@vger.kernel.org>; Fri,  9 Aug 2013 17:27:16 +0200 (CEST)
Date: Fri, 9 Aug 2013 17:27:14 +0200
From: David Sterba <dsterba@suse.cz>
To: Arvin Schnell <aschnell@suse.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: library version defines?
Message-ID: <20130809152714.GM5284@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20130603123141.GA2315@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130603123141.GA2315@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 03, 2013 at 02:31:41PM +0200, Arvin Schnell wrote:
> commit 46de1a6ec3dbb0db203baa6c46cb64ba9b000ea2 changed the
> parameters of btrfs_read_and_process_send_stream().  This breaks
> snapper compilation so I wonder whether we can include version
> defines usable for the C preprocessor.  Surely it won't help in
> this case anymore but might in the future.
> 
> Please find my proposal attached.

The C define part looks ok, the version numbers should be used in
Makefile to build libbtrfs.so.* files.

> +lib_major=0
> +lib_minor=1
> +lib_patchlevel=0

If the above snippet is placed into a separate file, it can be
included/sourced into Makefile and version.sh, keeping the version
information at a single location.

david
