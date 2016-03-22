Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56687 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750970AbcCVPJR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Mar 2016 11:09:17 -0400
Date: Tue, 22 Mar 2016 16:08:47 +0100
From: David Sterba <dsterba@suse.cz>
To: Noah Massey <nmassey@kmbs.konicaminolta.us>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>,
        Noah Massey <noah.massey@gmail.com>
Subject: Re: [PATCH] btrfs-progs: build: fix static standalone utilities
Message-ID: <20160322150847.GD29764@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1458569767-6432-1-git-send-email-noah.massey@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1458569767-6432-1-git-send-email-noah.massey@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 21, 2016 at 10:16:07AM -0400, Noah Massey wrote:
> commit b5e7979 "btrfs-progs: build: extend per-binary objects" allows
> the standalone utilities to link against object files shared with the
> main binary. However, the btrfs-*.static targets need to be adjusted
> to build against the static versions of the common files.
> 
> Signed-off-by: Noah Massey <noah.massey@gmail.com>

Applied, thanks. I'll release a .1 version probably next week as there
are more build fixes accumulated.
