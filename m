Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50417 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757555Ab3GLWTj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Jul 2013 18:19:39 -0400
Date: Sat, 13 Jul 2013 00:19:37 +0200
From: David Sterba <dsterba@suse.cz>
To: Chris Mason <chris.mason@fusionio.com>
Cc: Miao Xie <miaox@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/5] Btrfs: add branch prediction hints in the read page
 end IO function
Message-ID: <20130712221937.GH24343@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1373520339-13870-1-git-send-email-miaox@cn.fujitsu.com>
 <1373520339-13870-2-git-send-email-miaox@cn.fujitsu.com>
 <20130711143122.12026.78808@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130711143122.12026.78808@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 11, 2013 at 10:31:22AM -0400, Chris Mason wrote:
> Do you have benchmark numbers for how much these help?  I hesitate to
> bring in the likely/unlikely unless we can see it on the benchmarks.

Seconded, I doubt that this particular function gets any measurable
speed improvement with the prediction hints. They're eg suitable for
branches that almost never happen like error conditions or shortcuts to
the exit.

There's a config option CONFIG_PROFILE_ANNOTATED_BRANCHES to profile
all likely/unlikely, so if you want to see the hint effects yourself
feel free to experiment with that.

Theres' 'perf branch' patchset, able to gather information from the
Branch Trace Store (BTS), http://lwn.net/Articles/444885/ .

There probably are functions in btrfs code where even a small
improvement could bring some performance, first guess is
btrfs_search_slot + the callees, but I've never seen it up in the perf
top profile.

david
