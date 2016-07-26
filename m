Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38313 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757012AbcGZRHz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Jul 2016 13:07:55 -0400
Date: Tue, 26 Jul 2016 19:07:39 +0200
From: David Sterba <dsterba@suse.cz>
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>, linux-btrfs@vger.kernel.org,
        dsterba@suse.com
Subject: Re: [PATCH] btrfs-progs: add option to run balance as daemon
Message-ID: <20160726170739.GM30795@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20160621151659.32157-1-ahferroin7@gmail.com>
 <29743bb5-3b69-4d13-5737-cea6dd8f6a46@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <29743bb5-3b69-4d13-5737-cea6dd8f6a46@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 11, 2016 at 10:44:30AM +0900, Satoru Takeuchi wrote:
> > +					chdir("/");
> 
> You should check the return value of chdir(). Otherwise
> we get the following warning message at the build time.

Can we actually fail to change directory to '/' ? Otherwise I think the
warning should be silenced so the build is clean.
