Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44776 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752037Ab3B0Qny (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Feb 2013 11:43:54 -0500
Date: Wed, 27 Feb 2013 17:43:52 +0100
From: David Sterba <dsterba@suse.cz>
To: Florian Albrechtskirchinger <falbrechtskirchinger@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs-progs: add UUID switches to mkfs and convert
Message-ID: <20130227164352.GJ27541@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1357486331-4615-1-git-send-email-falbrechtskirchinger@gmail.com>
 <1357486331-4615-2-git-send-email-falbrechtskirchinger@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1357486331-4615-2-git-send-email-falbrechtskirchinger@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jan 06, 2013 at 04:32:11PM +0100, Florian Albrechtskirchinger wrote:
> Add the following switches to mkfs.btrfs and update man page:
> * -U UUID, --uuid UUID
> 
> Add the following switches to btrfs-convert:
> * -U UUID
> * -U new
>   Generates a random UUID (default behavior).
> * -U copy
>   Copies the UUID from the ext2fs.

Can you please enhance it with a check that the UUID is not duplicate
among other filesystems? It should be available throgh libblkid:

	blkid_probe_lookup_value(probe, "UUID", &uuid, NULL);

This is a sort of paranoia check with the generated UUID, but I think
that an accidentally repeated command or copy&paste with an existing
uuid can happen.

thanks,
david
