Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41444 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754890AbaC0P1e (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Mar 2014 11:27:34 -0400
Date: Thu, 27 Mar 2014 16:27:32 +0100
From: David Sterba <dsterba@suse.cz>
To: Brendan Hide <brendan@swiftspirit.co.za>
Cc: Gui Hecheng <guihc.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: add btrfs resize unit t/p/e support
Message-ID: <20140327152732.GX29256@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1395888673-28433-1-git-send-email-guihc.fnst@cn.fujitsu.com>
 <5333D4CD.6030605@swiftspirit.co.za>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5333D4CD.6030605@swiftspirit.co.za>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 27, 2014 at 09:35:41AM +0200, Brendan Hide wrote:
> On 2014/03/27 04:51 AM, Gui Hecheng wrote:
> >[snip]
> >
> >We add t/p/e support by replacing lib/cmdline.c:memparse
> >with btrfs_memparse. The btrfs_memparse copies memparse's code
> >and add unit t/p/e parsing.
> Is there a conflict preventing adding this to memparse directly?

Agreed, there's no reason do duplicate this function.
