Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56339 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752121AbaEBPqS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 2 May 2014 11:46:18 -0400
Date: Fri, 2 May 2014 17:46:17 +0200
From: David Sterba <dsterba@suse.cz>
To: Filipe David Borba Manana <fdmanana@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 6/6 v2] Btrfs: add send_stream_version attribute to sysfs
Message-ID: <20140502154617.GP5988@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1398002847-11144-1-git-send-email-fdmanana@gmail.com>
 <1398030003-12697-1-git-send-email-fdmanana@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1398030003-12697-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Apr 20, 2014 at 10:40:03PM +0100, Filipe David Borba Manana wrote:
> So that applications can find out what's the highest send stream
> version supported/implemented by the running kernel:
> 
>     $ cat /sys/fs/btrfs/send/stream_version
>     2
> 
> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
> ---
> 
> V2: Renamed /sys/fs/btrfs/send_stream_version to /sys/fs/btrfs/send/stream_version,
>     as in the future it might be useful to add other sysfs attrbutes related to
>     send (other ro information or tunables like internal buffer sizes, etc).

Sounds good, I don't see any issue with the separate directory. Mixing
it with /sys/fs/btrfs/features does not seem suitable for that if you
intend adding more entries.

Reviewed-by: David Sterba <dsterba@suse.cz>
