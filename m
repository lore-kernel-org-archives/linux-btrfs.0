Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49728 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752489Ab3HHSIS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 8 Aug 2013 14:08:18 -0400
Date: Thu, 8 Aug 2013 11:08:16 -0700
From: Zach Brown <zab@redhat.com>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] btrfs-progs: introduce btrfs filesystem show --kernel
Message-ID: <20130808180816.GW12314@lenny.home.zabbo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1375949227-23729-3-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1375949227-23729-1-git-send-email-anand.jain@oracle.com>
 <1375949227-23729-3-git-send-email-anand.jain@oracle.com>

On Thu, Aug 08, 2013 at 04:07:07PM +0800, Anand Jain wrote:
> As of now btrfs filesystem show reads directly from
> disks. So sometimes output can be stale, mainly when
> user want to verify their last operation like,
> labeling or device delete or add... etc.
> 
> This patch adds --kernel option to the 'filesystem show'
> subcli, which will read from the kernel instead of
> the disks directly.

Why should this be an option?

When mounted, the kernel cache is authoritative.  It was always a bug to
read stale data from disk.

The kernel should be read first, and if that isn't available it can fall
back to offering unreliable data from disk with a giant wraning.

Right?

- z
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
