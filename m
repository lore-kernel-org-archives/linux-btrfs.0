Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54184 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752885AbcFTQDZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Jun 2016 12:03:25 -0400
Date: Mon, 20 Jun 2016 18:03:54 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, chandan@linux.vnet.ibm.com
Subject: Re: [PATCH v11 00/13] Btrfs dedupe framework
Message-ID: <20160620160354.GR4915@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20160615021001.9588-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160615021001.9588-1-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I'm looking how well does this patchset merges with the rest, so far
there are excpected conflicts with Chandan's subpage-blocksize
patchset. For the easy parts, we can add stub patches to extend
functions like cow_file_range with parameters that are added by the
other patch.

Honestly I don't know which patchset to take first. As the
subpage-blockszie is in the core, there are no user visibility and
interface questions, but it must not cause any regressions.

Dedupe is optional, not default, and we have to mainly make sure it does
not have any impact when turned off.

So I see three possible ways:

* merge subpage first, as it defines the API, adapt dedupe
* merge dedupe first, as it only enhanced existing API, adapt subpage
* create a common branch for both, merge relevant parts of each
  patchset, add more patches to prepare common ground for either patch

You can deduce yourself which vairant poses work on who. My preference
is to do the 3rd variant, as it does not force us any particular merge
order.
