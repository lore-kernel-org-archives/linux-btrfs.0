Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29207 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770Ab3EPOcY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 May 2013 10:32:24 -0400
Date: Thu, 16 May 2013 22:31:39 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Chris Mason <chris.mason@fusionio.com>
Cc: "miaox@cn.fujitsu.com" <miaox@cn.fujitsu.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "alex.btrfs@zadarastorage.com" <alex.btrfs@zadarastorage.com>
Subject: Re: [PATCH 06/17] Btrfs: introduce grab/put functions for the root
 of the fs/file tree
Message-ID: <20130516143138.GL20202@liubo.jp.oracle.com>
Reply-To: bo.li.liu@oracle.com
References: <1368604111-25073-1-git-send-email-miaox@cn.fujitsu.com>
 <1368604111-25073-7-git-send-email-miaox@cn.fujitsu.com>
 <20130516033645.GF20202@liubo.jp.oracle.com>
 <5194610F.1000603@cn.fujitsu.com>
 <20130516051556.GH20202@liubo.jp.oracle.com>
 <51946FD3.5000008@cn.fujitsu.com>
 <20130516061552.GI20202@liubo.jp.oracle.com>
 <5194893D.90505@cn.fujitsu.com>
 <20130516115417.24668.98321@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130516115417.24668.98321@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 16, 2013 at 07:54:17AM -0400, Chris Mason wrote:
> Quoting Miao Xie (2013-05-16 03:22:37)
> > > I must say that the patch itself looks harmless, the reason is not good enough.
> > 
> > I don't agree with you.
> > It is perishing that The memory reclaim task is blocked for a long time. We should avoid
> > this problem.
> 
> synchronize_rcu and friends can take a very very long time.  I like this
> patch as a way to avoid them, it's just keeps the whole kernel moving.
> 
> -chris

Okay, that teaches me another lesson, thanks Miao :)

thanks,
liubo
