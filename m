Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:35462 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753887AbbLIKq2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 9 Dec 2015 05:46:28 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 5A9332051F
	for <linux-btrfs@vger.kernel.org>; Wed,  9 Dec 2015 10:46:26 +0000 (UTC)
Received: from mail-io0-f182.google.com (mail-io0-f182.google.com [209.85.223.182])
	(using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPSA id 6B736204FB
	for <linux-btrfs@vger.kernel.org>; Wed,  9 Dec 2015 10:46:25 +0000 (UTC)
Received: by ioir85 with SMTP id r85so54724525ioi.1
        for <linux-btrfs@vger.kernel.org>; Wed, 09 Dec 2015 02:46:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201512091812.nrsVZvei%fengguang.wu@intel.com>
References: <1449656629-16690-1-git-send-email-fdmanana@kernel.org>
	<201512091812.nrsVZvei%fengguang.wu@intel.com>
Date: Wed, 9 Dec 2015 10:46:24 +0000
Message-ID: <CAL3q7H4kUWPwiW=Qg8TuyXz+ezR-vY0kajsPFWgqOzBC+RxXBw@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: fix leaking of ordered extents after direct IO
 write error
From: Filipe Manana <fdmanana@kernel.org>
To: kbuild test robot <lkp@intel.com>
Cc: kbuild-all@01.org,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Filipe Manana <fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 9, 2015 at 10:41 AM, kbuild test robot <lkp@intel.com> wrote:
> Hi Filipe,
>
> [auto build test ERROR on v4.4-rc4]
> [also build test ERROR on next-20151208]
> [cannot apply to btrfs/next]
>
> url:    https://github.com/0day-ci/linux/commits/fdmanana-kernel-org/Btrfs-fix-leaking-of-ordered-extents-after-direct-IO-write-error/20151209-182927
> config: x86_64-randconfig-x008-12090811 (attached as .config)
> reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=x86_64
>
> All errors (new ones prefixed by >>):
>
>    fs/btrfs/inode.c: In function 'btrfs_direct_IO':
>>> fs/btrfs/inode.c:8528:5: error: implicit declaration of function 'btrfs_endio_direct_write_update_ordered' [-Werror=implicit-function-declaration]
>         btrfs_endio_direct_write_update_ordered(inode,
>         ^
>    cc1: some warnings being treated as errors


Yes test robot. It depends on a previous patch
(https://patchwork.kernel.org/patch/7702051/ /
http://git.kernel.org/cgit/linux/kernel/git/fdmanana/linux.git/commit/?h=integration-4.4&id=cefbb57148831bcdc47f78f5963ff6fb63a29936)
as mentioned in a comment of this patch.

>
> vim +/btrfs_endio_direct_write_update_ordered +8528 fs/btrfs/inode.c
>
>   8522                           * without submitting corresponding bios for them, so
>   8523                           * cleanup them up to avoid other tasks getting them
>   8524                           * and waiting for them to complete forever.
>   8525                           */
>   8526                          if (dio_data.unsubmitted_oe_range_start <
>   8527                              dio_data.unsubmitted_oe_range_end)
>> 8528                                  btrfs_endio_direct_write_update_ordered(inode,
>   8529                                          dio_data.unsubmitted_oe_range_start,
>   8530                                          dio_data.unsubmitted_oe_range_end -
>   8531                                          dio_data.unsubmitted_oe_range_start,
>
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
