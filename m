Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f178.google.com ([209.85.216.178]:38131 "EHLO
        mail-qt0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932248AbdK2RFF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 29 Nov 2017 12:05:05 -0500
Date: Wed, 29 Nov 2017 09:05:01 -0800
From: Tejun Heo <tj@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: axboe@kernel.dk, clm@fb.com, jbacik@fb.com, kernel-team@fb.com,
        linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCHSET v2] cgroup, writeback, btrfs: make sure btrfs issues
 metadata IOs from the root cgroup
Message-ID: <20171129170501.GW983427@devbig577.frc2.facebook.com>
References: <20171010155441.753966-1-tj@kernel.org>
 <20171129165608.GA26740@quack2.suse.cz>
 <20171129170330.GV983427@devbig577.frc2.facebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171129170330.GV983427@devbig577.frc2.facebook.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 29, 2017 at 09:03:30AM -0800, Tejun Heo wrote:
> Hello,
> 
> On Wed, Nov 29, 2017 at 05:56:08PM +0100, Jan Kara wrote:
> > What has happened with this patch set?
> 
> No idea.  cc'ing Chris directly.  Chris, if the patchset looks good,
> can you please route them through the btrfs tree?

lol looking at the patchset again, I'm not sure that's obviously the
right tree.  It can either be cgroup, block or btrfs.  If no one
objects, I'll just route them through cgroup.

Thanks.

-- 
tejun
