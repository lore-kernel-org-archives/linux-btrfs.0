Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50208 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755374AbaCLQgR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Mar 2014 12:36:17 -0400
Date: Wed, 12 Mar 2014 17:36:14 +0100
From: David Sterba <dsterba@suse.cz>
To: Rakesh Pandit <rakesh@tuxera.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs-progs: mkfs: let user known when forcing mixed
 metadata/data groups
Message-ID: <20140312163614.GC6782@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20140312134322.GA28005@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140312134322.GA28005@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 12, 2014 at 03:43:24PM +0200, Rakesh Pandit wrote:
> While formatting multiple devics (and user doesn't specify -M) if one
> of them has block count or size less then 1 GiB, mkfs doesn't tell
> user, on which one mixed metadata/data was forced. This patch updates
> message to print device name.

I think we should fix the constraints what devices can be used together,
mixing small and large ones works, but I don't think it's the usecase
I'd recommend. And I'm not sure the mixed profile was intended for
multiple devices at all.
