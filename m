Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39242 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752004AbdFLOFv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Jun 2017 10:05:51 -0400
Date: Mon, 12 Jun 2017 16:04:45 +0200
From: David Sterba <dsterba@suse.cz>
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs-progs: send operates on ro snapshots only
Message-ID: <20170612140445.GM25451@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170605233218.12421-1-hans.van.kranenburg@mendix.com>
 <20170606130058.11619-1-hans.van.kranenburg@mendix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170606130058.11619-1-hans.van.kranenburg@mendix.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 06, 2017 at 03:00:58PM +0200, Hans van Kranenburg wrote:
> While talking to another btrfs user on IRC today, it became clear that a
> major point of confusion in the btrfs send manual is that it's not
> telling the user soon enough that send/receive solely operates on
> subvolume snapshots instead of the original (read/write) subvolumes.
> 
> So, change the first few lines to explicitly mention snapshots instead.
> Technically, snapshots are also just subvolumes, but requiring this
> level of technical detailed knowledge doesn't help the user who is just
> trying out things.

Agreed.

> Signed-off-by: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
> ---

Applied, thanks.
