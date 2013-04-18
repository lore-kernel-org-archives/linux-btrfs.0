Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56719 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967136Ab3DROuA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Apr 2013 10:50:00 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 813B2A52C6
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Apr 2013 16:49:59 +0200 (CEST)
Date: Thu, 18 Apr 2013 16:49:58 +0200
From: David Sterba <dsterba@suse.cz>
To: David Sterba <dsterba@suse.cz>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [bug] 3.9-rc7+next: NULL deref in
 btrfs_next_old_leaf/btrfs_search_slot
Message-ID: <20130418144958.GI16427@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20130418144218.GH16427@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130418144218.GH16427@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 18, 2013 at 04:42:18PM +0200, David Sterba wrote:
> xfstests loop has hit this after a day, failing test was 276.

sorry it's test 273
