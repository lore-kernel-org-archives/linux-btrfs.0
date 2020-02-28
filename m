Return-Path: <SRS0=r+Ws=4Q=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A081C3F2D2
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Feb 2020 15:59:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 22C70246AC
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Feb 2020 15:59:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727110AbgB1P7i (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 28 Feb 2020 10:59:38 -0500
Received: from mx2.suse.de ([195.135.220.15]:54388 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726974AbgB1P7i (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Feb 2020 10:59:38 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id A4D86AF39;
        Fri, 28 Feb 2020 15:59:36 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 2456ADA79B; Fri, 28 Feb 2020 16:59:16 +0100 (CET)
Date:   Fri, 28 Feb 2020 16:59:15 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH] btrfs: set root to null in btrfs_search_path_in_tree_user
Message-ID: <20200228155915.GO2902@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        Dan Carpenter <dan.carpenter@oracle.com>
References: <20200227150708.4026770-1-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200227150708.4026770-1-josef@toxicpanda.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Feb 27, 2020 at 10:07:08AM -0500, Josef Bacik wrote:
> We could potentially have root uninitialized in some cases, so this will
> cause problems with btrfs_put_root.
> 
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> ---
> - Dave, this can be folded into "btrfs: hold a ref on the root in
>   btrfs_search_path_in_tree_user"

Folded, thanks.
