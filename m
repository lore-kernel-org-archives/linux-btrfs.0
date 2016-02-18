Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60565 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1425807AbcBRJjv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Feb 2016 04:39:51 -0500
Date: Thu, 18 Feb 2016 10:39:45 +0100
From: David Sterba <dsterba@suse.cz>
To: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: "'Dan Carpenter'" <dan.carpenter@oracle.com>, linux-btrfs@vger.kernel.org,
        "'David Sterba'" <dsterba@suse.cz>
Subject: Re: btrfs: reada: simplify dev->reada_in_flight processing
Message-ID: <20160218093945.GW4374@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20160217190152.GA10246@mwanda>
 <007601d169ec$f5d23f10$e176bd30$@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <007601d169ec$f5d23f10$e176bd30$@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 18, 2016 at 09:37:41AM +0800, Zhao Lei wrote:
> CC: David Sterba <dsterba@suse.cz>
> I'll fix this indent problem in following branch:
> https://github.com/zhaoleidd/btrfs.git integration-4.5
> 
> Could you pick them again?

Done, fixed manually and updated in for-next.
