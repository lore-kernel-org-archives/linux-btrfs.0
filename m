Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42330 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752687AbdIDQhA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 4 Sep 2017 12:37:00 -0400
Date: Mon, 4 Sep 2017 18:35:32 +0200
From: David Sterba <dsterba@suse.cz>
To: Patrik Lundquist <patrik.lundquist@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: device usage: don't calculate slack on
 missing device
Message-ID: <20170904163532.GC31874@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170831110024.9580-1-patrik.lundquist@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170831110024.9580-1-patrik.lundquist@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 31, 2017 at 01:00:24PM +0200, Patrik Lundquist wrote:
> Print      Device slack:              0.00B
> instead of Device slack:           16.00EiB
> 
> Signed-off-by: Patrik Lundquist <patrik.lundquist@gmail.com>

Applied, thanks. I've added a test.
