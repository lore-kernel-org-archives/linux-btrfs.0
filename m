Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57972 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752493AbaDDLgr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 4 Apr 2014 07:36:47 -0400
Date: Fri, 4 Apr 2014 13:36:44 +0200
From: David Sterba <dsterba@suse.cz>
To: clm@fb.com
Cc: Gerhard Heift <gerhard@heift.name>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH RFCv4] new ioctl TREE_SEARCH_V2
Message-ID: <20140404113644.GQ29256@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1391095443-20287-1-git-send-email-Gerhard@Heift.Name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1391095443-20287-1-git-send-email-Gerhard@Heift.Name>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

On Thu, Jan 30, 2014 at 04:23:56PM +0100, Gerhard Heift wrote:
> This patch series first rewrites tree_search to copy found items directly to
> userspace and then adds a new ioctl TREE_SEARCH_V2 with which we could store
> them in a varying buffer. Now even items larger than 3992 bytes or a large
> amount of items can be returned. This is the case for some EXTENT_CSUM items,
> which could have a size up to 16k.

can you add this patchset to 3.15 queue? It hasn't gone through
btrfs-next for unknown reasons, but it should be merged because it makes
search ioctl usable with bigblocks that are now > 4k by default.

The newly added functionality is localized, I don't see huge risks adding
it even it was not in -next yet.

thanks,
david
