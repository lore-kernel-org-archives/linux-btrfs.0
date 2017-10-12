Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44292 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751348AbdJLS6c (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 12 Oct 2017 14:58:32 -0400
Date: Thu, 12 Oct 2017 20:56:46 +0200
From: David Sterba <dsterba@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: dsterba@suse.cz, jack@suse.cz, axboe@kernel.dk, clm@fb.com, jbacik@fb.com,
        kernel-team@fb.com, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 5/5] btrfs: ensure that metadata and flush are issued
 from the root cgroup
Message-ID: <20171012185646.GG3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171010155441.753966-1-tj@kernel.org>
 <20171010155441.753966-6-tj@kernel.org>
 <20171010164325.GN3301751@devbig577.frc2.facebook.com>
 <20171011170723.GX3521@twin.jikos.cz>
 <20171012170628.GS3301751@devbig577.frc2.facebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171012170628.GS3301751@devbig577.frc2.facebook.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 12, 2017 at 10:06:28AM -0700, Tejun Heo wrote:
> Issuing metdata or otherwise shared IOs from !root cgroup can lead to
> priority inversion.  This patch ensures that those IOs are always
> issued from the root cgroup.
> 
> v3: Dropped unnecessary btree_inode handling as suggested by David
>     Sterba.
> 
> v2: Fixed missing @bh in submit_bh_blkcg_css() call.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reviewed-by: Liu Bo <bo.li.liu@oracle.com>
> Cc: David Sterba <dsterba@suse.cz>

Acked-by: David Sterba <dsterba@suse.com>
