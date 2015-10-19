Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51389 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753452AbbJSNNq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 Oct 2015 09:13:46 -0400
Date: Mon, 19 Oct 2015 15:12:31 +0200
From: David Sterba <dsterba@suse.cz>
To: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/3] btrfs-progs: mkfs: Fix different mixed type by
 argument sequence
Message-ID: <20151019131231.GV27761@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1444740703.git.zhaolei@cn.fujitsu.com>
 <20151013161913.GL27761@twin.jikos.cz>
 <00a101d10638$b763c7c0$262b5740$@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <00a101d10638$b763c7c0$262b5740$@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 14, 2015 at 12:28:03PM +0800, Zhao Lei wrote:
> If 4.3 released with dropping mixed-bg, the PATCH 1/3 maybe still
> necessary, I'll rebase after 4.3.
> 
> And another problem:
> This time the vdh1 is changed to 100M:
> 
> [root@kerneldev progs]# ./mkfs.btrfs -f /dev/vdh2 /dev/vdh1
> btrfs-progs v4.2.2-25-gc6b29b6-dirty
> See http://btrfs.wiki.kernel.org for more information.
> 
> not enough free space

Yeah, 100M reaches the current default settings of the blockgroups,
we'd need some adjustments for such filesystems.

> Can be fixed by checking raid support only based on "large disk count".

We can try to make it work even in the weird device size combinations,
but not at the cost of complicating the code unnecessarily. I don't want
to discourage you, so if you eg. make it work with 64M devices that
would be good enough though going even lower should be possible.

> This fix maybe conflict with Chandan's work, so I'll begin work after
> he finished.

That would be great, thanks.
