Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45200 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932467AbbIYQkT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Sep 2015 12:40:19 -0400
Date: Fri, 25 Sep 2015 18:39:21 +0200
From: David Sterba <dsterba@suse.cz>
To: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 1/2] btrfs-progs: use switch instead of a series of
 ifs for output errormsg
Message-ID: <20150925163921.GM11442@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <4779cd8de60a58c7e3d9ea2cf62595bd075638c2.1438830282.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4779cd8de60a58c7e3d9ea2cf62595bd075638c2.1438830282.git.zhaolei@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 06, 2015 at 11:05:54AM +0800, Zhao Lei wrote:
> switch statement is more suitable for outputing currsponding message
> for errno.
> 
> Suggested-by: David Sterba <dsterba@suse.com>
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>

Applied, thanks.
