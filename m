Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:54349 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751615AbdJLPi6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 12 Oct 2017 11:38:58 -0400
Date: Thu, 12 Oct 2017 08:38:54 -0700
From: Tejun Heo <tj@kernel.org>
To: dsterba@suse.cz, jack@suse.cz, axboe@kernel.dk, clm@fb.com, jbacik@fb.com,
        kernel-team@fb.com, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 5/5] btrfs: ensure that metadata and flush are issued
 from the root cgroup
Message-ID: <20171012153854.GR3301751@devbig577.frc2.facebook.com>
References: <20171010155441.753966-1-tj@kernel.org>
 <20171010155441.753966-6-tj@kernel.org>
 <20171010164325.GN3301751@devbig577.frc2.facebook.com>
 <20171011170723.GX3521@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171011170723.GX3521@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 11, 2017 at 07:07:23PM +0200, David Sterba wrote:
> The comment is useful, but the condition will be always true, so I don't
> see the point.
> 
> 	/*
> 	 * The btree_inode will be always in the root cgroup. The cgroup
> 	 * writeback can be enabled on regular inodes selectively.
> 	 */
> 	new_fl |= S_CGROUPWB;
> 
> is IMHO enough, based on my reading of patch 2/5 changelog.

Will update accordingly.

Thanks.

-- 
tejun
