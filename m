Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36392 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751704AbdIVISx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Sep 2017 04:18:53 -0400
Date: Fri, 22 Sep 2017 16:18:50 +0800
From: Eryu Guan <eguan@redhat.com>
To: Gu Jinxiang <gujx@cn.fujitsu.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfstests: Split MOUNT_OPTIONS to TEST_FS_MOUNT_OPTS
 and MOUNT_OPTIONS
Message-ID: <20170922081850.GE8034@eguan.usersys.redhat.com>
References: <1505722270-24648-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1505722270-24648-1-git-send-email-gujx@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 18, 2017 at 04:11:09PM +0800, Gu Jinxiang wrote:
> Resovle the inconsistent of mount option.
> Btrfs use MOUNT_OPTIONS for both scrath_dev and test_dev. Change to
> MOUNT_OPTIONS for scratch mount, and TEST_FS_MOUNT_OPTS for test dev
> mount.
> 
> Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>
> ---
> As mentioned by https://patchwork.kernel.org/patch/9742039/, the usage
> of MOUNT_OPTIONS is inconsistent.

Sorry for the late reply, because I don't think this is the right fix,
and I was trying to sort out & refactor the mount option settings
through fstests, but found that it required more time than I thought..

The new _check_test_btrfs_filesystem() you introduced here is a (almost)
complete copy of _check_btrfs_filesystem, the only difference is that
it's mounting $device with $TEST_FS_MOUNT_OPTS instead of
$MOUNT_OPTIONS. At least you could factor out a common helper so you
don't have to repeat 99% of the code.

But that only fixes _check_test_btrfs_filesystems, there're similar
problems in _check_generic_filesystems and other places that do mount
operation. I'd like to see a well-defined interface to return the correct
mount options to callers that want to do mount operations.

I'll look into this and see if I can work something out. I really
appreciate if anyone has other thoughts/suggestions!

Thanks,
Eryu
