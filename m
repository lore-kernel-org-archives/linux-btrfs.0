Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37784 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751136AbbFYRzF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Jun 2015 13:55:05 -0400
Date: Thu, 25 Jun 2015 19:55:03 +0200
From: David Sterba <dsterba@suse.cz>
To: Patrik Lundquist <patrik.lundquist@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: Fix defrag threshold overflow
Message-ID: <20150625175503.GQ726@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1435155666-11214-1-git-send-email-patrik.lundquist@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1435155666-11214-1-git-send-email-patrik.lundquist@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 24, 2015 at 04:21:06PM +0200, Patrik Lundquist wrote:
> btrfs fi defrag -t 1T overflows the u32 thresh variable and default, instead of max, threshold is used.
> 
> Signed-off-by: Patrik Lundquist <patrik.lundquist@gmail.com>

Applied, thanks.
