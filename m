Return-Path: <SRS0=zIKm=QA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23F95C282C5
	for <linux-btrfs@archiver.kernel.org>; Thu, 24 Jan 2019 20:17:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E5D57217D7
	for <linux-btrfs@archiver.kernel.org>; Thu, 24 Jan 2019 20:17:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729577AbfAXUR0 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 24 Jan 2019 15:17:26 -0500
Received: from mx2.suse.de ([195.135.220.15]:36502 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729018AbfAXTXO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 24 Jan 2019 14:23:14 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 7C6D2B102
        for <linux-btrfs@vger.kernel.org>; Thu, 24 Jan 2019 19:23:13 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 6A189DA6F5; Thu, 24 Jan 2019 20:22:38 +0100 (CET)
Date:   Thu, 24 Jan 2019 20:22:37 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [Patch v5 0/7] btrfs: qgroup: Delay subtree scan to reduce
 overhead
Message-ID: <20190124192236.GA2900@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190123071518.2528-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190123071518.2528-1-wqu@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Jan 23, 2019 at 03:15:11PM +0800, Qu Wenruo wrote:
> - A lot of coding style fixes:
>   * naming change from "file"/"subv" to "subvol"
>   * {} for any else if branch
>   * avoid err/ret confusion by introducing "tmp_ret"
>   * proper errno for non-uptodate extent buffer
>   * struct member re-ordering to avoid unnecessary padding
>   * avoid single letter variable name
>   * less redundant emphasizing
>   * move certain devel-only warning under CONFIG_BTRFS_DEBUG
>   * replace cool-sounding 'hack' with 'optimization'
>   * remove unnecessary inline prefix for btrfs_qgroup_init_swapped_blocks
>   * keep an empty line before #endif

Thank you, reading through the patches was now much smoother experience
for me. I'll let it pass fstests and merge it to misc-next, as there are
more patches and patchsets depending on it so we can give it wider
testing.

The slow metadata balance patch has been posted, the qgroup deadlock
still needs to be resolved. If you have ideas or pending cleanups in the
qgroup code then it's fine to send them until rc5. I hope the main
functional changes are about to be merged, small fixups or additions
should be within the scope of testing.
