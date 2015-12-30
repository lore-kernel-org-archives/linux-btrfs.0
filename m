Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54056 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755070AbbL3RmF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Dec 2015 12:42:05 -0500
Date: Wed, 30 Dec 2015 18:39:49 +0100
From: David Sterba <dsterba@suse.cz>
To: Sree Harsha Totakura <sreeharsha@totakura.in>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Confining scrub to a subvolume
Message-ID: <20151230173949.GH4227@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <56831EA2.3090807@totakura.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <56831EA2.3090807@totakura.in>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 30, 2015 at 01:00:34AM +0100, Sree Harsha Totakura wrote:
> Is it possible to confine scrubbing to a subvolume instead of the whole
> file system?

No. Srub reads the blocks from devices (without knowing which files own
them) and compares them to the stored checksums.

> [...]  Therefore, I would like to scrub the photos
> and documents subvolumes more often than the backups subvolume.  Would
> this be possible with the current tools?

The closest would be to read the files and look for any reported errors.
