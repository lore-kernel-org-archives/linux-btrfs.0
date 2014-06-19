Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:18803 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752884AbaFSAvV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Jun 2014 20:51:21 -0400
Date: Thu, 19 Jun 2014 10:51:06 +1000
From: Dave Chinner <david@fromorbit.com>
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Cc: Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3] xfstests/btrfs: add qgroup rescan stress test
Message-ID: <20140619005106.GG4453@dastard>
References: <1394423051-17356-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
 <1399615343-28544-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
 <53A14F86.9000506@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <53A14F86.9000506@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 18, 2014 at 04:36:22PM +0800, Wang Shilong wrote:
> Hello Josef,
> 
> The lastest Qgroup code still break this test sometimes.
> 
> Ps: this test seems not merging into xfstests.

Then repost it to fstests@vger.kernel.org. Sometimes patches get
missed...

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
