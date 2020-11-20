Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15E2EC56201
	for <linux-btrfs@archiver.kernel.org>; Fri, 20 Nov 2020 16:38:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B07CF2225B
	for <linux-btrfs@archiver.kernel.org>; Fri, 20 Nov 2020 16:38:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729812AbgKTQib (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 20 Nov 2020 11:38:31 -0500
Received: from mx2.suse.de ([195.135.220.15]:51022 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728892AbgKTQib (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Nov 2020 11:38:31 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id B9067AB3D;
        Fri, 20 Nov 2020 16:38:29 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id D7CD2DA6E1; Fri, 20 Nov 2020 17:36:42 +0100 (CET)
Date:   Fri, 20 Nov 2020 17:36:42 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc:     David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        Anand Jain <anand.jain@oracle.com>,
        Nikolay Borisov <nborisov@suse.com>,
        syzbot+582e66e5edf36a22c7b0@syzkaller.appspotmail.com
Subject: Re: [PATCH v3] btrfs: don't access possibly stale fs_info data for
 printing duplicate device
Message-ID: <20201120163642.GU20563@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        Anand Jain <anand.jain@oracle.com>,
        Nikolay Borisov <nborisov@suse.com>,
        syzbot+582e66e5edf36a22c7b0@syzkaller.appspotmail.com
References: <e639c7a057653c1947b3a4acf2fba6c7798000b5.1605690144.git.johannes.thumshirn@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e639c7a057653c1947b3a4acf2fba6c7798000b5.1605690144.git.johannes.thumshirn@wdc.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Nov 18, 2020 at 06:03:26PM +0900, Johannes Thumshirn wrote:
> Syzbot reported a possible use-after-free when printing a duplicate device
> warning device_list_add().
> 
> At this point it can happen that a btrfs_device::fs_info is not correctly
> setup yet, so we're accessing stale data, when printing the warning
> message using the btrfs_printk() wrappers.
> 
> The syzkaller reproducer for this use-after-free crafts a filesystem image
> and loop mounts it twice in a loop. The mount will fail as the crafted
> image has an invalid chunk tree. When this happens btrfs_mount_root() will
> call deactivate_locked_super(), which then cleans up fs_info and
> fs_info::sb. If a second thread now adds the same block-device to the
> file-system, it will get detected as a duplicate device and
> device_list_add() will reject the duplicate and print a warning. But as
> the fs_info pointer passed in is non-NULL this will result in a
> use-after-free.
> 
> Instead of printing possibly uninitialized or already freed memory in
> btrfs_printk(), explicitly pass in a NULL fs_info so the printing of the
> device name will be skipped altogether.
> 
> Link: https://lore.kernel.org/linux-btrfs/000000000000c9e14b05afcc41ba@google.com

I've added the stacktrace from the link.

> Reported-by: syzbot+582e66e5edf36a22c7b0@syzkaller.appspotmail.com
> Reviewed-by: Nikolay Borisov <nborisov@suse.com>
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

Added to misc-next, thanks.
