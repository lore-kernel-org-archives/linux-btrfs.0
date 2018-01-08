Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f182.google.com ([209.85.220.182]:41508 "EHLO
        mail-qk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933239AbeAHRMl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Jan 2018 12:12:41 -0500
Date: Mon, 8 Jan 2018 09:12:34 -0800
From: Tejun Heo <tj@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: jack@suse.cz, axboe@kernel.dk, clm@fb.com, jbacik@fb.com,
        kernel-team@fb.com, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, peterz@infradead.org,
        jianchao.w.wang@oracle.com, Bart.VanAssche@wdc.com
Subject: Re: [PATCH 1/7] blk-mq: protect completion path with RCU
Message-ID: <20180108171234.GX3668920@devbig577.frc2.facebook.com>
References: <20171216120726.517153-1-tj@kernel.org>
 <20171216120726.517153-2-tj@kernel.org>
 <20171229100418.GB4020@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171229100418.GB4020@infradead.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello, Christoph.

On Fri, Dec 29, 2017 at 02:04:18AM -0800, Christoph Hellwig wrote:
> Why do you need the srcu protection?  The completion path can never
> sleep.
> 
> If there is a good reason to keep it please add commment, and
> make the srcu variant a separate function only used by drivers that
> need it instead of adding the conditional.

It's either that or adding protection against both srcu and rcu in the
counterpart.  It's easier / cleaner to just use single rcu construct
for a given queue.  Will add a comment.  Jens already has a patch
which factors out the conditionals.

Thanks.

-- 
tejun
