Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:53539 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751132Ab2HGWZd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 7 Aug 2012 18:25:33 -0400
From: Andi Kleen <andi@firstfloor.org>
To: Josef Bacik <jbacik@fusionio.com>
Cc: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: use a slab for btrfs_dio_private
References: <1344028247-3143-1-git-send-email-jbacik@fusionio.com>
Date: Tue, 07 Aug 2012 15:25:31 -0700
In-Reply-To: <1344028247-3143-1-git-send-email-jbacik@fusionio.com> (Josef
	Bacik's message of "Fri, 3 Aug 2012 17:10:47 -0400")
Message-ID: <m2txwe49wk.fsf@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Josef Bacik <jbacik@fusionio.com> writes:

> This is in the IO path, let's try to avoid latencies by having our own slab.
> Thanks,

What latencies does this avoid?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
