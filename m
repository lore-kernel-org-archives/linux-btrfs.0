Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43315 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754662AbaG3RzC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Jul 2014 13:55:02 -0400
Date: Wed, 30 Jul 2014 19:55:01 +0200
From: David Sterba <dsterba@suse.cz>
To: Roman Mamedov <rm@romanrm.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: wait until all subvolumes are cleaned
Message-ID: <20140730175501.GZ1553@suse.cz>
Reply-To: dsterba@suse.cz
References: <1406148973-23162-1-git-send-email-dsterba@suse.cz>
 <20140730175519.55905112@natsu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140730175519.55905112@natsu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks for the feedback, appreciated.

On Wed, Jul 30, 2014 at 05:55:19PM +0600, Roman Mamedov wrote:
> > +static const char * const cmd_subvol_sync_usage[] = {
> > +	"btrfs subvolume sync <path> [<subvol-id>...]",
> > +	"Wait until given subvolume(s) are completely cleaned",
> > +	"Wait until given subvolume(s) are completely cleaned after deletion.",
> 
> I find "cleaned" to be confusing here. "OK, this subvolume is now clean"? At
> the very least this gives an impression that the desired condition is that
> subvolume *still exists*, but is empty.
>
> How about "Wait until given subvolume(s) are completely removed from the
> filesystem. Does not return until all ongoing deletion requests (if any) on
> given subvolume(s) are complete".

Sounds good, I'll use the text in the next version.

> > +	"If no subvolume id is given, wait until there are no more snapshots",
> 
> Please don't intermix "subvolume" and "snapshot" like that. Better to use
> "subvolume" in all cases to avoid confusion.

Good point, will fix it and the typos.
