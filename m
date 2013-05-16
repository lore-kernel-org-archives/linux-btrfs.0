Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:48509 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123Ab3EPLyU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 May 2013 07:54:20 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id D5E567C041B
	for <linux-btrfs@vger.kernel.org>; Thu, 16 May 2013 05:54:19 -0600 (MDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
To: "miaox@cn.fujitsu.com" <miaox@cn.fujitsu.com>,
        Miao Xie <miaox@cn.fujitsu.com>,
        "bo.li.liu@oracle.com" <bo.li.liu@oracle.com>
From: Chris Mason <chris.mason@fusionio.com>
In-Reply-To: <5194893D.90505@cn.fujitsu.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "alex.btrfs@zadarastorage.com" <alex.btrfs@zadarastorage.com>
References: <1368604111-25073-1-git-send-email-miaox@cn.fujitsu.com>
 <1368604111-25073-7-git-send-email-miaox@cn.fujitsu.com>
 <20130516033645.GF20202@liubo.jp.oracle.com>
 <5194610F.1000603@cn.fujitsu.com>
 <20130516051556.GH20202@liubo.jp.oracle.com>
 <51946FD3.5000008@cn.fujitsu.com>
 <20130516061552.GI20202@liubo.jp.oracle.com> <5194893D.90505@cn.fujitsu.com>
Message-ID: <20130516115417.24668.98321@localhost.localdomain>
Subject: Re: [PATCH 06/17] Btrfs: introduce grab/put functions for the root of the
 fs/file tree
Date: Thu, 16 May 2013 07:54:17 -0400
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Quoting Miao Xie (2013-05-16 03:22:37)
> > I must say that the patch itself looks harmless, the reason is not good enough.
> 
> I don't agree with you.
> It is perishing that The memory reclaim task is blocked for a long time. We should avoid
> this problem.

synchronize_rcu and friends can take a very very long time.  I like this
patch as a way to avoid them, it's just keeps the whole kernel moving.

-chris
