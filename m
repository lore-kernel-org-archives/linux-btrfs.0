Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49287 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932512AbaAaRkJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 31 Jan 2014 12:40:09 -0500
Date: Fri, 31 Jan 2014 18:40:08 +0100
From: David Sterba <dsterba@suse.cz>
To: Gerhard Heift <gerhard@heift.name>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH RFCv4] new ioctl TREE_SEARCH_V2
Message-ID: <20140131174008.GH1364@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1391095443-20287-1-git-send-email-Gerhard@Heift.Name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1391095443-20287-1-git-send-email-Gerhard@Heift.Name>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 30, 2014 at 04:23:56PM +0100, Gerhard Heift wrote:
> This patch series first rewrites tree_search to copy found items directly to
> userspace and then adds a new ioctl TREE_SEARCH_V2 with which we could store
> them in a varying buffer. Now even items larger than 3992 bytes or a large
> amount of items can be returned. This is the case for some EXTENT_CSUM items,
> which could have a size up to 16k.

>   Should we limit the buffer size?
>   * David suggested [1] a minimum of 64k, I've chosen a cap of 16M.

Well, 64M is a lot, but as it's only an upper limit, ok.

I have scrolled through the patches, overall i looks ok, can IMO go into
btrfs-next, but more testing is obviously needed. I'll stick a
reviewed-by once I give it a bit of testing myself.


thanks,
david
