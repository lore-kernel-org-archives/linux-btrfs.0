Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56256 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754133AbaLDPzy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 4 Dec 2014 10:55:54 -0500
Date: Thu, 4 Dec 2014 16:55:53 +0100
From: David Sterba <dsterba@suse.cz>
To: Wang Shilong <wangshilong1991@gmail.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH 0/3] Extent tree rebuilding with snapshots patches
Message-ID: <20141204155553.GE9754@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1416970736-26623-1-git-send-email-wangshilong1991@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1416970736-26623-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 26, 2014 at 10:58:49AM +0800, Wang Shilong wrote:
> I did send these patches a long while ago, but due to some reasons,
> they were not merged, these are important fixes for fsck, without
> these patches, extent tree rebuilding did not work with snapshots.

I have the patches in my local git, but fsck fixes need special care
(reviews or tests), so this was holding them back. I'll queue them for
3.18.
