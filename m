Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52780 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752129AbdGMQJr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Jul 2017 12:09:47 -0400
Date: Thu, 13 Jul 2017 18:08:29 +0200
From: David Sterba <dsterba@suse.cz>
To: fdmanana@kernel.org
Cc: linux-btrfs@vger.kernel.org, bo.li.liu@oracle.com
Subject: Re: [PATCH] Btrfs: fix write corruption due to bio cloning on raid5/6
Message-ID: <20170713160829.GD2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170713140954.2243-1-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170713140954.2243-1-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 13, 2017 at 03:09:54PM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> The recent changes to make bio cloning faster (added in the 4.13 merge
> window) by using the bio_clone_fast() API introduced a regression on
> raid5/6 modes, because cloned bios have an invalid bi_vcnt field
> (therefore it can not be used) and the raid5/6 code uses the
> bio_for_each_segment_all() API to iterate the segments of a bio, and this
> API uses a bio's bi_vcnt field.

Good catch! I'm going to add assertions to all remaining
bio_for_each_segment_all calls so that cloned bios do not get
accidentally iterated that way.

Other raid levels seem to be fine with the usecase you've provided, I'm
now running fstests with the assertions.
