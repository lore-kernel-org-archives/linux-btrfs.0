Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35659 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932598AbbKMKSF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Nov 2015 05:18:05 -0500
Message-ID: <5645B8A8.1050107@oracle.com>
Date: Fri, 13 Nov 2015 18:17:12 +0800
From: Anand Jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: Austin S Hemmelgarn <ahferroin7@gmail.com>, Duncan <1i5t5.duncan@cox.net>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 00/15] btrfs: Hot spare and Auto replace
References: <1447066589-3835-1-git-send-email-anand.jain@oracle.com> <5640A903.9030209@gmail.com> <pan$24d10$91cf318$b08c3c88$ac288e4@cox.net> <5641DF73.7030309@gmail.com>
In-Reply-To: <5641DF73.7030309@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Thanks for the comments.

  Sorry for the delay.
  Trying to find out if there is any pending concerns...

> Hopefully, per-filesystem hot-spares will be a high priority too, as
> that type of usage is pretty much required for many enterprise type
> uses, although that doesn't need to be the same code doing it (in fact,
> I could see having per-fs spares and global spares both available
> potentially being very useful).

  That's doable with in the current design as well, however stability
  and hardening (fixing the possible loop holes) is kind of priority.

Thanks, Anand
