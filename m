Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39097 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752940AbbGTQ4k (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Jul 2015 12:56:40 -0400
Date: Mon, 20 Jul 2015 18:56:34 +0200
From: David Sterba <dsterba@suse.com>
To: fdmanana@kernel.org
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH v3] Btrfs-progs: add feature to get mininum size for
 resizing a fs/device
Message-ID: <20150720165634.GM6306@twin.jikos.cz>
Reply-To: dsterba@suse.com
References: <1436188425-23535-1-git-send-email-fdmanana@kernel.org>
 <1437061633-732-1-git-send-email-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1437061633-732-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 16, 2015 at 04:47:13PM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> Currently there is not way for a user to know what is the minimum size a
> device of a btrfs filesystem can be resized to. Sometimes the value of
> total allocated space (sum of all allocated chunks/device extents), which
> can be parsed from 'btrfs filesystem show' and 'btrfs filesystem usage',
> works as the minimum size, but sometimes it does not, namely when device
> extents have to relocated to holes (unallocated space) within the new
> size of the device (the total allocated space sum).
> 
> This change adds the ability to reliably compute such minimum value and
> extents 'btrfs filesystem resize' with the following syntax to get such
> value:
> 
>    btrfs filesystem resize [devid:]get_min_size
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Applied, thanks. As mentioned before, the preferred interface is
'inspect-internal'. I've named the command 'min-dev-size' and added
optional arugment --id as replacement for the original resize syntax.
(It's a simple getopt stub so I'm not posting the patch.)
