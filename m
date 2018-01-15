Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54322 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932085AbeAOGWb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 15 Jan 2018 01:22:31 -0500
Date: Mon, 15 Jan 2018 14:22:28 +0800
From: Eryu Guan <eguan@redhat.com>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] fstests: common/rc: fix device still mounted error with
 SCRATCH_DEV_POOL
Message-ID: <20180115062228.GA3102@eguan.usersys.redhat.com>
References: <20180113010459.24321-1-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180113010459.24321-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 12, 2018 at 06:04:59PM -0700, Liu Bo wrote:
> One of btrfs tests, btrfs/011, uses SCRATCH_DEV_POOL and puts a non-SCRATCH_DEV
> device as the first one when doing mkfs, and this makes
> _require_scratch{_nocheck} fail to umount $SCRATCH_MNT since it checks mount
> point with SCRATCH_DEV only, and for sure it finds nothing to umount and the
> following tests complain about 'device still mounted' alike errors.
> 
> Introduce a helper to address this special case where both btrfs and scratch
> dev pool are in use.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Hmm, I didn't see this problem, I ran btrfs/011 then another tests that
uses $SCRATCH_DEV, and the second test ran fine too. Can you please
provide more details?

Anyway, I think we should fix btrfs/011 to either not use $SCRATCH_DEV
in replace operations (AFAIK, other btrfs replace tests do this) or
umount all devices before exit. And I noticed btrfs/011 does umount
$SCRATCH_MNT at the end of workout(), so usually all should be fine
(perhaps it would leave a device mounted if interrupted in the middle of
test run, because _cleanup() doesn't do umount).

Thanks,
Eryu
