Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35069 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750867AbcGGNOz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 7 Jul 2016 09:14:55 -0400
Date: Thu, 7 Jul 2016 15:15:13 +0200
From: David Sterba <dsterba@suse.cz>
To: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs: fix fsfreeze hang caused by delayed iputs deal
Message-ID: <20160707131513.GY13336@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20160629051510.17222-1-wangxg.fnst@cn.fujitsu.com>
 <20160704173529.GM13336@twin.jikos.cz>
 <577CDB78.6030507@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <577CDB78.6030507@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 06, 2016 at 06:20:40PM +0800, Wang Xiaoguang wrote:
> > There's opencoding an existing wrapper sb_start_write, please use it
> > instead.
> OK, I can submit a new version using this wrapper.
> Also could you please have a look at my reply to Filipe Manana in
> last mail? I suggest another solution, thanks.

I missed Filipe's response when writing mine, but I agree with him. We
should avoid relying on sb freezing API calls (or peeking into the
interal structures) in general. It could be quite hard to prove that the
change will not break something else.
