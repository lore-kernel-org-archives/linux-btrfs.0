Return-Path: <SRS0=GbvB=QE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B640EC282C8
	for <linux-btrfs@archiver.kernel.org>; Mon, 28 Jan 2019 18:16:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8D83220882
	for <linux-btrfs@archiver.kernel.org>; Mon, 28 Jan 2019 18:16:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727051AbfA1SQY (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 28 Jan 2019 13:16:24 -0500
Received: from mx2.suse.de ([195.135.220.15]:51676 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726995AbfA1SQY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 28 Jan 2019 13:16:24 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id F267DAF9B
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Jan 2019 18:16:22 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 5775CDA78C; Mon, 28 Jan 2019 19:15:44 +0100 (CET)
Date:   Mon, 28 Jan 2019 19:15:43 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [Patch v5 0/7] btrfs: qgroup: Delay subtree scan to reduce
 overhead
Message-ID: <20190128181543.GI2900@twin.jikos.cz>
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
> Qu Wenruo (6):
>   btrfs: relocation: Delay reloc tree deletion after merge_reloc_roots()
>   btrfs: qgroup: Refactor btrfs_qgroup_trace_subtree_swap()
>   btrfs: qgroup: Introduce per-root swapped blocks infrastructure
>   btrfs: qgroup: Use delayed subtree rescan for balance
>   btrfs: qgroup: Cleanup old subtree swap code

The above patches have been merged to misc-next, with a few small
updates to changelogs, comments or coding style that I found during the
last pass. Any updates please send as incremental patches, thanks.

I've folded the IS_ERR/PTR_ERR(subvol_eb) fix too.
