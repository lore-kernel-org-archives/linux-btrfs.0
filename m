Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53976 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751159AbaDRRlo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Apr 2014 13:41:44 -0400
Date: Fri, 18 Apr 2014 19:41:42 +0200
From: David Sterba <dsterba@suse.cz>
To: Filipe David Borba Manana <fdmanana@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/4 v3] Btrfs-progs: send, implement fallocate command
 callback
Message-ID: <20140418174142.GJ29256@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1397580051-26643-3-git-send-email-fdmanana@gmail.com>
 <1397678294-6248-1-git-send-email-fdmanana@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1397678294-6248-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 16, 2014 at 08:58:14PM +0100, Filipe David Borba Manana wrote:
> The fallocate send stream command, added in stream version 2, is used to
> pre-allocate space for files and punch file holes. This change implements
> the callback for that new command, using the fallocate function from the
> standard C library to carry out the specified action (allocate file space
> or punch a file hole).

> +-a::
> +Use fallocate to pre-allocate file extents and to punch file holes, instead of writing zeroes
> +to files.

(I wrote that in another mail and repeat it again in the context of the patch)

for v2 the fallocate mode should be default and IMHO not configurable by
a flag at all - falloc is efficient and the (right) thing that the devs
choose for the user.

I think that letting the user decide if he should use falloc or not is
too low-level. From the UI perspective, specifying a protocol number
should be enough.

There's currently no way to find the highest protocol version supported,
but the sysfs flags can be enhanced with that.
