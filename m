Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59184 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751025AbcFFJSN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 6 Jun 2016 05:18:13 -0400
Date: Mon, 6 Jun 2016 11:17:29 +0200
From: David Sterba <dsterba@suse.cz>
To: Andrew Armenia <andrew@asquaredlabs.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: chunk_width_limit mount option
Message-ID: <20160606091729.GX29147@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1464918615-6458-1-git-send-email-andrew@asquaredlabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1464918615-6458-1-git-send-email-andrew@asquaredlabs.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 02, 2016 at 09:50:15PM -0400, Andrew Armenia wrote:
> This patch adds mount option 'chunk_width_limit=X', which when set forces
> the chunk allocator to use only up to X devices when allocating a chunk.
> This may help reduce the seek penalties seen in filesystems with large
> numbers of devices.

There is a use for such limit but passing it as a mount is not the right
way to do it. Changing the value requires remount, different raid levels
might need different values, it's not persistent etc.
