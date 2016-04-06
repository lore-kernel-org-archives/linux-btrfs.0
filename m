Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:16967 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753639AbcDFAaR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 5 Apr 2016 20:30:17 -0400
Date: Tue, 5 Apr 2016 20:30:03 -0400
From: Chris Mason <clm@fb.com>
To: Lars Ellenberg <lars.ellenberg@linbit.com>
CC: Neil Brown <neilb@suse.de>, Jens Axboe <axboe@kernel.dk>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] [RFC] fix potential access after free: return value of
 blk_check_plugged() must be used schedule() safe
Message-ID: <20160406003003.GA57524@clm-mbp.masoncoding.com>
References: <20160405133657.GA3078@soda.linbit>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20160405133657.GA3078@soda.linbit>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 05, 2016 at 03:36:57PM +0200, Lars Ellenberg wrote:
> blk_check_plugged() will return a pointer
> to an object linked on current->plug->cb_list.
> 
> That list may "at any time" be implicitly cleared by
> blk_flush_plug_list()
>  flush_plug_callbacks()
> either as a result of blk_finish_plug(),
> or implicitly by schedule() [and maybe other implicit mechanisms?]
> 
> If there is no protection against an implicit unplug
> between the call to blk_check_plug() and using its return value,
> that implicit unplug may have already happened,
> even before the plug is actually initialized or populated,
> and we may be using a pointer to already free()d data.
> 
> I suggest that both raid1 and raid10 can easily be fixed
> by moving the call to blk_check_plugged() inside the spinlock.
> 
> For md/raid5 and btrfs/raid56,
> I'm unsure how (if) this needs to be fixed.

I think you're right, digging in to see if there's something I missed.
But as Neil said, it looks like we just got saved by preemption being
off by default.

-chris
