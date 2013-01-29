Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58741 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752835Ab3A2OZJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Jan 2013 09:25:09 -0500
Date: Tue, 29 Jan 2013 15:25:06 +0100
From: David Sterba <dsterba@suse.cz>
To: Ian Kumlien <pomac@vapor.com>
Cc: David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] [RFC] Add static compile target
Message-ID: <20130129142506.GK16977@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1359158987-19921-1-git-send-email-pomac@demius.net>
 <20130128170500.GC16977@twin.jikos.cz>
 <20130128184101.GG15780@pomac.netswarm.net>
 <20130128214651.GH16977@twin.jikos.cz>
 <20130128233153.GI15780@pomac.netswarm.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130128233153.GI15780@pomac.netswarm.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 29, 2013 at 12:31:53AM +0100, Ian Kumlien wrote:
> This means that dists are striping binaries...
> In which case it would be no problem to have then build the static target,
> perhaps we could try to verify if they are available and build btrfs.static
> and btrfsck.static if possible....

I like that, keeping the .static versions along the dynamic ones, just
for the rescue purposes. (And to reduce the total file size even further
merge the fsck functionlity into 'btrfs', but this is not a primary goal
now.)

david
