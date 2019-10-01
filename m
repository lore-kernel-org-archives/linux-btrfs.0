Return-Path: <SRS0=Mi70=X2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A004C352AA
	for <linux-btrfs@archiver.kernel.org>; Tue,  1 Oct 2019 18:23:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C2D7020815
	for <linux-btrfs@archiver.kernel.org>; Tue,  1 Oct 2019 18:23:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731948AbfJASXf (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 1 Oct 2019 14:23:35 -0400
Received: from mx2.suse.de ([195.135.220.15]:40648 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731560AbfJASXe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 1 Oct 2019 14:23:34 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 73BA0ABE9;
        Tue,  1 Oct 2019 18:23:33 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 3ADBBDA88C; Tue,  1 Oct 2019 20:23:51 +0200 (CEST)
Date:   Tue, 1 Oct 2019 20:23:51 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH][v3] btrfs: add a force_chunk_alloc to space_info's sysfs
Message-ID: <20191001182350.GH2751@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
References: <20190805183153.22712-1-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190805183153.22712-1-josef@toxicpanda.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Aug 05, 2019 at 02:31:53PM -0400, Josef Bacik wrote:
> In testing various things such as the btrfsck patch to detect over
> allocation of chunks, empty block group deletion, and balance I've had
> various ways to force chunk allocations for debug purposes.  Add a sysfs
> file to enable forcing of chunk allocation for the owning space info in
> order to enable us to add testcases in the future to test these various
> features easier.
> 
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> ---
> v2->v3:
> - as per Qu's suggestion, moved this to sysfs where it's easier to mess with and
>   makes more sense.
> - added side-effect is mixed bg forced allocation works with this scheme as
>   well.
> - had to add get_btrfs_kobj() to get to fs_info, not sure this is better than
>   just adding the fs_info to the space_info, am open to other opinions here.

I believe v3 is the latest version, but I don't see the new file being
added to the debug/ directory (ie. /sys/fs/btrfs/UUID/debug/)

As it has been discussed, whether to make the file always visible or
only with CONFIG_BTRFS_DEBUG, I'd rather keep it debugging-only. The
testing coverage should be sufficient for fstests that are run with the
config option and not giving users a knob to paper over allocator
problems sounds desirable.
